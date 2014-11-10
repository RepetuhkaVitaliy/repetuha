package game.garage.shopitems
{
	import flash.display.MovieClip;
	
	import game.engine.movecontrol.WasdControl;
	import game.gui.GameUI;
	
	public class ShopItemUpgrade1 extends ShopItem
	{
		public function ShopItemUpgrade1(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 45;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.maxSpeed += 0.05;
			game.gui.GameUI.level.ship.speed = game.gui.GameUI.level.ship.maxSpeed;
			
			if(game.gui.GameUI.level.ship.moveControl){
			  (game.gui.GameUI.level.ship.moveControl as WasdControl).rotationSpeedMax += 0.08;
			  (game.gui.GameUI.level.ship.moveControl as WasdControl).rotationSpeedInertiaDel += 0.03;
			  (game.gui.GameUI.level.ship.moveControl as WasdControl).maxSpeed = game.gui.GameUI.level.ship.maxSpeed;
			}
		}
	}
}