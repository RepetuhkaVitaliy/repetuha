package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.engine.types.Box2dMasterBodysTypes;

	public class Lopast extends SpaceBody
	{
		public function Lopast()
		{
			super();
			this.mc = new swc_lopast();
			
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 3;
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.view3dModelName = "lopast1";
			
			this.createPolygon();
		}
	}
}