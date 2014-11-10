package game.gui.screens
{
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.Game;
	import game.engine.Engine;
	import game.gui.GameUI;
	import game.level.Level;
	import game.level.LevelRezults;
	import game.level.LevelView;
	
	public class ScreenLevel extends ScreenSample
	{
		public var pauseBtn:swc_pauseBtn = new swc_pauseBtn();
		
		private var pointsMc:swc_points = new swc_points();
		
		//private var laser:swc_laser = new swc_laser();
		
		private var tip:swc_gui_tipcontrol = new swc_gui_tipcontrol();
		
		private var timer:swc_timer = new swc_timer();
		
		private var nitro:swc_gui_nitro = new swc_gui_nitro();
		
		private var roket:swc_gui_roket = new swc_gui_roket();
		
		private var magnit:swc_gui_magnit = new swc_gui_magnit();
		
		private var levelnum:swc_levelnum = new swc_levelnum();
		
		private var loading:swc_load_level = new swc_load_level();
		
		public function ScreenLevel()
		{
			visible = false;
			super("The Game - Litachok... figth!");
			
			addChild(pauseBtn);
			pauseBtn.x = Game.GameWidth-pauseBtn.width/2-5;
			pauseBtn.y = pauseBtn.height/2+5;
			
			// points
			addChild(pointsMc);
			pointsMc.mouseEnabled = pointsMc.mouseChildren = false;
			updateScore(0);
			
			// laser
			//addChild(laser);
			//updateLaser(0);
			
			addChild(timer);
			timer.x = 5;
			timer.y = 50;
			
			addChild(nitro);
			nitro.x = timer.x;
			nitro.y = timer.y+40;
			
			// control tip
			addChild(tip);
			tip.x = game.Game.GameWidth/2;
			tip.y = game.Game.GameHeight/2;
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
		  	    stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown,false,0,true);
			});
			//tip.btn_ok.addEventListener(MouseEvent.CLICK,tipHide);
			tip.btn_close.addEventListener(MouseEvent.CLICK,tipHide);
			tip.visible = false;
			
			// roket
			addChild(roket);
			roket.x = 0;
			roket.y = Game.GameHeight;
			
			// magnit
			addChild(magnit);
			magnit.x = 0;
			magnit.y = Game.GameHeight;
			
			//levelnum
			addChild(levelnum);
			levelnum.x = game.Game.GameWidth/2;
			levelnum.y = 20;
			
			//
			addChild(loading);
			loading.x = game.Game.GameWidth/2;
			loading.y = game.Game.GameHeight/2;
			
			this.addEventListener(Event.ENTER_FRAME, en);
			
			// sounds
			game.Game.sounds.addButton(pauseBtn);
		}
		
		public function en(e:Event):void
		{
			if(visible){
			  // level timer
			  timer.mc_percent.scaleX = game.level.LevelRezults.timeLeft/100;
			  if(timer.mc_percent.scaleX < 0.2 && timer.mc_border.currentFrame == 1){
				  timer.mc_border.gotoAndPlay(5);
			  }
			  
			  // roket
			  if(game.gui.GameUI.level.ship.roketEnable && game.gui.GameUI.level.ship.roketZapas != null){
				  roket.visible = true;
				  roket.mc_percent.gotoAndStop(1+Math.round(game.gui.GameUI.level.ship.roketTimer/game.gui.GameUI.level.ship.roketResetTime*100));
				  roket.mc_percent2.scaleX = Math.round(game.gui.GameUI.level.ship.roketZapas.health)/100;
			  }else{
				  roket.visible = false;  
			  }
			  
			  //nitro
			  if(game.gui.GameUI.level.ship.nitroEnable){
				 nitro.visible = true;
			     nitro.mc_percent.scaleX = Math.round(game.gui.GameUI.level.ship.nitroPercent*100)/100;
			  }else{
				  nitro.visible = false; 
			  }
			  
			  // magnit
			  if(game.gui.GameUI.level.ship.magnitEnable && game.gui.GameUI.level.ship.magnitZapas != null){
				  magnit.visible = true;
				  magnit.mc_percent.scaleX = Math.round(game.gui.GameUI.level.ship.magnitZapas.health)/100;
			  }else{
				  magnit.visible = false;
			  }
			}
		}
		
		public function updateScore(points:Number):void
		{
			pointsMc.field.text = "Points:"+points;
		}
		
		public function updateLaser(percent:Number):void
		{
			//laser.field.text = "Laser - "+percent;
		}
		
		override public function show():void{
			super.show();
			
			loading.visible = true;
			loading.play();
			loading.mc_tips.gotoAndStop(Math.round(1+3*Math.random()));
			if(game.Game.levelNum < 4)loading.mc_tips.visible = false;
			else loading.mc_tips.visible = true;
			
			var tt1:Timer = new Timer(100,1);
			tt1.start();
			tt1.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
			   game.gui.GameUI.level.pause();
			   
			   game.gui.GameUI.level.view.renderTick();
			});
			
			var tt:Timer = new Timer(2100,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
				// hide loading
				game.gui.GameUI.level.rezume();
				game.gui.GameUI.level.ship.startAnimation();
				loading.visible = false;
				
				tt = null;
				if(game.Game.levelNum == 1)tipShow(1);
				
				if(game.gui.GameUI.level.ship.nitroEnable)tipShow(2);
				
				if(game.gui.GameUI.level.ship.roketEnable)tipShow(3);
			});
			
			levelnum.field.text = "Level: "+game.Game.levelNum;
			updateScore(0);
		}
		
		private var tipsComplete:Array = [];
		private function tipShow(_id:Number = 1):void
		{
			if(tipsComplete.indexOf(_id) != -1)return;
			
			tipsComplete.push(_id);
			
			tip.gotoAndStop(_id);
			tip.visible = true;
			var cY:Number = game.Game.GameHeight/2;
			//tip.y = -500;
			tip.y = cY;
			tip.scaleX = tip.scaleY = 0;
			Tweener.addTween(tip,{scaleY:1,scaleX:1,time:0.5,delay:1,transition:"easeoutquad"});
			
			var tt:Timer = new Timer(1000,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
				game.gui.GameUI.level.pause();
				tt = null;
			});
		}
		
		// hide tip
		private function tipHide(e:MouseEvent = null):void
		{
			game.gui.GameUI.level.rezume();
			
			Tweener.addTween(tip,{scaleX:0,scaleY:0,time:0.3,transition:"easeinquad",onComplete:function():void
			{
				tip.visible = false;
			}});
		}
		private function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32)// space
			{
			   if(visible && tip.visible){
				   tipHide();
			   }
			}
		}
	}
}