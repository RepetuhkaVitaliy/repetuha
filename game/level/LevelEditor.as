package game.level
{
	import com.repetuha.utils.SliderVHSkin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Point;
	import flash.system.System;
	import flash.text.TextField;
	
	import game.Creator;
	import game.Game;
	import game.engine.Engine;
	import game.engine.bodys.*;
	
	public class LevelEditor extends Sprite
	{
		private var editorColor:uint = 0x333333;
		public static var worldChildsClasses:Array = [Stovp,GroundBox,CheckPointSimple,CheckPoint,CheckPointRot,CheckPointSc2,CheckPointSc3,CheckPointMaster,CheckPointDown,Crystal,SpeedUp,Vitryak,Tower1,Bomb1,RoketPoint,MagnitPoint,ActionArea1,ActionArea2,ActionArea3,ActionArea4,ActionArea5,Windmill1,Fon1,Aerostat1,Aerostat2,Fonplane1];
		
		private var cont:Sprite = new Sprite();		
		private var samplesCont:Sprite = new Sprite();
		private var dragFiled:Sprite = new Sprite();
		
		private var level:Level;
		public function LevelEditor(_level:Level)
		{
			super();
			
			level = _level;	
			
			addChild(cont);
			cont.visible = false;
			
			
			butt.y = Game.GameHeight-30;
			butt.addEventListener(MouseEvent.CLICK, function():void{
				if(!cont.visible)on()
				else off();
			});
			
			
			// samples button
			var buttSmp:Sprite = createEditorButton();
			cont.addChild(buttSmp);
			buttSmp.scaleX = buttSmp.scaleY = 1;
			buttSmp.x = 0;
			buttSmp.y = Game.GameHeight-30;
			buttSmp.addEventListener(MouseEvent.CLICK, function():void{
				if(!samplesCont.visible)samplesCont.visible = true;
				else samplesCont.visible = false;
			});
			samplesCont.visible = false;
			
			
			// show 2d button
			var butt2D:Sprite = createEditorButton();
			cont.addChild(butt2D);
			butt2D.scaleX = butt2D.scaleY = 1;
			butt2D.x = Game.GameWidth;
			butt2D.y = Game.GameHeight-400;
			butt2D.addEventListener(MouseEvent.CLICK, function():void{
				if(Level.engine.cont.alpha == 0)Level.engine.cont.alpha = 1;
				else Level.engine.cont.alpha = 0;
			});
			Level.engine.cont.alpha = 0;
			
			// zoom field
			var slider:Sprite = createEditorButton();slider.scaleX = slider.scaleY = 0.5;
			var zoomSlider:SliderVHSkin = new SliderVHSkin(300,null,null,slider,null);
			zoomSlider.x = Game.GameWidth-7;
			zoomSlider.y = Game.GameHeight-350;
			cont.addChild(zoomSlider);
			zoomSlider.addEventListener("update", function():void{
				zoomField(zoomSlider.value);
			});
			
			// draw field bounds
			Level.engine.addChildAt(dragFiled,0);
			dragFiled.graphics.beginFill(editorColor,0);
			dragFiled.graphics.drawRect(0,0,5000,5000);
			dragFiled.graphics.endFill();
			
			dragFiled.graphics.lineStyle(5,editorColor);
			dragFiled.graphics.drawRect(0,0,game.level.Level.widthSpace,game.level.Level.heightSpace);
			
			
			// drag field
			dragFiled.addEventListener(MouseEvent.MOUSE_DOWN, function():void{
				Level.engine.startDrag();
				addEventListener(Event.ENTER_FRAME,moveMap);
				Level.engine.addChild(dragFiled);
				dragFiled.alpha = 0;
				propClose();
			});
			dragFiled.addEventListener(MouseEvent.MOUSE_UP, function():void{
				removeEventListener(Event.ENTER_FRAME,moveMap);
				Level.engine.stopDrag();
				Level.engine.addChildAt(dragFiled,0);
				dragFiled.alpha = 1;
			});
			
			
			// save button
			var buttGetXML:Sprite = createEditorButton();
			cont.addChild(buttGetXML);
			buttGetXML.x = 0;
			buttGetXML.y = Game.GameHeight-100;
			buttGetXML.addEventListener(MouseEvent.CLICK, function():void{
				txt.text = level.levelsData.getXML(level,Level.engine.spaceBodys).toString();
			});
			
			// save text
			var txt:TextField = new TextField();
			cont.addChild(txt);txt.width = 30;txt.height = 30;
			txt.x = buttGetXML.x;
			txt.y = buttGetXML.y-50;
			txt.background = true;
			
			
			createSamples();
			
			configEngineElements();
			
			setupPropWindow();
			
			this.filters = [new DropShadowFilter(1,45,0,1,20,20)]
			
			this.off();
		}
		
		// PRIVATE:
		private function moveMap(e:Event):void
		{
			level.ship.x += (Level.engine.mouseX-level.ship.x)/10;
			level.ship.y += (Level.engine.mouseY-level.ship.y)/10;
			level.mapUpdatePosition();
		}
		private function createSamples():void
		{
			var sS:Number = 40;// sampleSize
			
			var td:Number = -1;
			var tr:Number = 0;
			
			var rowNum:Number = 15;
			
		     for(var i:uint = 0; i < worldChildsClasses.length; i ++)
			 {
				     var sample:* = Creator.createNewBody(worldChildsClasses[i]);
					 
					 td++;
						 if(td == rowNum){
				torColor,1)
			 samplesCont.graphics.drawRect(sS/2,-sS,sS*rowNum,sS*2);
			 samplesCont.graphics.endFill();
			 
			 samplesCont.y -= sS;
		}
		
		private function configureDrag(sample:*):void
		{
			sample.addEventListener(MouseEvent.MOUSE_DOWN,function():void
			{
				var el:SpaceBody = Creator.newCopy(sample);
				Level.engine.addBody(el,new Point(300,100));
				el.x = Level.engine.mouseX;
				el.y = Level.engine.mouseY;
				el.startDrag();
				propClose();
				configSelectElement(el);
			});
		}
		
		private function configSelectElement(el:SpaceBody):void
		{	
		    el.addEventListener(MouseEvent.MOUSE_UP,function():void{
				el.stopDrag();
				if(el.box2dbody){
			
	    }
		
		private function configEngineElements():void
		{
			for each(var el:SpaceBody in Level.engine.spaceBodys){
				configSelectElement(el);
			}
		}
		
		private function on():void
		{
			cont.visible = true;
			dragFiled.visible = true;
			level.pause();
		}
		
		private function off():void
		{
			cont.visible = false;
			dragFiled.visible = false;
			propClose();
			level.rezume();
		}
		
		
		private function zoomField(Z:Number):void
		{
			Level.engine.scaleX = Level.engine.scaleY = Z;			
		}
		wc_properties = new swc_properties();
		private var selectedTarget:SpaceBody = null;
		private function setupPropWindow():void
		{
			cont.addChild(prop);
			prop.visible = false;
			prop.scaleX = prop.scaleY = 0.7;
			
			prop.fon.addEventListener(MouseEvent.MOUSE_DOWN,function():void
			{
				prop.startDrag();
			});
			
			prop.fon.addEventListener(MouseEvent.MOUSE_UP,function():void
			{
				prop.stopDrag();
			});
			
			
			prop.btn_close.addEventListener(MouseEvent.CLICK,function():void
			{
				propClose();
			});
			
			prop.btn_rotate.addEventListener(MouseEvent.CLICK,function():void
			{
				if(selectedTarget == null)return ;
					
		
				if(selectedTarget == null)return;
				
				selectedTarget.view3dZ = Number(prop.view3dz.text);
			});
			
			prop.btn_targets_clear.addEventListener(MouseEvent.CLICK,function():void
			{
				if(selectedTarget == null)return;
				
				selectedTarget.targets = new Vector.<SpaceBody>;
				
				showProp(selectedTarget);
			});
			
			
			prop.btn_delete.addEventListener(MouseEvent.CLICK,function():void
			{
				if(selectedTarget == null)return;
				
				selectedTarget.isReadyForHell = true;
				Level.engine.removeDeadElements();
				propClose();
			});
			
		}
		private function propClose():void
		{
			prop.visible = false;
		    selectedTarget = null;
		}
		
		private function showProp(el:SpaceBody):void
		{
		
			prop.Name.text = el.toString();
			prop.rotate.text = ""+Math.round(el.rotation*100)/100;
			prop.mass.text = ""+Math.round(el.mass*100)/100;
			
			prop.view3dz.text = ""+Math.round(el.view3dZ*100)/100;
			
			prop.X.text = ""+Math.round(el.x);
			prop.Y.text = ""+Math.round(el.y);
			
			prop.Targets.text = "targest: "+el.targets.length+" = "+el.targets;
			
		}
		
	}
	
	
}