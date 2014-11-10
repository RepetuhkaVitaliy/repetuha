package game.garage.shopitems
{
	import flash.display.MovieClip;
	import game.gui.GameUI;
	public class ShopItemRoket1Upgrade2 extends ShopItem
	{
		public function ShopItemRoket1Upgrade2(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 45;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.roketDelPerFire *= 0.5;
		}
	}
}