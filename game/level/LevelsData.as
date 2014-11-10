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
			
				}
			}			
			code += '</code>';
		    
			return new XML(code);
		}
		
		public function parseXML(level:Level,code:XML):void
		{
			trace(code);
			trace(Number(code.@w),Number(code.@h));;
			
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