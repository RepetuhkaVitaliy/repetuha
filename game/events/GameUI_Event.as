package game.events
{
	import flash.events.Event;

	public class GameUI_Event extends Event
	{
		public static const START_GAME:String = "start_game";
		public static const PAUSE_GAME:String = "pause_game";
		public static const REZUME_GAME:String = "rezume_game";
		public static const REPLAY_LEVEL:String = "REPLAY_LEVEL";
		
		public static const SHOW_SCREEN:String = "show_screen";
		public static const HIDE_SCREEN:String = "hide_screen";
		
		public static const SHOW_MENU:String = "hide_menu";
		
		public function GameUI_Event(type : String) {
			super(type);
		}
		
		override public function toString() : String {
			return super.formatToString('GameUI_Event', 'type');
		}
	}
}