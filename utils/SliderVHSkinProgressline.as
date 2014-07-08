package com.repetuha.utils
{
	/* author: Repetukha Vitaliy */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class SliderVHSkinProgressline extends SliderVHSkin
	{
		public function SliderVHSkinProgressline(height:Number, _top:DisplayObject=null, _bottom:DisplayObject=null, _bar:Sprite=null, _line:Sprite=null, _pline:Sprite=null)
		{
			super(height, _top, _bottom, _bar, _line);
			
			addChild(_pline);
			
			addChild(_bar);
			
			this.addEventListener(Event.ENTER_FRAME,function():void{
				_pline.y = _line.y+_line.height;
				_pline.rotation = 180;
				_pline.height = _line.height*value;
			});
		}
	}
}