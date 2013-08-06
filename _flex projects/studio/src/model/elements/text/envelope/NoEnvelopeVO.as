package model.elements.text.envelope
{
	import Interfaces.IEnvelope;
	
	import factory.ICreator;
	import factory.NoEnvelopeCreator;
	
	import mx.utils.UIDUtil;
	
	public class NoEnvelopeVO implements IEnvelope
	{
		private var _uid:String;
		protected var _creator:ICreator;
		
		public function NoEnvelopeVO()
		{
			uid = UIDUtil.createUID();
			_creator = new NoEnvelopeCreator(this);
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

		public function get type():String
		{
			return EnvelopeTypeEnum.NONE;
		}


	}
}