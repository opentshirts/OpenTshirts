package events
{
	import flash.events.Event;
	
	public class ProductEvent extends Event
	{
		public static const COLOR_CHANGE:String = "COLOR_CHANGE";
		public static const VIEW_CHANGE:String = "VIEW_CHANGE";
		public static const LOAD_EXPORT_IMAGE:String = "LOAD_EXPORT_IMAGE";
		public static const LOAD_PRODUCT_LIST:String = "LOAD_PRODUCT_LIST";
		public static const SAVE_DESIGN:String = "SAVE_DESIGN";
		
		private var _data:Object;
		
		public function ProductEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:Object=null)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		override public function clone():Event
		{
			return new ProductEvent(type, bubbles, cancelable, data);
		}
		
		public function get data():Object
		{
			return _data;
		}
	}
}
