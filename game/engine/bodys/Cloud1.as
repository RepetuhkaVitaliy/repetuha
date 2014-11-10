package game.engine.bodys
{
	import flash.display.MovieClip;
	import flash.geom.Point;

	public class Cloud1 extends SpaceBody
	{
		
		public function Cloud1()
		{
		super();
		this.mc = new MovieClip();
		//addChild(this.mc);
		
		this.v = new Point(0.5+0.5*Math.random(),0);
		this.speed = 1;
		this.mass = 6;//0.6+0.6*Math.random();
		
		this.collisionCrashBy = [];
		
		this.collisionTakeIt = [];
		
		this.box2dbody = null;
		
		this.view3dModelName = ["cloud1","cloud1_2","cloud1_3"][Math.round(3*Math.random())];
		
		this.scaleX = 3;
		
		this.active = false;
		
		this.view3dZ = -450-150*Math.random();
	}
	}
}