package game.engine.bodys
{
	import flash.geom.Point;

	public class SpeedUp extends SpaceBody
	{
		public function SpeedUp()
		{
			super();

			this.mc = new swc_speedup();
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 4;
			
			this.collisionCrashBy = [];
			
			this.box2dbody = null;
			
			this.view3dModelName = "circle1nitro";
		}
		
		public function push(body:SpaceBody):void
		{
			if(body is Ship)
			{
			   if(Math.abs(body.rotation-rotation) > 25)return;
				
			   var pushed:Boolean = (body as Ship).nitro(mass*15,1500,this.rotation);
			   if(pushed){
				   //body.x = x; //body.y = y;   
			   }
			}
		}
	}
}