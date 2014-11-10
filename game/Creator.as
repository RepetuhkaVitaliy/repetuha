package game
{
	import game.engine.bodys.*;
	
	public class Creator
	{
		
		public function Creator()
		{
		}
		
		public static function newCopy(arg:SpaceBody):*
		{
			var el:SpaceBody = createNewBody(arg);
			el.x = arg.x;
			el.y = arg.y;
			el.mass = arg.mass;
			el.rotation = arg.rotation;
			
			return el;
		}
		
		public static function createNewBody(Class:*):*
		{
			if(Class == Ship || Class is Ship || Class == "Ship")return new Ship();
			
			if(Class == Alien || Class is Alien || Class == "Alien")return new Alien();
			
			if(Class == Teleport || Class is Teleport || Class == "Teleport")return new Teleport();
			
			if(Class == SpeedUp || Class is SpeedUp || Class == "SpeedUp")return new SpeedUp();
		
			if(Class == Asteroid || Class is Asteroid || Class == "Asteroid")return new Asteroid();
			
			if(Class == Crystal || Class is Crystal || Class == "Crystal")return new Crystal();
			
			if(Class == Meteor || Class is Meteor || Class == "Meteor")return new Meteor();
			
			if(Class == Stovp || Class is Stovp || Class == "Stovp")return new Stovp();
			
			if(Class == Earth || Class is Earth || Class == "Earth")return new Earth();
			
			if(Class == GroundBox || Class is GroundBox || Class == "GroundBox")return new GroundBox();
			
			// master first, because is also CheckPoint
			if(Class == CheckPointDown || Class is CheckPointDown || Class == "CheckPointDown")return new CheckPointDown();
			if(Class == CheckPointMaster || Class is CheckPointMaster || Class == "CheckPointMaster")return new CheckPointMaster();
			if(Class == CheckPointRot || Class is CheckPointRot || Class == "CheckPointRot")return new CheckPointRot();
			if(Class == CheckPointSc3 || Class is CheckPointSc3 || Class == "CheckPointSc3")return new CheckPointSc3();
			if(Class == CheckPointSc2 || Class is CheckPointSc2 || Class == "CheckPointSc2")return new CheckPointSc2();
			if(Class == CheckPointSimple || Class is CheckPointSimple || Class == "CheckPointSimple")return new CheckPointSimple();
			if(Class == CheckPoint || Class is CheckPoint || Class == "CheckPoint")return new CheckPoint();
			
			if(Class == Vitryak || Class is Vitryak || Class == "Vitryak")return new Vitryak();
			
			if(Class == Bomb1 || Class is Bomb1 || Class == "Bomb1")return new Bomb1();
			
			if(Class == Tower1 || Class is Tower1 || Class == "Tower1")return new Tower1();
			
			if(Class == ActionArea5 || Class is ActionArea5 || Class == "ActionArea5")return new ActionArea5();
			if(Class == ActionArea4 || Class is ActionArea4 || Class == "ActionArea4")return new ActionArea4();
			if(Class == ActionArea3 || Class is ActionArea3 || Class == "ActionArea3")return new ActionArea3();
			if(Class == ActionArea2 || Class is ActionArea2 || Class == "ActionArea2")return new ActionArea2();
			if(Class == ActionArea1 || Class is ActionArea1 || Class == "ActionArea1")return new ActionArea1();
			
			if(Class == Windmill1 || Class is Windmill1 || Class == "Windmill1")return new Windmill1();
			
			if(Class == Fon1 || Class is Fon1 || Class == "Fon1")return new Fon1();
			
			if(Class == RoketPoint || Class is RoketPoint || Class == "RoketPoint")return new RoketPoint();
			
			if(Class == MagnitPoint || Class is MagnitPoint || Class == "MagnitPoint")return new MagnitPoint();
			
			if(Class == Aerostat1 || Class is Aerostat1 || Class == "Aerostat1")return new Aerostat1();
			
			if(Class == Aerostat2 || Class is Aerostat2 || Class == "Aerostat2")return new Aerostat2();
			
			if(Class == Fonplane1 || Class is Fonplane1 || Class == "Fonplane1")return new Fonplane1();
			
			if(Class == Wheel || Class is Wheel || Class == "Wheel")return new Wheel();
			
			if(Class == Nojka || Class is Nojka || Class == "Nojka")return new Nojka();
			
			if(Class == Cloud1 || Class is Cloud1 || Class == "Cloud1")return new Cloud1();
			
			return null;
		}
	}
}