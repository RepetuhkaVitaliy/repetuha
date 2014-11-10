package game.engine.bodys
{
	public class CheckPointSc2 extends CheckPoint
	{
		
		public function CheckPointSc2()
		{
			super();
			removeChild(this.mc);
			mc = null;
			this.mc = new swc_checkpoint_scale();
			addChild(this.mc);
			
			this.mass += 1; 
			
			this.subtypeNum = 2;
			
			this.view3dModelName = "circle12";
			
			this.targets.push(this);
			
			updateNumber();
		}
		
		override public function die(by:SpaceBody = null):void
		{
			if(timeHit < 10)return;
			timeHit = 0;
			
			subtypeNum --;
			if(subtypeNum == 0){
				super.die(by);
				return;
			}
			
			for each(var sb:SpaceBody in targets){
				if(sb){
					(sb as CheckPoint).ScaleState(-1);
				}
			}
			
			updateNumber();
		}
		
		internal function updateNumber():void
		{
			(mc as swc_checkpoint_scale).mc_one.alpha = 0;
			(mc as swc_checkpoint_scale).mc_two.alpha = 0;
			(mc as swc_checkpoint_scale).mc_three.alpha = 0;
			
			if(subtypeNum == 1)(mc as swc_checkpoint_scale).mc_one.alpha = 1;
			if(subtypeNum == 2)(mc as swc_checkpoint_scale).mc_two.alpha = 1;
			if(subtypeNum == 3)(mc as swc_checkpoint_scale).mc_three.alpha = 1;
		}
		
		private var timeHit:Number = 0;
		override public function move():void
		{
			timeHit++;	
		}
	}
}