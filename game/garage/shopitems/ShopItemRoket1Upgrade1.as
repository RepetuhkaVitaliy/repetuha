package game.garage.shopitems
{
	import flash.display.MovieClip;
	import game.gui.GameUI;
	
	public class ShopItemRoket1Upgrade1 extends ShopItem
	{
		public function ShopItemRoket1Upgrade1(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 25;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.roketDelPerFire *= 0.75;
		}
	}
}