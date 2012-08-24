package  
{
	import flash.geom.Point;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import Playtomic.*;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class Man extends Animal 
	{
		[Embed(source = 'assets/man.png')] private const MAN:Class;
		[Embed(source = 'assets/woman.png')] private const WOMAN:Class;

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
		private var nearFood:DeadCow;
		private var nearCow:Cow;
		private var bestFriend:Man;
		private var myEnemy:Man;
		private var nearZom:Zombie = null;
		private var zomAlarm:Boolean = false;
		
		public function Man(startx:int, starty:int) 
		{
			super();
			
			switch(gender)
			{
				case 0:
					pic = new Image(MAN);
					break;
				case 1:
					pic = new Image(WOMAN);
					break;
			}
			graphic = pic;
			
			className = "Man";
			
			myThink = 0;
			
			x = startx * 16 + 8;
			y = starty * 16 + 8;

			health = 20 + FP.rand(10);
			maxhealth = health + FP.rand(25);
			satiated = 20 + FP.rand(80);
			happy = 20 + FP.rand(20);
			awake = 20 + FP.rand(80);
		}
		
		override protected function Die():void
		{
			world.add(new DeadMan(x, y));
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
				awake -= FP.random * 3;
				happy -= FP.random * 4;
				
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
				
				zomAlarm = false;
				if (action != 1 && CheckForZombies(x / 16, y / 16))
				{
					action = 0;
					zomAlarm = true;
				}
			}
			
			switch(action)
			{
				case 0: // idle
					if (zomAlarm && CheckForZombies(x / 16, y / 16))
					{
						if (gender == 1)
						{
							if (nearZom.x > x)
							{
								x -= 1;
							}
							else if (nearZom.x  < x)
							{
								x += 1;
							}
							
							if (nearZom.y  > y)
							{
								y -= 1;
							}
							else if (nearZom.y  < y)
							{
								y += 1;
							}
							
						}
						else
						{
							if (nearZom.x > x)
							{
								x += 1;
							}
							else if (nearZom.x  < x)
							{
								x -= 1;
							}
							
							if (nearZom.y  > y)
							{
								y += 1;
							}
							else if (nearZom.y  < y)
							{
								y -= 1;
							}
							
						}
						
						if (nearZom != null &&  nearZom.x == x && nearZom.y == y) // ATTACK!!!
						{
							nearZom.Damage(FP.rand(5));
							if (nearZom.Health < 0)
								nearZom = null;
							
						}
					}
					else
					{
						x += FP.rand(3) - 1;
						y += FP.rand(3) - 1;
					}
					break;
				case 1: // EAT!
					if (nearFood != null && nearFood.x == x && nearFood.y == y) // If I'm standing on DeadCow, EAT! Mmmm Cow.
					{
						//trace("Munch, munch!");
						var tmpSat:Number = 10 + FP.rand(20);
						if (tmpSat > nearFood.FoodVal)
							tmpSat = nearFood.FoodVal;
						nearFood.EatFood(tmpSat);
						satiated += tmpSat;
						happy += FP.rand(10);
						health += (FP.random * 5)
						if (nearFood.FoodVal < 1)
							nearFood = null; // ALL GONE!
					}
					else if (nearCow != null && nearCow.x == x && nearCow.y == y) // If I'm standing at a Cow and I'm Hungry, Kill! Mmmm Cow.
					{
						//trace("Killin my dinner!");
						happy += FP.rand(7) - 3;

						nearCow.Damage(FP.rand(5));
						if (nearCow.Health < 0)
							nearCow = null;
					}
					else // FIND FOOD!
					{
						if ((nearFood == null && nearCow == null) || (nearFood != null && nearFood.FoodVal < 1)) // Is the Dead Cow Im craving still there?
						{
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
				case 3: // Get some!
					if (nearFriend == null || nearFriend.Health < 1)
					{
						nearFriend = null;
						FindPeople(x / 16, y / 16);
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
			GameManager.GetGod.NewLife("Man");
			Log.LevelCounterMetric("ManBirths", GameManager.GetGod.WorldName);
		}
		
		private function FindFood(x:int, y:int):void
		{
			var deadCow:Array = [];
			var cowList:Array = [];
			
			world.getClass(DeadCow, deadCow);
			
			for each(var d:DeadCow in deadCow)
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
			
			if (nearFood == null)
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
			}
		}
		
		private function FindPeople(x:int, y:int):void
		{
			var manList:Array = [];
			
			world.getClass(Man, manList);
			
			for each(var c:Man in manList)
			{
				if (c != this)
				{
					if (nearFriend == null && c.Gender != this.Gender)
					{
						nearFriend = c;
					}
					else if (c.Gender != this.Gender && (Math.sqrt((nearFriend.x-x)*(nearFriend.x-x))+((nearFriend.y-y)*(nearFriend.y-y)) > Math.sqrt((c.x-x)*(c.x-x))+((c.y-y)*(c.y-y))))
					{
						nearFriend = c;
					}
				}
			}
		}
		
		private function CheckForZombies(x:int, y:int):Boolean
		{
			var zomList:Array = [];
			if (nearZom != null && nearZom.Health < 1)
				nearZom = null;
			
			world.getClass(Zombie, zomList);
			
			for each(var z:Zombie in zomList)
			{
				if (nearZom == null)
				{
					nearZom = z;
				}
				else if (Math.sqrt((nearZom.x-x)*(nearZom.x-x))+((nearZom.y-y)*(nearZom.y-y)) > Math.sqrt((z.x-x)*(z.x-x))+((z.y-y)*(z.y-y)))
				{
					nearZom = z;
				}
			}
			
			if (nearZom == null)
				return false;
			else
				return true;
		}

		public function get Gender():int
		{
			return gender;
		}
	}

}