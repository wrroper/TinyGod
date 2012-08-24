package  
{
	import net.flashpunk.Sfx;
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class SoundManager 
	{
		[Embed(source = 'sounds/awokenvertex.mp3')] 	private static const BGMUSIC:Class;
		[Embed(source = 'sounds/jealousgorilla.mp3')] 	private static const DGRMUSIC:Class;
		[Embed(source = 'sounds/whoosh.mp3')] 			private static const ZOMWHOOSH:Class;
		[Embed(source = 'sounds/thud.mp3')] 			private static const THUD:Class;
		[Embed(source = 'sounds/grasseat.mp3')] 		private static const GRASSEAT:Class;
		[Embed(source = 'sounds/whoosh2.mp3')] 			private static const WHOOSH:Class;

//			zomwhoosh = new Sfx(ZOMWHOOSH);
//			zomwhoosh.volume = .7;
		
		
		private static var musicList:Object = new Object();
		musicList["BGMUSIC"] 	= new Sfx(BGMUSIC);
		musicList["DGRMUSIC"] 	= new Sfx(DGRMUSIC);
		musicList["ZOMWHOOSH"] 	= new Sfx(ZOMWHOOSH);
		musicList["ZOMWHOOSH"].volume = .7;
		musicList["THUD"] 		= new Sfx(THUD);
		musicList["GRASSEAT"] 	= new Sfx(GRASSEAT);
		musicList["GRASSEAT"].volume = .8;
		musicList["WHOOSH"] 	= new Sfx(WHOOSH);
		musicList["WHOOSH"].volume = 0.25
			
		
//		private static var bgMusic:Sfx = new Sfx(BGMUSIC);
//		private static var dgrMusic:Sfx = new Sfx(DGRMUSIC);
//		private static var zomwhoosh:Sfx = new Sfx(ZOMWHOOSH);
		
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
			if (!musicList["BGMUSIC"].playing)
				musicList["BGMUSIC"].loop(.2);
		}
		
		public static function StopBGMusic():void
		{
			if (musicList["BGMUSIC"].playing)
				musicList["BGMUSIC"].stop();
			if (musicList["DGRMUSIC"].playing)
				musicList["DGRMUSIC"].stop();
		}
		
		public static function ToggleDGRMusic():void
		{
			if (!musicList["DGRMUSIC"].playing)
			{
				StopBGMusic();
				musicList["DGRMUSIC"].loop(.6);
			}
			else
			{
				StartBGMusic();
				musicList["DGRMUSIC"].stop();
			}
		}
		
		public static function get BGMusicPlaying():Boolean
		{
			return musicList["BGMUSIC"].playing;
		}
		
		public static function get DGRMusicPlaying():Boolean
		{
			return musicList["DGRMUSIC"].playing;
		}
			
		public static function PlaySound(name:String, checkPlay:Boolean = true, vol:Number = -1):void
		{
			if (musicList[name] != null)
			{
				if (checkPlay && !musicList[name].playing)
				{
					if(vol != -1)
						musicList.volume = vol;
					musicList[name].play();
				}
				else if (!checkPlay)
				{
					if(vol != -1)
						musicList.volume = vol;
					musicList[name].play();
				}
			}
		}
	}

}