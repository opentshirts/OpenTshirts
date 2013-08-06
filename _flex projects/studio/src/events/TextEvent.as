package events
{
	import flash.events.Event;
	
	public class TextEvent extends Event
	{
		public static const TEXT_ADD:String = "TEXT_ADD";
		public static const TEXT_CHANGE:String = "TEXT_CHANGE";
		public static const FONT_CHANGE:String = "FONT_CHANGE";
		public static const TEXT_SPACING_CHANGE:String = "TEXT_SPACING_CHANGE";
		public static const TEXT_SPACING_CHANGING:String = "TEXT_SPACING_CHANGING";
		public static const TEXT_LAYOUT_CHANGE:String = "TEXT_LAYOUT_CHANGE";
		public static const TEXT_ENVELOPE_CHANGE:String = "TEXT_ENVELOPE_CHANGE";
		
		private var _data:Object;
		
		public function TextEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new TextEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
