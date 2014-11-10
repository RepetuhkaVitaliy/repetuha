package game.engine.bodys
{
	import flash.geom.Point;

	public class Aerostat1 extends SpaceBody
	{
		public function Aerostat1()
		{
			super();
			this.mc = new swc_crystal();
			addChild(this.mc);
			
			this.v = new Point(-1,0);
			this.speed = 1;
			this.mass = 5;//0.6+0.6*Math.random();
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.box2dbody = null;
			
			this.active = false;
			
			this.view3dModelName = "aerostat1";
			
			this.view3dZ = -400;
		}
	}
}