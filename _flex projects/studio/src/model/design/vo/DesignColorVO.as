package model.design.vo
{
	import flash.events.EventDispatcher;

	public class DesignColorVO extends EventDispatcher
	{
		public static const WHITEBASE:String = 'WHITEBASE';
		public static const PRODUCTCOLOR:String = 'PRODUCTCOLOR';
		
		public var id:String;
		public var need_white_base:Boolean = true;
		public var isdefault:Boolean = true;
		[Bindable]
		public var name:String;
		[Bindable]
		public var hexa:uint;
		[Bindable]
		public var alpha:Number;

	}
}