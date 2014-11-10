package game.gui.screens
{
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.events.GameUI_Event;
	import game.gui.GameUI;
	import game.level.LevelRezults;
	
	public class ScreenFaildLevel extends ScreenSample
	{
		
		public var mc:swc_gui_faild = new swc_gui_faild();	
		
		public function ScreenFaildLevel(screenName:String="")
		{
			super("faild");
			
			addChild(mc);
			mc.x = game.Game.GameWidth/2;
			mc.y = game.Game.GameHeight/2;
			
			mc.btn_menu.addEventListener(MouseEvent.CLICK,function():void
			{
				dispatchEvent(new Event(GameUI_Event.SHOW_MENU));
			});
			
			mc.btn_replay.addEventListener(MouseEvent.CLICK,function():void
			{
				dispatchEvent(new Event(GameUI_Event.REPLAY_LEVEL));
			});
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown,false,0,true);
			});
			
			// sounds
			game.Game.sounds.addButton(mc.btn_menu);
			game.Game.sounds.addButton(mc.btn_replay);
			game.Game.sounds.addButton(mc.btn_levels);
			game.Game.sounds.addButton(mc.btn_shop);
		}
		
		override public function show():void
		{
			mc.mc_why.gotoAndStop(1);
			if(game.level.LevelRezults.timeLeft <= 0)mc.mc_why.gotoAndStop(2);
			
			(parent as game.gui.GameUI).screenShop.checkAvaibles(mc.btn_shop);
			
			super.show();
			x = game.Game.GameWidth;
			Tweener.addTween(this,{x:-30,time:0.5,delay:1.5,transition:"easeoutquad"});
			Tweener.addTween(this,{x:0,time:0.2,delay:2,transition:"easeinquad"});
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32)// space
			{
				if(visible && x == 0){
					dispatchEvent(new Event(GameUI_Event.REPLAY_LEVEL));
				}
			}
		}
	}
}