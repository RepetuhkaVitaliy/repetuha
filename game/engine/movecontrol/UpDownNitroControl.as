package game.engine.movecontrol
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	
	import game.engine.bodys.SpaceBody;
	import game.TapControl;
	
	public class UpDownNitroControl extends WasdNitroControl
	{
		public function UpDownNitroControl(_stage:DisplayObject, _target:SpaceBody, _maxSpeed:Number, style:String, _rotationSpeed:Number)
		{
			super(_stage, _target, _maxSpeed, style, _rotationSpeed);
			
			// connect tapcontrol
			game.Game.tap.addEventListener(game.TapControl.TAP_LEFT_DOWN,function():void{ _rotate = -1; });
			game.Game.tap.addEventListener(game.TapControl.TAP_RIGHT_DOWN,function():void{ _rotate = 1; });
			game.Game.tap.addEventListener(game.TapControl.TAP_LEFT_UP,function():void{ _rotate = 0; });
			game.Game.tap.addEventListener(game.TapControl.TAP_RIGHT_UP,function():void{ _rotate = 0; });
		}
		
		// move control
		internal override function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 38 || e.keyCode == 87)// up or W
			{
				_rotate = -1;
			}
			
			if(e.keyCode == 40 || e.keyCode == 83)// down or S
			{
				_rotate = 1;
			}
			
			// shift
			if(e.keyCode == 16){
				nitro(true);
			}
		}
		
		internal override function keyUp(e:KeyboardEvent):void
		{
			if(e.keyCode == 38 || e.keyCode == 40 || e.keyCode == 87  || e.keyCode == 83)
			{
				_rotate = 0;
			}
		}
	}
}