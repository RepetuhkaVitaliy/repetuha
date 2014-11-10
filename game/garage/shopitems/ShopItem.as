package game.garage.shopitems
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	import game.Game;
	
	public class ShopItem
	{
		public var mc:MovieClip;
		
		public var isActive:Boolean = false;
		
		public var parentItem:ShopItem = null;
		
		public function ShopItem(_mc:MovieClip = null)
		{
               if(_mc)this.setView(_mc);
		}
		
		// to override 
		public function activate():void
		{
			isActive = true;
		}
		public function deactivate():void
		{
			isActive = false;
		}
		
		// price
		private var _price:Number = 10;
		public function set price(arg:Number):void
		{
			_price = arg;
			
			if(mc){
				mc.field_price.text = ""+price;
			}
		}
		public function get price():Number
		{
			return _price;
		}
		
		// avaible
		private var _avaible:Boolean = false;
		public function set avaible(arg:Boolean):void
		{
			_avaible = arg;
			
			if(parentItem != null && parentItem.sold == false)_avaible = false;
			
			if(mc){
				if(!_avaible){ mc.alpha = 0.5; mc.mouseChildren = false; };
				if(_avaible){ mc.alpha = 1; mc.mouseChildren = true; };
			}
		}
		public function get avaible():Boolean
		{
			return _avaible;
		}
		
		// sold state
		private var _sold:Boolean = false;
		public function set sold(arg:Boolean):void
		{
			_sold = arg;
			
			if(sold)avaible = false;
			
			if(sold)activate(); // this used if uprgade during level. now active launch only on startlevel
			if(!sold)deactivate(); // this used if uprgade during level
			
			if(mc){
			    if(!sold)mc.gotoAndStop(1);
				if(sold)mc.gotoAndStop(2);
			}
		}
		public function get sold():Boolean
		{
			return _sold;
		}
		
		// view
		public function setView(_mc:MovieClip):void
		{
			if(mc){
				Core.u.write(this+".mc - already set!","FF0000");
				return;
			}
			
			mc = _mc;
			Core.u.write(".mc = "+mc,"0000FF");
			Core.u.write(".mc = "+mc.btn_buy,"0000FF");
			mc.btn_buy.addEventListener(MouseEvent.CLICK,buyClick);
			
			//avaible = false;
		}
		
		// PRIVATE:
		private function buyClick(e:MouseEvent):void
		{
			game.Game.shop.buy(this);
		}
	}
}