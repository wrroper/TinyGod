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
	public class Level extends Entity 
	{
		[Embed(source = 'assets/tilemap.png')] protected const TMAP:Class;
		
		protected var tiles:Tilemap;
		protected var tmap:Image;
		protected var colGrid:Grid;
		
		protected var startPlayerPower:int;
		protected var maxPlayerPower:int;
		protected var startPlayerForce:int;
		
		public function Level() 
		{
			startPlayerPower 	= 200;
			maxPlayerPower 		= 200;
			startPlayerForce 	= 0;
			
			//tmap = new Image(TMAP);
			tiles = new Tilemap(TMAP, 640, 576, 16, 16);
			graphic = tiles;
			layer = 1;

			// this should be done in each level.
			tiles.setRect(0, 0, 640 / 16, 576 / 16, 0); 

			//tiles.setRect(3, 3, 3, 5, 0);
			
			//colGrid = new Grid(640, 576, 16, 16, 0, 0);
			//mask = colGrid;
			
			//colGrid.setRect(3, 3, 3, 5, true);
		}

		public function get GetStartingPlayerPower():int
		{
			return startPlayerPower;
		}
		
		public function get GetMaxPlayerPower():int
		{
			return maxPlayerPower;
		}
		
		public function get GetStartingPlayerForce():int
		{
			return startPlayerForce;
		}
		
		public function get Tiles():Tilemap
		{
			return tiles;
		}
		
		public function SetTile(x:int, y:int, type:int):void
		{
			switch(type)
			{
				case 0: // Grass
					tiles.setTile(x, y, 1);
					break;
				case 1:
					tiles.setTile(x, y, 2);
					break;
				default:
					trace("I cant create that!");
					
			}
		}
		
		public function InWorld(x:int, y:int):Boolean
		{
			if (x >= 0 && x <= (tiles.width/16)-1 && y >= 0 && y <= (tiles.height/16)-1)
				return true;
			else
				return false;
		}
	}

}