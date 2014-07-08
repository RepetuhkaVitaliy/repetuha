package com.repetuha.utils{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.Sprite;
	import caurina.transitions.Tweener;
	import flash.events.MouseEvent;
	
	public class TweenButton extends Sprite{
		
		public var defSkin:*;
		private var overSkin:*;
		
		private var rect:Sprite = new Sprite();

		public function TweenButton(defSkin:*,overSkin:*) {
			// constructor code
			this.defSkin = defSkin;
			this.overSkin = overSkin;
			this.defSkin.stop();
			this.overSkin.gotoAndStop(2);
			
			addChild(this.defSkin);
			addChild(this.overSkin);
			this.overSkin.alpha = 0;
			
			addChild(rect);
			rect.graphics.beginFill(0,0);
			rect.graphics.drawRect(0,0,this.defSkin.width,this.defSkin.height);
			rect.graphics.endFill();
			
			rect.buttonMode = true;
			rect.addEventListener(MouseEvent.MOUSE_DOWN,down);
			rect.addEventListener(MouseEvent.MOUSE_UP,up);
			rect.addEventListener(MouseEvent.MOUSE_OVER,over);
			rect.addEventListener(MouseEvent.MOUSE_OUT,out);
		}
		
		private function down(e:MouseEvent){
			overSkin.alpha = 0;
		}
		private function up(e:MouseEvent){
			overSkin.alpha = 1;
		}
		
		private function over(e:MouseEvent){
			Tweener.addTween(overSkin, {alpha: 1, time: 0.15});
		}
		
		private function out(e:MouseEvent){
			Tweener.addTween(overSkin, {alpha: 0, time: 0.5});
		}

	}
	
}
