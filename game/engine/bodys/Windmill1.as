package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.engine.types.Box2dMasterBodysTypes;

	public class Windmill1 extends SpaceBody
	{
		public function Windmill1()
		{
			super();
			this.mc = new swc_windmill1();
			addChild(this.mc);
			
			this.v = new Point(1,1);
			this.speed = game.engine.types.Box2dMasterBodysTypes.STATIC;
			this.mass = 3;
			this.rotation = 0;
			
			this.collisionCrashBy = [];
			this.collisionTakeIt = [];
			
			this.view3dModelName = "windmill1";
			
			this.createPolygon();
		}
	}
}