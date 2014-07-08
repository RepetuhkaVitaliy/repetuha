package com.repetuha.utils
{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	public class SliderVHSkin extends Sprite
	{
		
		// PUBLIC
		public var deltaPercent:Number = 0.05;
		
		public function SliderVHSkin(height:Number,_top:DisplayObject = null,_bottom:DisplayObject = null,_bar:Sprite = null,_line:Sprite = null)
		{
			super();
			// constructor code
			W = 15;
			H = height;
			
			Top = _top;
			Bottom = _bottom;
			if(_bar)Bar = _bar else Bar = BAR_default;
			if(_line)Line = _line else Line = LINE_default;
			
			addEventListener(Event.ADDED_TO_STAGE, addToStage);
			
			addObjects();
			
			initScrollBar();
		}
		
		public function set value(percent:Number):void{
			Bar.y = minY+(maxY-minY)*(1-percent);
			checkMinMax();
		}
		public function get value():Number
		{
			var percent:Number = 1-(Bar.y-minY)/(maxY-minY);
			return Math.round(percent*100)/100;
		}
		
		public function set visibleArrows(arg:Boolean):void
		{
			Top.alpha = Number(arg);
			Bottom.alpha = Number(arg);
		}
		
		public function set delY_button(arg:Number):void
		{
			topBottomDelY = arg;
			drawScroll(W,H);
		}
		public function set delY_line(arg:Number):void
		{
			topDelY = arg;
			drawScroll(W,H);
		}
		
		public function enable():void
		{
			mouseEnabled = true;
			mouseChildren = true;
			alpha = 1;
		}
		
		public function disable():void
		{
			mouseEnabled = false;
			mouseChildren = false;
			alpha = 0.4;
		}
		
		// PRIVATE
		private var W:Number;
		private var H:Number;
		
		private var LINE_default:Sprite = new Sprite();
		private var BAR_default:Sprite = new Sprite();
		private var BarHeight:Number = 20;
		public var isDrag:Boolean = false;
		
		private var minY:Number;
		private var maxY:Number;
		
		public var Top:DisplayObject;
		public var Bottom:DisplayObject;
		public var Bar:Sprite;
		private var Line:Sprite;	
		
		private var topBottomDelY:Number = 4;
		private var topDelY:Number = 16;
		
		private function addToStage(e:Event):void {
			
			stage.addEventListener(MouseEvent.MOUSE_MOVE, move);
			//stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheelEvent);
			
			
		}
		
		private function addObjects():void
		{
			addChild(Line);
			
			Bar.buttonMode = true;
			Bar.addEventListener(MouseEvent.MOUSE_DOWN, down);
			
			if(Top && Bottom){
				
				Top.addEventListener(MouseEvent.CLICK, function():void{ plus(); });
				Bottom.addEventListener(MouseEvent.CLICK, function():void{ minus(); });
				
				addChild(Top);
				addChild(Bottom);
			}
			
			addChild(Bar);
		}
					
		private function initScrollBar():void{
			drawScroll(W,H);
			
			minY = Math.round(Bar.height/2);
			maxY = H-Math.round(Bar.height/2);
			
			checkMinMax();
		}
		
		private function plus():void
		{
			Bar.y -= Math.round(deltaPercent*H);
			checkMinMax();
			dispatchEvent(new Event("update"));
		}
		
		private function minus():void
		{
			Bar.y += Math.round(deltaPercent*H);
			checkMinMax();
			dispatchEvent(new Event("update"));
		}
		
		private function down(e:MouseEvent):void{
			Bar.startDrag(false,new Rectangle(0,minY,0,maxY-minY));
			isDrag = true;
			
			stage.addEventListener(MouseEvent.MOUSE_UP, up);
		}
		
		private function up(e:MouseEvent):void{
			
			stage.removeEventListener(MouseEvent.MOUSE_UP, up);
			
			Bar.stopDrag();
			Bar.y = Math.round(Bar.y);
			isDrag = false;
			
			dispatchEvent(new Event("dragEnd"));
			
			dispatchEvent(new Event("update"));
		}
		
		private function move(e:MouseEvent):void{
			if(isDrag){
				dispatchEvent(new Event("update"));
			}
		}
		
		private function onMouseWheelEvent(event:MouseEvent):void
		{
			if(!isDrag){
				
				Bar.y -= event.delta*10;
				
				checkMinMax();
				dispatchEvent(new Event("update"));
			}
			
		}
		
		private function checkMinMax():void
		{
		   if(Bar.y < minY) Bar.y = minY;
		   if(Bar.y > maxY) Bar.y = maxY;
		}
		
		private function drawScroll(w:Number, h:Number):void{
			
			if(Line == LINE_default){
				LINE_default.graphics.clear();
				LINE_default.graphics.beginFill(0xc5c5c5);
				LINE_default.graphics.drawRect(0,-BarHeight/2,w,h+BarHeight);
				LINE_default.graphics.endFill();
				
			    drawBarScroll();
			}
			else{
				Line.height = topDelY*2+H;
				Line.y = -topDelY;
			}
			
			if(Top && Bottom){				
				Top.y = -Top.height/2-topBottomDelY;
				Bottom.y = H+Bottom.height/2+topBottomDelY;
			}
		}
		
		
		private function drawBarScroll():void{
			
			var matrix:Matrix = new Matrix();
			matrix.createGradientBox(LINE_default.width,BarHeight,270*Math.PI/180);
			BAR_default.graphics.clear();
			BAR_default.graphics.lineStyle(1,0xababab,1,true,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND);
			
			BAR_default.graphics.beginGradientFill(GradientType.LINEAR,[0xd6d8d8,0xfbfbfb],[1,1],[0,245],matrix);
			BAR_default.graphics.drawRoundRect(0,-BarHeight/2,LINE_default.width-1,BarHeight,7);
			BAR_default.graphics.endFill();
			
			BAR_default.graphics.lineStyle(1,0xfbfbfb,1,true,LineScaleMode.NONE,CapsStyle.ROUND,JointStyle.ROUND);
			BAR_default.graphics.drawRoundRect(1,1-(BarHeight-2)/2,LINE_default.width-3,BarHeight-2,7);					
		}
				
	}
	
}