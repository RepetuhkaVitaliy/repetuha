package game.engine.bodys
{
	import flash.geom.Point;

	public class Fonplane1 extends SpaceBody
	{
		public function Fonplane1()
		{
			super();
			this.mc = new swc_crystal();
			addChild(this.mc);
			
			this.v = new Point(-1.5,0);
			this.speed = 0.5;
			this.mass = 10;//0.6+0.6*Math.random();
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.box2dbody = null;
			
			this.active = false;
			
			this.view3dModelName = "fonplane1";
			this.view3dZ = -450;	
		}
	}
} 