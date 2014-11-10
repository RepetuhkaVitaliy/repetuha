package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.gui.GameUI;

	public class RoketPoint extends SpaceBody
	{
		public function RoketPoint()
		{
			super();
			this.mc = new swc_bullet()
			addChild(this.mc);			
			
			this.v = new Point(0,0);
			
			this.speed = 0;
			
			this.mass = 2;
			
			collisionCrashBy = [];
			
			collisionTakeIt = [];
			
			view3dModelName = "roket1point";
			
			this.box2dbody = null;
		}
		
		override public function move():void
		{
			this.view3dRotationY += 5;
			//this.view3dRotationZ += 2;
		}
		
		
		override public function die(murder:SpaceBody=null):void
		{
			super.die();
			view3dModelName = "";
		}
		
		override public function set active(arg:Boolean):void
		{
			if(game.gui.GameUI.level.ship.roketEnable == false)arg = false;
			if(game.gui.GameUI.level.ship.roketEnable == true)arg = true;
			super.active = arg;
			
			visible = arg;
			
			if(arg)view3dModelName = "roket1point"
			else view3dModelName = "";
		}
	}
}