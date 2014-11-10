package game.garage.shopitems
{
	import flash.display.MovieClip;
	import game.gui.GameUI;
	
	public class ShopItemMagnit1 extends ShopItem
	{
		public function ShopItemMagnit1(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 15;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.magnitEnable = true;			
		}
	}
}