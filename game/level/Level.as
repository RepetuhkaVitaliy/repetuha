package game.level
{
	import away3d.containers.View3D;
	
	import com.repetuha.Utils;
	
	import flash.display.CapsStyle;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.Game;
	import game.engine.Engine;
	import game.engine.bodys.*;
	import game.engine.movecontrol.MapMoveControl;
	import game.engine.types.FIRE_TYPE;
	import game.events.GameEvent;
	import game.level.logic.AlienShooter;
	import game.level.logic.FlyCheckpoints;
	import game.level.logic.LevelLogic;
	
	import view3d.View3d;

	public class Level extends LevelView
	{
		public var view:View3d;
		
		public var started:Boolean = false;
		
		public static var widthSpace:Number = Game.GameWidth;
		public static var heightSpace:Number = Game.GameHeight;
		
		public static var engine:Engine = new Engine();
		
		public var levelsData:LevelsData = new LevelsData(); 
		
		public var rezult:LevelRezults;
		
		public var logic:LevelLogic;
		
		public var ship:Ship = new Ship();
		public var earth:Earth = new Earth();
		
		public var cursor:Teleport = new Teleport();
		private var cursorDot:Sprite = new Sprite();
		
		private var editor:LevelEditor = null;
		
		public function Level()
		{
			addChild(engine);
			
			logic = new FlyCheckpoints(this,engine);
			//logic = new AlienShooter(this,engine);
			
			rezult = new LevelRezults(this,engine);
			
			//
			addChild(cursorDot);
			cursorDot.mouseEnabled = false;
			cursorDot.graphics.beginFill(0xffffff,0.1);
			cursorDot.graphics.drawCircle(0,0,10);
			cursorDot.graphics.endFill();
			cursorDot.visible = false;
		}
		private function createPlayer():void
		{
			ship = new Ship()
			ship.addEventListener(GameEvent.PLAYER_FIRE, fire);
			ship.addEventListener(GameEvent.PLAYER_DIE, shipDie);
			ship.addEventListener("update", shipUpdate);
			ship.addEventListener(Ship.ADD_SMOKE,shipAddSmoke);
			
		    engine.addBody(ship,new Point(0,540));
		    ship.reborn();
			
			game.Game.shop.applyBuyItems();
		}
		
		private function destroyPlayer():void
		{
			if(ship){
				ship.removeEventListener(GameEvent.PLAYER_FIRE, fire);
				ship.removeEventListener(GameEvent.PLAYER_DIE, shipDie);
				ship.removeEventListener("update", shipUpdate);
				ship.removeEventListener(Ship.ADD_SMOKE,shipAddSmoke);
				ship = null;
			}
		}
		
		// ship events:
		private function shipDie(e:Event):void
		{
			faild();
		}
		private function shipUpdate(e:Event):void
		{
			mapUpdatePosition(); 
		}
		private function shipAddSmoke(e:Event):void
		{			
			var sm:SmokeParticle = new SmokeParticle();
			engine.addBody(sm,new Point(ship.x,ship.y));
			sm.view3dZ = ship.view3dZ;
			
			if(ship.smokeName == "smoke1dark"){ sm.v.y = -3;sm.v.x = 1;sm.rotation = -75;sm.mass = 0.6; }
		}
		
		// public methods
		public function init(num:uint):void
		{
			Core.u.write("level init");
			
			logic.init();

			destroyPlayer();
			
			engine.removeAllElements();
			
			createPlayer();
			
			engine.addBody(cursor);//cursor.visible = false;
			
		    levelsData.parseXML(this,game.level.LevelsData.levels[num-1]);
			
			addClouds();
			
			rezult.init();
		
			
			// add editor
			//editorOn();
			//tests();
		}
		
		public function start():void
		{
			engine.addEventListener("tick", en);
			engine.start();
			
			started = true;
			
			cursorDot.visible = true;
		}
		
		public function pause():void
		{
			/* MOBILE*/ engine.removeEventListener("tick", en)
			/* MOBILE*/ engine.stop();
			
			started = false;
			
			cursorDot.visible = false;
		}
		
		public function rezume():void
		{
			engine.addEventListener("tick", en)
			engine.start();
			
			started = true;
			
			cursorDot.visible = true;
		}		
			
		public function complete():void
		{
			started = false;
			
			ship.win();
			rezult.finish();
			/* MOBILE*/ if(game.Game.levelNum < 24)engine.stopDelay(7);
			engine.removeEventListener("tick", en)
			dispatchEvent(new Event(GameEvent.LEVEL_PASSED));
			
			this.graphics.clear();
			cursorDot.visible = false;
		}
		
		public function faild():void
		{			
			started = false;
			/* MOBILE*/ engine.stopDelay(5);
			engine.removeEventListener("tick", en)
			dispatchEvent(new Event(GameEvent.LEVEL_FAILD));
			
			this.graphics.clear();
			cursorDot.visible = false;
		}
		
		// PRIVATE methods:
		private function editorOn():void
		{
			if(editor != null)removeChild(editor);
			editor = new LevelEditor(this)
			addChild(editor);
			Level.engine.cont.visible = true;
			Level.engine.cont.alpha = 0.3;
		}
		private function en(e:Event):void
		{
			cursor.x = mouseX*widthSpace/Game.GameWidth;
			cursor.y = mouseY*heightSpace/Game.GameHeight;
			
			//cursor.x = ship.x+100;
			//cursor.y = ship.y;
			
			if(cursorDot.visible){
				this.graphics.clear();
				this.graphics.lineStyle(3,0xffffff,0.15,false,"normal",flash.display.CapsStyle.ROUND);
				var p:Point = ship.parent.localToGlobal(new Point(ship.x,ship.y));
				p = this.globalToLocal(p);
				this.graphics.moveTo(p.x,p.y);
				var dd:Number = com.repetuha.Utils.matchGet2Ddistance(p.x,p.y,mouseX,mouseY)
				this.graphics.curveTo(p.x+dd*0.5*Math.cos(ship.rotation/180*Math.PI),p.y+dd*0.5*Math.sin(ship.rotation/180*Math.PI),mouseX,mouseY);
				
				cursorDot.x = mouseX;
				cursorDot.y = mouseY;
			}
			
			mapUpdatePosition();
			
			logic.tick();
		}
		
		public function mapUpdatePosition():void
		{
			if(ship.isDead)return;
			game.engine.movecontrol.MapMoveControl.mapMoveByHero(engine,widthSpace,heightSpace,this.ship,Game.GameWidth/engine.scaleX,(Game.GameHeight)/engine.scaleY);
			
			fon.x = engine.x/2;
			fon.y = engine.y/2;
		}
		
		private function fire(e:Event):void
		{
			switch(ship.fireType){
				
				case FIRE_TYPE.BULLET:
					trace("BULLET !!!");
					var b:Bullet = new Bullet(new Point(Math.cos(ship.rotation/180*Math.PI),Math.sin(ship.rotation/180*Math.PI)));
					engine.addBody(b,new Point(ship.x+10*b.v.x,ship.y+10*b.v.y));
					
					break;
				
				case FIRE_TYPE.LASER:
					trace("LASER !!!");
					engine.killBodysOnRay(new Point(ship.x,ship.y),ship.rotation);
					
					break;
				
				case FIRE_TYPE.ROKET:
					trace("ROKET !!!");
					var r:Roket = new Roket(new Point(Math.cos(ship.rotation/180*Math.PI),Math.sin(ship.rotation/180*Math.PI)));
					engine.addBody(r,new Point(ship.x+15*Math.cos((ship.rotation+90)/180*Math.PI),ship.y+15*Math.sin((ship.rotation+90)/180*Math.PI)));/// under ship
					r.rotation = ship.rotation;
					break;
			}
		}
		
		// Clouds
		private function addClouds():void
		{
				for(var n:uint = 0; n < 4; n++)
				{	
					var body:Cloud1 = new Cloud1();
					
					var X:Number = widthSpace*Math.random();
					var Y:Number = (heightSpace-400)*Math.random();
					engine.addBody(body,new Point(X,Y));
				}	
		}
		
		// TESTS UTILS:
		private function tests():void
		{
			// test util
			placeBodys([[Meteor,20,"random"]]); 
			
			// temp test teleport pairs
			teleportsPairsLinkRandom();	
		}
		private function placeBodys(bodys:Array):void
		{
			for(var i:uint = 0; i < bodys.length; i++)
			{
				for(var n:uint = 0; n < bodys[i][1]; n++)
				{	
				    var body:SpaceBody = new bodys[i][0];
				
					if(bodys[i][2] == "random"){
						var X:Number = widthSpace*Math.random();
						var Y:Number = heightSpace*Math.random();
						engine.addBody(body,new Point(X,Y));
						
					}
				}
			}
		}
		private function teleportsPairsLinkRandom():void{
			
			var prewTeleport:Teleport = null;
			for(var i:uint = 0; i < engine.spaceBodys.length; i++)
			{
				if(engine.spaceBodys[i] is Teleport){
					
					if(prewTeleport){
						(engine.spaceBodys[i] as Teleport).pair = prewTeleport;
						prewTeleport.pair = (engine.spaceBodys[i] as Teleport);
						prewTeleport = null;
					}else{
						prewTeleport = (engine.spaceBodys[i] as Teleport);
					}
				}
			}
		}
		
	}
}
