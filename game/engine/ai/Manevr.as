package game.engine.ai
{
	import caurina.transitions.Tweener;
	
	import flash.geom.Point;
	
	import game.engine.Engine;
	import game.engine.bodys.Ship;
	import game.engine.bodys.SpaceBody;
	
	public class Manevr
	{
		public static var ROTATE_360X:String = "rotate_360X";
		public static var ROTATE_360Z:String = "rotate_360Z";
		public static var ROTATE_360Y:String = "rotate_360Y";
		
		public static var AVOID_RIGHT:String = "avoid_right";
		
		public static var AVOID_LEFT:String = "avoid_left";
		
		public static var LOOP_UP:String = "round_up";
		
		public static var LOOP_DOWN:String = "round_down";
		
		public static var CYLINDER:String = "cylinder";
		
		
		private static var SPEED_KOF:Number = 1;
		
		public function Manevr()
		{
		}
		
		public function play(typeName:String,sb:SpaceBody):void
		{
			
			switch(typeName)
			{
				//
				case ROTATE_360X:
				Tweener.removeTweens(sb);
				
				Tweener.addTween(sb,{rotation:360,time:1.5*SPEED_KOF,transition:"easeinoutquad",
					onComplete:function():void{
						sb.rotation = 0;
						Engine.box2dSetPosition(sb.box2dbody,new Point(sb.x,sb.y));
					}});
				break;
				
				case ROTATE_360Z:
				   //Tweener.removeTweens(sb);
				   
			       Tweener.addTween(sb,{view3dRotationZ:360,time:1.5*SPEED_KOF,transition:"easeinoutquad",
				   onComplete:function():void{
					   sb.view3dRotationZ = 0;
					   Engine.box2dSetPosition(sb.box2dbody,new Point(sb.x,sb.y));
				   }});
				break;
				
				
				case ROTATE_360Y:
					Tweener.removeTweens(sb);
					
					Tweener.addTween(sb,{view3dRotationY:360,time:1.5*SPEED_KOF,transition:"easeinoutquad",
						onComplete:function():void{
							sb.view3dRotationY = 0;
							Engine.box2dSetPosition(sb.box2dbody,new Point(sb.x,sb.y));
						}});
				break;
				
				// 
				case AVOID_RIGHT:
					Tweener.removeTweens(sb);
					
					Tweener.addTween(sb,{view3dZ:150,time:1*SPEED_KOF,transition:"easenone"});
					Tweener.addTween(sb,{view3dZ:0,delay:1*SPEED_KOF,time:1.5*SPEED_KOF,transition:"easenone"});
					
					Tweener.addTween(sb,{view3dRotationZ:-70,time:1*SPEED_KOF,transition:"easenone"});
					Tweener.addTween(sb,{view3dRotationZ:0,delay:1*SPEED_KOF,time:1.5*SPEED_KOF,transition:"easenone"});
						
					break;
				
				case AVOID_LEFT:
					Tweener.removeTweens(sb);
					
					Tweener.addTween(sb,{view3dZ:-150,time:1*SPEED_KOF,transition:"easenone"});
					Tweener.addTween(sb,{view3dZ:0,delay:1*SPEED_KOF,time:1.5*SPEED_KOF,transition:"easenone"});
					
					Tweener.addTween(sb,{view3dRotationZ:70,time:1*SPEED_KOF,transition:"easenone"});
					Tweener.addTween(sb,{view3dRotationZ:0,delay:1*SPEED_KOF,time:1.5*SPEED_KOF,transition:"easenone"});
					
					break;
				
				case LOOP_UP:
					//Tweener.removeTweens(sb);
					
					Tweener.addTween(sb,{rotation:sb.rotation-360,time:3*SPEED_KOF,transition:"easeoutquad",
						onComplete:function():void{
							//sb.rotation = 0;
					
							//Engine.box2dSetPosition(sb.box2dbody,new Point(sb.x,sb.y));
						}});
					
					break;
				
				case LOOP_DOWN:
					//Tweener.removeTweens(sb);
					
					Tweener.addTween(sb,{rotation:sb.rotation+360,time:1.5*SPEED_KOF,transition:"easeoutquad",
						onComplete:function():void{
							//sb.rotation = 0;
							//Engine.box2dSetPosition(sb.box2dbody,new Point(sb.x,sb.y));
						}});
					
					break;
				
				
				case CYLINDER:
					var cy_radius:Number = 20;
					var cy_loops:Number = 2;
					
					//Tweener.removeTweens(sb);
					var startX:Number = sb.x;
					var startY:Number = sb.y;
					var startZ:Number = sb.view3dZ;
					
					Tweener.addTween(sb,{view3dRotationZ:360*cy_loops,time:1*cy_loops*SPEED_KOF,transition:"easenone",
						onComplete:function():void{
							sb.view3dRotationZ = 0;
							//Engine.box2dSetPosition(sb.box2dbody,new Point(sb.x,sb.y));
						},
					    onUpdate:function():void{						  
							sb.y = startY+cy_radius*Math.cos(sb.view3dRotationZ/180*Math.PI);
							sb.view3dZ = cy_radius*Math.sin(sb.view3dRotationZ/180*Math.PI);
						}});
						
					break;
				
			}
		}
	}
}