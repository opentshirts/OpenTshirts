package events
{
	import flash.events.Event;
	
	public class SimpleEnvelopeEvent extends Event
	{
		public static const AMOUNT_CHANGE:String = "AMOUNT_CHANGE";
		public static const AMOUNT_CHANGING:String = "AMOUNT_CHANGING";
		
		private var _data:Object;
		
		public function SimpleEnvelopeEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new SimpleEnvelopeEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
