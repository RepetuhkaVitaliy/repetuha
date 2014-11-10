package game.level
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.system.System;
	import flash.xml.XMLNode;
	
	import game.Creator;
	import game.Game;
	import game.engine.Engine;
	import game.engine.bodys.CheckPoint;
	import game.engine.bodys.SpaceBody;
	import game.engine.bodys.Stovp;

	public class LevelsData
	{
		[Embed(source="../../xml/stage1/level0.xml", mimeType="application/octet-stream")]
		protected const level0:Class;
		public var xml_level0:XML = XML(new level0);
		
		[Embed(source="../../xml/stage1/level1.xml", mimeType="application/octet-stream")]
		protected const level1:Class;
		public var xml_level1:XML = XML(new level1);
		
		[Embed(source="../../xml/stage1/level2.xml", mimeType="application/octet-stream")]
		protected const level2:Class;
		public var xml_level2:XML = XML(new level2);
		
		[Embed(source="../../xml/stage1/level3.xml", mimeType="application/octet-stream")]
		protected const level3:Class;
		public var xml_level3:XML = XML(new level3);
		
		[Embed(source="../../xml/stage1/level4.xml", mimeType="application/octet-stream")]
		protected const level4:Class;
		public var xml_level4:XML = XML(new level4);
		
		[Embed(source="../../xml/stage1/level5.xml", mimeType="application/octet-stream")]
		protected const level5:Class;
		public var xml_level5:XML = XML(new level5);
		
		[Embed(source="../../xml/stage1/level6.xml", mimeType="application/octet-stream")]
		protected const level6:Class;
		public var xml_level6:XML = XML(new level6);
		
		[Embed(source="../../xml/stage1/level7.xml", mimeType="application/octet-stream")]
		protected const level7:Class;
		public var xml_level7:XML = XML(new level7);
		
		[Embed(source="../../xml/stage1/level8.xml", mimeType="application/octet-stream")]
		protected const level8:Class;
		public var xml_level8:XML = XML(new level8);
		
		[Embed(source="../../xml/stage1/level9.xml", mimeType="application/octet-stream")]
		protected const level9:Class;
		public var xml_level9:XML = XML(new level9);
		
		[Embed(source="../../xml/stage1/level10.xml", mimeType="application/octet-stream")]
		protected const level10:Class;
		public var xml_level10:XML = XML(new level10);
		
		[Embed(source="../../xml/stage1/level11.xml", mimeType="application/octet-stream")]
		protected const level11:Class;
		public var xml_level11:XML = XML(new level11);
		
		[Embed(source="../../xml/stage2/level12.xml", mimeType="application/octet-stream")]
		protected const level12:Class;
		public var xml_level12:XML = XML(new level12);
		
		[Embed(source="../../xml/stage2/level13.xml", mimeType="application/octet-stream")]
		protected const level13:Class;
		public var xml_level13:XML = XML(new level13);
		
		[Embed(source="../../xml/stage2/level14.xml", mimeType="application/octet-stream")]
		protected const level14:Class;
		public var xml_level14:XML = XML(new level14);
		
		[Embed(source="../../xml/stage2/level15.xml", mimeType="application/octet-stream")]
		protected const level15:Class;
		public var xml_level15:XML = XML(new level15);
		
		[Embed(source="../../xml/stage2/level16.xml", mimeType="application/octet-stream")]
		protected const level16:Class;
		public var xml_level16:XML = XML(new level16);
		
		[Embed(source="../../xml/stage2/level17.xml", mimeType="application/octet-stream")]
		protected const level17:Class;
		public var xml_level17:XML = XML(new level17);
		
		[Embed(source="../../xml/stage2/level18.xml", mimeType="application/octet-stream")]
		protected const level18:Class;
		public var xml_level18:XML = XML(new level18);
		
		[Embed(source="../../xml/stage2/level19.xml", mimeType="application/octet-stream")]
		protected const level19:Class;
		public var xml_level19:XML = XML(new level19);
		
		[Embed(source="../../xml/stage2/level20.xml", mimeType="application/octet-stream")]
		protected const level20:Class;
		public var xml_level20:XML = XML(new level20);
		
		[Embed(source="../../xml/stage2/level21.xml", mimeType="application/octet-stream")]
		protected const level21:Class;
		public var xml_level21:XML = XML(new level21);
		
		[Embed(source="../../xml/stage2/level22.xml", mimeType="application/octet-stream")]
		protected const level22:Class;
		public var xml_level22:XML = XML(new level22);
		
		[Embed(source="../../xml/stage2/level23.xml", mimeType="application/octet-stream")]
		protected const level23:Class;
		public var xml_level23:XML = XML(new level23);		
		
		public static var levels:Array = [];
		
		public function LevelsData()
		{
			levels = [xml_level0,xml_level1,xml_level2,xml_level3,xml_level4,xml_level5,xml_level6,xml_level7,xml_level8,xml_level9,xml_level10,xml_level11,
			          xml_level12,xml_level13,xml_level14,xml_level15,xml_level16,xml_level17,xml_level18,xml_level19,xml_level20,xml_level21,xml_level22,xml_level23];
		}
		
		// PUBLIC:
		public function getXML(level:Level,_allTargets:Vector.<SpaceBody>):XML
		{
			var code:String;
			code = '<?xml version="1.0" encoding="windows-1250"?>';
			code += '<code w="'+game.level.Level.widthSpace+'" h="'+game.level.Level.heightSpace+'" maxtime="'+game.level.LevelRezults.maxLevelTime+'">';
			
			for(var j:uint = 0; j < _allTargets.length;j++){
				var tagretLink:SpaceBody = _allTargets[j];
				
				if(tagretLink && !tagretLink.isReadyForHell && level.cursor != tagretLink){
					var targetType:String = tagretLink.toString().split(" ")[1].split("]")[0];
					
					if(checkAvaibleToSave(tagretLink) == false)continue;
					
					code += '<item type="'+targetType+'" ';
					
					code += 'ID="'+tagretLink.ID+'" ';
					
					code += 'x="'+Number(String(tagretLink.x).substring(0,7))+'" ';
					code += 'y="'+Number(String(tagretLink.y).substring(0,7))+'" ';
					
					var _rot:Number = Number(String(tagretLink.rotation).substring(0,7));
					if(tagretLink is game.engine.bodys.Stovp)_rot = 0;
					code += 'r="'+_rot+'" ';
					
					code += 'mass="'+Number(String(tagretLink.mass).substring(0,7))+'" ';
					code += 'vx="'+Number(String(tagretLink.v.x).substring(0,7))+'" ';
					code += 'vy="'+Number(String(tagretLink.v.y).substring(0,7))+'" ';
					code += 'speed="'+Number(String(tagretLink.speed).substring(0,7))+'" ';
					
					code += 'view3dz="'+Number(String(tagretLink.view3dZ).substring(0,7))+'" ';
					
					code += 'active="'+tagretLink.active+'" ';
					
					// targets
					var targestStr:String = '';
					//Number(String(tagretLink.speed).substring(0,7))
					for each(var target:SpaceBody in tagretLink.targets){
						targestStr += ''+target.ID+','
					}
						
					code += 'targets="'+targestStr+'" ';
					
					code += '></item>';
				}
			}			
			code += '</code>';
		    
			return new XML(code);
		}
		
		public function parseXML(level:Level,code:XML):void
		{
			trace(code);
			trace(Number(code.@w),Number(code.@h));;
			game.level.Level.widthSpace = Number(code.@w);
			game.level.Level.heightSpace = Number(code.@h);
			
			if(String(code.@maxtime).length > 0)game.level.LevelRezults.maxLevelTime = Number(code.@maxtime);
			
			Level.engine.W = game.level.Level.widthSpace;
			Level.engine.H = game.level.Level.heightSpace;
			
			var items:XMLList = code.children();
			
			for(var j:uint = 0; j < items.length();j++){
				
				var tagretLink:XML = items[j];
				var targetType:String = tagretLink.@type;

				var item:SpaceBody = Creator.createNewBody(targetType);
				
				var ID:String = String(tagretLink.@ID);
				
				var X:Number = Number(tagretLink.@x);
				var Y:Number = Number(tagretLink.@y);
				var R:Number = Number(tagretLink.@r);
				
				var Mass:Number = Number(tagretLink.@mass);
				var Vx:Number = Number(tagretLink.@vx);
				var Vy:Number = Number(tagretLink.@vy);
				var Speed:Number = Number(tagretLink.@speed);
				
				var view3dz:Number = Number(tagretLink.@view3dz);
				
				var targetsStr:String = String(tagretLink.@targets);
				
				var active:String = String(tagretLink.@active);
				
				item.rotation = R;
				item.speed = Speed;
				item.v = new Point(Vx,Vy);
				
				///(>.<)/// Mayor update -------
				var circleFixSize:Number = 0.4*((10-game.Game.levelNum)/10);
				if(game.Game.levelNum > 10)circleFixSize = 0.15;
				if(item is CheckPoint)Mass *= 1+circleFixSize;
				///(>.<)/// Mayor update -------
				
				item.mass = Mass;
				item.view3dZ = view3dz;
				
				Level.engine.addBody(item,new Point(X,Y));
				
				item.ID = ID;
				item.data.targetsStr = targetsStr;
				
				
				if(active.length != 0){
				  if(active == "true")item.active = true;
				  if(active == "false")item.active = false;				
				}
			}
			
			// set targets:
			for(var k:uint = 0; k < Level.engine.spaceBodys.length;k++){
				
				var _item:SpaceBody = Level.engine.spaceBodys[k];
				
				if(_item.data.hasOwnProperty('targetsStr') == false)continue;
				
				var _targetsStr:String = _item.data.targetsStr;
				
				var targetsIDs:Array = _targetsStr.split(",");
				targetsIDs.pop();
				
				for each(var _target:SpaceBody in Level.engine.spaceBodys){
					if(targetsIDs.indexOf(_target.ID) != -1)
					{
						_item.targets.push(_target);
					}
				}
				
			}
		}
		
		private function checkAvaibleToSave(sb:SpaceBody):Boolean
		{
			for(var j:uint = 0; j < LevelEditor.worldChildsClasses.length;j++){
				if(sb is LevelEditor.worldChildsClasses[j])return true;
			}
			
			return false;
		}
	}
}