package com.repetuha{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.FileReference;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.net.FileFilter;

	public class UploadPhoto extends Sprite {

		private var fileReference:FileReference = new FileReference();

		public var photo;

		public function UploadPhoto() {

			fileReference.addEventListener(Event.SELECT,   fileReference_select);
			fileReference.addEventListener(Event.COMPLETE, fileReference_complete);
		}

		public function upload() {
			var arr:Array=[];
			arr.push(new FileFilter("Images", ".gif;*.jpeg;*.jpg;*.png;*.bmp"));
			fileReference.browse(arr);
		}

		private function fileReference_select(evt:Event) {
			fileReference.load();
		}

		private function fileReference_complete(evt:Event) {
			var loader:Loader = new Loader();
			loader.loadBytes(fileReference.data);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadBytesHandler);

			function loadBytesHandler(event:Event):void {
				var loaderInfo:LoaderInfo = (event.target as LoaderInfo);
				loaderInfo.removeEventListener(Event.COMPLETE, loadBytesHandler);
				photo = loaderInfo.content;
				dispatchEvent(new Event(Event.COMPLETE));
			}

		}
	}
}