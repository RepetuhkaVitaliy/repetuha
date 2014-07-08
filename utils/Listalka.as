package com.repetuha.utils{
	
	/* author: Repetukha Vitaliy */
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	public class Listalka extends Sprite {
			
    	public var numsContainer:Sprite = new Sprite();		
		
		private var defFormat:TextFormat = new TextFormat();
		private var overFormat:TextFormat = new TextFormat();	
		private var selectFormat:TextFormat = new TextFormat();
		
		private var itemsArray:Array = new Array();
		
		public var pageNum:Number = -1;
		public var currItem:Sprite = new Sprite();

		public function Listalka() {
			
			 defFormat.font = 'Arial';
             defFormat.color = 0xffffff;
			 defFormat.underline = false;
             defFormat.size = 16;
			
			 overFormat.font = 'Arial';
             overFormat.color = 0xCCCCCC;
			 overFormat.underline = false;
             overFormat.size = 16;
			 
			 selectFormat.font = 'Arial';
             selectFormat.color = 0xffffff;
			 selectFormat.underline = false;
             selectFormat.size = 16;
			 
			 addChild(numsContainer);
		}
		
		
		public function init(nums) {
			
			show();
			
			var w:Number = 9;
			var del:Number = 9;
			
			for (var i:uint = 0; i < itemsArray.length; i++) {
				itemsArray[i].visible = false;
			}
			
			for ( i = 0; i < nums; i++) {
				
				var num;
				
				if(itemsArray[i]){
					 num = itemsArray[i];
					 num.visible = true;
				}
				else{
				 var numSprite:Sprite = new Sprite();
	
	             numSprite.addEventListener(MouseEvent.MOUSE_DOWN,tButtonDownListener);
			     numSprite.addEventListener(MouseEvent.MOUSE_OVER,tButtonOverListener);
			     numSprite.addEventListener(MouseEvent.MOUSE_OUT,tButtonOutListener);
				 numSprite.buttonMode = true;
	
				 numSprite.addChild(createTextField(""+(i+1)));
				 numsContainer.addChild(numSprite);
				 itemsArray.push(numSprite);
				 num = numSprite;
				}
				 
				 num.x = -(w+del)*(nums)/2+(w+del)*i;
				 
				
			}
			
		}
				
		private function createTextField(str:String){
			
			 var _textField:TextField = new TextField();
			 _textField.selectable = false;
			 _textField.embedFonts = true;
			 _textField.autoSize = TextFieldAutoSize.LEFT;
             _textField.background = false;
             _textField.border = false;
			 _textField.antiAliasType = AntiAliasType.ADVANCED;
			 
			 _textField.text = str;
			 _textField.setTextFormat(defFormat);
			 _textField.mouseEnabled = false;
			
             return _textField;
	    }
		
		private function tButtonOverListener(e:MouseEvent) {
			var item = e.target;
			var _textField = item.getChildAt(0);
			 
			 if(pageNum != itemsArray.indexOf(item)+1){
             _textField.setTextFormat(overFormat);
			 }
		}
		private function tButtonOutListener(e:MouseEvent) {
			var item = e.target;
			var _textField = item.getChildAt(0);
			
			if(pageNum != itemsArray.indexOf(item)+1){
             _textField.setTextFormat(defFormat);
			}
			
		}
		private function tButtonDownListener(e:MouseEvent) {
			
			for (var i:uint = 0; i < itemsArray.length; i++) {
			      var t = itemsArray[i].getChildAt(0);	
				  t.setTextFormat(defFormat);
			}
			
		    var item = e.target;
			var _textField = item.getChildAt(0);
			_textField.setTextFormat(selectFormat);
			
			currItem = item;
			pageNum = itemsArray.indexOf(item)+1;
    		dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function current(num:Number) {
			pageNum = num;
			
			if(itemsArray.length > 0){
			for (var i:uint = 0; i < itemsArray.length; i++) {
			      var t = itemsArray[i].getChildAt(0);	
				  t.setTextFormat(defFormat);
			}
			
		    var item = itemsArray[pageNum-1];
			currItem = item;
			var _textField = item.getChildAt(0);
			_textField.setTextFormat(selectFormat);
			}
			
			dispatchEvent(new Event(Event.CHANGE));
		}
		
	    public function show() {
			visible = true;
		}
		
		public function hide() {
			visible = false;
		}
		
		
	}
}