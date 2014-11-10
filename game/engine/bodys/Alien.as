package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.engine.Engine;

	public class Alien extends SpaceBody
	{
		
		public function Alien()
		{
			this.mc = new swc_alien()
			addChild(this.mc);			
			
			this.scan_distance = 30;
				
			this.v = new Point((0.5-1*Math.random()),(0.5-1*Math.random()));

			this.speed = 0.8+0.4*Math.random();
		
			this.mass = 1+1*Math.random();
			
			this.freeFly = false;
			
			collisionCrashBy = [Bullet];
			
		}
		
		public override function move():void
		{
			if(targets.length == 0)return;
			
			var target:SpaceBody = targets[0];
			
			if(target){
				
			   var vx:Number = -(this.x-target.x)/200;
			   if(Math.abs(vx) > 0.5)vx = 0.5*vx/Math.abs(vx);
			   
			   var vy:Number = -(this.y-target.y)/200;
			   if(Math.abs(vy) > 0.5)vy = 0.5*vy/Math.abs(vy);
			
			   if(target.isDead){
				   vx = 0.5-1*Math.random();
				   vy = 0.5-1*Math.random();
				   
				  target = null;
			   }
			   
			   this.v = new Point(vx,vy);
			   
			   rotation = Math.atan2(v.y,v.x)/Math.PI*180;
			   
			   /* BOX2D */	if(box2dbody)game.engine.Engine.box2dRotateBody(box2dbody,rotation/180*Math.PI);
			   /* BOX2D */	if(box2dbody)game.engine.Engine.box2dMoveBody(box2dbody,new Point(v.x*speed,v.y*speed));
			}
			
			super.move();
			
			
		}
	}
}