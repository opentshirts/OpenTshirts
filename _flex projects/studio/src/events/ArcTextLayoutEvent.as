package events
{
	import flash.events.Event;
	
	public class ArcTextLayoutEvent extends Event
	{
		public static const RADIO_CHANGE:String = "RADIO_CHANGE";
		public static const RADIO_CHANGING:String = "RADIO_CHANGING";
		
		private var _data:Object;
		
		public function ArcTextLayoutEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new ArcTextLayoutEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
