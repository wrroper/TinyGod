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
	public class GrassSower extends Animal 
	{
		[Embed(source = 'assets/grasssower.png')] private const SOWER:Class;
		
		private var pic:Image;
		private var myThink:Number;
		private var hungry:Number;
		private var hunWeight:Number = 3.0;
		private var sleep:Number;
		private var slpWeight:Number = 2.0;
		private var horny:Number;
		private var horWeight:Number = 1.5;
		private var action:int = 0;
		private var nearFriend:GrassSower;
		private var nearFood:Point;
		
		public function GrassSower(startx:int, starty:int) 
		{
			super();
			
			pic = new Image(SOWER);
			graphic = pic;
			
			className = "Sower";
			
			nearFood = new Point( -1, -1);
			nearFriend = null;
			myThink = 0;
			x = (startx * 16) + 8;
			y = (starty * 16) + 8;
			
			health = 5 + FP.rand(10);
			maxhealth = health + FP.rand(10);
			satiated = 40;
			happy = 20 + FP.rand(20);
			awake = 20 + FP.rand(80);
			
		}
		
		override protected function Die():void
		{
			GameManager.GetGod.LifeDied(className);			
			world.remove(this);
			
			super.Die();
		}
				
		override public function update():void 
		{	
			myThink += .016;
			
			if (myThink > 2)
			{
				myThink -= 2;

				
				satiated -= FP.random * 5;
				//awake -= FP.random * 3;
				//happy -= FP.random * 4;
				
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
					if (GameManager.GetLevel.Tiles.getTile((x+8) / 16, (y+8) / 16) == 2) // If I'm standing on Dirt, sow!
					{
						//trace("Munch, munch!");
						satiated += 1;
						happy += 1;
						GameManager.GetLevel.SetTile((x + 8) / 16, (y + 8) / 16, 0);
						nearFood.x = -1;
						nearFood.y = -1;
						GameManager.GetGod.NewLife("Grass");
						//SoundManager.PlaySound("GRASSEAT");
					}
					else
					{
						var tmp:int = GameManager.GetLevel.Tiles.getTile(nearFood.x, nearFood.y);
						if ((nearFood.x == -1 && nearFood.y == -1) || GameManager.GetLevel.Tiles.getTile(nearFood.x, nearFood.y) != 2) // Is the tile Im craving food and still there?
						{
							FindFood(x / 16, y / 16);
						}
						if (nearFood.x != -1 || nearFood.y != -1)
						{
							if ((nearFood.x*16)-8 > x)
							{
								x += 1;
							}
							else if ((nearFood.x * 16)-8 < x)
							{
								x -= 1;
							}
							
							if ((nearFood.y * 16)-8 > y)
							{
								y += 1;
							}
							else if ((nearFood.y * 16)-8 < y)
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
				case 3: // Get some!
					if (nearFriend == null || nearFriend.Health < 1)
					{
						nearFriend = null;
						FindSower(x / 16, y / 16);
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
							GetPregnant();
							nearFriend.GetPregnant();
							nearFriend = null;
						}
					}
					//trace("Lonely!");
					break;
			}
			
			super.update();
		}
		
		override protected function HaveChild():void 
		{
			world.add(new Man(x / 16, y / 16));
			GameManager.GetGod.NewLife("Sower");
			Log.LevelCounterMetric("SowerBirths", GameManager.GetGod.WorldName);
		}
		
		private function FindFood(x:int, y:int):void
		{
			var closest:Point = new Point(-1, -1);
			
			for (var i:int = 0; i < GameManager.GetLevel.Tiles.columns; i++)
			{
				for (var j:int = 0; j < GameManager.GetLevel.Tiles.rows; j++)
				{
					if (GameManager.GetLevel.Tiles.getTile(i, j) == 2)
					{
						if (closest.x == -1 && closest.y == -1)
						{
							closest.x = i;
							closest.y = j;
						}
						else if (Math.sqrt((closest.x-x)*(closest.x-x))+((closest.y-y)*(closest.y-y)) > Math.sqrt((closest.x-i)*(closest.x-i))+((closest.y-j)*(closest.y-j)))  // (Math.abs(closest.x - x) + Math.abs(closest.y - y) > Math.abs(closest.x - i) + Math.abs(closest.y - j))
						{
							closest.x = i;
							closest.y = j;
						}
					}
				}
			}
			
			if (closest.x != x || closest.y != y)
			{
				nearFood.x = closest.x;
				nearFood.y = closest.y;
			}
			else
			{
				nearFood.x = -1;
				nearFood.y = -1;
			}
		}
		
		private function FindSower(x:int, y:int):void
		{
			var sowerList:Array = [];
			
			world.getClass(GrassSower, sowerList);
			
			for each(var c:GrassSower in sowerList)
			{
				if (c != this)
				{
					if (nearFriend == null)
					{
						nearFriend = c;
					}
					else if ((Math.abs(nearFriend.x - x) + Math.abs(nearFriend.y -y)) < (Math.abs(c.x - x) + Math.abs(c.y - y)))
					{
						nearFriend = c;
					}
				}
			}
		}		
	}

}