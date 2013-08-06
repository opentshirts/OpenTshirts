package events
{
	import flash.events.Event;
	
	public class ClipartEvent extends Event
	{
		public static const LOAD_CLIPART_LIST:String = "LOAD_CLIPART_LIST";
		public static const COLOR_STATE_CHANGE:String = "COLOR_STATE_CHANGE";
		public static const INVERT:String = "INVERT";
		
		private var _data:Object;
		
		public function ClipartEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new ClipartEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
