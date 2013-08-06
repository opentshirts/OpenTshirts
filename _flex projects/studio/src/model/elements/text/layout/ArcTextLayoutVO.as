package model.elements.text.layout
{
	import Interfaces.ITextLayout;
	
	import factory.ArcTextLayoutCreator;
	import factory.ICreator;
	
	import mx.utils.UIDUtil;
	
	public class ArcTextLayoutVO implements ITextLayout
	{
		private var _radio:Number = 0.5; //range [-1,1]
		private var _uid:String;
		protected var _creator:ICreator;
		
		public function ArcTextLayoutVO()
		{
			uid = UIDUtil.createUID();
			_creator = new ArcTextLayoutCreator(this);
		}
		public function get name():String
		{
			return TextLayoutEnum.ARC;
		}
		public function get uid():String
		{
			return _uid;
		}
		public function get creator():ICreator
		{
			return _creator;
		}
		public function set uid(value:String):void
		{
			_uid = value;
		}
		[Bindable]
		public function get radio():Number
		{
			return _radio;
		}

		public function set radio(value:Number):void
		{
			_radio = value;
		}

	}
}