package 
{
	import net.flashpunk.Entity;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.Sfx;
	import Playtomic.*;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class God extends Entity 
	{
		[Embed(source = 'sounds/whoosh2.mp3')] private const WHOOSH:Class;
		
		private var whoosh:Sfx;
		
		private var worldName:String;
		
		private var lifeForce:int;
		private var lifePower:int;
		private var lifeType:int;

		private const costGrass:int = 1;
		private const costCow:int = 20;
		private const costMan:int = 50;
		private const costTrees:int = 10;
		private const lifeTick:Number = 4.0;
		
		private var cntGrass:int = 0;
		private var cntCow:int = 0;
		private var cntMan:int = 0;
		
		private var totGrass:int = 0;
		private var totDeadGrass:int = 0;
		private var totCow:int = 0;
		private var totCowCreated:int = 0;
		private var totDeadCow:int = 0;
		private var totMan:int = 0;
		private var totManCreated:int = 0;
		private var totDeadMan:int = 0;
		
		private var tick:Number = 0;
		
		public function God() 
		{
			whoosh = new Sfx(WHOOSH);
			whoosh.volume = 0.25;
			
			lifePower = 200;
			lifeForce = 0;
			lifeType = 0;
		}
		
		override public function update():void 
		{
			tick += .016;
			
			if (tick >= lifeTick)
			{
				tick -= lifeTick;
				
				if (lifePower < 50)
					lifePower += cntGrass/5;
				if (lifePower < 150)
					lifePower += cntCow * 2;
				if (lifePower < 200)
					lifePower += cntMan * 3;
				if (lifePower > 200)
					lifePower = 200;
			}
			
			if (Input.mousePressed || (lifeType == 0 && Input.mouseDown))
			{
				CreateLife(Input.mouseX/16, Input.mouseY/16, lifeType);
			}
			
			super.update();
		}
		
		public function get WorldName():String
		{
			return worldName;
		}
		
		public function set WorldName(value:String):void
		{
			worldName = value;
		}
		
		public function get LifePower():int 
		{
			return lifePower;
		}
		
		public function set LifePower(value:int):void
		{
			lifePower = value;
		}
		
		public function get LifeType():int
		{
			return lifeType;
		}
		
		public function set LifeType(value:int):void
		{
			lifeType = value;
		}
		
		public function get LifeForce():int
		{
			return lifeForce;
		}
		
		public function set LifeForce(value:int):void
		{
			lifeForce = value;
		}
		
		public function get GrassCount():int
		{
			return cntGrass;
		}
		
		public function get CowCount():int
		{
			return cntCow;
		}
		
		public function get ManCount():int
		{
			return cntMan;
		}

		public function get TotGrass():int
		{
			return totGrass;
		}
		
		public function get TotDeadGrass():int
		{
			return totDeadGrass;
		}
		
		public function get TotCows():int
		{
			return totCow;
		}
		
		public function get TotCowsCreated():int
		{
			return totCowCreated;
		}
		
		public function get TotDeadCows():int
		{
			return totDeadCow;
		}
		
		public function get TotMen():int
		{
			return totMan;
		}
		
		public function get TotMenCreated():int
		{
			return totManCreated;
		}
		
		public function get TotDeadMen():int
		{
			return totDeadMan;
		}
		
		public function LifeDied(what:String):void
		{
			switch(what)
			{
				case "Grass":
					lifeForce -= costGrass;
					cntGrass -= 1;
					totDeadGrass += 1;
					Log.LevelCounterMetric("GrassEaten", worldName);
					break;
				case "Cow":
					lifeForce -= costCow;
					cntCow -= 1;
					totDeadCow += 1;
					Log.LevelCounterMetric("CowsDied", worldName);
					break;
				case "Man":
					lifeForce -= costMan;
					cntMan -= 1;
					totDeadMan += 1;
					Log.LevelCounterMetric("MenDied", worldName);
					break;
				default:
					
			}
		}
		
		public function NewLife(what:String):void
		{			
			switch(what)
			{
				case "Grass":
					lifeForce += costGrass;
					cntGrass += 1;
					totGrass += 1;
					Log.LevelCounterMetric("GrassCreated", worldName);
					break;
				case "Cow":
					lifeForce += costCow;
					cntCow += 1;
					totCow += 1;
					//if(!whoosh.playing)
						whoosh.play();
					break;
				case "Man":
					lifeForce += costMan;
					cntMan += 1;
					totMan += 1;
					//if(!whoosh.playing)
						whoosh.play();
					break;
				default:
					
			}
		}
		
		/*
		 * Life types:
			 * 0: Grass
			 * 1: Cows
			 * 2: People
			 * 3: Trees
		 */
		public function CreateLife(x:int, y:int, type:int):void
		{
			if (lifePower <= 0)
				return;
				
			if(!MyWorld.level.InWorld(x, y))
				return;
				
			switch(type)
			{
				case 0: // Grass
					if (MyWorld.level.Tiles.getTile(x, y) == 2)
					{
						MyWorld.level.SetTile(x, y, 0);
						//trace("Grow Grass Grow!")
						lifePower -= costGrass;
						NewLife("Grass");
					}
				break;
				case 1: // Cow
					if (lifePower >= costCow)
					{
						world.add(new Cow(x, y));
						lifePower -= costCow;
						totCowCreated += 1;
						NewLife("Cow");
						Log.LevelCounterMetric("CowsCreated", worldName);
					}
				break;
				case 2: // Person
					if (lifePower >= costMan)
					{
						world.add(new Man(x, y));
						lifePower -= costMan;
						totManCreated += 1;
						NewLife("Man");
						Log.LevelCounterMetric("MenCreated", worldName);
					}
				break;
				case 3: // Trees
				break;
				default: // WTF are you creating?
					trace("Creating something alien!");
			}
			
			//trace("Let there be life!");
		}
		
	}

}