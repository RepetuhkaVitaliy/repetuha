package game.gui.screens
{
	import caurina.transitions.Tweener;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.Achivements;
	import game.Game;
	import game.gui.GameUI;

	public class ScreenAchivements extends ScreenSample
	{
		
		private var mc:swc_achivements = new swc_achivements();
		
		public function ScreenAchivements(screenName:String="")
		{
			super("achivements");
			
			addChild(mc);
			mc.x = game.Game.GameWidth/2;
			mc.y = game.Game.GameHeight/2;
			
			mc.btn_back.addEventListener(MouseEvent.CLICK,function():void
			{
				hide();
			});
			
			game.Game.achivs.addEventListener(game.Achivements.EVENT_NEW_ACHIVEMENT,update);
			
			// sounds
			game.Game.sounds.addButton(mc.btn_back);
		}
		
		override public function show():void
		{
			super.show();
			
			//y = -game.Game.GameHeight;
			//Tweener.addTween(this,{y:0,time:0.5,delay:0,transition:"easeoutquad"});
			
			newUnlockAnim();
			
			// anim - achivs blick
			(parent as GameUI).screenComplete.stopAnimatedAlertBtns();
		}
		
		public function update(e:Event = null):void
		{
			Core.u.write("new achiv","00FF00");
			for (var i:int = 0; i < game.Achivements.UNLOKED_ON_LEVEL.length; i++) 
			{
				switch(game.Achivements.UNLOKED_ON_LEVEL[i])
				{
					//
					case Achivements.ACH_2x100ACCURACY:
						unlock(mc.mc_2x100);
						break;
					
					case Achivements.ACH_3x100ACCURACY:
						unlock(mc.mc_3x100);
						break;
					
					case Achivements.ACH_4x100ACCURACY:
						unlock(mc.mc_4x100);
						break;
					
					case Achivements.ACH_5x100ACCURACY:
						unlock(mc.mc_5x100);
						break;
					
					//
					case Achivements.ACH_2xCIRCLE_MAXSPEED:
						unlock(mc.mc_2xnitro);
						break;
					
					case Achivements.ACH_3xCIRCLE_MAXSPEED:
						unlock(mc.mc_3xnitro);
						break;
					
					case Achivements.ACH_4xCIRCLE_MAXSPEED:
						unlock(mc.mc_4xnitro);
						break;
					
					case Achivements.ACH_5xCIRCLE_MAXSPEED:
						unlock(mc.mc_5xnitro);
						break;
					
					//
					case Achivements.ACH_ALLCOINS:
						unlock(mc.mc_allcoins);
						break;
					//
					case Achivements.ACH_NOBUMP:
						unlock(mc.mc_nobump);
						break;
				}
			}
		}
		
		//
		private function unlock(mc_achiv:MovieClip):void
		{
			mc_achiv.alpha = 1;
			
			newunlock.push(mc_achiv);
		}
		
		public var newunlock:Array = [];
		private function newUnlockAnim():void
		{
			if(newunlock.length == 0 || !visible)return;
			
			for (var i:int = 0; i < newunlock.length; i++) 
			{
				var mc_achiv:MovieClip = newunlock[i];
				
				// anim
				mc_achiv.mc_blick.gotoAndPlay("loop");
				Tweener.addTween(mc_achiv,{alpha:1,time:1,delay:0.5,transition:"easenone"});
			}			
		}
		
		override public function hide():void
		{
			super.hide();
			
			//visible = true;
			//Tweener.addTween(this,{y:-game.Game.GameHeight,time:0.3,delay:0,transition:"easeinquad",
				//onComplete:function():void{
					//visible = false;				
				//}});
			
			// stop blick animation
			for (var i:int = 0; i < newunlock.length; i++) 
			{
				var mc_achiv:MovieClip = newunlock[i];
				mc_achiv.mc_blick.gotoAndStop(1);
			}
			
			// clear
			newunlock = [];
		}
	}
}