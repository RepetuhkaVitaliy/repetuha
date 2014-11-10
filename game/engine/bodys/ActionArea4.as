package game.engine.bodys
{
	public class ActionArea4 extends ActionArea1
	{
		public function ActionArea4()
		{
			super();
			removeChild(this.mc);
			this.mc = new swc_actionarea4();
			addChild(this.mc);
			
			subtypeNum = 4;
			
			this.view3dModelName = "action4";
		}
	}
}