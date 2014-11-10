package game.engine.bodys
{
	import caurina.transitions.Tweener;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.engine.Engine;

	public class Roket extends SpaceBody
	{
		public function Roket(_v:Point)
		{
			startV = new Point(_v.x,_v.y);
			
			this.mc = new swc_bullet()
			addChild(this.mc);			
			
			this.v = _v;
			
			this.speed = 0.5;
			
			this.mass = 1;
			
			collisionCrashBy = [];
			
			collisionTakeIt = [CheckPoint];
			
			view3dModelName = "roket1";
			
			this.box2dbody = null;
			
			this.freeFly = false;
		}
		
		private var startV:Point;
		private var roketSeparateTime:Number = 0;
		override public function move():void
		{
		    roketSeparateTime++;
		    if(roketSeparateTime < 10)// separate from ship.
		    {
			  v.x = startV.x+3/roketSeparateTime*Math.cos((rotation+90)/180*Math.PI);
			  v.y = startV.y+3/roketSeparateTime*Math.sin((rotation+90)/180*Math.PI);
			  
			  speed += 15/10;
			  if(speed > 15)speed = 15;
		    }
			else{
				speed = 15;
				v = startV;
			}
			
		   if(!animationState)super.move();
			/* BOX2D */	if(box2dbody)game.engine.Engine.box2dRotateBody(box2dbody,rotation/180*Math.PI);
			/* BOX2D */	if(box2dbody)game.engine.Engine.box2dMoveBody(box2dbody,v);
		}
		
		override public function takeIt(sb:SpaceBody):void
		{
			if(sb is CheckPoint){
				(sb as CheckPoint).die(this);
				
				die();
			}
		}
	}
}