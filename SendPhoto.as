package com.repetuha{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	import flash.net.URLLoader;
	import flash.events.*;
	
	import flash.xml.XMLDocument;

	import com.adobe.images.PNGEncoder;
	import flash.utils.ByteArray;
	
	import flash.display.LoaderInfo;
	
	import flash.geom.Matrix;
	
	public class SendPhoto extends Sprite {
		
		private var id:Number;
		public var phpLink:String;
		private var varName:String;
		
		private var descriptionVar:String;
		private var descriptionTXT:String;
		
		private var myPNG;
		
		public var serverAnswer;
		public var error;
		
		public var percent:Number = 0;
		
		public function SendPhoto() {
		
		}
		
		private function dispatchError(error){
			this.error = error;
			dispatchEvent(new Event(Event.CONNECT));
			}
		
		public function send(id,image,Width,Height,phpLink,varName,descriptionVar,descriptionTXT) {
			this.phpLink = phpLink;
			this.varName = varName;
			this.descriptionVar = descriptionVar;
			this.descriptionTXT = descriptionTXT;
			this.id = id;
		
		    var preview = new BitmapData(Width, Height, false, 0xFFFFFF);
		
		    //var previewMatrix:Matrix = new Matrix(1, 0, 0, 1, -50, -50);

		    var previewB:Bitmap = new Bitmap(preview);
			
			preview.draw(image);//,previewMatrix);
			
			var myPNG:ByteArray = PNGEncoder.encode(preview);
			
			sendImage(myPNG);
		}
		public function sendImage(png:*):void {
			
			var myVars:URLVariables = new URLVariables();
			
			var rhArray:Array = new Array();
			//rhArray.push(new URLRequestHeader("", ""));
            rhArray.push(new URLRequestHeader ("Content-type", "application/octet-stream"));
			///     http://beleven.ws/vitalik/gl/test/mirror/img_create2.php
			
			var request:URLRequest = new URLRequest(phpLink);//+"?"+varName+"="+id+"&"+descriptionVar+"="+descriptionTXT);
			request.requestHeaders = rhArray;
			
			request.data = png;
			request.method = URLRequestMethod.POST;
		
		   var loader:URLLoader = new URLLoader();
            configureListeners(loader);
			
			loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);

            try {
                loader.load(request);
            } catch (error:Error) {
				dispatchError("<p align='center'>Помилка з'єднання!</p>");
			  //popUpAnswer.textF.htmlText = "<br></br><br></br>Помилка з'єднання!";
              Core.u.write("connection error - check URL!","ff0000");
            }
			percent = 0;
			dispatchEvent(new Event(Event.CHANGE));
        }
		
        private function configureListeners(dispatcher:IEventDispatcher):void {
            dispatcher.addEventListener(Event.COMPLETE, completeHandler);
            dispatcher.addEventListener(Event.OPEN, openHandler);
            dispatcher.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            dispatcher.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        }
        private function completeHandler(event:Event):void {
             var loader:URLLoader = URLLoader(event.target);
			 var otvet = loader.data;
			 Core.u.write(""+otvet,"FFFF00");
			 percent = 100;
			 dispatchEvent(new Event(Event.CHANGE));
			 serverAnswer = otvet;
			 
			 dispatchEvent(new Event(Event.COMPLETE));
        }
        private function openHandler(event:Event):void {
			Core.u.write("openHandler: " + event);
        }
        private function progressHandler(event:ProgressEvent):void {
			 Core.u.write("loaded:" + event.bytesLoaded + ", total: " + event.bytesTotal);
			 percent = Math.round(event.bytesLoaded);
			 
			 dispatchEvent(new Event(Event.CHANGE));
        }
        private function securityErrorHandler(event:SecurityErrorEvent):void {
			Core.u.write("securityErrorHandler: " + event,"ff0000");
			//popUpAnswer.textF.htmlText = '<br></br><br></br>securityError!';
			dispatchError("<p align='center'>securityError!</p>");
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
			Core.u.write("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
			Core.u.write("ioErrorHandler: " + event,"ff0000");
			dispatchError("<p align='center'>ioError!</p>");
			//popUpAnswer.textF.htmlText = '<br></br><br></br>ioError!';
        }
	}
}