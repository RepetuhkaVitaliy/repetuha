package game.engine.bodys
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.engine.Engine;
	import game.engine.types.Box2dMasterBodysTypes;

	public class Vitryak extends SpaceBody
	{
		public function Vitryak()
		{
			super();
			this.mc = new swc_vitryak();
			
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = game.engine.types.Box2dMasterBodysTypes.STATIC;
			this.mass = 3;
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.view3dModelName = "windmill2";
			this.freeFly = false;
			
			//this.bo
			
			this.addEventListener(Event.ADDED_TO_STAGE,createParts);
		}
		
		private var lopast1:Lopast = new Lopast();
		private var lopast2:Lopast = new Lopast();
		private var lopast3:Lopast = new Lopast();
		
		private var lopastSpeed:Number = 1.5;
		private var lopastRotation:Number = 0;
		
		private function createParts(e:Event):void
		{
			if(parent.parent is Engine){
				
			   (parent.parent as Engine).addBody(lopast1,new Point(x,y));
			   (parent.parent as Engine).addBody(lopast2,new Point(x,y));			   
			   (parent.parent as Engine).addBody(lopast3,new Point(x,y));
			   
			   var tt:Timer = new Timer(100,1);
			   tt.start();
			   tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			   {
				   //(parent.parent as Engine).box2dLinkBody(box2dbody,lopast1.box2dbody,0,false);
				   
				  // (parent.parent as Engine).box2dLinkBody(box2dbody,lopast2.box2dbody,0,false);
				   
				 //  (parent.parent as Engine).box2dLinkBody(box2dbody,lopast3.box2dbody,0,false);
				   
				   game.engine.Engine.box2dSetPosition(lopast1.box2dbody,new Point(x,y));
				   game.engine.Engine.box2dSetPosition(lopast2.box2dbody,new Point(x,y));
				   game.engine.Engine.box2dSetPosition(lopast3.box2dbody,new Point(x,y));
				   
				   box2dSlaveBodys = [lopast1.box2dbody,lopast2.box2dbody,lopast3.box2dbody];
			   });
			   
			}
		}
		
		override public function move():void
		{
			lopastRotation += lopastSpeed;

			game.engine.Engine.box2dSetPosition(lopast1.box2dbody,new Point(x,y));
			game.engine.Engine.box2dSetPosition(lopast2.box2dbody,new Point(x,y));
			game.engine.Engine.box2dSetPosition(lopast3.box2dbody,new Point(x,y));
			
			game.engine.Engine.box2dRotateBody(lopast1.box2dbody,(lopastRotation/180*Math.PI));
			game.engine.Engine.box2dRotateBody(lopast2.box2dbody,((lopastRotation+120)/180*Math.PI));
			game.engine.Engine.box2dRotateBody(lopast3.box2dbody,((lopastRotation+240)/180*Math.PI));
		}
	}
}