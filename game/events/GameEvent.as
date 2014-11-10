package  game.events{
	import flash.events.Event;
	
	public class GameEvent extends Event{
		
		public static const LEVEL_PASSED:String = "level_passed";
		public static const LEVEL_FAILD:String = "level_faild";
		
		public static const PLAYER_FIRE:String = "player_fire";
		public static const PLAYER_DIE:String = "player_die";
		public static const BODY_DIE:String = "body_die";
		public static const BODY_DAMAGE:String = "body_damage";
		
		public static const SCORE_UPDATE:String = "score_update";
		
		
		public function GameEvent(type : String) {
			super(type);
		}
		
		override public function toString() : String {
			return super.formatToString('GameEvent', 'type');
		}

	}
	
}
