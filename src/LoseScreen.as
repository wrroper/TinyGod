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
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class LoseScreen extends World 
	{
		[Embed(source = 'assets/gameover.png')] private const GAMEOVER:Class;
		
		private var scr:BGScreen = null;
		private var startbtn:PunkButton;

		public function LoseScreen() 
		{
			scr = new BGScreen(new Image(GAMEOVER));
			add(scr);
			
			startbtn = new PunkButton(350, 550, 100, 20, "End Game", StartGame);
			add(startbtn);
		}
		
		
		private function StartGame():void
		{
			trace("Start it!");
			startbtn.active = false;
			FP.world = new TitleScreen;
		}
	}

}