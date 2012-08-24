package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.World;
	import punk.ui.PunkButton;
	import punk.ui.PunkLabel;
	import punk.ui.PunkPanel;
	import punk.ui.PunkRadioButton;
	import punk.ui.PunkRadioButtonGroup;
	import net.flashpunk.FP;
	import net.flashpunk.Sfx;
	import Playtomic.*;
	import punk.ui.PunkToggleButton;
	
	/**
	 * ...
	 * @author Ryan Roper
	 */
	public class MyWorld extends World 
	{
		
		public static var zomLeft:int = 0;
		
		private var guiPanel:PunkPanel;
		private var lifelbl:PunkLabel;
		private var lifefrclbl:PunkLabel;
		private var hintlbl:PunkLabel;
		private var rdoGrass:PunkRadioButton;
		private var rdoCow:PunkRadioButton;
		private var rdoMan:PunkRadioButton;
		private var rdoSower:PunkRadioButton;
		private var rdoGroup:PunkRadioButtonGroup;
		private var chkSound:PunkToggleButton;		
		private var lblNumGrass:PunkLabel;
		private var lblNumCows:PunkLabel;
		private var lblNumMen:PunkLabel;
		private var lblNumSower:PunkLabel;
		
		private var makeGrass:Boolean;
		private var lifGrass:int;
		private var makeCow:Boolean;
		private var lifCow:int;
		private var makeMan:Boolean;
		private var lifMan:int;
		private var makeSower:Boolean;
		private var lifSower:int;
		private var zwave1:Boolean = false;
		private var zwave2:Boolean = false;
		private var zwave3:Boolean = false;
		
		private var countdown:Number;
		
		private var secPlayed:int = 0;
		private var frmCounter:Number = 0;
		private var totZombies:int = 0;
		
		public function MyWorld() 
		{
			lifGrass = 0;
			lifCow = 30;
			lifMan = 300;
			lifSower = 800;
			countdown = 15;
			
			add(new GameManager);
			
			//add(new Cow);
			//add(new PunkButton(10, 10, 100, 25, "Press me"));
			
			MakeGui();
		}
		
		private function MakeGui():void
		{
			guiPanel = new PunkPanel(645, 95, 50, 100);
			guiPanel.layer = 2;
			add(guiPanel);
			add(new PunkLabel("Life Power: ", 650, 10, 50, 10));
			lifelbl = new PunkLabel("0 ", 760, 10, 50, 10);
			add(lifelbl);
			add(new PunkLabel("Life Force : ", 650, 30, 60, 10));
			lifefrclbl = new PunkLabel("0 ", 760, 30, 60, 10);
			add(lifefrclbl);
			add(new PunkLabel("Grass : ", 650, 300, 60, 10));
			lblNumGrass = new PunkLabel("0 ", 760, 300, 60, 10);
			add(lblNumGrass);
			lblNumCows = new PunkLabel("0 ", 760, 320, 60, 10);
			lblNumMen = new PunkLabel("0 ", 760, 340, 60, 10);
			lblNumSower = new PunkLabel("0 ", 760, 360, 60, 10);
			
			hintlbl = new PunkLabel("Hints will be displayed here as you play...", 10, 580, 500, 20);
			add(hintlbl);
			
			rdoGroup = new PunkRadioButtonGroup(onRadioChange);
			//add(rdoGroup);
			rdoGrass = new PunkRadioButton(rdoGroup, "Grass", 650, 100, 50, 20, true, "Grass", null, 0, null, true);
			add(rdoGrass);
			
			chkSound = new PunkToggleButton(650, 540, 60, 20, true, "Sound", ToggleSound);
			add(chkSound);
		}
		
		private function ToggleSound(checked:Boolean):void
		{
			if (checked)
			{
				FP.volume = 1;
			}
			else
			{
				FP.volume = 0;
			}
		}
		
		override public function update():void 
		{
			//trace("Test : " + god.LifePower );
			
			frmCounter += .016;
			if (frmCounter >= 1)
			{
				frmCounter -= 1.0;
				secPlayed += 1;
			}
			
			lifelbl.text = String(GameManager.GetGod.LifePower);
			lifefrclbl.text = String(GameManager.GetGod.LifeForce);
			lblNumGrass.text = String(GameManager.GetGod.GrassCount);
			lblNumCows.text = String(GameManager.GetGod.CowCount);
			lblNumMen.text = String(GameManager.GetGod.ManCount);
			lblNumSower.text = String(GameManager.GetGod.SowerCount);
			
			if (SoundManager.DGRMusicPlaying && zomLeft == 0)
				SoundManager.ToggleDGRMusic();
			
			if (GameManager.GetGod.LifeForce >= lifCow && !makeCow)
			{
				rdoCow = new PunkRadioButton(rdoGroup, "Cow", 650, 120, 50, 20, false, "Cow", null, 0, null, true);
				add(rdoCow);
				makeCow = true;
				hintlbl.text = "You have unlocked cows! They arent the brightest but will reproduce on their own!";
				countdown = 10;
				add(new PunkLabel("Cows  : ", 650, 320, 60, 10));
				add(lblNumCows);
				Log.LevelCounterMetric("CowUnlock", "MyWorld", false);
			}
			
			if (GameManager.GetGod.LifeForce >= lifMan && !makeMan)
			{
				rdoMan = new PunkRadioButton(rdoGroup, "Man", 650, 140, 50, 20, false, "Man", null, 0, null, true);
				add(rdoMan);
				hintlbl.text = "You have unlocked men! You are becoming a proper god now!";
				countdown = 10;
				makeMan = true;
				add(new PunkLabel("Men   : ", 650, 340, 60, 10));
				add(lblNumMen);
				Log.LevelCounterMetric("ManUnlock", "MyWorld", false);
			}
			
			if (GameManager.GetGod.LifeForce >= lifSower && !makeSower)
			{
				rdoSower = new PunkRadioButton(rdoGroup, "GrassSower", 650, 160, 50, 20, false, "GrassSower", null, 0, null, true);
				add(rdoSower);
				makeSower = true;
				hintlbl.text = "You have unlocked men! You are becoming a proper god now!";
				countdown = 10;
				add(new PunkLabel("Sower : ", 650, 360, 60, 10));
				add(lblNumSower);
				Log.LevelCounterMetric("SowerUnlock", "MyWorld", false);
			}
			
			if (countdown > 0)
				countdown -= .016;
			else
			{
				CheckHints();
				countdown = 7.0;
			}
			
			if (GameManager.GetGod.LifeForce >= 1400 && zwave1 == false)
			{
				zwave1 = true;
				SpawnZombieWave(1);
				hintlbl.text = "An Elder god sees you have grown too strong and has sent his minions to destroy you!";
				countdown = 10;
				Log.LevelCounterMetric("ZombieWave1", "MyWorld", false);
			}
			
			if (GameManager.GetGod.LifeForce >= 1800 && zwave2 == false)
			{
				zwave2 = true;
				SpawnZombieWave(2);
				hintlbl.text = "The Elder god grows desperate, do not give up!";
				countdown = 10;
				Log.LevelCounterMetric("ZombieWave2", "MyWorld", false);
			}

			if (GameManager.GetGod.LifeForce >= 2200 && zwave3 == false)
			{
				zwave3 = true;
				SpawnZombieWave(3);
				hintlbl.text = "You are becoming a match for the Elder gods strength, defeat his minions!";
				countdown = 10;
				Log.LevelCounterMetric("ZombieWave3", "MyWorld", false);
			}

			if (GameManager.GetGod.LifeForce < 0)
			{
				FP.world = new LoseScreen;
				Log.CustomMetric("Lose", "Screens");
			}
			
			if (GameManager.GetGod.LifeForce > 2500 && countdown < 1 && zomLeft == 0)
			{
				FP.world = new WinScreen(GameManager.GetGod.TotGrass, GameManager.GetGod.TotDeadGrass, GameManager.GetGod.TotCows, GameManager.GetGod.TotCowsCreated, GameManager.GetGod.TotDeadCows, GameManager.GetGod.TotMen, GameManager.GetGod.TotMenCreated, GameManager.GetGod.TotDeadMen, totZombies, secPlayed);;
				SoundManager.StopBGMusic();
				Log.CustomMetric("Win", "Screens");
				Log.LevelAverageMetric("Time", "MyWorld", secPlayed);
			}
			
			super.update();
		}
		
		public function CheckHints():void
		{
			if (GameManager.GetGod.LifeForce == 0)
				hintlbl.text = "A great world, even a tiny one starts with the basics! Try clicking to create grass!";
			if (GameManager.GetGod.LifeForce > 0 && !makeCow)
				hintlbl.text = "Every god needs life force to survive, the more life the better!";
			if (GameManager.GetGod.LifeForce > 0 && makeCow && !makeMan)
				hintlbl.text = "Cows are nice but if you expand your power you will be able to create more complex life.";
			if (GameManager.GetGod.LifeForce > 0 && makeCow && makeMan)
				hintlbl.text = "Beware, the more power you attain the more likely you are to draw attention.";
			if (GameManager.GetGod.LifeForce > 0 && makeCow && makeMan && makeSower)
				hintlbl.text = "Beware, the more power you attain the more likely you are to draw attention.";

			if (GameManager.GetGod.LifeForce >= 1200 && GameManager.GetGod.LifeForce <= 1300)
				hintlbl.text = "Beware, Tiny God! I feel the eyes of an elder god!";
			if (GameManager.GetGod.LifeForce >= 1600 && GameManager.GetGod.LifeForce <= 1700)
				hintlbl.text = "I feel his attention focused on us! Prepare!";
			if (GameManager.GetGod.LifeForce >= 1900 && GameManager.GetGod.LifeForce <= 2100)
				hintlbl.text = "I feel his wrath, prepare for his full might!";
			
		}
		
		private function SpawnZombieWave(wave:int):void
		{
			FP.randomizeSeed();

			var dir:int = FP.rand(4);
			var i:int;
			var num:int;
			
			num = (FP.rand(10)+10)*wave;

			switch(dir)
			{
				case 0:
					
					for (i = 0; i < num; i++)
					{
						add(new Zombie(FP.rand(40), 0));
						totZombies++;
						zomLeft++;
						Log.LevelCounterMetric("Zombies", "MyWorld");
					}
					break;
				case 1:
					for (i = 0; i < num; i++)
					{
						add(new Zombie(39, FP.rand(36)));
						totZombies++;
						zomLeft++;
						Log.LevelCounterMetric("Zombies", "MyWorld");
					}
					break;
				case 2:
					for (i = 0; i < num; i++)
					{
						add(new Zombie(FP.rand(40), 35));
						totZombies++;
						zomLeft++;
						Log.LevelCounterMetric("Zombies", "MyWorld");
					}
					break;
				case 3:
					for (i = 0; i < num; i++)
					{
						add(new Zombie(0, FP.rand(36)));
						totZombies++;
						zomLeft++;
						Log.LevelCounterMetric("Zombies", "MyWorld");
					}
					break;
			}
			
			SoundManager.ToggleDGRMusic();
		}
		
		private function onRadioChange(id:String):void
		{
			//var tmpGod:God = God(typeFirst("God"));
			
			switch(id)
			{
				case "Grass":
					GameManager.GetGod.LifeType = 0;
					break;
				case "Cow":
					GameManager.GetGod.LifeType = 1;
					break;
				case "Man":
					GameManager.GetGod.LifeType = 2;
					break;
				case "GrassSower":
					GameManager.GetGod.LifeType = 3;
					break;
			}
		}
	}
	

}