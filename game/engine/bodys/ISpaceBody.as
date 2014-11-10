package game.engine.bodys
{
	import flash.geom.Point;

	public interface ISpaceBody
	{
		function move():void;// or tick
	    function die(by:SpaceBody = null):void;
	    
	    function set mass(arg:Number):void;
	    function get mass():Number;
	}
}