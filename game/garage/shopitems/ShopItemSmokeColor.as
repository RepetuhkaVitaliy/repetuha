package game.garage.shopitems
{
	import flash.display.MovieClip;
	
	import game.gui.GameUI;
	
	public class ShopItemSmokeColor extends ShopItem
	{
		public function ShopItemSmokeColor(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 75;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.smokeName = "smoke1color";
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			game.gui.GameUI.level.ship.smokeName = "smoke1";
		}
	}
}