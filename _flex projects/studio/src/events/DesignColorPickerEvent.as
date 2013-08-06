package events
{
	import flash.events.Event;
	
	public class DesignColorPickerEvent extends Event
	{
		public static const SHOW:String = "SHOW";
		public static const OPEN:String = "OPEN";
		public static const CLOSE:String = "CLOSE";
		public static const COLOR_CHANGE:String = "COLOR_CHANGE";
		public static const COLOR_OVER:String = "COLOR_OVER";
		public static const COLOR_OUT:String = "COLOR_OUT";
		public static const GARMENT_COLOR:String = "GARMENT_COLOR";
		
		
		private var _data:Object;
		
		public function DesignColorPickerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new DesignColorPickerEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
