package game.engine.bodys
{
	import flash.geom.Point;

	public class Bullet extends SpaceBody
	{
		public function Bullet(_v:Point)
		{
			this.mc = new swc_bullet()
			addChild(this.mc);			
			
		    this.v = _v;
			
			this.speed = 0.7;
			
			this.mass = 1;
			
			collisionCrashBy = [SpaceBody];
		}
	}
}