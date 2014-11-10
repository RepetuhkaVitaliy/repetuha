package game.garage
{
	import game.Game;
	import game.garage.shopitems.ShopItem;

	public class UpgradeByPlus
	{
		public var lines:Array = [[],[],[],[]];
		
		public function UpgradeByPlus()
		{
			
		}
		
		public function regAtLine(lineIndex:Number,inchIndex:Number,shopItem:ShopItem):void
		{
			lines[lineIndex].push(shopItem);
		}
		
		public function buyOnLine(index:Number):Boolean
		{
			Core.u.write("buyOnLine = "+index);
			for (var i:int = 0; i < lines[index].length; i++) 
			{
			   var item:ShopItem = lines[index][i];
			   if(item.avaible && !item.sold){
				   game.Game.shop.buy(item);
				   return true;
			   }
			}
			
			return false;
		}
		
	}
}