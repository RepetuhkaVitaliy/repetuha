package game.engine.bodys
{
	import flash.geom.Point;
	public class Nojka extends SpaceBody
	{
		public function Nojka()
		{
			super();
			this.mc = new swc_nojka();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 1;
			
			this.collisionCrashBy = [];
			
			this.view3dModelName = "airplane2_nojka";
		}
	}
}