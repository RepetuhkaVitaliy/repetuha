package game.engine.bodys
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.Game;
	import game.Sounds;
	import game.engine.Engine;
	import game.engine.types.Box2dMasterBodysTypes;
	import game.engine.types.Box2dSlaveBodysTypes;
	import game.events.GameEvent;
	import game.level.Level;
	
	public class CheckPoint extends SpaceBody// refactor todo: rename to checkpoint.
	{
		internal var bumpBordersOn:Boolean = true;
		
		public function CheckPoint()
		{
			super();
			this.mc = new swc_checkpoint()
			addChild(this.mc);
			
			this.v = new Point(0,0);
			this.speed = 0;
			this.mass = 4;//0.6+0.6*Math.random();
			
			this.box2dbody = null;
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [CheckPoint,Crystal];// for editor - [CheckPoint,Crystal]
			
			// block this line and set v = new Point(0,0); - for simple check point
			//this.box2dSlaveBodysTypes = [Box2dSlaveBodysTypes.BORDER_LEFT,Box2dSlaveBodysTypes.BORDER_RIGHT];
		
            this.view3dModelName = "circle1";
			this.freeFly = false;
			
			this.price = 100;
			
			this.addEventListener(Event.ADDED_TO_STAGE,createParts);
		}
		
		override public function die(by:SpaceBody = null):void
		{
			if(by is Roket)this.price = 200;
			
			this.active = false;
			this.isDead = true;
			dispatchEvent(new Event(GameEvent.BODY_DIE));
			
			Level.engine.removeBox2dBodys(this);
			
			this.view3dModelName = "circle1off";
			
			dropCoins();
			
			// sound
			game.Game.sounds.play(game.Sounds.CIRCLE);
		}
		
		// add to stage - link two stone
		private var border1:Stone1 = new Stone1();
		private var border2:Stone1 = new Stone1();
		
		private function createParts(e:Event):void
		{	
			this.removeEventListener(Event.ADDED_TO_STAGE,createParts);
			
			if(!bumpBordersOn)return;
			
			if(!(parent.parent is Engine))return;
			
			var tt:Timer = new Timer(100,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
				border2.speed = 0;// center of rotation.
				border1.animationState = true;
				border2.animationState = true;
				border1.rotation = rotation;
				
				game.level.Level.engine.addBody(border1,new Point(x,y));
				game.level.Level.engine.addBody(border2,new Point(x,y));			   
				
				box2dSlaveBodys = [border1.box2dbody,border2.box2dbody];
				
				game.level.Level.engine.box2dLinkBody(border1.box2dbody,border2.box2dbody,-mass*0.8);
			});
		}
		
		public function Rotate90():void
		{
			//rotation += 90;
			
			Tweener.removeTweens(this);
			
			Tweener.addTween(this,{rotation:rotation+90,time:0.3,transition:"easeoutquad",
				onUpdate:function():void{
					game.engine.Engine.box2dRotateBody(box2dSlaveBodys[0],rotation/180*Math.PI);
				}});
			// box2d rotate
			// box2d slave rotate
		}
		
		public function ScaleState(arg:Number = -1):void
		{
			//mass += arg;
			
			Tweener.addTween(this,{mass:mass+arg,time:0.5,transition:"easeoutelastic",
				onComplete:function():void{
					game.engine.Engine.box2dSetPosition(border1.box2dbody,new Point(x,y)); 
					game.level.Level.engine.box2dLinkBody(border1.box2dbody,border2.box2dbody,-mass*0.8);
				}});
			// box2d link with new radius;
			
			// sound
			game.Game.sounds.play(game.Sounds.CIRCLE2);
		}
		
		override public function move():void
		{
			//this.view3dRotationY += 2;
			//this.view3dRotationZ += 2;	
		}
		
		// for editor:
		override public function takeIt(sb:SpaceBody):void
		{
			if(this.targets.indexOf(sb) == -1){
				this.targets.push(sb);
			}
		}
		
		private function dropCoins():void
		{
			var count:Number = 0;
			for(var i:uint = 0; i < this.targets.length;i++)
			{
				var item:SpaceBody = this.targets[i];
				if(!item.active && item is Crystal)
				{
					count ++;
					//item.y -= 50;
					var _mass:Number = item.mass; 
					item.mass = 0.2;
					item.active = true;
					Tweener.addTween(item,{y:item.y,mass:_mass,time:0.2+1*count,transition:"easeoutelastic"});
				}
			}
		}
	}
}