package game.engine.bodys
{
	import flash.geom.Point;

	public class Aerostat2 extends SpaceBody
	{
		public function Aerostat2()
		{
			super();
			this.mc = new swc_crystal();
			addChild(this.mc);
			
			this.v = new Point(-1,0);
			this.speed = 1;
			this.mass = 4;//0.6+0.6*Math.random();
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.box2dbody = null;
			
			this.active = false;
			
			var names3d:Array = ["aerostat2","aerostat2color6","aerostat2color5","aerostat2color4","aerostat2color3"];
			this.view3dModelName = names3d[Math.round(0+4*Math.random())];
			
			this.view3dZ = -200;	
		}
	}
}