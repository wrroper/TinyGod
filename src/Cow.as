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
	public class Cow extends Animal 
	{
		[Embed(source = 'assets/cow2.png')] private const COW:Class;
		
		private var pic:Image;

		private var cowThink:Number;
		private var hungry:Number;
		private var hunWeight:Number = 3.0;
		private var sleep:Number;
		private var slpWeight:Number = 2.0;
		private var horny:Number;
		private var horWeight:Number = 1.5;
		private var action:int = 0;
		private var nearFood:Point;
		private var nearFriend:Cow;
		private var bestFriend:Cow;
		
		public function Cow(startx:int, starty:int) 
		{
			pic = new Image(COW);
			graphic = pic;
			
			className = "Cow";
			
			nearFood = new Point( -1, -1);
			nearFriend = null;
			cowThink = 0;
			this.x = startx*16;
			this.y = starty*16;
			
			health = 10 + FP.rand(10);
			satiated = 20 + FP.rand(80);
			happy = 30 + FP.rand(30);
			awake = 20 + FP.rand(80);
		}
		
		override protected function Die():void
		{
			world.add(new DeadCow(x, y));
			GameManager.GetGod.LifeDied(className);
			world.remove(this);
			
			super.Die();
		}
		
		override public function update():void 
		{	
			cowThink += .016;
			
			if (cowThink > 2)
			{
				cowThink -= 2;
				
				satiated -= FP.random * 5;
				awake -= FP.random * 4;
				happy -= FP.random * 2;
				
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
					if (GameManager.GetLevel.Tiles.getTile((x+8) / 16, (y+8) / 16) == 1) // If I'm standing on grass, EAT!
					{
						//trace("Munch, munch!");
						satiated += 10 + FP.rand(20);
						happy += FP.rand(10);
						GameManager.GetLevel.SetTile((x + 8) / 16, (y + 8) / 16, 1);
						nearFood.x = -1;
						nearFood.y = -1;
						GameManager.GetGod.LifeDied("Grass");
						SoundManager.PlaySound("GRASSEAT");
					}
					else if (GameManager.GetLevel.Tiles.getTile((x+8) / 16, (y+8) / 16) == 3) // If I'm standing on grass, EAT!
					{
						//trace("Munch, munch!");
						satiated += 0; // Evil purple grass doesn't fill us.
						happy -= 3;    // And it makes us sad.
						GameManager.GetLevel.SetTile((x + 8) / 16, (y + 8) / 16, 1);
						nearFood.x = -1;
						nearFood.y = -1;
						GameManager.GetGod.LifeDied("PurpleGrass");
						SoundManager.PlaySound("GRASSEAT");
					}
					else
					{
						var tmp:int = GameManager.GetLevel.Tiles.getTile(nearFood.x, nearFood.y);
						if ((nearFood.x == -1 && nearFood.y == -1) || ((GameManager.GetLevel.Tiles.getTile(nearFood.x, nearFood.y) != 1) && GameManager.GetLevel.Tiles.getTile(nearFood.x, nearFood.y) != 3)) // Is the tile Im craving food and still there?
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
						FindCows(x / 16, y / 16);
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
			if (world)
			{
				world.add(new Cow(x / 16, y / 16));
				GameManager.GetGod.NewLife("Cow");
				Log.LevelCounterMetric("CowBirths", GameManager.GetGod.WorldName);
			}
		}
		
		private function FindFood(x:int, y:int):void
		{
			var closest:Point = new Point(-1, -1);
			
			for (var i:int = 0; i < GameManager.GetLevel.Tiles.columns; i++)
			{
				for (var j:int = 0; j < GameManager.GetLevel.Tiles.rows; j++)
				{
					if ((GameManager.GetLevel.Tiles.getTile(i, j) == 1) || (GameManager.GetLevel.Tiles.getTile(i, j) == 3))
					{
						if (closest.x == -1 && closest.y == -1)
						{
							closest.x = i;
							closest.y = j;
						}
						else if (Math.sqrt((closest.x-x)*(closest.x-x))+((closest.y-y)*(closest.y-y)) > Math.sqrt((closest.x-i)*(closest.x-i))+((closest.y-j)*(closest.y-j)))
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
		
		private function FindCows(x:int, y:int):void
		{
			var cowList:Array = [];
			
			world.getClass(Cow, cowList);
			
			for each(var c:Cow in cowList)
			{
				if (c != this)
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

}