package com.repetuha{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.*;
	import flash.net.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.display.Graphics;

	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	import com.JPGSizeExtractor;

	public class LoadPhoto extends Sprite {
		public var loader:Loader = new Loader();
		private var foto:Sprite = new Sprite();

		private var fonrect:Shape = new Shape();

		public var w:Number;
		public var h:Number;

		public var imageHeight;
		public var imageWidth;

		private var tweenNums:uint = 0;
		private var numFoto:Number = -1;
		
		private var je : JPGSizeExtractor = new JPGSizeExtractor( );
		
		private var imagesArray:Array = new Array();
		private var _idArray:Array = new Array(String);
		private var _id;
		
		private var loaderLink;
		
        private var timer:Timer = new Timer(1,0);
		private var timerCekOut:Number = 0;
		private var timerCekIn:Number = 0;
		private var speed:Number = 20;
		
		public function LoadPhoto() {
			addChild(fonrect);
			addChild(foto);
		}
		
		private function overListener(e:MouseEvent) {
			e.target.alpha = 1;
		}
		private function outListener(e:MouseEvent) {
			e.target.alpha = 0;
		}
		
		public function loadPhoto(id,w,h) {
			this.w = w;
			this.h = h;
			
                 _id = id;

		/*		if (w) {
					
				Tweener.removeTweenByIndex(0);
				Tweener.removeTweenByIndex(1);
				}*/
				foto.alpha = 1;
				fonrect.alpha = 1;
				if(loaderLink){
                if(timerCekIn > 0)timer.removeEventListener(TimerEvent.TIMER,fadeIn);
                if(timerCekOut > 0)timer.removeEventListener(TimerEvent.TIMER,fadeOut);
			
			    timer.addEventListener(TimerEvent.TIMER,fadeOut);
    			timer.start();
            
	     		timerCekOut = 0;
				}
				else{
					loadNew();
					}

/*				Tweener.addTween(foto, {alpha: 0, time: 0.3,delay:0.2,onComplete:loadNew});
				Tweener.addTween(fonrect, {alpha: 0, time: 0.3,delay:0.2});
			
				tweenNums += 2;
*/				
			
		}
		
		private function fadeOut(e:TimerEvent):void {
				timerCekOut ++;
				var Alpha:Number = 100-100/speed*timerCekOut;
				if(timerCekOut > 5){
				loaderLink.alpha = Alpha/100;
				fonrect.alpha = Alpha/100;
				}
				if(timerCekOut >= speed){
					timer.removeEventListener(TimerEvent.TIMER,fadeOut);
					loadNew();
				} 
			}
			
		private function fadeIn(e:TimerEvent):void {
				timerCekIn ++;
				var Alpha:Number = 100/speed*timerCekIn;
				trace(Alpha);
				loaderLink.alpha = Alpha/100;
				fonrect.alpha = Alpha/100;
				if(timerCekIn >= speed){
					timer.removeEventListener(TimerEvent.TIMER,fadeIn);
				} 
		}

		private function loadNew() {
					tweenNums -= 2;
					if (loaderLink) {
						loaderLink.visible = false;
						/*loaderLink.unload();
		                loaderLink = null;*/
					}
             		if(loader){
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeListener);
					loader.unload();
             		loader = null;
               		removeChild(loader);
		             }
            		var loader = new Loader();
					
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeListener);

					var urlRequest:URLRequest = new URLRequest(_id);
					loader.load(urlRequest);

					//foto.addChild(loader);
					loaderLink = loader;
					loader.alpha = 1;
					numFoto++;
					foto.alpha = 1;
					
		}
		
		private function completeListener(event:Event):void {
			trace("lasssss");
			var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
			imageWidth = loaderInfo.content.width;
			imageHeight = loaderInfo.content.height;
			
			var preview = new BitmapData(imageWidth, imageHeight, true, 0x000000);
		    var previewB:Bitmap = new Bitmap(preview);
			previewB.smoothing = true;
			
			preview.draw(loaderInfo.content);//,previewMatrix);
			addChild(previewB);
			
			var foto = previewB;
			
			if (imageWidth > w) {
				foto.width = w;
				foto.height = Math.round(foto.width*imageHeight/imageWidth);
			} else {
				foto.width = imageWidth;
			}
			if (imageHeight > h) {
				foto.height = h;
				foto.width = Math.round(foto.height*imageWidth/imageHeight);
			} else {
				foto.height = imageHeight;
			}
			
			foto.width = w;
			foto.height = h;
			
			alpha = 1;
			
			/*
            if(timerCekIn > 0)timer.removeEventListener(TimerEvent.TIMER,fadeIn);
            if(timerCekOut > 0)timer.removeEventListener(TimerEvent.TIMER,fadeOut);
			
			timer.addEventListener(TimerEvent.TIMER,fadeIn);
			timer.start();
            
			timerCekIn = 0;*/
		}
		public function setPos(w,h,fw,fh) {
			w = w;
			h = h;
			var border = 6;
			var fonrW = Number(fw);
			var fonrH = Number(fh);
			fonrect.graphics.clear();
			fonrect.graphics.beginFill(0xFFFFFF,0);
			fonrect.graphics.lineStyle(border,0xFFFFFF);
			fonrect.graphics.drawRoundRect(Math.floor(w/2)-Math.floor(fw/2), Math.floor(h/2)-Math.floor(fh/2), fonrW, fonrH,4);
			fonrect.graphics.endFill();

			
			if (loaderLink) {
				loaderLink.x = Math.floor(w/2)-Math.floor(fw/2);
				loaderLink.y = Math.floor(h/2)-Math.floor(fh/2);
			}
			
		}
	}
}