package game
{
	// enable = addChild
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class TapControl extends Sprite
	{
		// events
		public static var TAP_LEFT_DOWN:String = "TAP_LEFT_DOWN";
		public static var TAP_LEFT_UP:String = "TAP_LEFT_UP";
		
		public static var TAP_RIGHT_DOWN:String = "TAP_RIGHT_DOWN";
		public static var TAP_RIGHT_UP:String = "TAP_RIGHT_UP";
		
		//
		public var btnLeft:Sprite;
		public var btnRight:Sprite;
		
		public var borderRadius:Number = 300;//80
		
		public function TapControl()
		{
			super();
			
			btnLeft = roundButton();
			btnRight = roundButton();
			
			addChild(btnLeft);
			addChild(btnRight);
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				btnLeft.x = borderRadius;
				btnLeft.y = game.Game.GameHeight;
				
				btnRight.x = game.Game.GameWidth-borderRadius;
				btnRight.y = game.Game.GameHeight;
			});
			//
			btnLeft.addEventListener(MouseEvent.MOUSE_DOWN,function():void
			{
				dispatchEvent(new Event(TapControl.TAP_LEFT_DOWN));
			});
			btnLeft.addEventListener(MouseEvent.MOUSE_UP,function():void
			{
				dispatchEvent(new Event(TapControl.TAP_LEFT_UP));
			});
			
			btnRight.addEventListener(MouseEvent.MOUSE_DOWN,function():void
			{
				dispatchEvent(new Event(TapControl.TAP_RIGHT_DOWN));
			});
			btnRight.addEventListener(MouseEvent.MOUSE_UP,function():void
			{
				dispatchEvent(new Event(TapControl.TAP_RIGHT_UP));
			});
		}
		
		public function set enable(arg:Boolean):void
		{
			if(arg)visible = true
			else visible = false;
		}
		
		//
		private function roundButton():Sprite
		{
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xffffff,0.5);
			sp.graphics.lineStyle(2,0xffffff,1);
			sp.graphics.drawCircle(0,0,80);
			sp.graphics.endFill();
			return sp;
		}
	}
}