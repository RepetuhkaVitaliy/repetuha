package game.engine.bodys
{
	public class CheckPointRot extends CheckPoint
	{
		public function CheckPointRot()
		{
			super();
			removeChild(this.mc);
			mc = null;
			this.mc = new swc_checkpoint_rotate();
			addChild(this.mc);
			
			this.view3dModelName = "circle1rot";
		}
		
		override public function die(by:SpaceBody = null):void
		{
			for each(var sb:SpaceBody in targets){
				if(sb)(sb as CheckPoint).Rotate90();
			}
			super.die(by);
		}
	}
}