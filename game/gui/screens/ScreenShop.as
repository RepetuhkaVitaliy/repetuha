package game.gui.screens
{
	import caurina.transitions.Tweener;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	
	import game.Game;
	import game.garage.Shop;
	import game.garage.shopitems.ShopItem;
	import game.garage.shopitems.ShopItemRoket1;
	import game.gui.GameUI;
	
	public class ScreenShop extends ScreenSample
	{
		public var mc:swc_gui_shop = new swc_gui_shop();
		
		public var mcPopUp:swc_easyshoppopup = new swc_easyshoppopup();
		
		public function ScreenShop(screenName:String="")
		{
			super("shoppping");
			
			addChild(mc);
			mc.x = game.Game.GameWidth/2;
			mc.y = game.Game.GameHeight/2;
			mc.visible = false;
			
			addChild(mcPopUp);
			mcPopUp.x = game.Game.GameWidth/2;
			mcPopUp.y = game.Game.GameHeight/2;
			
			mcPopUp.btn_close.addEventListener(MouseEvent.CLICK,function():void
			{
				hide();
			});
			configLines(mcPopUp);
			
			
			mc.btn_back.addEventListener(MouseEvent.CLICK,function():void
			{
				hide();
			});
			
			this.addEventListener(Event.ADDED_TO_STAGE,function():void
			{
				stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			});
			
			// sounds
			game.Game.sounds.addButton(mc.btn_back);
		}
		
		override public function show():void
		{
			super.show();
			
			y = game.Game.GameHeight;
			Tweener.addTween(this,{y:0,time:0.5,delay:0,transition:"easeoutquad"});
			
			update();
			
			updateUpgradePopUp();
		}
		
		override public function hide():void
		{
			super.hide();
			
			if(!game.Game.shop.checkItemsAvaible())this.stopAnimatedAlertBtns();
			//visible = true;
			//Tweener.addTween(this,{y:game.Game.GameHeight,time:0.3,delay:0,transition:"easeinquad",
				//onComplete:function():void{
					//visible = false;				
				//}});
			
		}
		
		public function update():void
		{
			   mc.field_coins.text = ""+game.Game.shop.budget;
			   updateUpgradePopUp();
		}
		
		
		public function checkAvaibles(shopBtnMc:MovieClip):void
		{
			(shopBtnMc as swc_gui_btn_shop_mc).mc_blick.visible = false;
			
			if(!game.Game.shop.checkItemsAvaible())return;
			
			// anim - alert blick
			(shopBtnMc as swc_gui_btn_shop_mc).mc_blick.visible = true;
			if(animatedShopBtns.indexOf(shopBtnMc) == -1)animatedShopBtns.push(shopBtnMc);
		}
		
		// anim - alert blick
		private var animatedShopBtns:Array = [];
		public function stopAnimatedAlertBtns():void
		{
			for (var i:int = 0; i < animatedShopBtns.length; i++) 
			{
				var shopBtnMc:swc_gui_btn_shop_mc = animatedShopBtns[i];
				shopBtnMc.mc_blick.visible = false;	
			}
			
		}
		
		/// EASY UPRGADES:
		private var linesMcs:Array = [];
		private function configLines(mc:swc_easyshoppopup):void
		{
			linesMcs = [mc.mc_up1,mc.mc_up2,mc.mc_up3,mc.mc_up4];
			
			for (var i:int = 0; i < linesMcs.length; i++) 
			{
				var mcUpg:easyshopLine = linesMcs[i];
				mcUpg.btn_plus.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
				{
					game.Game.shop.plusUpgrade.buyOnLine(linesMcs.indexOf(e.target.parent));
					update();
				});	
			}
			
		}
		private function updateUpgradePopUp():void
		{
			for (var i:int = 0; i < game.Game.shop.plusUpgrade.lines.length; i++) 
			{
				var mcUpg:easyshopLine = linesMcs[i];
				mcUpg.field_price.alpha = 1;// reset
				mcUpg.field_price.text = "";// reset
				plusSetActive(mcUpg.btn_plus,false);// reset
				
				var lineItems:Array = game.Game.shop.plusUpgrade.lines[i];
				
				var firstAvaible:Boolean = false;
				for (var j:int = 0; j < lineItems.length; j++) 
				{
					var item:ShopItem = lineItems[j];
					
					if(item.sold){
					  mcUpg.mc_progress.gotoAndStop(2+j);
					  if(j == 2)mcUpg.field_price.text = "max";
					}
					
					if(item.avaible && !item.sold && !firstAvaible){
						mcUpg.field_price.text = ""+item.price;
						plusSetActive(mcUpg.btn_plus,true);
						firstAvaible = true;
					}
					
					if(!item.avaible && !item.sold && !firstAvaible){
						mcUpg.field_price.text = ""+item.price;
						mcUpg.field_price.alpha = 0.5;// reset
						j = 999;
					}
					
					
				}
				
			}
			
		}
		public function plusSetActive(btn:SimpleButton,active:Boolean):void
		{
			if(active){
				btn.alpha = 1;
				btn.mouseEnabled = true;
			}else{
				btn.alpha = 0.5;
				btn.mouseEnabled = false;
			}
		}
		
		// keyboard
		private function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32)// space
			{
				if(visible && x == 0 && y == 0){
					hide();
				}
			}
		}
		
	}
}