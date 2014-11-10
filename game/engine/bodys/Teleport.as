package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.engine.Engine;

	public class Teleport extends SpaceBody
	{
		private var _target:Teleport;
		
		public function Teleport()
		{
			super();
			this.mc = new swc_teleport();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 0.6;
			
			this.collisionCrashBy = [];
			
			this.box2dbody = null;
		}
		
		public function set pair(teleport:Teleport):void
		{
			_target = teleport;
		}
		
		public function teleportate(body:SpaceBody):void
		{
			if(_target){
				var d:Number = body.mc.width/2+this.mc.width/2+30;
				var delX:Number = d*body.v.x;//Math.cos(body.rotation/180*Math.PI)
				var delY:Number = d*body.v.y;//Math.sin(body.rotation/180*Math.PI);
				var X:Number = _target.x+delX;
				var Y:Number = _target.y+delY;
				/* BOX2D */ game.engine.Engine.box2dSetPosition(body.box2dbody,new Point(X,Y));
			}
			else{
				trace(this+" say: No pair to me!"+" - "+x+","+y);
			}
		}
	}
}