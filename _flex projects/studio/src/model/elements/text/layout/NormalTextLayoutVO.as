package model.elements.text.layout
{
	import Interfaces.ITextLayout;
	
	import factory.ICreator;
	import factory.NormalTextLayoutCreator;
	
	import mx.utils.UIDUtil;
	
	public class NormalTextLayoutVO implements ITextLayout
	{
		private var _uid:String;
		protected var _creator:ICreator;
		
		public function NormalTextLayoutVO()
		{
			uid = UIDUtil.createUID();
			_creator = new NormalTextLayoutCreator(this);
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
		public function get name():String
		{
			return TextLayoutEnum.NORMAL;
		}

	}
}