package game.engine.bodys
{
	import flash.geom.Point;
	
	public class Meteor extends SpaceBody
	{
		public function Meteor()
		{
			super();
			this.mc = new swc_meteor()
			addChild(this.mc);
			
			this.v = new Point(1,1);
			this.speed = 0;
			this.mass = 0.6+4*Math.random();
			
			this.collisionCrashBy = [];
		}
	}
}