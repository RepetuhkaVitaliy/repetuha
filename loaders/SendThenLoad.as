package com.repetuha.loaders{
	
	/* author: Repetukha Vitaliy */
	
    import flash.display.*;
    import flash.events.*;
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLRequestHeader;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;
    import flash.net.navigateToURL;
    import flash.xml.XMLDocument;

	public class SendThenLoad extends Sprite{
		
		public var answer;
		public var error;
		
		private var myloader;
		private var loading:Boolean = false;

		public function SendThenLoad() {

		}
		
		public function send(phpURL,param:Array,inheader:* = null,ContentType:String = ""){
			stopSend();
			
			sendData(phpURL,param,inheader,ContentType);
			}
			
		public function stopSend(){
			if(loading == true){
				  myloader.close();
				  loading = false;
				}
			}	
		
		private function dispatchAnswer(answer){
			this.answer = answer;
			Core.u.write(answer,"FFFF00");
			dispatchEvent(new Event(Event.COMPLETE));
			trace(answer);
			}
			
		private function dispatchError(error){
			this.error = error;
			dispatchEvent(new Event("error"));
			}

		private function sendData(phpURL,param:Array,inheader:* = null,ContentType:String = ""):void {

			var myVars:URLVariables=new URLVariables  ;
			var rhArray:Array=new Array  ;
			//rhArray.push(new URLRequestHeader("", ""));
			//rhArray.push(new URLRequestHeader ("Content-type", "application/octet-stream"));
			//rhArray.push(new URLRequestHeader( "enctype", "multipart/form-data" ));
			///  test - http://beleven.ws/vitalik/rapp/png/img_create.php
			var request:URLRequest=new URLRequest(phpURL);
			
			if(ContentType.length > 0){
				rhArray.push(new URLRequestHeader ("Content-type",ContentType));
				request.requestHeaders = rhArray;
			}
		    
			
			for(var i:uint = 0; i < param.length/2; i++){
				var paramName:String = param[i*2];
			    var paramValue:String = param[i*2+1];
				myVars[paramName] = paramValue;
				trace(paramName+" = "+paramValue);
			}

			if(inheader == null){
			  request.data = myVars;
			}else{
			  request.data = inheader;
			}
			request.method=URLRequestMethod.POST;

			var loader:URLLoader=new URLLoader  ;
			configureListeners(loader);
            myloader = loader;
			
			try {
				loader.load(request);
				loading = true;
			} catch (error:Error) {
               loading = false; 
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
			loading = false;
				dispatchAnswer(loader. data);
			
		}
		private function openHandler(event:Event):void {
			trace("openHandler: " + event);
		}
		private function progressHandler(event:ProgressEvent):void {
			trace("progressHandler loaded:" + event.bytesLoaded + " total: " + event.bytesTotal);
		}
		private function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler: " + event);
             loading = false;
	        dispatchError("<p align='center'>securityError!</p>");
		}

		private function httpStatusHandler(event:HTTPStatusEvent):void {
			trace("httpStatusHandler: " + event);
		}

		private function ioErrorHandler(event:IOErrorEvent):void {
			trace("ioErrorHandler: " + event.text);
                loading = false;
			  dispatchError("<p align='center'>ioError!</p>");
			  
			  trace("myloader = "+myloader.data);
		}
	}
}