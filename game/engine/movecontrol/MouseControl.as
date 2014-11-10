package game.engine.movecontrol
{
	import com.repetuha.Utils;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	import game.engine.bodys.SpaceBody;

	public class MouseControl implements IMoveControl
	{
		internal var target:SpaceBody = null;
		private var radius:Number;
		private var center:Point;
		private var _rotate:Number = 1;// todo: 1= right, -1 = left
		
		public var delSpeedBasic:Number = 0.3;
		public var delSpeed:Number = delSpeedBasic;
		
		public var minimumSpeed:Number = 10;
		
		public function MouseControl(_target:SpaceBody,_radius:Number = 0,_center:Point = null):void
		{
		   target = _target;
		   radius = _radius;
		   center = _center;
		}
		
		public function get types():String
		{
			return "mouse";
		}
		
		public function update():void
		{
			var cX:Number = target.x;
			var cY:Number = target.y;
			
			if(center){
				cX = center.x;
				cY = center.y;
			}
			
			var delXtoMouse:Number = (target.parent.mouseX-cX);
			var delYtoMouse:Number = (target.parent.mouseY-cY);
						
			target.rotation = Math.atan2(delYtoMouse,delXtoMouse)/Math.PI*180;
			
				if(center && radius){
				     target.x = center.x+radius*Math.cos((target.rotation)/180*Math.PI);
					 target.y = center.y+radius*Math.sin((target.rotation)/180*Math.PI);
				}else{
					var delXtoMouseDist:Number = delXtoMouse-radius*Math.cos(target.rotation/180*Math.PI);
					var delYtoMouseDist:Number = delYtoMouse-radius*Math.sin(target.rotation/180*Math.PI);
					
					if(com.repetuha.Utils.matchGet2Ddistance(target.x,target.y,target.parent.mouseX,target.parent.mouseY) > radius+1){
					   
						// minimum speed
						if(Math.abs(delXtoMouseDist) < minimumSpeed)delXtoMouseDist = minimumSpeed*delXtoMouseDist/Math.abs(delXtoMouseDist);
					    if(Math.abs(delYtoMouseDist) < minimumSpeed)delYtoMouseDist = minimumSpeed*delYtoMouseDist/Math.abs(delYtoMouseDist);
						
						//if(Math.abs(delXtoMouseDist) > 30)delXtoMouseDist = 30*delXtoMouseDist/Math.abs(delXtoMouseDist);
						//if(Math.abs(delYtoMouseDist) > 30)delYtoMouseDist = 30*delYtoMouseDist/Math.abs(delYtoMouseDist);

						//update x y
						target.x += delXtoMouseDist*delSpeed;
					    target.y += delYtoMouseDist*delSpeed;
					}
				}
			
		}
		
		public function get rotate():Number
		{
			return _rotate;
		}
	}
}