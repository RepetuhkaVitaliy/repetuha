package game.garage.shopitems
{
	import flash.display.MovieClip;
	
	import game.gui.GameUI;
	
	public class ShopItemSmokeWhite extends ShopItem
	{
		public function ShopItemSmokeWhite(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 15;
			
			
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.smokeName = "smoke1white";
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			game.gui.GameUI.level.ship.smokeName = "smoke1";
		}
	}
}