package com.repetuha
{
	/* author: Repetukha Vitaliy */
	
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
		
		public class VideoStream extends Sprite
		{
			public static var SEND_DONE:String = "send_done";
			public static var READY_TO_STREAM:String = "ready_to_stream";
			
			public var videoURL:String = "rtmp://localhost/oflaDemo";
			public var connection:NetConnection;
			public var stream:NetStream;
			
			public function VideoStream()
			{
				// constructor code
			}
			
			// PUBLIC:
			public var connectionReady:Boolean = false;
			public function initStream(url:String = null):void
			{
				videoURL = url;
				
				connection = new NetConnection();
				connection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				connection.client = new Client(); 
				connection.connect(videoURL, true);
				trace("STREAM - connect start!");
			}
			
			private var _camera:Camera = null;
			public function set camera(arg:Camera):void
			{
				_camera = arg;
			}
			private var _mic:Microphone = null;
			public function set mic(arg:Microphone):void
			{
				_mic = arg;
				
				//_mic.codec = "Speex";
				//_mic.enableVAD = true;
				_mic.setSilenceLevel(0.1);
			}
			
			public function startRecord(_NameFile:String):void
			{
				trace("STREAM - startRecord()");
				if(!connectionReady)return;
				
				NameFile = _NameFile;
				NameFilePlay = NameFile+".flv";
				
		        connectStreamToRecord();
			}
			public function stopRecord():void
			{
				if(!connection.connected)return;
				if(!stream)return;
				
				stream.attachCamera(null);
				stream.attachAudio(null);
				
				// on complete from server - stream.close(); and dispatch to play
				
				startCheckBufferComplete();
			}
			
			public function startPlay(buffer:Number = 0):void
			{
				if(!connectionReady)return;
				
				connectStreamToPlay(buffer);
			}
			
			public function stopPlay():void
			{
				if(!connectionReady)return;
				if(!stream)return;
				stream.close();
			}
			
			public function pausePlay():void
			{
				if(!connectionReady)return;
				if(!stream)return;
				stream.pause();
			}
			
			public function resumePlay():void
			{
				if(!connectionReady)return;
				if(!stream)return;
				stream.resume();
			}
	
			// PRIVATE:
			private function netStatusHandler(event:NetStatusEvent):void
			{
				trace("STREAM - netStatusHandler",event.info.code);
				switch (event.info.code)
				{
					case "NetConnection.Connect.Success":
						connectionReady = true; 
						dispatchEvent(new Event(READY_TO_STREAM));
						connection.call("checkBandwidth", null); 
						break;
					case "NetStream.Play.StreamNotFound":
						trace("STREAM -Stream not found: " + videoURL);
						break;
					case "NetStream.Play.Start":
						break;
				}
			}
			
			private function securityErrorHandler(event:SecurityErrorEvent):void
			{
				trace("STREAM -securityErrorHandler: " + event);
			}
			
			public var NameFile:String = "noname";
			public var NameFilePlay:String = "noname.flv";
			private function connectStreamToPlay(buffer:Number = 0):void
			{
				if(!connectionReady)return;
				
				if(stream)stream.close();
				
				  stream = new NetStream(this.connection);
				  stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				  stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler)
				  stream.client = new CustomClient();
				
				  stream.bufferTime = buffer;
				  
				stream.play(NameFilePlay,5000, -1);
			}
			
			private function connectStreamToRecord():void
			{
				if(_camera == null)return;
				if(_mic == null)return;
				if(!connectionReady)return;
				
				trace("STREAM -connectStreamToRecord();")
				if(stream)stream.close();
				
				  stream = new NetStream(this.connection);
				  stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				  stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler)
			      stream.client = new CustomClient();
				
				stream.bufferTime = 20;
				stream.attachCamera(_camera);
				stream.attachAudio(_mic);
				 
				stream.publish(NameFile, "record");
			}
			
			private function asyncErrorHandler(event:AsyncErrorEvent):void {
				// ignore AsyncErrorEvent events.
			}
			
			private function startCheckBufferComplete():void
			{
				trace("STREAM -startCheckBufferComplete");
				if(stream && connection.connected)
				{
					addEventListener(Event.ENTER_FRAME, en);
				}
			}
			
			private function en(e:Event):void
			{
				Core.u.write("STREAM -stream.bufferLength = "+stream.bufferLength);
				if(stream.bufferLength > 0){
					//bufferingSendComplete = false;
				}
				else{
					
					//bufferingSendComplete = true;
					removeEventListener(Event.ENTER_FRAME, en);
					
					if(stream)stream.close();
					
					dispatchEvent(new Event(SEND_DONE));
					trace("STREAM -SEND_DONE");
				}
			}
			
		}
}

class CustomClient {
	public function onMetaData(info:Object):void
	{
		trace("metadata: duration=" + info.duration + " width=" + info.width + " height=" + info.height + " framerate=" + info.framerate);
	}
	public function onCuePoint(info:Object):void
	{
		trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
	}
}

class Client {
	public function onBWCheck(... rest):Number { 
		return 0; 
	} 
	public function onBWDone(... rest):void { 
		var p_bw:Number; 
		if (rest.length > 0) p_bw = rest[0]; 
		// your application should do something here 
		// when the bandwidth check is complete 
		trace("bandwidth = " + p_bw + " Kbps."); 
	} 
}