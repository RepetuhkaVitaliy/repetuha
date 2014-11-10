package game.garage.shopitems
{
	import flash.display.MovieClip;
	import game.engine.movecontrol.WasdControl;
	import game.gui.GameUI;
	
	public class ShopItemUpgrade3 extends ShopItemUpgrade2
	{
		public function ShopItemUpgrade3(_mc:MovieClip=null)
		{
			super(_mc);
			
			this.price = 100;
		}
		
		override public function activate():void
		{
			super.activate();
			
			game.gui.GameUI.level.ship.maxSpeed += 0;
			game.gui.GameUI.level.ship.speed = game.gui.GameUI.level.ship.maxSpeed;
			
			if(game.gui.GameUI.level.ship.moveControl){
				(game.gui.GameUI.level.ship.moveControl as WasdControl).rotationSpeedMax += 0.15;			
				(game.gui.GameUI.level.ship.moveControl as WasdControl).maxSpeed = game.gui.GameUI.level.ship.maxSpeed;
			}
		}
	}
}