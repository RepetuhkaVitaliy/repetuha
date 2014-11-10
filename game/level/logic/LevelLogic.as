package game.level.logic
{
	import flash.events.EventDispatcher;
	
	import game.engine.Engine;
	import game.level.Level;

	public class LevelLogic extends EventDispatcher
	{
		internal var engine:Engine;
		internal var level:Level;
		public function LevelLogic(_level:Level,_engine:Engine)
		{
			engine = _engine;
			level = _level;
		}
		
		// PUBLIC:
		public function init():void
		{
			
		}
		
		public function tick():void
		{
			
		}
	}
}