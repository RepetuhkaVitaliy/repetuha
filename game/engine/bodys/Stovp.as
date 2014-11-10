package game.engine.bodys
{
	import flash.geom.Point;
	
	public class Stovp extends SpaceBody
	{
		public function Stovp()
		{
			super();
			this.mc = new swc_stovp();
			addChild(this.mc);
			
			this.v = new Point(1,1);
			this.speed = 0;
			this.mass = 1;
			
			this.collisionCrashBy = [];
			
			this.view3dModelName = "stovp1";
		}
	}
}