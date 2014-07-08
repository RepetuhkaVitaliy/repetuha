package com.repetuha.utils
{
	/* author: Repetukha Vitaliy */
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	public class ProgressDebug extends Sprite
	{
		public function ProgressDebug()
		{
			addEventListener(Event.ENTER_FRAME, en);
			alpha = 0;
		}
		
		public function show(name:String,percent:Number):void
		{
			// show
			alpha = 1;
			
			// add
			if(names.indexOf(name) == -1 && percent != 100){
				names.push(name);
				var tt:TextField = new TextField();
				addChild(tt);
				tt.width = 300;
				tt.text = name;
				fields.push(tt);
			}
			
			// remove
			if(names.indexOf(name) != -1 && Math.round(percent) == 100){
				var _name:String = ""+name;
				var id:Number = names.indexOf(_name);
				var timer:Timer = new Timer(300,1);
				timer.start();
				timer.addEventListener(TimerEvent.TIMER_COMPLETE, function():void{
				    
				    var _tt:TextField = fields[id];
				    if(_tt)removeChild(_tt);
					names.splice(id,1);
					fields.splice(id,1);
					
					graphics.clear();
					for(var i:uint = 0; i < names.length; i++){
						drawProgress(names[i],progress[i],i);
					}
				});
			}
			
			
			// draw
			graphics.clear();
			for(var i:uint = 0; i < names.length; i++){
				if(names[i] == name)progress[i] = percent;
				drawProgress(names[i],progress[i],i);
			}
				
		    // hide
			if(names.length == 0)alpha = 0;	
		}
		
		// PRIVATE
		private var names:Array = [];
		private var progress:Array = [];
		private var fields:Array = [];
		private function en(e:Event):void
		{
			//x = parent.mouseX+20;
			//y = parent.mouseY+20;
		}
		
		private function drawProgress(name:String,percent:Number,i:uint):void
		{
			// layer 100%
			graphics.lineStyle(10,0x00ccFF,0.25);
			graphics.moveTo(0,i*10);
			graphics.lineTo(100,i*10);
			
			// laye current %
			graphics.lineStyle(10,0x00ccFF,1);
			graphics.moveTo(0,i*10);
			graphics.lineTo(percent,i*10);
			
			// text
			fields[i].x = 110;
			fields[i].y = i*10-10;
		}
	}
}