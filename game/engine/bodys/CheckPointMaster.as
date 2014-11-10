package game.engine.bodys
{
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	import game.engine.types.Box2dSlaveBodysTypes;
	
	public class CheckPointMaster extends CheckPoint
	{
		public function CheckPointMaster()
		{
			super();
			removeChild(this.mc);
			this.mc = new swc_checkpoint_master()
			addChild(this.mc);
			
			mc.alpha = 0.5;
			this.active = false;
			
			//this.view3dModelName = "circle1finishoff";
		}
		
		override public function set active(arg:Boolean):void
		{
			super.active = arg;
			if(arg){this.view3dModelName = "circle1finish";
			}else{
				this.view3dModelName = "circle1finishoff";
			}
		}
		
		override public function die(by:SpaceBody = null):void
		{
			super.die(by);
			this.view3dModelName = "circle1finishoff";
		}
	}
}