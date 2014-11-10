package game.engine.movecontrol
{
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import game.engine.bodys.Ship;
	import game.engine.bodys.SpaceBody;
	
	import caurina.transitions.Tweener;

	public class WasdNitroControl extends WasdControl implements INitro
	{
		
		public function WasdNitroControl(_stage:DisplayObject,_target:SpaceBody,_maxSpeed:Number,style:String,_rotationSpeed:Number):void
		{
			super(_stage,_target,_maxSpeed,style,_rotationSpeed);
		}
		
		
		// !! nitro code - similar in MouseControlNitro.
		
		private var _nitroOn:Boolean = false;
		public function get nitroOn():Boolean
		{
			return _nitroOn;
		}
		
		public override function get types():String
		{
			return super.types+",nitro";
		}
		
		private var _self:Boolean = false;
		public function get self():Boolean
		{
			return _self;
		}
		public function nitro(__self:Boolean,_speed:Number = -999,time:Number = 300):Boolean
		{
			_self = __self;
			if(_self){
			  if((target as Ship).nitroZapas == 0 || (target as Ship).nitroEnable == false)return false;
			}
			
			if(nitroTimer == null)
			{
				if(_speed == -999){
					_speed = maxSpeed*2;
				}
				
				Tweener.removeTweens(this);
				
				t_smoke = (target as Ship).smokeName;(target as Ship).smokeName = "smoke1nitro";
				t_maxSpeed = maxSpeed;
				maxSpeed = _speed;
				delSpeed = 3;
				
				force = true;
				_nitroOn = true;
				nitroTimer = new Timer(time,1);
				nitroTimer.start();
				nitroTimer.addEventListener(TimerEvent.TIMER_COMPLETE,nitroComplete);			   
				return true;
			}
		  return false;
		}
		
		override internal function keyDown(e:KeyboardEvent):void{
			super.keyDown(e);
			
			// shift
			if(e.keyCode == 16){
				nitro(true);
			}
		}
		
		// PRIVATE:
		private var nitroTimer:Timer = null;
		private var t_maxSpeed:Number = maxSpeed;
		private var t_smoke:String = "";
		private function nitroComplete(e:TimerEvent):void{
			nitroTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,nitroComplete);
			
			Tweener.addTween(this,{maxSpeed:t_maxSpeed,time:0.5,transition:"easeoutquad",
			onComplete:function():void
			{
				nitroTimer = null;
				force = false;
				_nitroOn = false;
			}});
			
			
			delSpeed = delSpeedBasic;
			
			(target as Ship).smokeName = t_smoke;
		}
	}
}