package  
{
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class SoundManager 
	{
		[Embed(source = 'sounds/awokenvertex.mp3')] private static const BGMUSIC:Class;
		[Embed(source = 'sounds/jealousgorilla.mp3')] private static const DGRMUSIC:Class;

		private static var bgMusic:Sfx = new Sfx(BGMUSIC);
		private static var dgrMusic:Sfx = new Sfx(DGRMUSIC);
		
		private static var soundon:Boolean = true;
		
		public function SoundManager() 
		{
			
		}
		
		public static function ToggleSound(onoff:Boolean):void
		{
			soundon = onoff;
			
			if (!soundon)
			{
				StopBGMusic();
			}
			else
			{
				StartBGMusic();
			}
		}
		
		public static function StartBGMusic():void
		{
			if (!bgMusic.playing)
				bgMusic.loop(.2);
		}
		
		public static function StopBGMusic():void
		{
			if (bgMusic.playing)
				bgMusic.stop();
			if (dgrMusic.playing)
				dgrMusic.stop();
		}
		
		public static function ToggleDGRMusic():void
		{
			if (!dgrMusic.playing)
			{
				StopBGMusic();
				dgrMusic.loop(.6);
			}
			else
			{
				StartBGMusic();
				dgrMusic.stop();
			}
		}
		
		public static function get BGMusicPlaying():Boolean
		{
			return bgMusic.playing;
		}
		
		public static function get DGRMusicPlaying():Boolean
		{
			return dgrMusic.playing;
		}
	}

}