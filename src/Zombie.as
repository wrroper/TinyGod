package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import Playtomic.*;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class Zombie extends Animal
	{
		[Embed(source = 'assets/zombie.png')] private const ZOMBIE:Class;

		private var pic:Image;

		private var myThink:Number;
		private var hungry:Number;
		private var hunWeight:Number = 3.0;
		private var sleep:Number;
		private var slpWeight:Number = 2.0;
		private var horny:Number;
		private var horWeight:Number = 1.5;
		private var action:int = 0;
		private var nearFriend:Man;
		private var nearFood:Man;
		private var nearCow:Cow;
		private var bestFriend:Man;
		private var myEnemy:Man;
		
		public function Zombie(startx:int, starty:int) 
		{
			super();
						
			pic = new Image(ZOMBIE);
			graphic = pic;
			
			className = "Zombie";
			
			myThink = 0;
			
			x = startx * 16 + 8;
			y = starty * 16 + 8;

			health = 40 + FP.rand(20);
			satiated = 20;
			happy = 60 + FP.rand(20);
			awake = 80;
			
			SoundManager.PlaySound("ZOMWHOOSH", false);
			//zomwhoosh.play();
		}
		
		override protected function Die():void
		{
			world.add(new DeadMan(x, y));
			MyWorld.zomLeft--;
//			GameManager.GetGod.LifeDied(className);			
			world.remove(this);
			
			super.Die();
			Log.LevelCounterMetric("ZombieKills", GameManager.GetGod.WorldName);
		}
				
		override public function update():void 
		{	
			myThink += .016;
			
			if (myThink > 2)
			{
				myThink -= 2;

				
				awake -= 0; // Zombies Never Sleep
				happy -= 0; // They are never unhappy
				satiated -= FP.random * 5; // THEY JUST WANT BRAINS
				
				if (satiated < 40)
				{
					hungry = (40 - satiated) * hunWeight;
				}
				else
					hungry = 0;
					
				if (awake < 40)
					sleep = (40 - awake) * slpWeight;
				else
					sleep = 0;
				
				if (happy < 30)
					horny = (30 - happy) * horWeight;
				else
					horny = 0;
					
				if (hungry > sleep && hungry > horny && hungry > 0)
				{
					action = 1;
				}
				else if (sleep > hungry && sleep > horny && sleep > 0)
				{
					action = 2;
				}
				else if (horny > hungry && horny > sleep && horny > 0)
				{
					action = 3;
				}
				else
				{
					action = 0;
				}
			}
			
			switch(action)
			{
				case 0: // idle
					x += FP.rand(3) - 1;
					y += FP.rand(3) - 1;
					break;
				case 1: // EAT!
					if (nearFood != null && nearFood.x == x && nearFood.y == y) // If I'm standing on a person, EAT! Mmmm Brains.
					{
						//trace("Munch, munch!");
						var tmpSat:Number = 2; // A good Zombie is never satisfied.
						nearFood.Damage(FP.rand(8)+3);
						satiated += tmpSat;
						health += tmpSat; // Brains heal zombies! mmmm.
						if (nearFood.Health < 1)
							nearFood = null; // ALL GONE!
					}
					else if (nearCow != null && nearCow.x == x && nearCow.y == y) // If I'm standing at a Cow and I'm Hungry, Kill! Mmmm Cow.
					{
						//trace("Killin my dinner!");
						//happy += FP.rand(7) - 3;

						satiated += 1; // A good Zombie is never satisfied.
						health += 1;
						nearCow.Damage(FP.rand(8)+3);
						if (nearCow.Health < 0)
							nearCow = null;
					}
					else // FIND FOOD!
					{
						if ((nearFood == null && nearCow == null) || (nearFood != null && nearFood.Health < 1) || (nearCow != null && nearCow.Health < 1)) // Is the Dead Cow Im craving still there?
						{
							nearFood = null;
							nearCow = null;
							FindFood(x / 16, y / 16);
						}
						
						if (nearFood != null)
						{
							if (nearFood.x > x)
							{
								x += 1;
							}
							else if (nearFood.x  < x)
							{
								x -= 1;
							}
							
							if (nearFood.y  > y)
							{
								y += 1;
							}
							else if (nearFood.y  < y)
							{
								y -= 1;
							}
							
						}
						else if (nearCow != null)
						{
							if (nearCow.x > x)
							{
								x += 1;
							}
							else if (nearCow.x  < x)
							{
								x -= 1;
							}
							
							if (nearCow.y  > y)
							{
								y += 1;
							}
							else if (nearCow.y  < y)
							{
								y -= 1;
							}
						}
					}
					break;
				case 2: // SLEEP!
					//trace("snooooooore!");
					awake += 1 + (FP.random * 2);
					break;
				case 3: // Zombies don't procreate.
					if (nearFriend == null || nearFriend.Health < 1)
					{
						nearFriend = null;
					}
					else
					{
						if (nearFriend.x > x)
						{
							x += 1;
						}
						else if (nearFriend.x < x)
						{
							x -= 1;
						}
						
						if (nearFriend.y > y)
						{
							y += 1;
						}
						else if (nearFriend.y < y)
						{
							y -= 1;
						}
						else if (nearFriend.x == x && nearFriend.y == y)
						{
							//trace("Lets get it on!");
							happy += 5;
							nearFriend = null;
						}
					}
					//trace("Lonely!");
					break;
			}
			
			super.update();
		}
		
		private function FindFood(x:int, y:int):void
		{
			var manList:Array = [];
			var cowList:Array = [];
			var vegZom:Number = FP.random;
			
			world.getClass(Man, manList);
			
			for each(var d:Man in manList)
			{
				if (nearFood == null)
				{
					nearFood = d;
				}
				else if (Math.sqrt((nearFood.x-x)*(nearFood.x-x))+((nearFood.y-y)*(nearFood.y-y)) > Math.sqrt((d.x-x)*(d.x-x))+((d.y-y)*(d.y-y)))
				{
					nearFood = d;
				}
			}
			
			if (nearFood == null || vegZom >= .85)
			{
				world.getClass(Cow, cowList);
				
				for each(var c:Cow in cowList)
				{
					if (nearCow == null)
					{
						nearCow = c;
					}
					else if (Math.sqrt((nearCow.x-x)*(nearCow.x-x))+((nearCow.y-y)*(nearCow.y-y)) > Math.sqrt((c.x-x)*(c.x-x))+((c.y-y)*(c.y-y)))
					{
						nearCow = c;
					}
				}
				if (nearCow != null)
					nearFood = null;
			}
		}
		
		private function FindPeople(x:int, y:int):void
		{
			var manList:Array = [];
			
			world.getClass(Man, manList);
			
			for each(var c:Man in manList)
			{
				if (nearFriend == null)
				{
					nearFriend = c;
				}
				else if (Math.sqrt((nearFriend.x-x)*(nearFriend.x-x))+((nearFriend.y-y)*(nearFriend.y-y)) > Math.sqrt((c.x-x)*(c.x-x))+((c.y-y)*(c.y-y)))
				{
					nearFriend = c;
				}
			}
		}
		
	}

}