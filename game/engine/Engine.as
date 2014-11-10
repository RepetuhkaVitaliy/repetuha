package game.engine
{
	
	//----------------- BOX2D: -----------------------
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2MassData;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import Box2D.Common.Math.b2Vec2;
	import Box2D.Dynamics.Contacts.b2Contact;
	import Box2D.Dynamics.Joints.b2Joint;
	import Box2D.Dynamics.Joints.b2JointDef;
	import Box2D.Dynamics.Joints.b2JointEdge;
	import Box2D.Dynamics.Joints.b2PrismaticJointDef;
	import Box2D.Dynamics.Joints.b2RevoluteJoint;
	import Box2D.Dynamics.Joints.b2RevoluteJointDef;
	import Box2D.Dynamics.b2Body;
	import Box2D.Dynamics.b2BodyDef;
	import Box2D.Dynamics.b2DebugDraw;
	import Box2D.Dynamics.b2FixtureDef;
	import Box2D.Dynamics.b2World;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.engine.bodys.*;
	import game.engine.types.Box2dMasterBodysTypes;
	import game.engine.types.Box2dSlaveBodysTypes;
	import game.events.GameEvent;
	import game.gui.GameUI;
	
	public class Engine extends Sprite
	{
		public static var totalSpaceBodysCreated:Number = 0;
		
		public var spaceBodys:Vector.<SpaceBody> = new Vector.<SpaceBody>();
		
		public var lastDeadBody:SpaceBody;
		
		public var W:Number = 200;
		public var H:Number = 200;
		
		public var cont:Sprite = new Sprite();
		private var border:Number = 100;// outside screen space
		
		private var ZlayerDel:Number = 70;
		
		public function Engine()
		{
			super();
					
			box2dCreateWorld();
			
			addChild(cont);
			cont.visible = false;
		}
		
		private function en(e:Event = null):void
		{
			/* BOX2D */ box2dworld.Step(1 / 33, 3, 10);
			/* BOX2D */ //box2dworld.DrawDebugData();
			
			updateBodysPosition();
			
			checkCollisions();
			
			removeDeadElements();
			
			dispatchEvent(new Event("tick"));
		}
		
		// public
		public function start():void
		{
		    addEventListener(Event.ENTER_FRAME, en);
			cancelStopDelay();
		}
		
		public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, en);
			cancelStopDelay();
		}
		
		private var stopDelayTimer:Timer = new Timer(3000,1);
		public function stopDelay(_time:Number = 3):void
		{
			stopDelayTimer = new Timer(_time*1000,1);
			stopDelayTimer.start();
			stopDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,stopDelayTimerComplete);
		}
		public function cancelStopDelay():void
		{
			stopDelayTimer.stop();
			stopDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,stopDelayTimerComplete);
		}
		private function stopDelayTimerComplete(e:Event):void
		{
			stop();
		}
	
		public function addBody(sb:SpaceBody,p:Point = null):void
		{			
			cont.addChild(sb);
			spaceBodys.push(sb);
			
			totalSpaceBodysCreated++;
			sb.ID = sb.toString()+"_"+totalSpaceBodysCreated;
			
			sb.addEventListener(GameEvent.BODY_DIE,cryAboutDie);
			//if(!(sb is Bullet) && !(sb is Ship))placeBodyOutSide(sb);
			
			if(p){
			  sb.x = p.x;
			  sb.y = p.y;
			}
			if(sb.box2dbody == "createme"){
			  /* BOX2D */ sb.box2dbody = box2dCreateRectangleBody(sb.x,sb.y,sb.mc.hit.width*sb.mc.scaleX,sb.mc.hit.height*sb.mc.scaleY,sb.v,sb.speed,sb.mass,sb.rotation,sb.polygon);
			  //if(sb.box2dSlaveBodysTypes.length > 0)createSlaveBodys(sb);
			}
			
			
		}
		
		public function removeAllElements():void
		{
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var sb:SpaceBody =  spaceBodys[i];
				cont.removeChild(sb);
				sb.removeEventListener(GameEvent.BODY_DIE,cryAboutDie);
				removeBox2dBodys(sb);				
				
				sb = null;
			}
			
			spaceBodys = new Vector.<SpaceBody>();
		}
		
		public function killBodysOnRay(xy:Point,rad:Number):void
		{
			var ray:Sprite = new Sprite();
			cont.addChild(ray);ray.alpha = 1;
			
			ray.x = xy.x; ray.y = xy.y;
			ray.rotation = rad;
			
			ray.graphics.beginFill(0xffffff,0.3);
			ray.graphics.drawRect(0,-5,1000,10);
			ray.graphics.endFill();
			
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var sb:SpaceBody =  spaceBodys[i];
				if(!sb.isDead && !(sb is Ship)){
					if(ray.hitTestObject(sb.mc) == true){
					   sb.die();
					}
				}
			}
			
			//cont.removeChild(ray);
			//ray = null;
		}

		
		// private
		
		public function removeDeadElements():void
		{
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var sb:SpaceBody =  spaceBodys[i];
				
				if(sb.isReadyForHell){
					cont.removeChild(sb);
					sb.removeEventListener(GameEvent.BODY_DIE,cryAboutDie);
					spaceBodys.splice(i,1);
					removeBox2dBodys(sb);
					sb = null;
					i--;
				}
				
			}
		}
		
		private function cryAboutDie(e:Event):void
		{
			var sb:SpaceBody = e.target as SpaceBody;
			if(sb is SmokeParticle)return;
			
			lastDeadBody = sb;
			Core.u.write(sb);
	 	    dispatchEvent(new Event(GameEvent.BODY_DIE));
		}
		
		private function createSlaveBodys(sb:SpaceBody):void
		{
			if(!sb.box2dbody)return;
			
			for(var i:uint = 0; i < sb.box2dSlaveBodysTypes.length;i++)
			{
				var body_slave:b2Body = box2dCreateRectangleBody(sb.x,sb.y,10,10,new Point(0,0),Math.abs((i-1)*Box2dMasterBodysTypes.STATIC),1,sb.rotation); 
				
				sb.box2dSlaveBodys.push(body_slave);
				
				if(sb.box2dSlaveBodysTypes[i] == game.engine.types.Box2dSlaveBodysTypes.BORDER_LEFT){
					// link objects at left side
					box2dLinkBody(sb.box2dbody,body_slave,-3);
				}
				
				if(sb.box2dSlaveBodysTypes[i] == game.engine.types.Box2dSlaveBodysTypes.BORDER_RIGHT){
					// link objects at right side
					box2dLinkBody(sb.box2dbody,body_slave,3);
				}
			}
			
			if(sb.box2dSlaveBodysTypes[0] == game.engine.types.Box2dSlaveBodysTypes.BORDER_LEFT){
				if(sb.box2dSlaveBodysTypes[1] == game.engine.types.Box2dSlaveBodysTypes.BORDER_RIGHT){
			          box2dworld.DestroyBody(sb.box2dbody);
					  sb.box2dbody = null;
					  sb.v = new Point(0,0);
					  box2dLinkBody(sb.box2dSlaveBodys[0],sb.box2dSlaveBodys[1],-sb.mass*0.8);
				}
			}
		}
		
		public function removeBox2dBodys(sb:SpaceBody):void
		{
			// remove master
			/* BOX2D */   if(sb.box2dbody)box2dworld.DestroyBody(sb.box2dbody); sb.box2dbody = null;
			
			// remove slave
			for(var i:uint = 0; i < sb.box2dSlaveBodys.length;i++)
			{
				var sb_slave:b2Body = sb.box2dSlaveBodys[i];
				
				/* BOX2D */   if(sb_slave)box2dworld.DestroyBody(sb_slave); sb_slave = null;				
			}
			
			sb.box2dSlaveBodys = [];
		}
		
		private function placeBodyOutSide(sb:SpaceBody):void
		{
			
			if(sb is Bullet){
				sb.die(); 
				return;}
			
			if(Math.round(Math.random())){
			      // trace("pos body - vertical");
			      sb.x = -border+(W+border*2)*Math.random();
			      
				  if(Math.round(Math.random())){
				     // trace("pos body - up");
				     sb.y = -border;
			      }
				  else{
				    //	trace("pos body - down");		
					sb.y = H+border; 
				  }
			}
			else{
			      // trace("pos body - horizontal");
			      sb.y = -border+(H+border*2)*Math.random();
			      
			      if(Math.round(Math.random())){
				     // trace("pos body - left");
				     sb.x = -border;
			      }
				  else{
					 // trace("pos body - right");		
					 sb.x = W+border; 
				  }
			}
			
			/* BOX2D */ if(sb.box2dbody)sb.box2dbody.SetPosition(new b2Vec2(sb.x/box2dPM, sb.y/box2dPM));
		}
		
		private function updateBodysPosition():void
		{
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var sb:SpaceBody =  spaceBodys[i];
				
				if(sb.isReadyForHell != true){
					
	/* BOX2D */  if(sb.box2dbody){
							
							if(!sb.freeFly){
								   sb.move();
							}
							
							if(!sb.animationState){
						     /* BOX2D */  	sb.x = sb.box2dbody.GetPosition().x * box2dPM;
						     /* BOX2D */  	sb.y = sb.box2dbody.GetPosition().y * box2dPM;
						     /* BOX2D */  	sb.rotation = sb.box2dbody.GetAngle() * (180 / Math.PI); // radians to degrees		
							}
					}else{
						sb.move();	
					}
				}
				
				if(!sb.isDead){
					if(sb.x < -border || sb.x > W+border || sb.y < -border || sb.y > H+border){
						 sb.die(); //placeBodyOutSide(sb);
					}
				}
			}
		}
		
		//----------------- BOX2D: -----------------------
		private var box2dworld:b2World;
		private var box2dplayer:b2Body;
		private var debugDraw:b2DebugDraw;
		private var box2dPM:Number = 30;
		
		public function box2dCreateWorld():void
		{
			var gravity:b2Vec2 = new b2Vec2(0, 29.8);
			var sleep:Boolean = true;
			box2dworld = new b2World(gravity, sleep);
			
			//addEventListener(MouseEvent.CLICK, box2dStageClicked);
			initDebugDraw();
		}
		
		private function initDebugDraw():void
		{
			debugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(box2dPM);
			debugDraw.SetFillAlpha(.3);
			debugDraw.SetLineThickness(1.0);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit | b2DebugDraw.e_jointBit);
			box2dworld.SetDebugDraw(debugDraw);
		}
		
		private function box2dStageClicked(e:MouseEvent):void{
			 if(box2dplayer){	
				var impulse_x:Number = (mouseX / box2dPM - box2dplayer.GetPosition().x);
				var impulse_y:Number = (mouseY / box2dPM - box2dplayer.GetPosition().y);
				
				var impulse:b2Vec2 = new b2Vec2(impulse_x, impulse_y);
				impulse.Multiply( 2 / 3 );
				box2dplayer.ApplyImpulse(impulse, box2dplayer.GetPosition());
			 }
		}
		
		public static function box2dMoveBody(b:b2Body,v:Point):void
		{
			b.SetLinearVelocity(new b2Vec2(0,0));
			var impulse:b2Vec2 = new b2Vec2(v.x,v.y);
			impulse.Multiply( 2 / 3 );
			b.ApplyImpulse(impulse, b.GetPosition());
			//b.ApplyForce(impulse, b.GetPosition());
			//b.
			//b.SetLinearVelocity(new b2Vec2(v.x,v.y));
		}
		
		public static function box2dSetPosition(b:b2Body,xy:Point):void
		{
			b.SetLinearVelocity(new b2Vec2(0,0));
			b.SetPosition(new b2Vec2(xy.x/30, xy.y/30));// 30 = box2dPM
		}
		
		public static function box2dRotateBody(b:b2Body,a:Number):void
		{
			if(!b)return;
			
			b.SetAngularVelocity(0);
			//b.SetAngularVelocity(a);
			b.SetAngle(a);
			//b.ApplyForce(impulse, b.GetPosition());
			//b.
			//b.SetLinearVelocity(new b2Vec2(v.x,v.y));
		}
		
		public static function box2dEnableMotorBody(b:b2Body,a:Number):void
		{
			if(!b)return;
			
			b.SetAngularVelocity(a);
			//b.ApplyForce(impulse, b.GetPosition());
		}
		
		
		
		private function box2dCreateRectangleBody(_x:Number , _y:Number, _width:Number, _height:Number,v:Point,speed:Number,mass:Number,rotation:Number,_polygon:Vector.<Point> = null):b2Body
		{
			// Create body definition
			var bodyDef:b2BodyDef = new b2BodyDef();
			//bodyDef.userData = carSprite;
			bodyDef.type = b2Body.b2_dynamicBody;if(speed == Box2dMasterBodysTypes.STATIC)bodyDef.type = b2Body.b2_staticBody;
			bodyDef.position.Set(_x / box2dPM, _y / box2dPM);
			// Create body from world using bodyDef
			var body:b2Body = box2dworld.CreateBody(bodyDef);
			
			// Create shape
			var shape:b2PolygonShape = new b2PolygonShape();
			shape.SetAsBox(_width / 2 / box2dPM, _height / 2 / box2dPM);
			// muhi :) - shape.SetAsOrientedBox(_width / 2 / box2dPM, _height / 2 / box2dPM,new b2Vec2(v.x*speed,v.y*speed),45);
			
			//var shape:b2CircleShape = new b2CircleShape();
			//shape.SetRadius(_width / 2 / box2dPM);
			
			// if polygon
			if(_polygon != null && _polygon.length > 3)
			{
				var vertexArray:Array = [];	
				
				for(var i:uint = 0; i < _polygon.length;i++)
				{
					vertexArray.push(new b2Vec2( _polygon[i].x/ box2dPM, _polygon[i].y/ box2dPM));	
				}
				
				shape.SetAsArray(vertexArray,vertexArray.length);
			}
			
			
			// Create fixtureDef giving shape
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.shape       = shape;
			fixtureDef.restitution = 0.2/(mass);
			fixtureDef.friction    = 10;
			fixtureDef.density     = 0.5;
			
			// Pass the fixtureDef to the createFixture method in the body object
			body.CreateFixture(fixtureDef);
			
			if(speed != 0 && speed != Box2dMasterBodysTypes.STATIC){
			  var impulse:b2Vec2 = new b2Vec2(v.x*speed,v.y*speed);
			  impulse.Multiply( 2 / 3 );
			  body.ApplyImpulse(impulse, body.GetPosition());
			}
			
			body.SetAngle(rotation/180*Math.PI);		
			
			return body;
		}
		
		
		public function box2dLinkBody(body1:b2Body,body2:b2Body,localAnchorX:Number = -1,limit:Boolean = true):b2Joint
		{
			box2dClearJoints(body2);
			
			var linked:b2RevoluteJointDef = new b2RevoluteJointDef();
			linked.bodyA = body1;
			linked.bodyB = body2;
			
			linked.localAnchorA.Set(0,0);
			linked.localAnchorB.Set(localAnchorX,0);
			
			linked.collideConnected = false;
			if(limit){
			  linked.enableLimit = true;
			  linked.lowerAngle = -90/180*Math.PI;
			  linked.upperAngle =  -90/180*Math.PI;
			}
			box2dworld.CreateJoint(linked);
			return linked as b2Joint;
		}
		
		public function box2dRemoveLink(linked:b2Joint):void
		{
			box2dworld.DestroyJoint(linked);
		}
		
		public function box2dClearJoints(body2:b2Body):void
		{
		    var list:b2JointEdge = body2.GetJointList();
			
			if(list){
				box2dworld.DestroyJoint(list.joint);	
			}
		}
		
		public function box2dLinkBodyWithMotor(body1:b2Body,body2:b2Body,_angle:Number = 0):void
		{
			var linked:b2RevoluteJointDef  = new b2RevoluteJointDef();//b2RevoluteJointDef
			linked.bodyA = body1;
			linked.bodyB = body2;
			
			linked.localAnchorA.Set(0,0);
			linked.localAnchorB.Set(0,0);		
			
			linked.collideConnected = false;
			linked.enableMotor = true;
			linked.maxMotorTorque = 2000;
			linked.motorSpeed = 60 / 180*Math.PI;			
			
			//linked.enableLimit = true;
			//linked.lowerAngle = _angle/180*Math.PI;
			//linked.upperAngle =  _angle/180*Math.PI;			
			
			box2dworld.CreateJoint(linked);
		}
		
		public function box2dLinkBodyHard(body1:b2Body,body2:b2Body,_angle:Number = 0):void
		{
			body1.Merge(body2);
		}
		
		//----------------- BOX2D. -----------------------
		
		public function checkCollisions():void
		{				
			checkContactsInBox2d();
			
			//checkCollisionsByDistance();
			
			checkCollisionsByHitTest();
		}
		
		private function checkCollisionsByDistance():void
		{
			
		}
		
		private function checkCollisionsByHitTest():void
		{
			for(var j:uint = 0; j < spaceBodys.length; j++)
			{
                var sb:SpaceBody = spaceBodys[j];
				
				if((sb is Ship) || (sb is Roket))// for editor  || (sb is CheckPoint)
				{
					//var sb:SpaceBody = game.gui.GameUI.level.ship;
					
					//if(!sb.active)continue;
					
					for(var i:uint = 0; i < spaceBodys.length; i++)
					{
						var _sb:SpaceBody =  spaceBodys[i];
						
						if(_sb.active){
						
							if(_sb.box2dbody is b2Body && !(_sb is GroundBox) && !(_sb is Vitryak) && !(_sb is Lopast)){
								
								if(distance2d(_sb.x,_sb.y,game.gui.GameUI.level.ship.x,game.gui.GameUI.level.ship.y) > 800)(_sb.box2dbody as b2Body).SetActive(false)
								else (_sb.box2dbody as b2Body).SetActive(true);
							}
							
							if(distance2d(sb.x,sb.y,_sb.x,_sb.y) < 200){
							
								if(_sb.isDead != true && sb != _sb && _sb.active && onSameZlayer(sb,_sb)){
									
									checkForTakeByHitTest(sb,_sb);
								}
							}
						}
					}
				}
			}				
		}
		
		private function checkForTakeByHitTest(sb:SpaceBody,_sb:SpaceBody):void
		{
			for(var i:uint = 0; i < sb.collisionTakeIt.length; i++)
			{
			     if(_sb is sb.collisionTakeIt[i])
				 {
					var p:Point = cont.localToGlobal(new Point(sb.x,sb.y)); 
					p = _sb.mc.hit.globalToLocal(p);
					
					if(_sb is CheckPoint || _sb is CheckPointMaster || _sb is SpeedUp){// by line
						if(Math.abs(p.x) < 10 && Math.abs(p.y) <  _sb.mc.hit.height/2){
							_sb.price = Math.round(_sb.price/Math.round(Math.abs(p.y/3.5)+1)/20)*20;
							sb.takeIt(_sb);
						}
					}
					
					if(_sb is Crystal || _sb is Bomb1 || _sb is RoketPoint || _sb is MagnitPoint){// by distance
						
						if(checkCollide(_sb,sb,10)){
							sb.takeIt(_sb);
						}
					}
					
					if(_sb is ActionArea1){
						if(pointHitTestRect(p,new Point(-_sb.mc.hit.width/2,-_sb.mc.hit.height/2),new Point(_sb.mc.hit.width,_sb.mc.hit.height)))
						{
							sb.takeIt(_sb);	
							
							if(_sb is ActionArea1){
								_sb.takeIt(sb);
							}
						}
					}
				 }
			}
		}
		
		private function checkContactsInBox2d():void
		{
			var contact:b2Contact = box2dworld.GetContactList();
			
			if(!contact)return;
			
			if(!contact.IsTouching())return;
			var sb1_collided:SpaceBody = null;
			var sb2_collided:SpaceBody = null;
			
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var sb:SpaceBody = spaceBodys[i];
				
				if(!sb.isDead && sb.box2dbody != null && sb.active){
					
					if((sb.box2dbody as b2Body) == contact.GetFixtureA().GetBody()){
						
						sb1_collided = sb;
					}
					
					if((sb.box2dbody as b2Body) == contact.GetFixtureB().GetBody()){
						
						sb2_collided = sb;
					}
				}
			}
			
				if(sb1_collided && sb2_collided && onSameZlayer(sb1_collided,sb2_collided)){
									
					for(var cr:uint = 0; cr < sb1_collided.collisionCrashBy.length; cr++)
					{
						// crash
						if(sb2_collided is sb1_collided.collisionCrashBy[cr]){
							sb1_collided.die(sb2_collided);
							Core.u.write("die1 "+sb2_collided);
						}
						
						// take
						// now its released by hitTest
						/*if(sb2_collided is sb1_collided.collisionTakeIt[cr]){
							sb1_collided.takeIt(sb2_collided);
						}*/
					}
					
					for(var cr2:uint = 0; cr2 < sb2_collided.collisionCrashBy.length; cr2++)
					{
						// crash
						if(sb1_collided is sb2_collided.collisionCrashBy[cr2]){
							sb2_collided.die(sb1_collided);
							Core.u.write("die2");
						}
					}
				}
		}
		
		private function onSameZlayer(sb:SpaceBody,_sb:SpaceBody):Boolean
		{
			if(Math.abs(sb.view3dZ-_sb.view3dZ) < ZlayerDel)return true;
			
			return false;
		}
		
	/*
		private function checkCollisions():void
		{
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var sb:SpaceBody =  spaceBodys[i];
				
				if(sb.isDead != true && sb.speed != 0){
					
					var sb2:SpaceBody;// collided body
					
					switch(sb.collision_type){
						
						case COLLISION_TYPE.BOUNCE:
							sb2 = findCollidedBody(sb,0);
							if(sb2 && !(sb2 is Bullet)){
								if(sb is Ship && sb2 is Teleport)(sb2 as Teleport).teleportate(sb);
								if(sb is Ship && sb2 is SpeedUp)(sb2 as SpeedUp).push(sb);
								if(sb is Ship && sb2 is Shtuka)(sb as Ship).take(sb2);
								//if(sb2 is Ship)sb.die();
							}
						break;
						
						case COLLISION_TYPE.AVOID:
							sb2 = findCollidedBody(sb,sb.scan_distance);
							if(sb2){
								if(sb2 is Asteroid || sb2 is Alien){
								    avoidBody(sb,sb2);
								}
							}
						break;
						
						case COLLISION_TYPE.DESTROY:
							sb2 = findCollidedBody(sb,0);
							if(sb2 && sb2.collision_type == COLLISION_TYPE.STATIC)break;
							if(sb2 && !(sb2 is Ship) && !(sb2 is Earth) && !(sb2 is Teleport)){
								sb2.die();
							    sb.die();
								
								lastDeadBody = sb2;
								dispatchEvent(new Event(GameEvent.BODY_DIE));
							}
						break;
					}
				}
			}
		}
		*/
		
		private function findCollidedBody(sb:SpaceBody,distance:Number):SpaceBody
		{
			for(var i:uint = 0; i < spaceBodys.length; i++)
			{
				var _sb:SpaceBody =  spaceBodys[i];
				
				if(_sb.isDead != true && sb != _sb){
				   
				   if(checkCollide(sb,_sb,distance)){
					   return _sb;
				   }
				}
			}
			
			return null;
		}
		
		private function checkCollide(sb:SpaceBody,_sb:SpaceBody,distance:Number):Boolean
		{
			var d:Number = distance2d(sb.x,sb.y,_sb.x,_sb.y);
			if(d < 200){
					if(d < (sb.mc.hit.width/2*sb.mc.scaleX+_sb.mc.hit.width/2*_sb.mc.scaleX+distance)){
						return true;
					}
			}
			
			return false;
		}
			
		
		private function bounceBodys(sb:SpaceBody,sb2:SpaceBody):void
		{
			//return;
			//if(sb is Ship && sb2 is Meteor){
			
					var tempV:Point = new Point(sb.v.x,sb.v.y);
					 
					//-!-// sb2.v = new Point(sb2.v.x+sb.mass*sb.v.x,sb2.v.y+sb.mass*sb.v.x);// - avoid
					
					sb.v = new Point(sb2.v.x,sb2.v.y);
					sb2.v = new Point(tempV.x,tempV.y);
					
					//sb2.v = new Point((sb2.v.x+sb.v.x)/2,(sb2.v.y+sb.v.y)/2);// - avoid
					//sb.v = new Point(-(sb2.v.x+sb.v.x)/2,(sb2.v.y+sb.v.y)/2);// - avoid
					
					sb2.speed = sb.speed*1/sb2.mass;
					sb.speed = sb.speed*1/sb.mass;
					
					sb.move();
					sb2.move();
					
					while(checkCollide(sb,sb2,0)){
						sb.x += (sb.x-sb2.x)/Math.abs(sb.x-sb2.x);
						sb.y += (sb.y-sb2.y)/Math.abs(sb.y-sb2.y);
					}
					
			//}
		}
		
		private function avoidBody(sb:SpaceBody,sb2:SpaceBody):void
		{
			return;
			var tempV:Point = new Point(sb.v.x,sb.v.y);
			//sb.v = new Point(sb.v.x*(-sb2.v.x/Math.abs(sb2.v.x)),sb.v.y*(-sb2.v.y/Math.abs(sb2.v.y)));
			
			var avoidVx:Number = sb.scan_distance/Math.abs(sb.x-sb2.x);
			var avoidVy:Number = sb.scan_distance/Math.abs(sb.y-sb2.y);
			
			if(avoidVx < 0.5)avoidVx = 0.5;
			if(avoidVy < 0.5)avoidVy = 0.5;
			
			sb.x += (sb.x-sb2.x)/Math.abs(sb.x-sb2.x)*avoidVx;
			sb.y += (sb.y-sb2.y)/Math.abs(sb.y-sb2.y)*avoidVy;
			
			//sb.move();
		}

		
		// utils
		public function pointHitTestRect(point:Point, rectA:Point, rectB:Point):Boolean
		{
			return point.x-rectA.x > 0 && point.y-rectA.y > 0 && point.x-rectA.x < rectB.x-rectA.x && point.y-rectA.y < rectB.y-rectA.y;
		}
		
		public function distance2d(x1:Number, y1:Number,  x2:Number, y2:Number):Number
		{
				var dx:Number = x1-x2;
				var dy:Number = y1-y2;
				return Math.sqrt(dx * dx + dy * dy);
		}
	}
}