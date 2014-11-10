package game.gui.screens
{
	import caurina.transitions.Tweener;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import game.Game;
	import game.events.GameUI_Event;
	
	public class ScreenSample extends Sprite
	{	
		private var nameField:swc_screenName = new swc_screenName();
		
		public function ScreenSample(screenName:String = "")
		{
			super();
			
			visible = false;
			
			//addChild(nameField);
			nameField.x = Game.GameWidth/2;
			nameField.field.text = screenName;
			nameField.mouseEnabled = nameField.mouseChildren = false;
		}
		
		public function show():void
		{
			//x = game.Game.GameWidth;
			//Tweener.addTween(this,{x:0,time:1,transition:"easeinoutquad"});
			
			visible = true;
			dispatchEvent(new Event(GameUI_Event.SHOW_SCREEN));
			
		}
		
		public function hide():void
		{
		
			//Tweener.addTween(this,{x:-game.Game.GameWidth,time:1,transition:"easeinoutquad",
			//onComplete:function():void{
				visible = false;
			///}});
			dispatchEvent(new Event(GameUI_Event.HIDE_SCREEN));
			
		}
	}
}