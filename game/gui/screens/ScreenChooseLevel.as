package game.gui.screens
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.events.GameUI_Event;
	import game.garage.Shop;
	import game.gui.GameUI;
	import game.level.LevelRezults;
	import game.level.LevelsData;
	
	import caurina.transitions.Tweener;
	
	public class ScreenChooseLevel extends ScreenSample
	{
		
		public var chooseLevel:Number = 0;
		
		public var mc:swc_gui_levelchoose = new swc_gui_levelchoose();
		
		public var btnMenu:swc_backmenu = new swc_backmenu();
		public var btnPlay:swc_playlevel = new swc_playlevel();
		
		public var achivBtn:swc_btn_achiv_mc = new swc_btn_achiv_mc();
		
		public var shopBtn:swc_gui_btn_shop_mc = new swc_gui_btn_shop_mc();
		
		public function ScreenChooseLevel(screenName:String="Choose Level:")
		{
			super(screenName);
			
			addChild(mc);
			mc.x = game.Game.GameWidth/2;
			mc.y = game.Game.GameHeight/2;
			
			
			addChild(cont);
			cont.x = 205;
			cont.y = 84;
			
			btnMenu = mc.btn_home;
			btnPlay = mc.btn_play;
			achivBtn = mc.btn_achiv;
			shopBtn = mc.btn_shop;
			
			
			btnMenu.addEventListener(MouseEvent.CLICK, menuClick);
			btnPlay.addEventListener(MouseEvent.CLICK, playClick);
			
			// sounds
			game.Game.sounds.addButton(btnMenu);
			game.Game.sounds.addButton(btnPlay);
			game.Game.sounds.addButton(achivBtn);
			game.Game.sounds.addButton(shopBtn);
			game.Game.sounds.addButton(mc.btn_howto);
			
		}
		
		// PUBLIC:
		public override function show():void
		{
			super.show();
			
			update();
			
			(parent as game.gui.GameUI).screenComplete.checkAchivs(achivBtn);
			
			(parent as game.gui.GameUI).screenShop.checkAvaibles(shopBtn);
			
			/* MOBILE*/ 	cont.y = 470;
			/* MOBILE*/ Tweener.addTween(cont,{y:84,time:1,transition:"easeoutquad"});
			
			//if(game.Game.levelNum == 1){shopBtn.alpha = 0.7;shopBtn.mouseEnabled = false;}
			//if(game.Game.levelNum > 1){shopBtn.alpha = 1;shopBtn.mouseEnabled = true;}
		}
		
		public function update():void
		{
			if(buttons.length == 0)init(game.level.LevelsData.levels.length);
			
			setCurrent(game.Game.levelNum);
			
			updateStars();
		}
		
		// PRIVATE:
		private var buttons:Array = [];
		private var cont:Sprite = new Sprite();
		private static var buttonsBorder:Number = 2; 
		private function init(totalNum:Number):void{
			createButtons(totalNum)
		}
		public function createButtons(totalNum:Number):void{
			var tr:Number = 0;
			var td:Number = 0;
			for(var i:uint = 0;i < totalNum;i++){
				
				var btn:swc_level_button = new swc_level_button();
				btn.num.text = String(i+1);
				btn.num.mouseEnabled = false;
				btn.buttonMode = true;
				buttons.push(btn);		
				btn.addEventListener(MouseEvent.CLICK, btnClick);
				cont.addChild(btn);
				btn.x = td*(btn.width+buttonsBorder+8);
				btn.y = tr*(btn.height+buttonsBorder);
				
				btn.mc_level_locked.mouseEnabled = false;
				
				// lock leves
				btn.mouseEnabled = false;
				//btn.mc_level_locked.visible = false;
				
				btn.mc_level_locked.mouseChildren = false;
				btn.mc_level_locked.mouseEnabled = false;
				
				// hide stars
				btn.mc_star1.visible = false;
				btn.mc_star1.mouseEnabled = false;
				btn.mc_star2.visible = false;
				btn.mc_star2.mouseEnabled = false;
				btn.mc_star3.visible = false;
				btn.mc_star3.mouseEnabled = false;
				btn.mc_stars_gray.mouseEnabled = false;
				btn.mc_stars_gray.mouseChildren = false;
				
				td++;
				if(td >= 6){
					td = 0;
					tr++;
				}
			}
				
			setCurrent(1);
		}
		
		private function btnClick(e:MouseEvent):void{
			var btn:MovieClip = e.target as MovieClip;
			
			for(var i:uint = 0;i < buttons.length;i++){
				buttons[i].gotoAndStop(1);
			}
			
			btn.gotoAndStop(2);
			
			chooseLevel = buttons.indexOf(btn)+1;
			Core.u.write("choosen level = "+chooseLevel);
		}
		
		private function setCurrent(num:Number):void{
			if(buttons.length > 0 && num < buttons.length+1){
				for(var i:uint = 0;i < buttons.length;i++){
					buttons[i].gotoAndStop(1);
					
					if(num-1 >= i){
						buttons[i].alpha = 1;
						buttons[i].mouseEnabled = true;
						(buttons[i] as swc_level_button).mc_level_locked.visible = false;
					}
				}
				
				buttons[num-1].gotoAndStop(2);
				
				chooseLevel = num;
			}
		}
		
		private function updateStars():void
		{
			for(var i:uint = 0;i < buttons.length;i++)
			{
                buttons[i].mc_star1.visible = false;
				buttons[i].mc_star2.visible = false;
				buttons[i].mc_star3.visible = false;
				
				if(game.level.LevelRezults.levelsPoints.length < i+1)return;
				
				if(game.level.LevelRezults.levelsPoints[i].stars >= 1)buttons[i].mc_star1.visible = true;
				if(game.level.LevelRezults.levelsPoints[i].stars >= 2)buttons[i].mc_star2.visible = true;
				if(game.level.LevelRezults.levelsPoints[i].stars >= 3)buttons[i].mc_star3.visible = true;
			}
				
		}
		
		private function playClick(e:MouseEvent):void{	
			
			if(chooseLevel > 0){
					dispatchEvent(new Event(GameUI_Event.START_GAME));
		    }
		}
		
		private function menuClick(e:MouseEvent):void{	
			hide();
			dispatchEvent(new Event(GameUI_Event.SHOW_MENU));
		}
	}
}
