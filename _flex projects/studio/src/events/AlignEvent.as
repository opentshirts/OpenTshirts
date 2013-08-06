package events
{
	import flash.events.Event;
	
	public class AlignEvent extends Event
	{
		public static const ALIGN_TO_TOP:String = "ALIGN_TO_TOP";
		public static const ALIGN_TO_BOTTOM:String = "ALIGN_TO_BOTTOM";
		public static const ALIGN_TO_LEFT:String = "ALIGN_TO_LEFT";
		public static const ALIGN_TO_RIGHT:String = "ALIGN_TO_RIGHT";
		public static const ALIGN_TO_CENTER_H:String = "ALIGN_TO_CENTER_H";
		public static const ALIGN_TO_CENTER_V:String = "ALIGN_TO_CENTER_V";
		
		private var _data:Object;
		
		public function AlignEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new AlignEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
