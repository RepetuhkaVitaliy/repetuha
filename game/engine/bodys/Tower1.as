package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.engine.types.Box2dMasterBodysTypes;

	public class Tower1 extends SpaceBody
	{
		public function Tower1()
		{
			super();
			this.mc = new swc_tower1();
			
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = game.engine.types.Box2dMasterBodysTypes.STATIC;
			this.mass = 3;
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.view3dModelName = "tower1";
			
			this.createPolygon();
		}
	}
}