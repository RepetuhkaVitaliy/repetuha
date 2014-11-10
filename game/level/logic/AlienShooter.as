package game.level.logic
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	import game.engine.Engine;
	import game.engine.bodys.*;
	import game.events.GameEvent;
	import game.level.Level;
	
	import org.osmf.events.TimeEvent;

	public class AlienShooter extends LevelLogic
	{
		
		public function AlienShooter(_level:Level,_engine:Engine)
		{
			super(_level,_engine);
			
			engine.addEventListener(GameEvent.BODY_DIE, bodyDie);
		}
		
		// PUBLIC:
		public override function init():void
		{
			super.init();
			
			maxAsteroids = 0;
			maxAliens = 0;
		}

		public override function tick():void
		{
			checkBodysNum();	
		}
		
		// PRIVATE:
		private var maxAsteroids:Number;
		private var maxAliens:Number;
		
		private var pointsForAlien:Number = 5;
		private var pointsForBigAsteroid:Number = 2;
		private var pointsForSmallAsteroid:Number = 1;
		
		
		private function bodyDie(e:Event):void
		{
			if(engine.lastDeadBody is Alien){	
				
				upAliensNumbers();
				
				level.rezult.points += pointsForAlien;
				level.showPlus(level,pointsForAlien,engine.x+engine.lastDeadBody.x,engine.y+engine.lastDeadBody.y);
			}
			
			if(engine.lastDeadBody is Asteroid){	
				var ast:Asteroid = engine.lastDeadBody as Asteroid;
				if(ast.mass > 1){
					
					createGroupAliens(3,ast.mass/3,new Point(ast.x,ast.y));
					
					level.rezult.points += pointsForBigAsteroid;
					level.showPlus(level,pointsForBigAsteroid,engine.x+engine.lastDeadBody.x,engine.y+engine.lastDeadBody.y);
					
				}
				else
				{
					level.rezult.points += pointsForSmallAsteroid;
					level.showPlus(level,pointsForSmallAsteroid,engine.x+engine.lastDeadBody.x,engine.y+engine.lastDeadBody.y);
				}
			}
			
			level.dispatchEvent(new Event(GameEvent.BODY_DIE));
			
		}
		
		private function upAliensNumbers():void
		{
			var timer:Timer = new Timer(3000,1);
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE,function():void{
				maxAliens++;  
				timer = null;
			});
		}
		
		private function createGroupAliens(num:Number,mass:Number,xy:Point):void
		{
			
			for(var i:uint = 0; i < num; i++){
				
				var asteroid:Asteroid = new Asteroid();
				asteroid.mass = mass;
				engine.addBody(asteroid,new Point(xy.x,xy.y));					
			}
			
		}
				
		private function checkBodysNum():void
		{
			if(engine.spaceBodys.length < (maxAsteroids+maxAliens))
			{
				var asteroidsNum:Number = 0;
				var aliensNum:Number = 0;
				
				for(var i:uint = 0; i < engine.spaceBodys.length; i++)
				{
					if(engine.spaceBodys[i] is Asteroid)asteroidsNum++;
					if(engine.spaceBodys[i] is Alien)aliensNum++;
				}
				
				if(asteroidsNum < maxAsteroids){
					var asteroid:Asteroid = new Asteroid();
					engine.addBody(asteroid);
					
					// test static asteroids
					//asteroid.x = Game.GameWidth*Math.random();
					//asteroid.y = Game.GameHeight*Math.random();
					//asteroid.speed = 0.5;
				}
				
				if(aliensNum < maxAliens){
					var alien:Alien = new Alien();
					engine.addBody(alien);
					var a:Number = (360*Math.random())/90*Math.PI;
					var r:Number = 100+100*Math.random();
					var t:SpaceBody = new SpaceBody();
					t.x = level.earth.x+r*Math.sin(a);
					t.y = level.earth.y+r*Math.cos(a);
					
					alien.targets.push(t);
				}
			}
		}
		
	}
}