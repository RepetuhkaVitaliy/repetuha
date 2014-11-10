package game.gui.screens
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.Game;
	import game.gui.GameUI;
	
	public class ScreenStart extends ScreenSample
	{
		public var mc:swc_gui_start = new swc_gui_start();
		
		public var startBtn:swc_startBtn;
		
		public var achivBtn:swc_btn_achiv_mc;
		
		public function ScreenStart()
		{
			super("The Game - Litachok");
			
			addChild(mc);
			mc.x = Game.GameWidth/2;
			mc.y = Game.GameHeight/2;
			
			startBtn = mc.mc_menu.btn_start;
			achivBtn = mc.mc_menu.btn_achiv;
			
			// sounds
			game.Game.sounds.addButton(startBtn);
			game.Game.sounds.addButton(achivBtn);
			game.Game.sounds.addButton(mc.mc_menu.btn_moregames);
			game.Game.sounds.addButton(mc.mc_menu.btn_howto);
			
			// after loading menu anim
			mc.mc_menu.visible = false;
			var tt:Timer = new Timer(3000,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
				mc.mc_menu.visible = true;
				mc.gotoAndPlay(2);
			});
		}
		
		override public function show():void
		{
			super.show();
			/* MOBILE*/ mc.gotoAndPlay(2);
			
			(parent as game.gui.GameUI).screenComplete.checkAchivs(achivBtn);
		}
	}
}
