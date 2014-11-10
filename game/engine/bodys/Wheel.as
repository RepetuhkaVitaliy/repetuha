package game.engine.bodys
{
	import flash.geom.Point;

	public class Wheel extends SpaceBody
	{
		public function Wheel()
		{
			super();
			this.mc = new swc_wheel();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 1;
			
			this.collisionCrashBy = [];
			
			this.view3dModelName = "airplane2_wheel";
		}
	}
}