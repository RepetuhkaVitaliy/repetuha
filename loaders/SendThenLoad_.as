package com.beleven.loaders{
	
	/* author: Repetukha Vitaliy */
	
    import flash.display.*;
	import flash.events.*;

	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLRequestHeader;
	import flash.net.navigateToURL;
	import flash.net.URLVariables;
	import flash.net.URLLoader;

	import flash.xml.XMLDocument;

	public class SendThenLoad extends Sprite{
		
		public var answer;
		public var error;
		
		public var Mytrace;

		public function SendThenLoad() {

		}
		
		public function send(phpURL,param:Array){
			sendData(phpURL,param);
			}
		
		private function dispatchAnswer(answer){
			this.answer = answer;
			dispatchEvent(new Event(Event.COMPLETE));
			trace(answer);
			}
			
		private function dispatchError(error){
			this.error = error;
			dispatchEvent(new Event(Event.CONNECT));
			}

		private function sendData(phpURL,param:Array):void {
			
			Mytrace = "do 2"
			dispatchEvent(new Event(Event.CHANGE));

			var myVars:URLVariables=new URLVariables();
			//var rhArray:Array=new Array();
			//rhArray.push(new URLRequestHeader("", ""));
			//rhArray.push(new URLRequestHeader ("Content-type", "application/octet-stream"));
			///  test - http://beleven.ws/vitalik/rapp/png/img_create.php
			
			var paramName:String = param[0];
			var paramValue:String = param[1];
			var paramName2:String = '';

			myVars[paramName] = paramValue;
			
			if(param.length > 2){
				 var paramName2:String = param[2];
			     var paramValue2:String = param[3];
				 myVars[paramName2] = paramValue2;
				 trace('here!!!!!!!!!!!!!');
				 Mytrace = "posle 2"
				 dispatchEvent(new Event(Event.CHANGE));
				 phpURL += "/"+escape(paramName2)+"="+escape(paramValue2)+"/"+escape(paramName)+"="+escape(paramValue);
			}
			var request:URLRequest=new URLRequest(phpURL);
			//request.requestHeaders = rhArray;
			
			/*
			if(param.length > 2){
				 var paramName2:String = param[2];
			     var paramValue2:String = param[3];
				 
				 myVars[paramName2] = paramValue2;
				}*/
				
			request.data=myVars;
			trace("request.data = "+request.data);
			/*
			if(param.length > 2 && paramName=='name' &&  paramName2 == 'email') {
				request.method=URLRequestMethod.GET;
				phpURL += "?"+escape(paramName2)+"="+escape(paramValue2)+"&"+escape(paramName)+"="+escape(paramValue);
			} else {
				request.method=URLRequestMethod.POST
			}*/

			var loader:URLLoader = new URLLoader();
			configureListeners(loader);

			try {
				loader.load(request);
			} catch (error:Error) {

               dispatchError("<p align='center'>Помилка з'єднання!");
               //Core.alert.show("<br></br><br></br>Помилка з'єднання!");  --- звідси будем в Core передавати повідомдення
			   trace("Unable to load requested document.");
				
			}
		}
		
		
		public function sendSpecialData(phpURL,param:Array):void {
             trace("sendSpecialData");
			var myVars:URLVariables=new URLVariables();
			var rhArray:Array=new Array();
			//rhArray.push(new URLRequestHeader("", ""));
			//rhArray.push(new URLRequestHeader ("Content-type", "application/octet-stream"));
			///  test - http://beleven.ws/vitalik/rapp/png/img_create.php
			
			var paramName:String = param[0];
			var paramValue:String = param[1];
			myVars[paramName] = paramValue;
			
			if(param.length > 2){
				 var paramName2:String = param[2];
			     var paramValue2:String = param[3];
 	 			 myVars[paramName2] = paramValue2;
				 phpURL += "?"+escape(paramName2)+"="+escape(paramValue2)+"&"+escape(paramName)+"="+escape(paramValue)+'&';
			}
			var request:URLRequest=new URLRequest(phpURL);
			//request.requestHeaders = rhArray;
			
			request.data=myVars;
			//trace("request.data = "+request.data)
			request.method=URLRequestMethod.POST;

			var loader:URLLoader = new URLLoader();
			configureListeners(loader);

			try {
				loader.load(request);
			} catch (error:Error) {

               dispatchError("<p align='center'>Помилка з'єднання!");
               //Core.alert.show("<br></br><br></br>Помилка з'єднання!");  --- звідси будем в Core передавати повідомдення
			   trace("Unable to load requested document.");
				
			}
		}
		
		private function configureListeners(dispatcher:IEventDispatcher):void {
			dispatcher.addEventListener(Event.COMPLETE,completeHandler);
			dispatcher.addEventListener(Event.OPEN,openHandler);
			dispatcher.addEventListener(ProgressEvent.PROGRESS,progressHandler);
			dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,securityErrorHandler);
			dispatcher.addEventListener(HTTPStatusEvent.HTTP_STATUS,httpStatusHandler);
			dispatcher.addEventListener(IOErrorEvent.IO_ERROR,ioErrorHandler);
		}
		private function completeHandler(event:Event):void {
			var loader:URLLoader=URLLoader(event.target);

				/*var otvet:XML=new XML(loader.data);
				var serverAnswer = otvet.children();*/
			
				dispatchAnswer(loader.data);
			
		}
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);

	        dispatchError("<p align='center'>securityError!</p>");
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event);

			  dispatchError("<p align='center'>ioError!</p>");
		}
	}
}