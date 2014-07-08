package  com.repetuha.utils{
	
	/* author: Repetukha Vitaliy */
	
	import flash.text.TextField;
	import flash.display.Shape;
	
	public class MiddleTextLine extends Shape{

		public function MiddleTextLine(txt:TextField,thickness:Number,color:uint,alpha:Number) {
			// constructor code
			this.x = txt.x;
			this.y = txt.y;
			
			var l:Number = txt.text.length;
			
			var line1EndCharId:uint = txt.getLineLength(0)-1;
			
			// draw first line
			var x1:Number = txt.getCharBoundaries(0).left;
			var y1:Number = txt.getCharBoundaries(0).bottom-txt.getCharBoundaries(0).height/2+1;
			
			var x2:Number = txt.getCharBoundaries(line1EndCharId).right;
			var y2:Number = txt.getCharBoundaries(line1EndCharId).bottom-txt.getCharBoundaries(line1EndCharId).height/2+1;
		
			this.graphics.lineStyle(thickness,color,alpha);
			this.graphics.moveTo(x1,y1);
			this.graphics.lineTo(x2,y2);
			this.graphics.endFill();
			
			// draw second line
			if((line1EndCharId+1) < txt.text.length){
			   var x3:Number = txt.getCharBoundaries(line1EndCharId+1).left;
			   var y3:Number = txt.getCharBoundaries(line1EndCharId+1).bottom-txt.getCharBoundaries(line1EndCharId+1).height/2+1;
			   
			   var lastCharId:uint = txt.text.length-1;
			   var x4:Number = txt.getCharBoundaries(lastCharId).right;
			   var y4:Number = txt.getCharBoundaries(lastCharId).bottom-txt.getCharBoundaries(lastCharId).height/2+1;
			   
			   this.graphics.lineStyle(thickness,color,alpha);
			   this.graphics.moveTo(x3,y3);
			   this.graphics.lineTo(x4,y4);
			   this.graphics.endFill();
			}
		}

	}
	
}
