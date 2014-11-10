package game.level
{
	import com.repetuha.loaders.SendThenLoad;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.net.SharedObject;
	import flash.utils.Timer;
	
	import game.Achivements;
	import game.Game;
	import game.engine.Engine;
	import game.engine.bodys.CheckPoint;
	import game.engine.bodys.Crystal;
	import game.engine.bodys.SmokeParticle;
	import game.engine.bodys.SpaceBody;
	import game.engine.movecontrol.INitro;
	import game.engine.movecontrol.WasdNitroControl;
	import game.events.GameEvent;
	import game.garage.Shop;
	import game.gui.GameUI;
		
	public class LevelRezults extends EventDispatcher
	{
		private var engine:Engine;
		private var level:Level;
		
		public static var totalScore:Number = 0;
		private var _points:Number;
		public var stars:Number;
		
		public var maxLevelPoints:Number = 1;
		
		public var levelCoins:Number;
		public var maxLevelCoins:Number;
		
		public static var levelsPoints:Array = [];
		
		private var levelTime:Number = 0;
		public static var maxLevelTime:Number = 60;
		
		public static var timeLeft:Number = 0;
		
		private var mySharedObject:SharedObject;
		
		public function LevelRezults(_level:Level,_engine:Engine)
		{
			level = _level;
			engine = _engine;
		
			//createEmptyPointsArrayData();
		
			var tt:Timer = new Timer(1000,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,getShared);
		}
		
		private function getShared(e:TimerEvent):void
		{	
		     mySharedObject = SharedObject.getLocal("ThunderPlaneSave5");
			 
			if(!mySharedObject.data.myprogress){
				
			   createEmptyPointsArrayData();
			}
			else{
				parseProgress();
			}
		}		
		
		private function parseProgress():void
		{			
				
			levelsPoints = mySharedObject.data.myprogress;
			
			calculateTotalScore();
			
			game.Game.shop.budget = Number(mySharedObject.data.budget);
				
			game.Game.shop.parseSoldsArray(mySharedObject.data.solds);
			
			game.Game.levelNum = Number(mySharedObject.data.levelNum);
				
		}
		
		private function calculateTotalScore():void{
			var _totalPoints:Number = 0;
			for (var i:int = 0; i < levelsPoints.length; i++) 
			{
				_totalPoints += levelsPoints[i].points;
				
				if(levelsPoints[i].points > 0 && i <= 22)mySharedObject.data.levelNum = i+2;
			}
			
			totalScore = _totalPoints;	
		}
		
		public function set points(arg:Number):void
		{
			this._points = arg;
			if(this._points < 0)this._points = 0;
		}
		public function get points():Number
		{
			return this._points;
		}
		
		public function en(e:Event):void
		{
			levelTime++;
			if(levelTime > maxLevelTime*30){
				Level.engine.removeEventListener("tick", en);
				level.ship.die();
			}
			timeLeft = 100-Math.round(levelTime/maxLevelTime/30*100);
		}
		
		private function createEmptyPointsArrayData():void
		{
			for (var i:int = 0; i < game.level.LevelsData.levels.length; i++) 
			{
				levelsPoints.push({points:0,stars:0,maxLevelPoints:0,accuracy:0,fuel:0,nobump:0})	
			}
		}
		
		public function init():void
		{
			
			levelsPoints[game.Game.levelNum-1] = {points:0,stars:0,maxLevelPoints:0,accuracy:0,fuel:0,nobump:0};
			
			points = 0;
			stars = 0;
			levelTime = 0;
			
			levelCoins = 0;
			maxLevelCoins = 0;
			
			maxLevelPoints = this.getMaxLevelPoints();
			
			engine.addEventListener(GameEvent.BODY_DIE, getPoints);
			
			level.ship.addEventListener(GameEvent.BODY_DAMAGE, shipDamage);
			
			Level.engine.addEventListener("tick", en);
			
			game.Game.achivs.addAction(game.Achivements.ACTION_NEWLEVEL);
			
			send.send("http://repetuha.net/projects/tp/plays/session.php",["NAME",sessionId,"DATA",("START LEVEL! level="+(game.Game.levelNum)+", minute="+dd.minutes+", musicOn="+game.Game.sounds.musicEnable+", soundsOn="+game.Game.sounds.soundsEnable+"")]);
		}
		
		public function finish():void
		{
			calculateBonuses();
			
			calculateCoins();
			
			calculateTotalScore();
			
			if(game.gui.GameUI.level.ship.nobump && game.Game.levelNum >= 10)game.Game.achivs.unlockAchiv(game.Achivements.ACH_NOBUMP);
			
			engine.removeEventListener(GameEvent.BODY_DIE, getPoints);
			
			Level.engine.removeEventListener("tick", en);
			
			game.Game.achivs.addAction(game.Achivements.ACTION_ENDLEVEL);
			
			
			var tt:Timer = new Timer(2000,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
				
				send.send("http://repetuha.net/projects/tp/plays/session.php",["NAME",sessionId,"DATA",("FINISH LEVEL!  level="+(game.Game.levelNum-1)+", solds="+game.Game.shop.getSoldsArray()+", minute="+dd.minutes+", musicOn="+game.Game.sounds.musicEnable+", soundsOn="+game.Game.sounds.soundsEnable+"")]);
				
		      mySharedObject.data.myprogress = LevelRezults.levelsPoints;
			  mySharedObject.data.budget = game.Game.shop.budget;
			  mySharedObject.data.solds = game.Game.shop.getSoldsArray();
			  mySharedObject.flush();
			});
		}
		
		// php session
		private var dd:Date = new Date();
		private var sessionId:String = ""+dd.toString();
		private var send:SendThenLoad = new SendThenLoad();
		
		// php session.
		
		private function getPoints(e:Event):void
		{
			
			if(engine.lastDeadBody){
				if(engine.lastDeadBody is SmokeParticle)return;
				
				
				
				var price:Number = engine.lastDeadBody.price;
				if(price == 0)return;
				
				
				
				points += price;
				
				if(engine.lastDeadBody is CheckPoint)
				{
					if((game.gui.GameUI.level.ship.moveControl as INitro).nitroOn)
				    {
					  game.Game.achivs.addAction(game.Achivements.ACTION_KILL_SPEED);
				    }else{
				       if(price == 100)game.Game.achivs.addAction(game.Achivements.ACTION_KILL_100ACCURACY);
				       if(price != 100)game.Game.achivs.addAction(game.Achivements.ACTION_KILL);
					}
				  
				}
				
				if(engine.lastDeadBody is Crystal)
				{
				    game.Game.shop.budget += 1;
					levelCoins ++;
				}
				
				if(!levelsPoints[game.Game.levelNum-1])return;
				
				levelsPoints[game.Game.levelNum-1].points = points;
				levelsPoints[game.Game.levelNum-1].stars = Math.round(points/maxLevelPoints*3);// <60,<90, <100
				levelsPoints[game.Game.levelNum-1].maxLevelPoints = maxLevelPoints;
				levelsPoints[game.Game.levelNum-1].levelCoins = levelCoins;
				
				level.dispatchEvent(new Event(GameEvent.SCORE_UPDATE));
					
				if(engine.lastDeadBody is CheckPoint)
				{
				   level.showPlus(engine,price,engine.lastDeadBody.x+30,engine.lastDeadBody.y-50);
				}
			}
		}
		
		private function shipDamage(e:Event):void
		{
			points -= 20;
			level.showPlus(engine,-20,level.ship.x,level.ship.y);
		}
		
		private function getMaxLevelPoints():Number
		{
			var summ:Number = 0;
			
			for each(var sb:SpaceBody in engine.spaceBodys){
				if(sb is CheckPoint || sb is Crystal){
					summ += sb.price;
				}
				if(sb is Crystal){
				    maxLevelCoins ++;
				}
			}
			if(summ == 0)summ = 1;
			return summ;
		}
		
		
		private function calculateCoins():void
		{
		   if(game.Game.levelNum < 5)return;
				
		   if(levelCoins >= maxLevelCoins)game.Game.achivs.unlockAchiv(Achivements.ACH_ALLCOINS); 
		}
		
		private function calculateBonuses():void
		{
			// accuracy
			var summ:Number = 0;
			var count:Number = 0;
			for each(var sb:SpaceBody in engine.spaceBodys){
				if(sb is CheckPoint){
					summ += sb.price;
					count ++;
				}
			}
			
			var _accuracy:Number = Math.round(summ/count)*5;
			levelsPoints[game.Game.levelNum-1].accuracy = _accuracy;
			points +=  _accuracy;	
			
			// fuel
			var _fuel:Number = timeLeft*5;
			levelsPoints[game.Game.levelNum-1].fuel = _fuel;
			points  +=  _fuel;		
			
			// nobump
			var _nobump:Number = Number(level.ship.nobump)*500;
			levelsPoints[game.Game.levelNum-1].nobump = _nobump;
			points += _nobump;
			
			levelsPoints[game.Game.levelNum-1].points = points;
			
		}
	}
}