package game.engine.bodys
{
	public class ActionArea3 extends ActionArea1
	{
		public function ActionArea3()
		{
			super();
			removeChild(this.mc);
			this.mc = new swc_actionarea3();
			addChild(this.mc);
			
			subtypeNum = 3;
			
			this.view3dModelName = "action3";
		}
	}
}