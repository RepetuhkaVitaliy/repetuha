package game.engine.bodys
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import game.events.GameEvent;
	
	public class SpaceBody extends Sprite implements ISpaceBody
	{
		public var ID:String = "noid";
		// options
		public var v:Point;
		
		public var speed:Number;
		
		private var _active:Boolean = true;
		
		public var freeFly:Boolean = true;
		
		public var isDead:Boolean = false;
		
		public var isReadyForHell:Boolean = false;
		
		public var mc:MovieClip;
		
		public var collisionCrashBy:Array = [GroundBox];
		
		public var collisionTakeIt:Array = [];		
		
		public var scan_distance:Number = 0;// see radius
		
		public var targets:Vector.<SpaceBody> = new Vector.<SpaceBody>;
		
		public var animationState:Boolean = false;
		
		public var box2dbody:* = "createme";
		
		public var box2dSlaveBodysTypes:Array = [];
		public var box2dSlaveBodys:Array = [];
		
		// view3d
		public var view3dModelName:String = "";
		public var view3dRotationZ:Number = 0;
		public var view3dRotationY:Number = 0;
		public var view3dZ:Number = 0;
		public var view3deffect1:Boolean = false;
		
		//
		public var price:Number = 0;
		
		//some data
		public var data:Object = {};
		
		// subtype (3,2,1,A1,A2...).
		public var subtypeNum:Number = 1;
		
		// commands
		public function move():void
		{
			this.x += speed*v.x;
			this.y += speed*v.y;
		}
		
		public function die(murder:SpaceBody = null):void
		{
			//mc.gotoAndPlay("die");
			visible = false;
			isDead = true;
			isReadyForHell = true;
			
			dispatchEvent(new Event(GameEvent.BODY_DIE));
		}
		public function takeIt(sb:SpaceBody):void
		{
			sb.die();
		}
		
		private var _mass:Number;
		public function set mass(arg:Number):void
		{
			_mass = arg;
			mc.scaleX = mc.scaleY = arg;
		}
		
		public function get mass():Number
		{
			return _mass;
		}
		
		public function set active(arg:Boolean):void
		{
			this._active = arg;
		}
		
		public function get active():Boolean
		{
			return this._active;
		}
		
		// 
		public var damage:Number = 10;
		
		private var _health:Number = 100; 
		public function set health(arg:Number):void
		{
			this._health = arg;
			if(this._health < 0)this._health = 0;
		}
		
		public function get health():Number
		{
			return this._health;
		}
		
		
		// polygon
		internal var _polygon:Vector.<Point> = new Vector.<Point>;
		public function get polygon():Vector.<Point>
		{
			var polyScale:Vector.<Point> = new Vector.<Point>;
		
			
			for(var i:uint = 0; i < _polygon.length;i++)
			{
				polyScale.push(new Point(_polygon[i].x*_mass,_polygon[i].y*_mass));
			}
			
			if(polyScale.length == 0)return null;
			return polyScale;
		}
		
		internal function createPolygon():void
		{
			for(var i:uint = 0; i < this.mc.numChildren;i++)
			{
				var _item:MovieClip = this.mc.getChildAt(i) as MovieClip;
				if(_item is polypoint_mc){
					_polygon.push(new Point(_item.x,_item.y));
				}
			}
		}
	}
}