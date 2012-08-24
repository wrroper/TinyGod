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
				
				Log.View(7764, "", "", root.loaderInfo.loaderURL);
				
				FP.world = new TitleScreen;
		}
		
		
	}
	
}