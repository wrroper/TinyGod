package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	import Playtomic.*;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class Main extends Engine 
	{
		
		public function Main():void 
		{

				super(800, 600, 60, false);
				
				Log.View(7723, "3bc78897cf8642ed", "c314a89fa7cf492ca98f468657f54a", root.loaderInfo.loaderURL);
				
				FP.world = new TitleScreen;
		}
		
		
	}
	
}