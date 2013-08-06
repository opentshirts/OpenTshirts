package events
{
	import flash.events.Event;
	
	public class ArrangeEvent extends Event
	{
		public static const BRING_FORWARD:String = "BRING_FORWARD";
		public static const BRING_BACKWARD:String = "BRING_BACKWARD";
		public static const BRING_TO_TOP:String = "BRING_TO_TOP";
		public static const BRING_TO_BOTTOM:String = "BRING_TO_BOTTOM";
		
		private var _data:Object;
		
		public function ArrangeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new ArrangeEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
