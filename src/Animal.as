package  
{
	import net.flashpunk.FP;
	import net.flashpunk.Entity;
	import net.flashpunk.Sfx;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class Animal extends Entity 
	{
		[Embed(source = 'sounds/thud.mp3')] private const THUD:Class;

		public var attack:Sfx;
		
		protected var pregTime:Number = 50;
		
		protected var health:int;
		protected var maxhealth:int;
		protected var satiated:int;
		protected var happy:int;
		protected var awake:int;
		
		protected var canReproduce:Number = 50.0;
		protected var gender:int;
		protected var pregnant:Boolean = false;
		protected var pregCnt:Number = 0.0;		
		
		protected var className:String = "Animal";
		
		public function Animal() 
		{
			gender = FP.rand(2);
			maxhealth = 100;
			
			attack = new Sfx(THUD);
		}
		
		protected function Die():void
		{
			
		}
		
		override public function update():void 
		{			
			if (x < 0)
				x = 0;
			if (x > 632)
				x = 632;
			if (y < 0)
				y = 0;
			if (y > 568)
				y = 568;
			
			if (health > maxhealth)
				health = maxhealth;
			
			if (health <= 0)
			{
				trace("I'm dead!");
				Die();
			}
				
			if (satiated > 100)
				satiated = 100;
			
			if (satiated < 1)
			{
				trace("Im starving!!!");
				health -= 1;
			}
				
			if (happy > 100)
				happy = 100;
				
			if (awake > 100)
				awake = 100;

			if(canReproduce >= 1)
				canReproduce -= 1.0;
				
			if (pregnant)
			{
				pregCnt -= .016;
				if (pregCnt < 1)
				{
					HaveChild();
					pregnant = false;
				}
			}
				
			super.update();
		}
		
		protected function GetPregnant():void
		{
			if (canReproduce < 1 && !pregnant && gender == 1)
			{
				pregnant = true;
				pregCnt = pregTime;
			}
		}
		
		protected function HaveChild():void
		{
			trace("Can't have children!");
			pregnant = false;
		}
		
		public function Damage(dam:int):void
		{
			health -= dam;
			happy -= 10;
			if (world)
			{
				world.add(new BloodSplat(x, y));
				world.add(new BloodSplat(x, y));
			}
			trace("Ouch!");
			if(!attack.playing)
				attack.play();
		}
		
		public function get Health():int
		{
			return health;
		}
	}

}