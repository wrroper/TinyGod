package  
{
	import flash.display.GradientType;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Tilemap;
	import net.flashpunk.masks.Grid;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class LevelTwo extends Level 
	{
	
		public function LevelTwo() 
		{
			startPlayerForce = 500;
			startPlayerPower = 2500;
			maxPlayerPower   = 2500;
			// this should be done in each level.
			tiles.setRect(0, 0, 640 / 16, 576 / 16, 3); 
			
			//-----------------------------
			// Set up the map
			//-----------------------------
			
			tiles.setRect(3, 3, 3, 5, 0);
			
			//colGrid = new Grid(640, 576, 16, 16, 0, 0);
			//mask = colGrid;
			
			//colGrid.setRect(3, 3, 3, 5, true);
		}
		
	}

}