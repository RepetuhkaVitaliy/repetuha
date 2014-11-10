package game.engine.bodys
{
	import flash.geom.Point;

	public class Bomb1 extends SpaceBody
	{
		public function Bomb1()
		{
			super();
			this.mc = new swc_bomb1();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 2;//0.6+0.6*Math.random();
			
			this.box2dbody = null;
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [CheckPoint];// for editor
			
			this.view3dModelName = "bomb1";
		}
		
		
		override public function die(by:SpaceBody = null):void
		{
			for each(var sb:SpaceBody in targets){
				if(sb)sb.die();
			}
			super.die();
		}
		
		
		// for editor:
		override public function takeIt(sb:SpaceBody):void
		{
			if(this.targets.indexOf(sb) == -1){
				this.targets.push(sb);
			}
		}
	}
}