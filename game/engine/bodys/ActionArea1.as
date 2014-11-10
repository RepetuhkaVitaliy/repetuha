package game.engine.bodys
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.engine.ai.Manevr;

	public class ActionArea1 extends SpaceBody
	{
		private var manevr:Manevr = new Manevr();
		
		public function ActionArea1()
		{
			super();
			
			this.mc = new swc_actionarea();
		
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 4;
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.box2dbody = null;
			
			this.view3dModelName = "action1";
		}
		
		override public function takeIt(sb:SpaceBody):void
		{
			if(Math.abs(sb.rotation-rotation) > 25)return;
			
			if(this.view3deffect1 == false){
				
			     this.view3deffect1 = true;
				 var tt:Timer = new Timer(500,1);
				 tt.start();
				 tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
				 {
					 view3deffect1 = false;					 
				 });
			}
		}
		
		public function push(sb:SpaceBody):void
		{
			if(Math.abs(sb.rotation-rotation) > 25)return;
			
			if(this.subtypeNum == 1)manevr.play(Manevr.AVOID_RIGHT,sb);
			
			if(this.subtypeNum == 2)manevr.play(Manevr.AVOID_LEFT,sb);
			
			if(this.subtypeNum == 3)manevr.play(Manevr.LOOP_UP,sb);
			
			if(this.subtypeNum == 4)manevr.play(Manevr.LOOP_DOWN,sb);
			
			if(this.subtypeNum == 5)manevr.play(Manevr.CYLINDER,sb);
			
			// rotation where use?
			//if(rotation == 0 || rotation == 180)manevr.play(Manevr.ROTATE_360Z,sb);
			//if(rotation == -90 || rotation == 90)manevr.play(Manevr.ROTATE_360Y,sb);
			
		    this.die(); 
		}
	}
}