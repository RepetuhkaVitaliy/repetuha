package game.engine.bodys
{
	import flash.geom.Point;
	
	import game.Game;
	import game.Sounds;
	
	public class Crystal extends SpaceBody
	{
		public function Crystal()
		{
			super();
			this.mc = new swc_crystal()
			addChild(this.mc);
			
			this.v = new Point(0,-1);
			this.speed = 3;
			this.mass = 3//0.6+0.6*Math.random();
				
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.box2dbody = null;
			
			this.view3dModelName = "coin1";
			
			this.view3dRotationY = Math.round(360*Math.random());
			
			this.price = 1;
		}
		
		override public function die(murder:SpaceBody = null):void
		{
			super.die(murder);
			
		   // sound
		   game.Game.sounds.play(game.Sounds.COIN);
		}
		override public function move():void
		{
			this.view3dRotationY += 5;
			//this.view3dRotationZ += 2;
		}
		
		override public function set active(arg:Boolean):void
		{
			super.active = arg;
			if(arg){
				this.view3dModelName = "coin1";
			}else{
				this.view3dModelName = "";	
			}
		}
	}
}