package game.engine.bodys
{
	public class ActionArea5 extends ActionArea1
	{
		public function ActionArea5()
		{
			super();
			removeChild(this.mc);
			this.mc = new swc_actionarea5();
			addChild(this.mc);
			
			subtypeNum = 5;
			
			this.view3dModelName = "action5";
		}
	}
}