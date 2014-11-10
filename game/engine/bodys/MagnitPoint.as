package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.gui.GameUI;

	public class MagnitPoint extends SpaceBody
	{
		public function MagnitPoint()
		{
			super();
			this.mc = new swc_bullet()
			addChild(this.mc);			
			
			this.v = new Point(0,0);
			
			this.speed = 0;
			
			this.mass = 2;
			
			collisionCrashBy = [];
			
			collisionTakeIt = [];
			
			view3dModelName = "magnit1";
			
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
			if(game.gui.GameUI.level.ship.magnitEnable == false)arg = false;
			if(game.gui.GameUI.level.ship.magnitEnable == true)arg = true;
			
			super.active = arg;
			
			visible = arg;
			
			if(arg)view3dModelName = "magnit1"
			else view3dModelName = "";
		}
	}
}