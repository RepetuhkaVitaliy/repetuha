package game.engine.movecontrol
{
	// todo: add move styles - "sideMove", "sidePush"
	
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	import game.engine.bodys.SpaceBody;

	public class WasdControl implements IMoveControl
	{
		public var maxSpeed:Number = 2.5;
		public var delSpeedBasic:Number = 0.3;
		public var rotationSpeedMax:Number = 8;		
			
		public var delSpeed:Number = delSpeedBasic;
		public var force:Boolean = false;
		public var forceDown:Boolean = false;		
		public var _rotate:Number = 0;
		public var rotationSpeed:Number = 2;
		/* MOBILE*/ public var rotationSpeedInertiaDel:Number = 0.2;//0.12
		
		internal var target:SpaceBody = null;
		
		public function WasdControl(_stage:DisplayObject,_target:SpaceBody,_maxSpeed:Number,style:String,_rotationSpeedMax:Number = 8)
		{
			target = _target;
			maxSpeed = _maxSpeed;
			rotationSpeedMax = _rotationSpeedMax;
			
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown,false,0,true);
		}
		
		public function get types():String
		{
			return "wasd";
		}
		
		public var inertiaV:Number = 0;
		public function update():void
		{
			if(target == null)return;
			
			if(force)target.speed += delSpeed;
			
			if(target.speed > maxSpeed)target.speed = maxSpeed;
			
			if(forceDown)target.speed -= delSpeed;
			
			if(target.speed < -1)target.speed = -1;
			
			if(_rotate != 0){
				rotationSpeed += 0.8/rotationSpeed;
				if(rotationSpeed > rotationSpeedMax)rotationSpeed = rotationSpeedMax;
			}
			if(_rotate == 0){
				rotationSpeed -= rotationSpeedInertiaDel;
				if(rotationSpeed < 0)rotationSpeed = 0;
			}
			
			if(_rotate != 0)inertiaV = _rotate;
		   	target.rotation += inertiaV*rotationSpeed;
			
			target.v = new Point(Math.cos((target.rotation)/180*Math.PI),Math.sin((target.rotation)/180*Math.PI));
		}
		
		public function get rotate():Number
		{
			return _rotate;
		}
		
		// move control
		internal function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 38)// up
			{
				force = true;
				forceDown = false;
				Tweener.removeAllTweens();
			}
			
			if(e.keyCode == 40)// down
			{
				forceDown = true;
			}
			
			if(e.keyCode == 37)// left
			{
				_rotate = -1;			
				// if(!force)manevr();
			}
			
			if(e.keyCode == 39)// right
			{
				_rotate = 1;
				//if(!force)manevr();
			}
		}
		
		internal function keyUp(e:KeyboardEvent):void
		{
			
			if(e.keyCode == 38)// up
			{
				force = false;
			}
			
			if(e.keyCode == 37 || e.keyCode == 39)
			{
				_rotate = 0;
			}
		}
		
		
		// move side
		/*if(!force && !forceDown && rotate != 0){
		var delX:Number = 1*Math.cos((rotation+90*rotate)/180*Math.PI);
		var delY:Number = 1*Math.sin((rotation+90*rotate)/180*Math.PI);
		x = x+delX;
		y = y+delY;
		rotation = rotation-1*rotate;
		speed = this.maxSpeed*0.75;
		/* BOX2D *///	if(box2dbody)game.engine.Engine.box2dRotateBody(box2dbody,rotation/180*Math.PI);
		//	v = new Point(delX,delY);
		//}
		// move side.
		
		/*
		// push side 
		private function manevr():void
		{
			//animationState = true;
			var delX:Number = 2*Math.cos((rotation+90*rotate)/180*Math.PI);
			var delY:Number = 2*Math.sin((rotation+90*rotate)/180*Math.PI);
			//forceDown = true;
			x = x+delX;
			y = y+delY;
			rotation = rotation-0.5*rotate;
			speed = 0.1;
			//force = true;
			Tweener.addTween(this, {x: x+delX, y: y+delY, rotation:rotation-10*rotate, time: 0.5, transition:"easeinoutquad",
			onComplete:function():void{
			
			animationState = false;
			force = false;
			},onUpdate:function():void{
			animationState = false;
			v = new Point(Math.cos((rotation)/180*Math.PI),Math.sin((rotation)/180*Math.PI));
			move();
			animationState = true;
			dispatchEvent(new Event("update"));
			}});
		}
		*/
	}
}