package  
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class GameManager extends Entity 
	{
		private static var god:God = null;
		private static var godAdded:Boolean = false;
		private static var level:Level = null;
		private static var levelAdded:Boolean = false;
		
		public function GameManager() 
		{
		}
		
		public static function get GetGod():God
		{
			if (god == null)
			{
				god = new God;
				god.WorldName = "MyWorld";
			}
			return god;
		}
		
		public static function get GetLevel():Level
		{
			if (level == null)
			{
				level = new LevelOne;
			}
			return level;
		}
		
		override public function update():void 
		{
			if (GetLevel != null && levelAdded == false)
			{
				world.add(level);
				levelAdded = true;
			}
			
			if (GetGod != null && godAdded == false )
			{
				world.add(god);
				godAdded = true;
			}
			
			super.update();
		}
	}

}