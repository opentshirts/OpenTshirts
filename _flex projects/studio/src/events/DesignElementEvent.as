package events
{
	import flash.events.Event;
	
	public class DesignElementEvent extends Event
	{
		public static const SIZE_CHANGE:String = "SIZE_CHANGE";
		public static const POSITION_CHANGE:String = "POSITION_CHANGE";
		public static const ROTATION_CHANGE:String = "ROTATION_CHANGE";
		public static const UNSCALED_SIZE_CHANGE:String = "UNSCALED_SIZE_CHANGE";
		
		private var _data:Object;
		
		public function DesignElementEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new DesignElementEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
