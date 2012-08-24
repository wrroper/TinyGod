package  
{
	import flash.geom.Point;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;	
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class BloodSplat extends Entity 
	{
		[Embed(source = 'assets/blood.png')] private const BLOOD:Class;		
		
		private var pic:Image;
		private var velocity:Point;
		private var life:Number = 1;
		
		public function BloodSplat(startx:int, starty:int) 
		{
			pic = new Image(BLOOD);
			
			graphic = pic;
			
			x = startx;
			y = starty;
			
			velocity = new Point(FP.rand(3) - 1, FP.rand(3) - 1);
		}
		
		override public function update():void 
		{
			life -= .016;
			if (life < 0)
				world.remove(this);
				
			this.x += velocity.x;
			this.y += velocity.y;
			
			super.update();
		}
	}

}