package game.engine.bodys
{
	import flash.geom.Point;
	
	public class Asteroid extends SpaceBody
	{
		
		public function Asteroid()
		{
			this.mc = new swc_asteroid()
			addChild(this.mc);
			
			this.v = new Point((0.5-1*Math.random()),(0.5-1*Math.random()));
			
			this.speed = 2.5+1*Math.random();
			
			this.mass = 0.5+2.5*Math.random()
		
			this.collisionCrashBy.push(Earth);	
			
		}
		
		public override function move():void
		{
			super.move();
		    
			rotation = Math.atan2(v.y,v.x)/Math.PI*180;
		}
	}
}