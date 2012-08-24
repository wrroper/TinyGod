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
	import Playtomic.*;
	import punk.ui.PunkTextArea;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class TitleScreen extends World 
	{
		[Embed(source = 'assets/titlescreen.png')] private const TITLESCREEN:Class;
		
		//private var pic:Image = null;
		private var scr:BGScreen = null;
		private var startbtn:PunkButton;
		private var start:Boolean = false;
		
		private var instbtn:PunkButton;
		private var instr:PunkTextArea;
		private var insShown:Boolean = false;
		
		private var credbtn:PunkButton;
		private var credits:PunkTextArea;
		private var credShown:Boolean = false;
		
		public function TitleScreen() 
		{
			scr = new BGScreen(new Image(TITLESCREEN));
			add(scr);
			
			startbtn = new PunkButton(350, 550, 100, 20, "Start Game", StartGame);
			add(startbtn);
			
			instbtn = new PunkButton(100, 550, 110, 20, "Instructions", ShowInstructions);
			add(instbtn);
			
			instr = new PunkTextArea("                           Welcome to Tiny God\n\n  The goal of the game is to gain Life Force.  You gain Life Force by\n creating life and by the life you create procreating.\n\n  If life dies, you lose power. Get to 2500 Life Force and you win!\n\n  Beware Tiny God! You are not the only diety out there and\n others might not look kindly on your rise to power!",
									  100, 250, 600, 250);
			//add(instr);

			credbtn = new PunkButton(600, 550, 110, 20, "Credits", ShowCredits);
			add(credbtn);
			
			credits = new PunkTextArea("                                Credits\n\nProgramming/Design: Ryan Roper\n\n\nThanks to: Ludum Dare #23, for the inspiration to make this.\n            Chevy Ray for his FlashPunk framework, which I used for\n            the first time this weekend.\n            Abel Troy for his Punk.UI addon, which is displaying this\n            box!\n            GreaseMonkey for his cool music generator!\n\n            And Especially to my understanding girlfriend, Leah\n            without whom I probably wouldn't have done this.",
									  100, 250, 600, 250);
									  
			SoundManager.StartBGMusic();
		}
		
		override public function update():void 
		{
			if (start)
			{
				startbtn.active = false;
				FP.world = new MyWorld;
				Log.Play();
			}
			super.update();
		}
		
		private function StartGame():void
		{
			trace("Start it!");
			start = true;
			//FP.world.remove(startbtn);
		}
		
		private function ShowInstructions():void
		{
			if (!insShown)
			{
				insShown = true;
				add(instr);
			}
			else
			{
				insShown = false;
				remove(instr);
			}
		}

		private function ShowCredits():void
		{
			if (!credShown)
			{
				credShown = true;
				add(credits);
			}
			else
			{
				credShown = false;
				remove(credits);
			}
		}
	}

}