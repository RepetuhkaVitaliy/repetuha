package game
{
	/*
	 *
	   GAME ENGINE FRAMEWORK by REPETUKHA VITALIY.
	*
	*/
		
		import flash.display.Sprite;
		import flash.events.Event;
		import flash.events.MouseEvent;
		
		import game.Sounds;
		import game.events.GameEvent;
		import game.events.GameUI_Event;
		import game.garage.Shop;
		import game.gui.GameUI;
		import game.level.Level;
		
		import view3d.View3d;
		
		public class Game extends Sprite{
			
			public static var GameWidth:Number = 700;// 700
			public static var GameHeight:Number = 480;// 480
			
			public var gui:GameUI = new GameUI();
			
			private var level:Level = new Level();
			
			private var view:View3d = new View3d(level);
			
			public static var achivs:Achivements = new Achivements();
			
			public static var shop:Shop;
			
			public static var sounds:Sounds = new Sounds();
			
			public static var levelNum:uint;
			
			//
			public static var tap:TapControl = new TapControl();
			
			public function Game() {
				// constructor code
				addChild(view);
				
				addChild(level);
				level.view = view;
				
				addChild(gui);
				
				//addChild(tap);tap.enable = false;
				
				GameUI.level = level;
				
				shop = new Shop(gui.screenShop);
		
				init({});
				
				//test01();
			}
			
			private function init(params:Object):void
			{
				trace("game init");
				levelNum = 1;
				
				gui.addEventListener(GameUI_Event.START_GAME,function():void{
					start();
					tap.enable = true;
				});
				
				gui.addEventListener(GameUI_Event.PAUSE_GAME,function():void{
					level.pause();
					tap.enable = false;
				});
				
				gui.addEventListener(GameUI_Event.REZUME_GAME,function():void{
					level.rezume();
					tap.enable = true;
				});
				
				level.addEventListener(GameEvent.LEVEL_PASSED,function():void{ 
					levelNum++; 
					gui.levelComplete(level.rezult.points);
					tap.enable = false;
				});
				
				level.addEventListener(GameEvent.LEVEL_FAILD,function():void{    
					gui.showGameOver(level.rezult.points);
					tap.enable = false;
				});
				
				level.addEventListener(GameEvent.SCORE_UPDATE,function():void{    
					gui.screenLevel.updateScore(level.rezult.points); 
				});
				
				level.addEventListener(GameEvent.SCORE_UPDATE,function():void{    
					gui.screenLevel.updateScore(level.rezult.points); 
				});
				
				game.Game.sounds.musicOn();
				
			}
			
			private function start():void
			{	
				trace("game start();");
				startNewLevel();
				
				view.onResize();
			}
			
			private function startNewLevel():void
			{
				level.init(levelNum);
				level.start();
			}
			
			// tests
			private function test01():void
			{
				//gui. .alpha = 0;
				level.alpha = 0;
				tap.alpha = 1;
				//tap.enable = true;
				
				Core.timer.Delay(1,function():void{
					Game.levelNum = 4;
					start();  });
				
				Core.timer.Delay(1.5,function():void{
					level.faild();
					gui.screenFaild.hide();
				});
				
				//gui.screenStart.hide();
			}
			
		}
}