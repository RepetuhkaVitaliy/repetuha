package game.engine.bodys
{
	public class ActionArea2 extends ActionArea1
	{
		public function ActionArea2()
		{	
			super();
			removeChild(this.mc);
			this.mc = new swc_actionarea2();
			addChild(this.mc);
			
			subtypeNum = 2;
			
			this.view3dModelName = "action2";
		}
	}
}