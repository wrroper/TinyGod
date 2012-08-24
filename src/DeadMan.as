package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class DeadMan extends Entity 
	{
		[Embed(source = 'assets/deadman.png')] private const DEADMAN:Class;		
		
		private var pic:Image;
		private var foodVal:Number = 50;
		
		public function DeadMan(startx:int, starty:int) 
		{
			pic = new Image(DEADMAN);
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
		
	}

}