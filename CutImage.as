package com.repetuha{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.Sprite;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;

	public class CutImage extends Sprite {

		public var backGroundColor:Array = ["ffffff"];
		
		public var colorsArray:Array = new Array();

		public function CutImage() {

		}
		public function cut(bm,bmd,Width,Height,backGroundColor,border) {
			this.backGroundColor = backGroundColor;
			
			var rect:Rectangle = getImageBounds(bmd,Width,Height);
			
            var bmdCut = new BitmapData(rect.width+border*2, rect.height+border*2, false, 0xFFFFFF);
            var bmdCutMatrix:Matrix = new Matrix(1, 0, 0, 1, -rect.left+border, -rect.top+border);
            var bmCut:Bitmap = new Bitmap(bmdCut);
			bmdCut.draw(bmd,bmdCutMatrix);
			return bmCut;
		}
		private function getImageBounds(bmd,Width,Height) {

			var rect:Rectangle = new Rectangle();
			rect.left = left(bmd,Width,Height);
			rect.right = right(bmd,Width,Height);
			rect.top = top(bmd,Width,Height);
			rect.bottom = bottom(bmd,Width,Height);
			
			trace("backGroundColor = "+backGroundColor)
			trace("colorsArray = "+colorsArray)
			
			return rect;

		}
		
		private function checkColor(pixelValue){
			
			if(colorsArray.indexOf(pixelValue.toString(16)) == -1){
				colorsArray.push(pixelValue.toString(16)); 
				}
			
			var count:Number = 0;
			for (var i:uint = 0; i < backGroundColor.length; i++) {
	          if (pixelValue.toString(16) != backGroundColor[i]){
						count ++;
			  }
			}
			
			if(count == backGroundColor.length){
			   return true;
			}else{
			   return false;
			}
		}

		private function left(bmd,Width,Height) {
			for (var i:uint = 0; i < Width; i++) {
				for (var j:uint = 0; j < Height; j++) {
					var pixelValue:uint = bmd.getPixel(i,j);
					
					if (checkColor(pixelValue)) {
						return i;
						i = Width;
						j = Height;
					}
				}
			}
		}

		private function right(bmd,Width,Height) {
			for (var i:uint = Width-1; i >= 0; i--) {
				for (var j:uint = 0; j < Height; j++) {
					var pixelValue:uint = bmd.getPixel(i,j);
					if (checkColor(pixelValue)) {
						return i;
						i = Width;
						j = Height;
					}
				}
			}
		}

		private function top(bmd,Width,Height) {
			for (var i:uint = 0; i < Height; i++) {
				for (var j:uint = 0; j < Width; j++) {
					var pixelValue:uint = bmd.getPixel(j,i);
					if (checkColor(pixelValue)) {
						return i;
						i = Width;
						j = Height;
					}
				}
			}
		}

		private function bottom(bmd,Width,Height) {
			for (var i:uint = Height-1; i >=0; i--) {
				for (var j:uint = 0; j < Width; j++) {
					var pixelValue:uint = bmd.getPixel(j,i);
					if (checkColor(pixelValue)) {
						return i;
						i = Width;
						j = Height;
					}
				}
			}
		}
	}
}