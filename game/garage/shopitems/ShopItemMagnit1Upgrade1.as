package game.garage.shopitems
{
	import flash.display.MovieClip;
	
	import game.gui.GameUI;
	
	public class ShopItemMagnit1Upgrade1 extends ShopItem
	{
		public function ShopItemMagnit1Upgrade1(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 20;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.magnitDelPerFrame *= 0.75;			
		}
	}
}