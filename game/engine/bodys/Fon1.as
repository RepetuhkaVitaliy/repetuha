package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.Game;
	import game.engine.types.Box2dMasterBodysTypes;

	public class Fon1 extends SpaceBody
	{
		public function Fon1()
		{
			super();
			this.mc = new swc_fon1();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = game.engine.types.Box2dMasterBodysTypes.STATIC;
			this.mass = 1;
			this.rotation = 0;
			
			this.collisionCrashBy = [];
			this.collisionTakeIt = [];
			
			if(game.Game.levelNum > 12)this.view3dModelName = "fon2"
			else this.view3dModelName = "fon1";
			
			this.box2dbody = null;
		}
	}
}