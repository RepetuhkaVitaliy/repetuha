package game.garage
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import game.Game;
	import game.garage.shopitems.*;
	import game.gui.GameUI;
	import game.gui.screens.ScreenShop;

	public class Shop extends EventDispatcher
	{
		public static var EVENT_BUY:String = "EVENT_BUY";
		
		//
		public var shopItems:Vector.<ShopItem> = new Vector.<ShopItem>;
		
		//
		public var buysArray:Vector.<ShopItem> = new Vector.<ShopItem>;
		public var lastBuyItem:ShopItem = null;
		
		//
		private var view:ScreenShop;
		
		//
		public var plusUpgrade:UpgradeByPlus = new UpgradeByPlus();
		
		public function Shop(_view:ScreenShop)
		{
			view = _view;
			
			var item1:ShopItem = new ShopItemRoket1(view.mc.mc_roket1)
			add(item1);
			var item2:ShopItem = new ShopItemSmokeWhite(view.mc.mc_white_smoke)
			add(item2);
			var item3:ShopItem = new ShopItemSmokeColor(view.mc.mc_color_smoke)
			add(item3);
			var item4:ShopItem = new ShopItemNitro1(view.mc.mc_nitro1)
			add(item4);
			var item5:ShopItem = new ShopItemUpgrade1(view.mc.mc_upgrade1)
			add(item5);
			var item6:ShopItem = new ShopItemUpgrade2(view.mc.mc_upgrade2)
			add(item6); item6.parentItem = item5;
			var item7:ShopItem = new ShopItemNitro1Upgrade1(view.mc.mc_nitro1_upgrade1)
			add(item7); item7.parentItem = item4;
			var item8:ShopItem = new ShopItemMagnit1(view.mc.mc_magnit)
			add(item8);
			var item9:ShopItem = new ShopItemMagnit1Upgrade1(view.mc.mc_magnit_upg1)
			add(item9); item9.parentItem = item8;
			var item10:ShopItem = new ShopItemRoket1Upgrade1(view.mc.mc_roket1_upgrade1)
			add(item10); item10.parentItem = item1;

			// make 3 uprgrades
			var item11:ShopItem = new ShopItemRoket1Upgrade2(view.mc.mc_upgrade1)
			add(item11); item11.parentItem = item10;
			
			var item12:ShopItem = new ShopItemUpgrade3(view.mc.mc_upgrade1)
			add(item12); item12.parentItem = item6;
			
			var item13:ShopItem = new ShopItemMagnit1Upgrade2(view.mc.mc_upgrade1)
			add(item13); item13.parentItem = item9;
			
			var item14:ShopItem = new ShopItemNitro1Upgrade2(view.mc.mc_upgrade1)
			add(item14); item14.parentItem = item7;
			
			// setup UpgradeByPlus
			/*engine*/ plusUpgrade.regAtLine(0,0,item5); plusUpgrade.regAtLine(0,1,item6); plusUpgrade.regAtLine(0,2,item12);
			/*nitro*/  plusUpgrade.regAtLine(1,0,item4); plusUpgrade.regAtLine(1,1,item7); plusUpgrade.regAtLine(1,2,item14);
			/*magnet*/ plusUpgrade.regAtLine(2,0,item8); plusUpgrade.regAtLine(2,1,item9); plusUpgrade.regAtLine(2,2,item13);
			/*rocket*/ plusUpgrade.regAtLine(3,0,item1); plusUpgrade.regAtLine(3,1,item10); plusUpgrade.regAtLine(3,2,item11);
			
			
			//add(new ShopItemConfeti1(view.mc.mc_confeti));
			
			item2.sold = true;
			item3.sold = true;
			
			checkItemsAvaible();
		}
		
		// price
		private var _budget:Number = 0;
		public function set budget(arg:Number):void
		{
			_budget = arg;
			
			checkItemsAvaible();
			view.update();
		}
		public function get budget():Number
		{
			return _budget;
		}
		
		public function add(item:ShopItem):void
		{
			shopItems.push(item);
			//item.avaible = true;
		}
		
		public function buy(item:ShopItem):void
		{
			if(item.sold)return;
			if(budget < item.price)return;
				
			budget -= item.price;
			
			buysArray.push(item);
			item.sold = true;
			
			lastBuyItem = item;
			dispatchEvent(new Event(EVENT_BUY));
			
			view.update();
			checkItemsAvaible();
		}
		
		public function sell(item:ShopItem):void
		{
			buysArray.splice(buysArray.indexOf(item),1);
			item.sold = false;
		}
		
		public function applyBuyItems():void
		{
			for each (var item:ShopItem in buysArray) 
			{
				if(item.isActive)item.activate();
			}
		}
		
		public function checkItemsAvaible():Boolean
		{
			var somethingAvaible:Boolean = false;
			
			for each (var item:ShopItem in shopItems) 
			{
				item.avaible = true;
				if(budget < item.price && !item.sold)item.avaible = false;
				
				if(item.avaible && !item.sold)somethingAvaible = true;
				//if(game.gui.GameUI.level.ship && item is ShopItemRoket1Upgrade1 && game.gui.GameUI.level.ship.roketEnable == false)item.avaible = false;
			}
		
			return somethingAvaible;
		}
		
		public function getSoldsArray():Array
		{
		    var arr:Array = [];
			for(var i:uint  = 0; i < shopItems.length;i++)
			{
			   arr.push(shopItems[i].sold);		
			}
			
			return arr;
		}
		
		public function parseSoldsArray(arr:Array):void
		{
			for(var i:uint  = 0; i < shopItems.length;i++)
			{
				shopItems[i].sold = Boolean(arr[i]);	
				buysArray.push(shopItems[i]);
			}
		}
		
	}
}