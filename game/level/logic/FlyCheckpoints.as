package game.level.logic
{
	import flash.events.Event;
	
	import game.engine.Engine;
	import game.engine.bodys.CheckPoint;
	import game.engine.bodys.CheckPointMaster;
	import game.engine.bodys.SpaceBody;
	import game.events.GameEvent;
	import game.events.GameUI_Event;
	import game.level.Level;
	
	public class FlyCheckpoints extends LevelLogic
	{
		public function FlyCheckpoints(_level:Level, _engine:Engine)
		{
			super(_level, _engine);
		}
		
		public override function tick():void
		{
			if(level.started)check();

		}
		
		private function check(e:GameEvent = null):void
		{
			if(engine.spaceBodys.length < 2)return;
			
			var slaveCheckpointComplete:Boolean = true;
			
			// check checkpoints
			for each(var sb:SpaceBody in engine.spaceBodys){
				if(sb is CheckPoint && !(sb is CheckPointMaster)){
					if(sb.isDead != true){
						slaveCheckpointComplete = false;
					}
				}
			}
			
			if(slaveCheckpointComplete)enableMasterChekpoints();
		}
		
		private function enableMasterChekpoints():void
		{
			for each(var sb:SpaceBody in engine.spaceBodys){
				
				if(sb is CheckPointMaster){
					if(!sb.active){
						sb.active = true;
						sb.mc.alpha = 1;
						sb.addEventListener(GameEvent.BODY_DIE,function():void{ 
							
							  level.complete(); 
						});
					}
				}
			}
		}
	}
}