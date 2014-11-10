package game.engine.bodys
{
	// COMMENTS IN THIS CLASS VERY IMPORTANT!
	// Because it is powerfull way to use this class in absolutly different mehanics:
	// this class can be - spaceship, airplane, car, hero ...
	
	import caurina.transitions.Tweener;
	
	import com.repetuha.Utils;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.Game;
	import game.Sounds;
	import game.engine.Engine;
	import game.engine.ai.Manevr;
	import game.engine.movecontrol.*;
	import game.engine.types.FIRE_TYPE;
	import game.events.GameEvent;
	import game.level.Level;
	import game.level.LevelRezults;
	
	public class Ship extends SpaceBody
	{
		public static var ADD_SMOKE:String = "add_smoke";
		
		// private options
		/* MOBILE*/ 	public var maxSpeed:Number = 1.4 // 1.25
		
		// control
		public var moveControl:IMoveControl;
		private var moveControlEnable:Boolean = false;
		
		private var manevr:Manevr = new Manevr();
		
		public var motorEnable:Boolean = true;
		
		//smoke
		public var smokeName:String = "smoke1";
		private var smoke:Boolean = false;
		private var smokeDel:Number = 4;
		private var smokeTimer:Number = 0;
		
		//
		public var nobump:Boolean = true;
		
		// 
		public var fireType:String;	
		
		// fire
		public var fireEnable:Boolean = false;
		
		// laser
		public var laserEnable:Boolean = false;
		
		// roket
		public var roketEnable:Boolean = false;
		public var roketZapas:SpaceBody = null;
		public var roketDelPerFire:Number = 20;
		
		//	nitro	
		public var nitroEnable:Boolean = false;
		public var nitroPercent:Number = 1;
		public var nitroZapasStart:Number = 100;
		public var nitroZapas:Number = nitroZapasStart;
		private var nitroDelPerFrame:Number = 0.2;
		
		// magint
		public var magnitEnable:Boolean = false;
		public var magnitZapas:SpaceBody = null;
		public var magnitDelPerFrame:Number = 100/10/33;
		public var magnitRadius:Number = 80;
		
		
		public function Ship()
		{
			// view
			this.mc = new swc_ship()
			addChild(this.mc);
			
			mc.force_left.visible = false;
			mc.force_right.visible = false;
			
			// model
			configBody();
			
			this.collisionTakeIt = [CheckPoint,SpeedUp,Crystal,Bomb1,ActionArea1,RoketPoint,MagnitPoint];
		
			this.collisionCrashBy.push(Lopast);
			this.collisionCrashBy.push(Vitryak);
			this.collisionCrashBy.push(Tower1);
			this.collisionCrashBy.push(Stone1);
			this.collisionCrashBy.push(Windmill1);
			this.collisionCrashBy.push(Stovp);			
				
			//this.collisionCrashBy.push(Bullet,Alien,Asteroid);  
			
			this.view3dModelName = "airplane2";
			
			this.active = true;
			
			this.createPolygon();
			
			this.addEventListener(Event.ADDED_TO_STAGE,addToStage);
		}
		
		private function configBody():void
		{
			this.v = new Point(1,1);
			this.speed = maxSpeed;
			this.mass = 0.55;
			this.freeFly = false;
			this.rotation = 0;
			
			this.nobump = true;
		}
		
		private function addToStage(e:Event):void
		{	
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUp);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown,false,0,true);
			//stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownFire);
		}
		
		public function setControl():void
		{
			//moveControl = new MouseControl(this,50);
			//moveControl = new MouseControl(this,80,new Point(x,y));
			//moveControl = new MouseControlNitro(stage,this,0.05,50);
		    //moveControl = new WasdNitroControl(stage,this,maxSpeed,"todo:style",7);
			moveControl = new UpDownNitroControl(stage,this,maxSpeed,"todo:style",3.5);//2.8
		}
		
		public override function move():void
		{
			//
			if(smoke && motorEnable){
				smokeTimer ++;
				if(smokeTimer >= smokeDel){
					smokeTimer = 0;
					dispatchEvent(new Event(Ship.ADD_SMOKE));
				}
			}
			
			//
			if((moveControl as INitro).nitroOn)nitroTick();
			
			//
			roketTimer ++;
			
			//
			if(magnitEnable)magnitCoinsTick();
			
			//
			if(!motorEnable)freeDownTick();
			
			//
		    if(moveControlEnable == false)return;
			
			var _x:Number = x;
			var _y:Number = y;
			
			//moveControl.update();
	        
			/// convert mouseControl - x,y to - v.x,v.y
			if(moveControl.types.indexOf("mouse") != -1){
			   v.x = (x-_x)/7;  v.y = (y-_y)/7;
			   x = _x; y = _y; speed = speed;
			}
			
			//super.move();
			
			//-------------------------Mouse Control Fly--------------
			// by mouse - 
			var angle:Number = Math.atan2(parent.mouseY-y,parent.mouseX-x)/Math.PI*180;
			
			// keep rotation positive, between 0 and 360 degrees
			if (angle > rotation + 180) angle -= 360;
			if (angle < rotation - 180) angle += 360;
			var delR:Number = angle-rotation; 
			rotation += (delR)/15;
			
			v = new Point(Math.cos((rotation)/180*Math.PI),Math.sin((rotation)/180*Math.PI));
			
			if((moveControl as INitro).nitroOn){
			      moveControl.update();
			}
			
			//-------------------------Mouse Control Fly--------------
					
			//if(moveControl.rotate != 0){
			if(Math.abs(delR) > 45){
				//if(speed < maxSpeed*1.1)speed += 0.1;
				if(this.view3dRotationZ < 20)this.view3dRotationZ += 2;// for airplane - wing down
			}
			else{
				if(speed > maxSpeed)speed -= 0.05;
				//if(speed < maxSpeed)speed = maxSpeed;
				
				if(this.view3dRotationZ >= 4)this.view3dRotationZ -= 2;// for airplane - wing up
				
				if(this.view3dRotationZ < 4){
					this.view3dRotationZ = 3*Math.sin(x/30);
				}
			}
			
			
			
			//if((moveControl as WasdControl).rotationSpeed != 0){
			  /* BOX2D */	if(box2dbody)game.engine.Engine.box2dRotateBody(box2dbody,rotation/180*Math.PI);
			//}
		     /* BOX2D */	if(box2dbody)game.engine.Engine.box2dMoveBody(box2dbody,new Point(v.x*speed,v.y*speed));
			 
			 /* BOX2D */	//if(box2dbody)game.engine.Engine.box2dSetPosition(box2dbody,new Point(x,y));
		}
		
		public function nitro(_speed:Number,time:Number,_rotation:Number = NaN):Boolean
		{
			if(moveControl.types.indexOf("nitro") == -1)return false;
			   
			   if(String(_rotation) != "NaN"){
				   rotation = _rotation;
				   //v = new Point(Math.cos((rotation)/180*Math.PI),Math.sin((rotation)/180*Math.PI));
			   }
			
			 return (moveControl as INitro).nitro(false,1.4*2.5,time);
		}
		
		public function nitroTick():void
		{
			if((moveControl as INitro).self == false)return;
			
		    nitroZapas -= nitroDelPerFrame;
			if(nitroZapas < 0)nitroZapas = 0;
			nitroPercent = nitroZapas/nitroZapasStart;
		}
		
		public override function die(by:SpaceBody = null):void
		{
			Core.u.write("ship die","ff0000");
			
			//if(by is Stone1){this.ouch(by);return;}
			
			if(by is Stovp){this.ouch(by);return;}
			
			if(isDead)return;
			
			this.isDead = true;
			this.active = false;
			this.moveControlEnable = false;
			
			dispatchEvent(new Event(GameEvent.PLAYER_DIE));
			
			dieAnimation();
			
			// sound
			game.Game.sounds.propellerOff();
			if(by != null)game.Game.sounds.play(game.Sounds.BUMP1);
		}
		public function win():void
		{
			if(isDead || !active)return;
			
			Core.u.write("ship win","00ff00");
			this.isDead = true;
			this.active = false;
			this.moveControlEnable = false;
			this.animationState = true;
			
			Level.engine.removeBox2dBodys(this);
			
			winAnimation();
			
			// sound
			game.Game.sounds.propellerOff();
		}
		
		public function startAnimation():void
		{
			this.view3dZ = 120;
			
			Tweener.addTween(this,{view3dZ:0,time:1.5,transition:"easeoutquad"});
			
			this.view3dRotationZ = 360;
			Tweener.addTween(this,{view3dRotationZ:0,time:1.5,transition:"easeoutquad"});
			
			//this.view3dRotationY = -30;
			//Tweener.addTween(this,{view3dRotationY:0,transition:"easenone"});
		}
		public function winAnimation():void
		{
		   var _type:Number = Math.round(1+8*Math.random());
		   
		   if(_type > 8)_type = 8;
		   
		   if(game.Game.levelNum == 1)_type = 1;
		   if(game.Game.levelNum == 3)_type = 2;
		   if(game.Game.levelNum == 6)_type = 3;
		   if(game.Game.levelNum == 9)_type = 4;
		   if(game.Game.levelNum == 12)_type = 5;
		   if(game.Game.levelNum == 15)_type = 6;
		   if(game.Game.levelNum == 18)_type = 7;
		   if(game.Game.levelNum == 21)_type = 8;
		   
		   if(game.Game.levelNum == 24){ gameCompleteAnimation(); return;}
		  
		   
		   if(this.v.x <= 0)_type = 1;
		   
		  // _type = 7;
		   
		   //
		   if(_type == 1){
	 	     Tweener.removeTweens(this);
		     Tweener.addTween(this,{rotation:Math.round(rotation/180)*180,time:0.3,transition:"easenone"});
		     Tweener.addTween(this,{x:this.x+700*Math.abs(this.v.x)/this.v.x,time:3,transition:"easenone"});
		     manevr.play(Manevr.ROTATE_360Z,this);
		   }
		   
		   //
		   if(_type == 2){
		     Tweener.removeTweens(this);
		     Tweener.addTween(this,{view3dRotationZ:90,time:1,transition:"easenone"});
		     Tweener.addTween(this,{x:this.x+100,time:1,transition:"easeoutquad"});
		     Tweener.addTween(this,{x:this.x-700*Math.abs(this.v.x)/this.v.x,time:3,delay:1,transition:"easeinquad"});
		     Tweener.addTween(this,{rotation:-180,time:2,transition:"easenone"});
			 Tweener.addTween(this,{view3dZ:300,time:2,transition:"easenone"});
		   }
		   
		   //
		   if(_type == 3){
			   Tweener.removeTweens(this);
			   Tweener.addTween(this,{view3dRotationZ:-90,time:1,transition:"easenone"});
			   Tweener.addTween(this,{x:this.x+100,time:1,transition:"easeoutquad"});
			   Tweener.addTween(this,{y:this.y+30,time:2,transition:"easeinoutquad"});
			   Tweener.addTween(this,{x:this.x-700*Math.abs(this.v.x)/this.v.x,time:3,delay:1,transition:"easeinquad"});
			   Tweener.addTween(this,{rotation:180,time:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:300,time:2,transition:"easenone"});
		   }
		   
		   //
		   if(_type == 4){
			   Tweener.removeTweens(this);
			   Tweener.addTween(this,{view3dRotationZ:-89,time:1,transition:"easenone"});
			   Tweener.addTween(this,{x:this.x+100,time:1,transition:"easeoutquad"});
			   Tweener.addTween(this,{x:this.x-700*Math.abs(this.v.x)/this.v.x,time:3,delay:1,transition:"easeinquad"});
			   Tweener.addTween(this,{rotation:-180,time:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:-200,time:2,transition:"easenone"});
		   }
		   
		   //
		   if(_type == 5){
			   Tweener.removeTweens(this);
			   Tweener.addTween(this,{view3dRotationZ:-89,time:1,transition:"easenone"});
			   Tweener.addTween(this,{x:this.x+200,time:1.5,transition:"easeoutquad"});
			   Tweener.addTween(this,{y:this.y+30,time:2,transition:"easeinoutquad"});
			   Tweener.addTween(this,{x:this.x-700*Math.abs(this.v.x)/this.v.x,time:3,delay:1.5,transition:"easeinquad"});
			   Tweener.addTween(this,{rotation:180,time:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:300,time:2,transition:"easenone"});
			   
			   Tweener.addTween(this,{view3dRotationZ:360,time:2,delay:2,transition:"easeinoutquad"});
		   }
		   
		   //
		   if(_type == 6){
			   Tweener.removeTweens(this);
			   Tweener.addTween(this,{view3dRotationZ:-89,time:1,transition:"easenone"});
			   Tweener.addTween(this,{x:this.x+200,time:1.5,transition:"easeoutquad"});
			   Tweener.addTween(this,{x:this.x-700*Math.abs(this.v.x)/this.v.x,time:3,delay:1.5,transition:"easeinquad"});
			   Tweener.addTween(this,{rotation:-180,time:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:-200,time:2,transition:"easenone"});
			   
			   Tweener.addTween(this,{view3dRotationZ:360,time:2,delay:2,transition:"easeinoutquad"});
		   }
		   
		   
		   //
		   if(_type == 7){
			   Tweener.removeTweens(this);
			   Tweener.addTween(this,{view3dRotationZ:-89,time:1,transition:"easenone"});
			   Tweener.addTween(this,{x:this.x+50,time:1,transition:"easeoutquad"});
			   Tweener.addTween(this,{x:this.x,time:1,delay:1,transition:"easeinquad"});
			   Tweener.addTween(this,{x:this.x-100,time:1,delay:2,transition:"easeoutquad"});
			   Tweener.addTween(this,{x:this.x+700*Math.abs(this.v.x)/this.v.x,time:3,delay:3,transition:"easeinoutquad"});
			   Tweener.addTween(this,{rotation:180,time:2,transition:"easenone"});
			   Tweener.addTween(this,{rotation:360,time:2,delay:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:300,time:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:-300,time:2,delay:2,transition:"easenone"});
		   }
		   
		   //
		   if(_type == 8){
			   Tweener.removeTweens(this);
			   Tweener.addTween(this,{view3dRotationZ:-89,time:1,transition:"easenone"});
			   Tweener.addTween(this,{x:this.x+50,time:1,transition:"easeoutquad"});
			   Tweener.addTween(this,{x:this.x,time:1,delay:1,transition:"easeinquad"});
			   Tweener.addTween(this,{x:this.x-100,time:1,delay:2,transition:"easeoutquad"});
			   Tweener.addTween(this,{x:this.x+700*Math.abs(this.v.x)/this.v.x,time:3,delay:3,transition:"easeinquad"});
			   Tweener.addTween(this,{rotation:-180,time:2,transition:"easenone"});
			   Tweener.addTween(this,{rotation:-360,time:2,delay:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:-300,time:2,transition:"easenone"});
			   Tweener.addTween(this,{view3dZ:300,time:2,delay:2,transition:"easenone"});
		   }
		   
		}
		
		public function gameCompleteAnimation():void
		{
			this.isDead = true;
			this.active = false;
			this.moveControlEnable = false;
			this.animationState = true;
			
			//Level.engine.removeBox2dBodys(this);
			
			addEventListener(Event.ENTER_FRAME,_en);
		}
		private function _en(e:Event):void
		{
			removeEventListener(Event.ENTER_FRAME,_en);
			dispatchEvent(new Event("update"));
			
			Tweener.removeTweens(this);
			Tweener.addTween(this,{view3dRotationZ:90,time:1,transition:"easenone"});
			Tweener.addTween(this,{x:this.x+60*Math.abs(v.x)/(v.x+0.0001),time:0.6,transition:"easeoutquad"});			
			Tweener.addTween(this,{rotation:-90,time:2,transition:"easenone"});
			
			Tweener.addTween(this,{view3dRotationY:-620,time:3, delay:1,transition:"easeinoutquad"});
			
			Tweener.addTween(this,{view3dRotationZ:60,time:3, delay:5,transition:"easeinquad"});
			
			Tweener.addTween(this,{y:this.y-100,time:9,delay:2,transition:"easeinquad"});
			
			Tweener.addTween(this,{view3dZ:1000,time:11,transition:"easenone",onUpdate:function():void
			{
				dispatchEvent(new Event("update"));
			}
			});
		}
		
		public function dieAnimation():void
		{
			if(game.level.LevelRezults.timeLeft <= 0){
				this.smokeName = "";
				// sound
				game.Game.sounds.play(game.Sounds.PLANEDOWN);
				return;
			}
			
			var wheel:Wheel = new Wheel();wheel.mass = 0.5;
			var wheel2:Wheel = new Wheel();wheel2.mass = 0.3;
			var nojka:Nojka = new Nojka();
			
			game.level.Level.engine.addBody(wheel,new Point(x+35,y));
			game.level.Level.engine.addBody(wheel2,new Point(x-15,y));
			game.level.Level.engine.addBody(nojka,new Point(x-13,y));
			
			this.view3dModelName = ["airplane2_crash1","airplane2_crash2"][Math.round(Math.random())];
			
			this.smokeName = "smoke1dark";
			
			var tt:Timer = new Timer(2000,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,box2dKill);
			
			
			
		}
		
		private function box2dKill(e:Event):void
		{
			Level.engine.removeBox2dBodys(this);
		}
		
		public function reborn():void
		{
			Core.u.write("ship reborn","00ff00");
			
			configBody();
			
			/* BOX2D */	if(box2dbody != null && box2dbody != "createme")game.engine.Engine.box2dRotateBody(box2dbody,rotation/180*Math.PI);
			
			this.isDead = false;
			this.isReadyForHell = false;
			this.moveControlEnable = true;
			this.visible = true;
			this.health = 100;
			this.animationState = false;
			this.active = true;
			
			setControl();
			
			smoke = true;
			motorEnable = true;
			
			startAnimation();
			
			// sound
			game.Game.sounds.propellerOn();
		}
		
		public override function takeIt(sb:SpaceBody):void
		{
			
			if(!active || isDead)return;
			
			Core.u.write("takeIt = "+sb,"00FFFF");
			if(sb is CheckPoint){
				sb.die(); 
				if(sb is CheckPointDown)motorOff();
			}
			
		    if(sb is SpeedUp)(sb as SpeedUp).push(this);
			
			if(sb is Crystal)sb.die();
			
			if(sb is Bomb1)sb.die();
			
			if(sb is ActionArea1 && AkeyIsDown){ (sb as ActionArea1).push(this);}
			
			if(sb is RoketPoint){sb.die(); roketZapas = sb; };
			
			if(sb is MagnitPoint){sb.die(); magnitZapas = sb;}
		}
		
		public function ouch(sb:SpaceBody):void
		{
			if(active){
			  nobump = false;
			  manevr.play(Manevr.ROTATE_360Y,this);
			  health -= sb.damage;
			  
			  active = false;
			  var tt:Timer = new Timer(1000,1);
			  tt.start();
			  tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			  {
				  active = true;
			  });
			  
			  game.Game.sounds.play(game.Sounds.WRONG1);
			}
		}
		
		public override function set health(arg:Number):void
		{
			  super.health = arg;
			  dispatchEvent(new Event(GameEvent.BODY_DAMAGE));
		}
		
		private var motorOnTimerPercent:Number = 0;
		public function motorOff():void
		{
			motorEnable = false; 
			moveControlEnable = false;
			
			// sound
			game.Game.sounds.play(game.Sounds.PLANEDOWN);
			game.Game.sounds.propellerOff();
			
			var tt2:Timer = new Timer(300,10);
			tt2.start();
			tt2.addEventListener(TimerEvent.TIMER,function():void
			{
				motorOnTimerPercent = tt2.currentCount/10;
			});
			tt2.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
				motorEnable = true; 
				moveControlEnable = true;
				v.x = 0;
				v.y = 0;
				speed = 1;
				normalizeView3dRotY();
				
				game.Game.sounds.propellerOn();
			});
		}
		
		private var freeDownG:Number = 0.1;
		private function freeDownTick():void
		{
			super.move();
			
			moveControl.update();
			
			if(Math.abs(rotation) < 90 && (moveControl as IMoveControl).rotate == 0){
				// rotate to down
				this.rotation += 5//(moveControl as WasdControl).inertiaV*5;
			}
			
			// fall down
			v.y = 2.5;
			speed = maxSpeed+Math.abs(Math.sin(rotation/180*Math.PI))*1.5;// speed by rotation
			
			v.y += freeDownG;
			freeDownG += 0.005;
			
			/* BOX2D */	if(box2dbody)game.engine.Engine.box2dRotateBody(box2dbody,rotation/180*Math.PI);
			
			/* BOX2D */	if(box2dbody)game.engine.Engine.box2dSetPosition(box2dbody,new Point(x,y));
		}
		
		private function normalizeView3dRotY():void
		{
			//manevr.play(Manevr.ROTATE_360X,this);
			//Tweener.addTween(this,{view3dRotationY:0,time:1,transition:"easenone"});
		}
		
		// magnit
		private function magnitCoinsTick():void
		{
			if(magnitZapas == null)return;
			
			magnitZapas.health -= magnitDelPerFrame;
			if(magnitZapas.health <= 0){magnitZapas.die(); magnitZapas = null; }
			
			for each (var sb:SpaceBody in game.level.Level.engine.spaceBodys) 
			{
				if(sb is Crystal && !sb.isDead){
					
					var d:Number = game.level.Level.engine.distance2d(sb.x,sb.y,x,y);
					
					if(d < 30)
					{
						this.takeIt(sb);
					}
					
					if(d < magnitRadius)
					{
					  sb.x += 10*(this.x-sb.x)/Math.abs(this.x-sb.x)*d/60;
					  sb.y += 10*(this.y-sb.y)/Math.abs(this.y-sb.y)*d/60;
					}
				}
			}
		}
		
		
		
		// FIRE:
		private var AkeyIsDown:Boolean = false;
		
		  // bullet
		private function fire():void
		{
			if(!fireEnable)return;
			
			fireType = FIRE_TYPE.BULLET;
			dispatchEvent(new Event(GameEvent.PLAYER_FIRE));
		}
		
		  //roket
		public var roketTimer:Number = 0;
		public var roketResetTime:Number = 0.5*33;
		private function roketStart():void
		{
			if(this.roketZapas == null)return;
			
		    if(roketTimer > roketResetTime && roketEnable){
			  roketTimer = 0;
			  fireType = FIRE_TYPE.ROKET;
			  dispatchEvent(new Event(GameEvent.PLAYER_FIRE));
			  
			  this.roketZapas.health -= roketDelPerFire;
			  if(this.roketZapas.health <= 0){ roketZapas.die(); roketZapas = null; }
			}
		}
		
		// laser
		private function laserStart():void
		{
		   if(!laserEnable)return;
		   
		   fireType = FIRE_TYPE.LASER;
		   dispatchEvent(new Event(GameEvent.PLAYER_FIRE));
		}
		
		private function mouseDownFire(e:MouseEvent):void
		{
			fire();
		}
		private function keyUp(e:KeyboardEvent):void
		{
		     AkeyIsDown = false;
		}
		private function keyDown(e:KeyboardEvent):void
		{
			if(e.keyCode == 32)// space
			{
				fire();
			}
			
			if(e.keyCode == 88)// x
			{
				laserStart();
			}
			
			if(e.keyCode == 32)// space        //67)// c
			{
				roketStart();
			}
			
			if(e.keyCode == 32)// space       //65)// A
			{
				AkeyIsDown = true;
			}
		}
		
	}
}