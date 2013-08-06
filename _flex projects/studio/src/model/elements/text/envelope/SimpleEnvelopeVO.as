package model.elements.text.envelope
{
	import Interfaces.IEnvelope;
	
	import factory.ICreator;
	import factory.SimpleEnvelopeCreator;
	
	import mx.utils.UIDUtil;
	
	public class SimpleEnvelopeVO implements IEnvelope
	{
		public var effectNumber:uint;
		[Bindable]
		public var amount:Number = 0.5; //number between -1 and 1
		private var _uid:String;
		protected var _creator:ICreator;
		
		public function SimpleEnvelopeVO(effectNumber:uint)
		{
			this.effectNumber = effectNumber;
			uid = UIDUtil.createUID();
			_creator = new SimpleEnvelopeCreator(this);
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
			return EnvelopeTypeEnum.SIMPLE;
		}


	}
}