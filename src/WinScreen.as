package  
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.World;
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPanel;
	import punk.ui.PunkRadioButton;
	import punk.ui.PunkRadioButtonGroup;
	import net.flashpunk.FP;
	import punk.ui.PunkTextArea;
		
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class WinScreen extends World 
	{
		[Embed(source = 'assets/winner.png')] private const WINNER:Class;
		
		private var scr:BGScreen = null;
		private var startbtn:PunkButton;
		private var statbtn:PunkButton;
		private var stats:PunkTextArea;
		private var statShown:Boolean = false;
				
		private var totGrass:int = 0;
		private var totDeadGrass:int = 0;
		private var totCow:int = 0;
		private var totCowCreated:int = 0;
		private var totDeadCow:int = 0;
		private var totMan:int = 0;
		private var totManCreated:int = 0;
		private var totDeadMan:int = 0;
		private var totZombies:int = 0;
		private var secplayed:int = 0;
		
/*		public function WinScreen() 
		{
			scr = new BGScreen(new Image(WINNER));
			add(scr);
			
			startbtn = new PunkButton(350, 550, 100, 20, "End Game", StartGame);
			add(startbtn);

			statbtn = new PunkButton(100, 550, 100, 20, "Instructions", ShowStats);
			add(statbtn);
			
		}
*/		
		public function WinScreen(totgr:int, totdgr:int, totc:int, totcrc:int, totdc:int, totm:int, totcrm:int, totdm:int, totz:int, time:int) 
		{
			scr = new BGScreen(new Image(WINNER));
			add(scr);
			
			startbtn = new PunkButton(350, 550, 100, 20, "End Game", StartGame);
			add(startbtn);

			statbtn = new PunkButton(100, 550, 110, 20, "Game Stats", ShowStats);
			add(statbtn);
			
			totGrass = totgr;
			totDeadGrass = totdgr;
			totCow = totc;
			totCowCreated = totcrc;
			totDeadCow = totdc;
			totMan = totm;
			totManCreated = totcrm;
			totDeadMan = totdm;
			totZombies = totz;
			secplayed = time;
			
			var statstr:String = "                                Stats\n\n Total Grass Created: " + String(totGrass) + "\n Total Eaten Grass: " + String(totDeadGrass) + "\n" +
								 "\n Total Cows: " + String(totCow) + "\n Total Cows Created: " + String(totCowCreated) + "\n Total Dead Cows: " + String(totDeadCow) + "\n" +
								 "\n Total Men: " + String(totMan) + "\n Total Men Created: " + String(totManCreated) + "\n Total Dead Men: " + String(totDeadMan) + "\n" +
								 "\n Total Zombies: " + String(totZombies) + "\n\n Total Seconds to Win: " + String(secplayed);
			stats = new PunkTextArea(statstr, 100, 250, 600, 250);
		}
		
		private function StartGame():void
		{
			trace("Start it!");
			startbtn.active = false;
			FP.world = new TitleScreen;
		}
		
		public function SetStats(totgr:int, totdgr:int, totc:int, totcrc:int, totdc:int, totm:int, totcrm:int, totdm:int, totz:int, time:int):void
		{
			totGrass = totgr;
			totDeadGrass = totdgr;
			totCow = totc;
			totCowCreated = totcrc;
			totDeadCow = totdc;
			totMan = totm;
			totManCreated = totcrm;
			totDeadMan = totdm;
			totZombies = totz;
			secplayed = time;
			
			var statstr:String = "                                Stats\n\n Total Grass Created: " + String(totGrass) + "\n Total Eaten Grass: " + String(totDeadGrass) + "\n" +
								 "\n Total Cows: " + String(totCow) + "\n Total Cows Created: " + String(totCowCreated) + "\n Total Dead Cows: " + String(totDeadCow) + "\n" +
								 "\n Total Men: " + String(totMan) + "\n Total Men Created: " + String(totManCreated) + "\n Total Dead Men: " + String(totDeadMan) + "\n" +
								 "\n Total Zombies: " + String(totZombies) + "\n\n Total Seconds to Win: " + String(secplayed);
			stats = new PunkTextArea(statstr, 100, 250, 600, 270);
		}

		private function ShowStats():void
		{
			if (!statShown)
			{
				statShown = true;
				add(stats);
			}
			else
			{
				statShown = false;
				remove(stats);
			}
		}
	}

}