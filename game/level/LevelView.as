package game.level
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.Game;

	public class LevelView extends Sprite 
	{
		public var fon:Sprite = new Sprite();
		
		public function LevelView()
		{
			//addChild(fon);
			drawFon();
		}
		
		
		// private methods
		private var plusArray:Vector.<swc_plus_mc> = new Vector.<swc_plus_mc>();// try Array for optimize
		public function showPlus(cont:DisplayObjectContainer,points:Number,x:Number,y:Number):void
		{
			var plus:swc_plus_mc = new swc_plus_mc();
			
			cont.addChild(plus);
			
			plus.x = x;
			plus.y = y;
			
			plus.mc.txt.text = "+"+points;
			
			if(points < 0){
				plus.mc.gotoAndStop(2);
				plus.mc.txt.text = points;
			}
			
			plus.gotoAndPlay("show");
			
			plusArray.push(plus);
		}
		
		private function tick():void
		{
			
			// clear pluses
			for(var i:uint = 0; i < plusArray.length; i++){
				var plus:MovieClip = plusArray[i];
				if(plus.visible == false)removeChild(plus);
				plus = null;
				plusArray[i] = null;
			}
		}
		
		private function drawFon():void
		{
			fon.graphics.beginFill(0x62A6E2);
			fon.graphics.drawRect(0,0,Game.GameWidth*2,Game.GameHeight*2);
			fon.graphics.endFill();
			
			var level_fon:level1fon = new level1fon();
			//fon.addChild(level_fon);
			
			var spaceMask:Sprite = new Sprite();
			spaceMask.graphics.copyFrom(fon.graphics);
			level_fon.mask = spaceMask; 
		}
		
	}
}