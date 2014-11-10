package game.engine.bodys
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	import game.Game;
	import game.engine.movecontrol.INitro;
	import game.engine.movecontrol.UpDownNitroControl;
	import game.gui.GameUI;
	
	public class SmokeParticle extends SpaceBody
	{
		public function SmokeParticle()
		{
			super();
			this.mc = new MovieClip();
			//addChild(this.mc);
			
			this.v = new Point(0,0.2-0.2*Math.random());
			this.speed = 1;
			/* MOBILE 0.9; */ this.mass = 0.6+0.6*Math.random();
			
			this.collisionCrashBy = [];
			
			this.collisionTakeIt = [];
			
			this.box2dbody = null;
			
			//this.view3dModelName = game.gui.GameUI.level.ship.smokeName;
			if(game.gui.GameUI.level.ship.roketZapas != null)this.view3dModelName = "smoke1color"
			else this.view3dModelName = "smoke1white";
			
			if((game.gui.GameUI.level.ship.moveControl as INitro).nitroOn)this.view3dModelName = "smoke1nitro";
			
			if(game.gui.GameUI.level.ship.smokeName == "smoke1dark")this.view3dModelName = "smoke1dark";
			
			this.rotation = game.gui.GameUI.level.ship.rotation;//Math.round(20*Math.random());
			this.scaleX = 3;
			
			this.active = false;
		}
		
		
		private var liveTime:Number = 5*10;
		private var count:Number = 0;
		
		override public function move():void
		{
			super.move();
			count++;
			if(count >= liveTime)this.die();
			
			if(mass < 4)mass += 0.05;
			
			if(count >= liveTime/2)this.alpha -= 0.1;
			
			if(this.view3dModelName == "smoke1dark")this.x += 2-3*Math.random();
			//this.rotation += 5;
		}
	}
}
