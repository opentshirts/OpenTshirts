package events
{
	import flash.events.Event;
	
	public class FilterEvent extends Event
	{
		public static const OUTLINE_THICKNESS_CHANGE:String = "OUTLINE_THICKNESS_CHANGE";
		public static const OUTLINE_THICKNESS_CHANGING:String = "OUTLINE_THICKNESS_CHANGING";
		public static const OUTLINE_COLOR_CHANGE:String = "OUTLINE_COLOR_CHANGE";
		public static const SHADOW_THICKNESS_CHANGE:String = "SHADOW_THICKNESS_CHANGE";
		public static const SHADOW_THICKNESS_CHANGING:String = "SHADOW_THICKNESS_CHANGING";
		public static const SHADOW_DISTANCE_CHANGE:String = "SHADOW_DISTANCE_CHANGE";
		public static const SHADOW_DISTANCE_CHANGING:String = "SHADOW_DISTANCE_CHANGING";
		public static const SHADOW_ANGLE_CHANGE:String = "SHADOW_ANGLE_CHANGE";
		public static const SHADOW_ANGLE_CHANGING:String = "SHADOW_ANGLE_CHANGING";
		public static const SHADOW_COLOR_CHANGE:String = "SHADOW_COLOR_CHANGE";
		public static const VISIBILITY_CHANGE:String = "VISIBILITY_CHANGE";
		
		private var _data:Object;
		
		public function FilterEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new FilterEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
