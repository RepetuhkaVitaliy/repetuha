package game.gui
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.utils.Timer;
	
	import game.Game;
	import game.Sounds;
	import game.events.GameUI_Event;
	import game.garage.Shop;
	import game.gui.screens.*;
	import game.level.Level;
	import game.level.LevelsData;
	
	public class GameUI extends Sprite
	{
		public static var level:Level = null;
		
		public var screenStart:ScreenStart = new ScreenStart();
		
		private var screenPause:ScreenPause = new ScreenPause();
		
		public var screenLevel:ScreenLevel = new ScreenLevel();
		
		public var screenChoose:ScreenChooseLevel = new ScreenChooseLevel();
		
		public var screenComplete:ScreenLevelComplete = new ScreenLevelComplete();
		
		public var screenAchiv:ScreenAchivements = new ScreenAchivements();
		
		public var screenFaild:ScreenFaildLevel = new ScreenFaildLevel();
		
		public var screenShop:ScreenShop = new ScreenShop();
		
		private var totalscore:swc_total = new swc_total();
		
		public var soundpanel:swc_soundpanel = new swc_soundpanel();
		
		public var howto:swc_howto = new swc_howto();
		
		public var credits:swc_credits = new swc_credits();
		
		public function GameUI()
		{
			
			addChild(screenLevel);
			
			addChild(screenPause);
			
			addChild(screenComplete);
			
			addChild(credits);
			
			addChild(screenChoose);
			
			addChild(totalscore);
			
			addChild(screenFaild);
			
			addChild(screenStart);
			
			addChild(screenAchiv);
			
			addChild(screenShop);
			
			addChild(howto);
			
			addChild(soundpanel);
			
			screenStart.show();
			
			// basic 
			screenStart.startBtn.addEventListener(MouseEvent.CLICK,function():void{
				
			   screenStart.hide();
			   screenChoose.show();
			   
			   updateTotalScore();
			});
			
			screenLevel.pauseBtn.addEventListener(MouseEvent.CLICK,function():void{
				screenLevel.hide();
				screenPause.show();
				dispatchEvent(new Event(GameUI_Event.PAUSE_GAME));
			});
			
			screenLevel.addEventListener(GameUI_Event.SHOW_SCREEN,function():void
			{
				Game.sounds.musicOn(0.45);
				totalscore.visible = false;
			});
			
			screenLevel.addEventListener(GameUI_Event.HIDE_SCREEN,function():void
			{
				Game.sounds.musicOn();
				totalscore.visible = true;
			});
			
			
			screenPause.rezumeBtn.addEventListener(MouseEvent.CLICK,function():void{
				screenLevel.visible = true;
				totalscore.visible = false;
				screenPause.hide();
				screenStart.hide()
				dispatchEvent(new Event(GameUI_Event.REZUME_GAME));
				
				Game.sounds.musicOn(0.45);
			});
			screenPause.addEventListener(GameUI_Event.SHOW_MENU,function():void{
				screenStart.show();
			});
			
			// add levelChooser
			screenChoose.addEventListener(GameUI_Event.START_GAME,function():void{
				game.Game.levelNum = screenChoose.chooseLevel;
				
				screenChoose.hide();
				screenLevel.show();
				screenStart.hide();
				
				dispatchEvent(new Event(GameUI_Event.START_GAME));
			});
			screenChoose.addEventListener(GameUI_Event.SHOW_MENU,function():void{
				screenStart.show();
			});
			
			// add level complete
			screenComplete.mc.btn_levels.addEventListener(MouseEvent.CLICK,function():void
			{
				screenComplete.hide();
				screenChoose.show();
				screenStart.hide();
			});
			
			screenComplete.addEventListener(GameUI_Event.START_GAME,function():void{
				
				
				screenChoose.update();
				game.Game.levelNum = screenChoose.chooseLevel;
				
				                  //callStartFromComplete();
				showShopBeforeLevel(callStartFromComplete)
				screenComplete.hide();
			});
			
			function callStartFromComplete():void
			{
				screenLevel.show();
				
				screenComplete.hide();
				screenStart.hide();
				
				dispatchEvent(new Event(GameUI_Event.START_GAME));
			}
			
			screenComplete.addEventListener(GameUI_Event.SHOW_MENU,function():void{
				screenComplete.hide();
				screenStart.show();
			});
			screenComplete.addEventListener(GameUI_Event.REPLAY_LEVEL,function():void
			{
				game.Game.levelNum --;
				
				screenComplete.hide();
				screenLevel.show();
				dispatchEvent(new Event(GameUI_Event.START_GAME));
			});
			screenComplete.addEventListener(GameUI_Event.SHOW_SCREEN,function():void
			{
				game.Game.sounds.play(game.Sounds.COMPLETE);
				game.Game.sounds.musicOff();
				var tt:Timer = new Timer(5000,1);
				tt.start();
				tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
				{
				    if(screenLevel.visible == false)game.Game.sounds.musicOn();
				});
			});
			
			// add achivs
			screenComplete.mc.btn_achiv.addEventListener(MouseEvent.CLICK,showAchivs);
			screenComplete._screenAchis = screenAchiv;
			screenStart.achivBtn.addEventListener(MouseEvent.CLICK,showAchivs);
			screenChoose.achivBtn.addEventListener(MouseEvent.CLICK,showAchivs);
			screenPause.achivBtn.addEventListener(MouseEvent.CLICK,showAchivs);
			
			// shop
			screenComplete.mc.btn_shop.addEventListener(MouseEvent.CLICK,showShop);
			screenFaild.mc.btn_shop.addEventListener(MouseEvent.CLICK,showShop);
			screenChoose.shopBtn.addEventListener(MouseEvent.CLICK,showShop);
			
			var _shopCallBack:Function = null;
			this.screenShop.addEventListener(GameUI_Event.HIDE_SCREEN,function():void
			{
				if(_shopCallBack != null){
					_shopCallBack();
					_shopCallBack = null;
				}
			});
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void{
					game.Game.shop.addEventListener(game.garage.Shop.EVENT_BUY,function():void
					{
						updateTotalScore();
					});
			});
			
			
			function showShopBeforeLevel(callBack:Function):void
			{
				_shopCallBack = callBack;
				screenShop.show();
			}
			
			// add faild
			screenFaild.addEventListener(GameUI_Event.SHOW_MENU,function():void{
				screenFaild.hide();
				screenStart.show();
			});
			screenFaild.mc.btn_levels.addEventListener(MouseEvent.CLICK,function():void
			{
				screenFaild.hide();
				screenChoose.show();
				screenStart.hide();
			});
			screenFaild.addEventListener(GameUI_Event.REPLAY_LEVEL,function():void
			{
				screenFaild.hide();
				screenLevel.show();
				dispatchEvent(new Event(GameUI_Event.START_GAME));
			});
			
			screenFaild.addEventListener(GameUI_Event.SHOW_SCREEN,function():void
			{
				_shopCallBack = null;
				
				game.Game.sounds.play(game.Sounds.FAIL,500);
				game.Game.sounds.musicOff();
				var tt:Timer = new Timer(2000,1);
				tt.start();
				tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
				{
					if(screenLevel.visible == false)game.Game.sounds.musicOn();
				});
			});
			
			
			// howto
			howto.x = game.Game.GameWidth/2;
			howto.y = game.Game.GameHeight/2;
			howto.visible = false;
			howto.btn_close.addEventListener(MouseEvent.CLICK,function():void
			{
				howto.visible = false;
			});
			screenChoose.mc.btn_howto.addEventListener(MouseEvent.CLICK,function():void
			{
				howto.visible = true;
			});
			screenStart.mc.mc_menu.btn_howto.addEventListener(MouseEvent.CLICK,function():void
			{
				howto.visible = true;
			});
			
			//credits
			credits.x = game.Game.GameWidth/2;
			credits.y = game.Game.GameHeight/2;
			credits.visible = false;
			credits.btn_continue.addEventListener(MouseEvent.CLICK,function():void
			{
				showLevelComplete(game.gui.GameUI.level.rezult.points);
			});
			
			//totalscore
			totalscore.x = game.Game.GameWidth/2;
			/* MOBILE*/ ///totalscore.alpha = 0;
			
			// sound panel
			soundpanel.x = game.Game.GameWidth-60;
			soundpanel.y = game.Game.GameHeight-25;/* MOBILE*/ ///soundpanel.y = 40;//
			soundpanel.filters = [new DropShadowFilter(3,45,0x4d4d4d,0.6,3,3,10)]
			soundpanel.addEventListener("soundon",function():void{ game.Game.sounds.soundsEnable = true; game.Game.sounds.soundsOn(); });
			soundpanel.addEventListener("soundoff",function():void{ game.Game.sounds.soundsEnable = false; game.Game.sounds.soundsOff(); });
			soundpanel.addEventListener("musicon",function():void{ game.Game.sounds.musicEnable = true; if(!screenLevel.visible)game.Game.sounds.musicOn() else game.Game.sounds.musicOn(0.45); });
			soundpanel.addEventListener("musicoff",function():void{ game.Game.sounds.musicEnable = false; game.Game.sounds.musicOff(); });
			soundpanel.STATE("soundon");
			soundpanel.STATEMUSIC("musicon");
			/* temp */ //soundpanel.STATEMUSIC("musicoff");game.Game.sounds.musicEnable = false; game.Game.sounds.musicOff();
		}
		
		public function showAchivs(e:MouseEvent):void
		{
			screenAchiv.show();
		}
		
		public function showShop(e:MouseEvent):void
		{
			screenShop.show();
		}
		
		public function levelComplete(points:Number):void
		{
			if(game.Game.levelNum > 24)showCredits()
			else showLevelComplete(points);
		}
		
		private function showLevelComplete(points:Number):void
		{
			screenLevel.hide();
			screenComplete.show();
			
			screenComplete.showScore(points);
		
			updateTotalScore();
			
			credits.visible = false;
		}
		
		public function updateTotalScore():void{
			totalscore.field_total_score.text = ""+game.level.LevelRezults.totalScore;
			totalscore.field_coins.text = ""+game.Game.shop.budget;
		}
		
		private function showCredits():void
		{
			credits.visible = true;
			credits.alpha = 0;
			Tweener.addTween(credits,{alpha:1,time:1,delay:9,transition:"easenone"});
			
			game.Game.sounds.play(game.Sounds.COMPLETE);
		}
		
		
		public function showGameOver(points:Number):void
		{
			screenLevel.hide();
			screenFaild.show();
		}
	}
}
