package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.Game;
	import game.engine.types.Box2dMasterBodysTypes;
	
	public class GroundBox extends SpaceBody
	{
		public function GroundBox()
		{
			
			super();
			this.mc = new swc_ground();
			addChild(this.mc);
			
			this.v = new Point(1,1);
			this.speed = game.engine.types.Box2dMasterBodysTypes.STATIC;
			this.mass = 10;
			this.rotation = 0;
			
			this.collisionCrashBy = [];
			this.collisionTakeIt = [];
			
			if(game.Game.levelNum > 12)this.view3dModelName = "ground2"
			else this.view3dModelName = "ground1";
		}
	}
}