package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class BGScreen extends Entity 
	{
		
		public function BGScreen(pic:Image) 
		{
			graphic = pic;
			layer = 20;
		}
		
	}

}