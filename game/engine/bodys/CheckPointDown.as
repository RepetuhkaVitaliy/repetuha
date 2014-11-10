package game.engine.bodys
{
	public class CheckPointDown extends CheckPoint
	{
		public function CheckPointDown()
		{
			super();
			removeChild(this.mc);
			mc = null;
			this.mc = new swc_checkpoint();
			addChild(this.mc);
			
			this.view3dModelName = "circle1down";
		}
	}
}