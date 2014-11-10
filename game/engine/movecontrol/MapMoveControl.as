package game.engine.movecontrol
{	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class MapMoveControl
	{
		public static var lookAtHero:Boolean = true;
		
		public static var cameraPoint:Point = new Point(0,0)
		
		public static function mapMoveByHero(map:DisplayObject,map_width:Number,map_height:Number,hero:DisplayObject,screenWidth:Number,screenHeight:Number):void
		{
			// map move
				map.x = -hero.x+screenWidth/2;
				map.y = -hero.y+screenHeight/2;
				
				lookAtHero = true;
				
				if(map.x < -map_width+screenWidth){map.x = -map_width+screenWidth; lookAtHero = false;}
				if(map.x > 0){map.x = 0; lookAtHero = false;}
				
				if(map.y < -map_height+screenHeight){map.y = -map_height+screenHeight; lookAtHero = false;}
				if(map.y > 0){map.y = 0; lookAtHero = false;}
				
				cameraPoint.x = screenWidth/2-map.x;
				cameraPoint.y = screenHeight/2-map.y;
		}
	}
}