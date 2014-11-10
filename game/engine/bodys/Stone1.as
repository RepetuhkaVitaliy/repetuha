package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.engine.ai.Manevr;
	import game.engine.types.Box2dMasterBodysTypes;

	public class Stone1 extends SpaceBody
	{
		public function Stone1()
		{
			super();
			this.mc = new swc_stone1();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = game.engine.types.Box2dMasterBodysTypes.STATIC;
			this.mass = 1;//0.6+0.6*Math.random();
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
		}
		
	}
}