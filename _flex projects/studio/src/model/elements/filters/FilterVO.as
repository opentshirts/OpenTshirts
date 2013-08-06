package model.elements.filters
{
	import Interfaces.ICreatable;
	
	import factory.ICreator;
	
	import flash.errors.IllegalOperationError;
	
	import mx.utils.UIDUtil;

	public class FilterVO implements ICreatable
	{
		public var uid:String;
		protected var _name:String;
		protected var _visible:Boolean;
		protected var _creator:ICreator;
		private var _index:String = "";
		
		public function FilterVO()
		{
			uid = UIDUtil.createUID();
			visible = false;
		}
		public function get creator():ICreator
		{
			return _creator;
		}
		[Bindable]
		public function get index():String
		{
			return _index;
		}
		
		public function set index(value:String):void
		{
			_index = value;
		}
		[Bindable]
		public function get name():String
		{
			throw new IllegalOperationError("Abstract method: must be overriden in a subclass");
			return null;
		}
		public function set name(value:String):void
		{
			_name = value;
		}
		[Bindable]
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			_visible = value;
		}
	}
}