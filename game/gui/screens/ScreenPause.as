package game.gui.screens
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.events.GameUI_Event;
	import game.gui.GameUI;
	
	public class ScreenPause extends ScreenSample
	{
		public var mc:swc_pause_fon = new swc_pause_fon();
		
		public var rezumeBtn:swc_rezumeBtn = new swc_rezumeBtn();
		public var btnMenu:swc_backmenu = new swc_backmenu();
		public var achivBtn:swc_btn_achiv_mc = new swc_btn_achiv_mc();
		
		public function ScreenPause()
		{
			super("The Game - Litachok... pause");
			
			addChild(mc);
			mc.x = Game.GameWidth/2;
			mc.y = Game.GameHeight/2;
			
			addChild(rezumeBtn);	
			rezumeBtn.x = Game.GameWidth/2;
			rezumeBtn.y = Game.GameHeight/2-50;
			
			addChild(btnMenu);
			btnMenu.addEventListener(MouseEvent.CLICK, menuClick);
			
			addChild(achivBtn);
			achivBtn.x = rezumeBtn.x-3;
			achivBtn.y = rezumeBtn.y+60;
			
			btnMenu.x = rezumeBtn.x;
			btnMenu.y = rezumeBtn.y+106;
			
			
			// sounds
			game.Game.sounds.addButton(rezumeBtn);
			game.Game.sounds.addButton(btnMenu);
			game.Game.sounds.addButton(achivBtn);
		}
		
		override public function show():void
		{
			super.show();
			(parent as game.gui.GameUI).screenComplete.checkAchivs(achivBtn);
		}
		
		private function menuClick(e:MouseEvent):void{	
			hide();
			dispatchEvent(new Event(GameUI_Event.SHOW_MENU));
			
			game.Game.sounds.propellerOff();
		}
	}
}