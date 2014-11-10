package game.garage.shopitems
{
	import flash.display.MovieClip;
	
	import game.engine.movecontrol.WasdControl;
	import game.gui.GameUI;
	
	public class ShopItemUpgrade2 extends ShopItemUpgrade1
	{
		public function ShopItemUpgrade2(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 55;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.maxSpeed += 0.025;
			game.gui.GameUI.level.ship.speed = game.gui.GameUI.level.ship.maxSpeed;
			
			if(game.gui.GameUI.level.ship.moveControl){
			  (game.gui.GameUI.level.ship.moveControl as WasdControl).rotationSpeedMax += 0.08;	
			  (game.gui.GameUI.level.ship.moveControl as WasdControl).maxSpeed = game.gui.GameUI.level.ship.maxSpeed;
			}
		}
	}
}