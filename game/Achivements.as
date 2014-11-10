package game
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Achivements extends EventDispatcher
	{
		// event
		public static var EVENT_NEW_ACHIVEMENT:String = "EVENT_NEW_ACHIVEMENT";
		
		// 
		public static var UNLOKED_ON_LEVEL:Array = [];
		public static var UNLOKED:Array = [];
		public static var LAST_UNLOKED:String = "";
		
		// achivs
		public static var ACH_2x100ACCURACY:String = "ACH_2x100ACCURACY";
		public static var ACH_3x100ACCURACY:String = "ACH_3x100ACCURACY";
		public static var ACH_4x100ACCURACY:String = "ACH_4x100ACCURACY";
		public static var ACH_5x100ACCURACY:String = "ACH_5x100ACCURACY";
		
		
		public static var ACH_NOBUMP:String = "ACH_NOBUMP";
		
		public static var ACH_ALLCOINS:String = "ACH_ALLCOINS";
		
		public static var ACH_MINIMUMTIME:String = "ACH_MINIMUMTIME";
		
		public static var ACH_2xCIRCLE_MAXSPEED:String = "ACH_2xCIRCLE_MAXSPEED";		
		public static var ACH_3xCIRCLE_MAXSPEED:String = "ACH_3xCIRCLE_MAXSPEED";
		public static var ACH_4xCIRCLE_MAXSPEED:String = "ACH_4xCIRCLE_MAXSPEED";
		public static var ACH_5xCIRCLE_MAXSPEED:String = "ACH_5xCIRCLE_MAXSPEED";
		
		
		// stack actions
		public static var ACTION_NEWLEVEL:String = "ACTION_NEWLEVEL";
		public static var ACTION_ENDLEVEL:String = "ACTION_ENDLEVEL";
		
		public static var ACTION_KILL:String = "ACTION_KILL";
		public static var ACTION_KILL_100ACCURACY:String = "ACTION_KILL_100ACCURACY";
		public static var ACTION_KILL_SPEED:String = "ACTION_KILL_SPEED";
		
		public function Achivements()
		{
		}
		
		public function unlockAchiv(achiv:String):void
		{
			if(UNLOKED.indexOf(achiv) != -1)return;
			
			UNLOKED.push(achiv);
			UNLOKED_ON_LEVEL.push(achiv);
			
			LAST_UNLOKED = achiv;
			dispatchEvent(new Event(Achivements.EVENT_NEW_ACHIVEMENT));
		}
		
		public function addAction(_action:String):void
		{
			if(_action == Achivements.ACTION_NEWLEVEL){ UNLOKED_ON_LEVEL = []; actionsStack = []; };
			
			actionsStack.push(_action);
			Core.u.write("AAAAAA = "+actionsStack.length);
			checkForAchivements();
		}
		//
		private var actionsStack:Array = [];
		private function checkForAchivements():void
		{
			var prewAction:String = "";
			var count:Number = 0;
			for(var i:uint = 0; i < actionsStack.length;i++)
			{
				var next:String = actionsStack[i];
				if(next == prewAction){
					count ++;
					checkForAchiv(prewAction,count);
					continue;
				}
				if(next != prewAction)
				{
					checkForAchiv(prewAction,count);
					prewAction = next;
					count = 1;
				}
			}
		}
		
		private function checkForAchiv(action:String,count:Number):void
		{
			switch(action){
				case Achivements.ACTION_KILL_100ACCURACY:
					if(count == 2)unlockAchiv(Achivements.ACH_2x100ACCURACY);
					if(count == 3)unlockAchiv(Achivements.ACH_3x100ACCURACY);
					if(count == 4)unlockAchiv(Achivements.ACH_4x100ACCURACY);
					if(count == 5)unlockAchiv(Achivements.ACH_5x100ACCURACY);
					break;
				
				case Achivements.ACTION_KILL_SPEED:
					if(count == 2)unlockAchiv(Achivements.ACH_2xCIRCLE_MAXSPEED);
					if(count == 3)unlockAchiv(Achivements.ACH_3xCIRCLE_MAXSPEED);
					if(count == 4)unlockAchiv(Achivements.ACH_4xCIRCLE_MAXSPEED);
					if(count == 5)unlockAchiv(Achivements.ACH_5xCIRCLE_MAXSPEED);
					break;
			}
		}
	}
}