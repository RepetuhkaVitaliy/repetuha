package game.engine.movecontrol
{
	public interface INitro
	{
		function get nitroOn():Boolean;
		function nitro(_self:Boolean,_speed:Number = 0,time:Number = 0):Boolean;
		function get self():Boolean;
	}
}