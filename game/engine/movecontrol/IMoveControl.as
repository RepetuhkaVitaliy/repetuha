package game.engine.movecontrol
{
	public interface IMoveControl
	{
		function get types():String;
		
		function update():void;
		
		function get rotate():Number;
	}
}