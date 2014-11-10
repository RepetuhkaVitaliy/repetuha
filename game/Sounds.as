package game
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;

	public class Sounds
	{
		public static var BUTTON_OVER:String = "BUTTON_OVER";
		[Embed(source='../../sounds/button_over.mp3')]
		private const button_over_Sound:Class;
		private var button_over:Sound = new button_over_Sound();
		private var button_over_ch:SoundChannel = new SoundChannel();
		private var button_over_obj:Object = {name:BUTTON_OVER,snd:button_over,chn:button_over_ch};
		
		public static var BUTTON_CLICK:String = "BUTTON_CLICK";
		[Embed(source='../../sounds/button_click.mp3')]
		private const button_click_Sound:Class;
		private var button_click:Sound = new button_click_Sound();
		private var button_click_ch:SoundChannel = new SoundChannel();
		private var button_click_obj:Object = {name:BUTTON_CLICK,snd:button_click,chn:button_click_ch};
		
		public static var COMPLETE:String = "COMPLETE";
		[Embed(source='../../sounds/complete.mp3')]
		private const complete_Sound:Class;
		private var complete:Sound = new complete_Sound();
		private var complete_ch:SoundChannel = new SoundChannel();
		private var complete_obj:Object = {name:COMPLETE,snd:complete,chn:complete_ch};
		
		public static var FAIL:String = "FAIL";
		[Embed(source='../../sounds/fail.mp3')]
		private const fail_Sound:Class;
		private var fail:Sound = new fail_Sound();
		private var fail_ch:SoundChannel = new SoundChannel();
		private var fail_obj:Object = {name:FAIL,snd:fail,chn:fail_ch};
		
		public static var COIN:String = "COIN";
		[Embed(source='../../sounds/coin.mp3')]
		private const coin_Sound:Class;
		private var coin:Sound = new coin_Sound();
		private var coin_ch:SoundChannel = new SoundChannel();
		private var coin_obj:Object = {name:COIN,snd:coin,chn:coin_ch};
		
		public static var CIRCLE:String = "CIRCLE";
		[Embed(source='../../sounds/circle.mp3')]
		private const circle_Sound:Class;
		private var circle:Sound = new circle_Sound();
		private var circle_ch:SoundChannel = new SoundChannel();
		private var circle_obj:Object = {name:CIRCLE,snd:circle,chn:circle_ch};
		
		public static var CIRCLE2:String = "CIRCLE2";
		[Embed(source='../../sounds/circle2.mp3')]
		private const circle2_Sound:Class;
		private var circle2:Sound = new circle2_Sound();
		private var circle2_ch:SoundChannel = new SoundChannel();
		private var circle2_obj:Object = {name:CIRCLE2,snd:circle2,chn:circle2_ch};
		
		public static var WRONG1:String = "WRONG1";
		[Embed(source='../../sounds/wrong1.mp3')]
		private const wrong1_Sound:Class;
		private var wrong1:Sound = new wrong1_Sound();
		private var wrong1_ch:SoundChannel = new SoundChannel();
		private var wrong1_obj:Object = {name:WRONG1,snd:wrong1,chn:wrong1_ch};
		
		public static var PLANEDOWN:String = "PLANEDOWN";
		[Embed(source='../../sounds/planedown.mp3')]
		private const planedown_Sound:Class;
		private var planedown:Sound = new planedown_Sound();
		private var planedown_ch:SoundChannel = new SoundChannel();
		private var planedown_obj:Object = {name:PLANEDOWN,snd:planedown,chn:planedown_ch};
		
		public static var BUMP1:String = "BUMP1";
		[Embed(source='../../sounds/BUMP1.mp3')]
		private const bump1_Sound:Class;
		private var bump1:Sound = new bump1_Sound();
		private var bump1_ch:SoundChannel = new SoundChannel();
		private var bump1_obj:Object = {name:BUMP1,snd:bump1,chn:bump1_ch};
		
		public static var PROPELLER:String = "PROPELLER";
		[Embed(source='../../sounds/propeller_loop.mp3')]
		private const propeller_Sound:Class;
		private var propeller:Sound = new propeller_Sound();
		private var propeller_ch:SoundChannel = new SoundChannel();
		private var propeller_obj:Object = {name:PROPELLER,snd:propeller,chn:propeller_ch};
		
		
		public static var MENU_MUSIC:String = "MENU_MUSIC";
		[Embed(source='../../sounds/rock2.mp3')]
		private const menu_Sound:Class;
		private var menu:Sound = new menu_Sound();
		private var menu_ch:SoundChannel = new SoundChannel();
		private var menu_obj:Object = {name:MENU_MUSIC,snd:menu,chn:menu_ch};
		
		private var array:Array = [bump1_obj,planedown_obj,wrong1_obj,button_over_obj,button_click_obj,propeller_obj,complete_obj,fail_obj,coin_obj,circle_obj,circle2_obj];
		
		private var soundsVolume:SoundTransform = new SoundTransform();
		private var musicVolume:SoundTransform = new SoundTransform();
		
		public var musicEnable:Boolean = true;
		public var soundsEnable:Boolean = true;
		
		public function Sounds()
		{
			menu_obj.chn = menu_obj.snd.play(0,3000);
		}
		
		public function play(name:String,delay:Number = 10):void
		{
			if(!soundsEnable)return;
			
			var obj:Object = null;
			for (var i:int = 0; i < array.length; i++) 
			{
				if(name == array[i].name)obj = array[i];
			}
			
			if(obj == null)return;
			
			if(soundsVolume.volume == 0)return;
			
			var tt:Timer = new Timer(delay,1);
			tt.start();
			tt.addEventListener(TimerEvent.TIMER_COMPLETE,function():void
			{
			    // play
			    obj.chn = obj.snd.play();
			    obj.chn.soundTransform = soundsVolume;
			});
		}
		
		public function soundsOff():void
		{
			for (var i:int = 0; i < array.length; i++) 
			{
				var obj:Object = array[i];
				
				// reset volume
				soundsVolume.volume = 0;
				obj.chn.soundTransform = soundsVolume;
			}
		}
		
		public function soundsOn():void
		{
			if(!soundsEnable)return;
			
			for (var i:int = 0; i < array.length; i++) 
			{
				var obj:Object = array[i];
				
				// reset volume
				soundsVolume.volume = 1;
				obj.chn.soundTransform = soundsVolume;
			}
		}
		
		public function musicOff():void
		{
			var obj:Object = menu_obj;
			// reset volume
			musicVolume.volume = 0;			
			
			obj.chn.soundTransform = musicVolume;
		}
		
		public function musicOn(v:Number = 1):void
		{
			if(!musicEnable)return;
			
			var obj:Object = menu_obj;
			// reset volume
			musicVolume.volume = v;
			obj.chn.soundTransform = musicVolume;
		}
		
		public function propellerOff():void
		{
			// reset volume
			
			propeller_obj.chn.stop();
		}
		
		public function propellerOn():void
		{
			if(!soundsEnable)return;
			
			propeller_obj.chn.stop();
			
			propeller_obj.chn = propeller_obj.snd.play(0,10000);
			
			propeller_obj.chn.soundTransform = soundsVolume;
		}
		
		public function addButton(item:DisplayObject):void
		{
			if(!item)return;
			item.addEventListener(MouseEvent.CLICK,function():void
			{
				play(Sounds.BUTTON_CLICK);
			});
			
			item.addEventListener(MouseEvent.MOUSE_OVER,function():void
			{
				//play(Sounds.BUTTON_OVER);
			});
		}
	}
}