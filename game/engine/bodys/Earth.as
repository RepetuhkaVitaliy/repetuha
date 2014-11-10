package game.engine.bodys
{
	import flash.geom.Point;
	
	public class Earth extends SpaceBody
	{
		public function Earth()
		{
			super();
			
			this.mc = new mc_earth()
			addChild(this.mc);
			
			this.v = new Point(1,1);
			this.speed = 0;
			this.mass = 2;
			
			this.collisionCrashBy = [];
			this.collisionTakeIt = [];
		}
	}
}