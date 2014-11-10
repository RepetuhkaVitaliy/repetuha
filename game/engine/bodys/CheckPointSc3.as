package game.engine.bodys
{
	public class CheckPointSc3 extends CheckPointSc2
	{
		public function CheckPointSc3()
		{
			super();
			
			this.subtypeNum = 3;
			this.mass += 1;
			
			updateNumber();
			
			this.view3dModelName = "circle13";
		}
	}
}