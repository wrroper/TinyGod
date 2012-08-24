package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class DeadCow extends Entity 
	{
		[Embed(source = 'assets/deadcow.png')] private const DEADCOW:Class;		
		
		private var pic:Image;
		private var foodVal:Number = 50;
		
		public function DeadCow(startx:int, starty:int) 
		{
			pic = new Image(DEADCOW);
			graphic = pic;
			
			x = startx;
			y = starty;
		}
		
		override public function update():void 
		{
			if (foodVal > 0)
				foodVal -= .02;
			else
			{
				trace("Rotted!");
				world.remove(this);
			}
			super.update();
		}
		
		public function get FoodVal():Number
		{
			return foodVal;
		}
		
		public function EatFood(eaten:Number):void
		{
			foodVal -= eaten;
		}
	}

}