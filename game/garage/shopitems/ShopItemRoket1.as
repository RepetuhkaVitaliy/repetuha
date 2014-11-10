package game.garage.shopitems
{
	import flash.display.MovieClip;
	
	import game.Game;
	import game.gui.GameUI;

	public class ShopItemRoket1 extends ShopItem
	{
		public function ShopItemRoket1(_mc:MovieClip = null)
		{
			super(_mc);
			
			this.price = 15;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.roketEnable = true;
		}
		
		override public function deactivate():void
		{
			super.deactivate();
			
			game.gui.GameUI.level.ship.roketEnable = false;
		}
	}
}