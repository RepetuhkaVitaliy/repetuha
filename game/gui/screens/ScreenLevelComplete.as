package game.gui.screens
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.events.GameUI_Event;
	import game.gui.GameUI;
	import game.level.LevelRezults;
	
	import mx.core.ButtonAsset;

	public class ScreenLevelComplete extends ScreenSample
	{
		public var mc:swc_your_score = new swc_your_score();
		
		public function ScreenLevelComplete(screenName:String="")
		{
			super("Level complete!");
			
			addChild(mc);
			mc.x = game.Game.GameWidth/2;
			mc.y = game.Game.GameHeight/2;
			
			mc.btn_next.addEventListener(MouseEvent.CLICK,function():void
			{
			     dispatchEvent(new Event(GameUI_Event.START_GAME));
			});
			
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
			game.Game.sounds.addButton(mc.btn_next);
			game.Game.sounds.addButton(mc.btn_achiv);
			game.Game.sounds.addButton(mc.btn_levels);
			game.Game.sounds.addButton(mc.btn_menu);
			game.Game.sounds.addButton(mc.btn_replay);
			game.Game.sounds.addButton(mc.btn_shop);
		}
		
		override public function show():void
		{
			super.show();
			x = game.Game.GameWidth;
			Tweener.addTween(this,{x:-30,time:0.5,delay:3,transition:"easeoutquad"});
			Tweener.addTween(this,{x:0,time:0.2,delay:3.5,transition:"easeinquad"});
			
			//mc.mc_score.y = -194-200;
			//Tweener.addTween(mc.mc_score,{y:-194+15,time:0.5,delay:2.5,transition:"easeoutquad"});
			//Tweener.addTween(mc.mc_score,{y:-194,time:0.2,delay:3,transition:"easeinquad"});
			
		}
		
		public function showScore(points:Number):void
		{
			mc.field_score.text = "Level points: "+points;
			
			
			Tweener.addTween(mc,{alpha:1,time:2,onComplete:function():void
			{
				updateStars();
				
				updateBonuses();
				
				checkAchivs(mc.btn_achiv);
				
				(parent as game.gui.GameUI).screenShop.checkAvaibles(mc.btn_shop);
			}});
		}
		
		public var _screenAchis:ScreenAchivements = null;
		public function checkAchivs(achivBtnMc:MovieClip):void
		{
			(achivBtnMc as swc_btn_achiv_mc).mc_blick.visible = false;
			
			if(!_screenAchis)return;
			if(_screenAchis.newunlock.length == 0)return;
			
			// anim - alert blick
			(achivBtnMc as swc_btn_achiv_mc).mc_blick.visible = true;
			if(animatedAchivBtns.indexOf(achivBtnMc) == -1)animatedAchivBtns.push(achivBtnMc);
		}
		
		// anim - alert blick
		private var animatedAchivBtns:Array = [];
		public function stopAnimatedAlertBtns():void
		{
			for (var i:int = 0; i < animatedAchivBtns.length; i++) 
			{
				var achivBtnMc:swc_btn_achiv_mc = animatedAchivBtns[i];
				achivBtnMc.mc_blick.visible = false;	
			}
			
		}
		
		private function updateBonuses():void
		{
		   mc.field_bonus_accuracy.text = "+0";
		   mc.field_bonus_fuel.text = "+0";
		   mc.field_bonus_nobump.text = "+0";
			   
		   if(!game.level.LevelRezults.levelsPoints[game.Game.levelNum-2])return;
		   
		   mc.field_bonus_accuracy.text = "+"+game.level.LevelRezults.levelsPoints[game.Game.levelNum-2].accuracy;
		   
		   mc.field_bonus_fuel.text = "+"+game.level.LevelRezults.levelsPoints[game.Game.levelNum-2].fuel;
		   
		   mc.field_bonus_nobump.text = "+"+game.level.LevelRezults.levelsPoints[game.Game.levelNum-2].nobump;
		   
		   /// animation
		   mc.field_bonus_accuracy.alpha = 0;mc.field_bonus_accuracy.y -= 30;
		   Tweener.addTween(mc.field_bonus_accuracy,{alpha:1,y:mc.field_bonus_accuracy.y+30,time:1,transition:"easeoutbounce"});
		   
		   mc.field_bonus_fuel.alpha = 0;mc.field_bonus_fuel.y -= 30;
		   Tweener.addTween(mc.field_bonus_fuel,{alpha:1,y:mc.field_bonus_fuel.y+30,time:1,delay:0.4,transition:"easeoutbounce"});
		   
		   mc.field_bonus_nobump.alpha = 0;mc.field_bonus_nobump.y -= 30;
		   Tweener.addTween(mc.field_bonus_nobump,{alpha:1,y:mc.field_bonus_nobump.y+30,time:1,delay:0.8,transition:"easeoutbounce"});
		}
		
		private function updateStars():void
		{
				mc.mc_star1.visible = false;
				mc.mc_star2.visible = false;
				mc.mc_star3.visible = false;
				
				if(!game.level.LevelRezults.levelsPoints[game.Game.levelNum-2])return;
				
				if(game.level.LevelRezults.levelsPoints[game.Game.levelNum-2].stars >= 1){
					mc.mc_star1.visible = true;
					mc.field_awesom.text = "GOOD";
				}
				if(game.level.LevelRezults.levelsPoints[game.Game.levelNum-2].stars >= 2){
					mc.mc_star2.visible = true;
					mc.field_awesom.text = "GREAT";
				}
				if(game.level.LevelRezults.levelsPoints[game.Game.levelNum-2].stars >= 3){
					mc.mc_star3.visible = true;
					mc.field_awesom.text = "PERFECT";
				}
				
				/// animation
				mc.mc_star1.scaleX = mc.mc_star1.scaleY = 2;mc.mc_star1.alpha = 0;
				Tweener.addTween(mc.mc_star1,{scaleX:1,scaleY:1,alpha:1,time:1,delay:1.5,transition:"easeoutbounce"});
				
				mc.mc_star2.scaleX = mc.mc_star2.scaleY = 2;mc.mc_star2.alpha = 0;
				Tweener.addTween(mc.mc_star2,{scaleX:1,scaleY:1,alpha:1,time:1,delay:2,transition:"easeoutbounce"});
				
				mc.mc_star3.scaleX = mc.mc_star3.scaleY = 2;mc.mc_star3.alpha = 0;
				Tweener.addTween(mc.mc_star3,{scaleX:1,scaleY:1,alpha:1,time:1,delay:2.5,transition:"easeoutbounce"});
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32)// space
			{
				if(visible && x == 0){
					dispatchEvent(new Event(GameUI_Event.START_GAME));
				}
			}
		}
	}
}