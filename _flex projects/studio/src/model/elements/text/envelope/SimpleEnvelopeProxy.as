package model.elements.text.envelope
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SimpleEnvelopeProxy extends Proxy implements IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'SimpleEnvelopeProxy';
		public static const AMOUNT_CHANGED:String = NAME + 'AMOUNT_CHANGED';
		public static const EFFECT_NUMBER_CHANGED:String = NAME + 'EFFECT_NUMBER_CHANGED';
		
		public function SimpleEnvelopeProxy(value_object:Object)  
		{  
			super( NAME, value_object  ); 
		}
		override public function getProxyName():String
		{
			return vo.uid;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			sendNotification(ApplicationConstants.REGISTER_MEDIATOR,vo,NAME);
			
		}
		public function setAmount(value:Number):void
		{
			vo.amount = value;
			sendNotification(AMOUNT_CHANGED, {uid:vo.uid, amount:vo.amount}, NAME);
		}
		public function setEffectNumber(value:uint):void
		{
			vo.effectNumber = value;
			sendNotification(EFFECT_NUMBER_CHANGED, {uid:vo.uid, effectNumber:vo.effectNumber}, NAME);
		}
		
		public function saveToXML():XML {
			var elementXml:XML = <envelope/>;
			elementXml.@type = vo.type;
			elementXml.@amount = vo.amount;
			elementXml.@effectNumber = vo.effectNumber;
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.amount = Number(xml.@amount);
			vo.effectNumber = uint(xml.@effectNumber);
		}
		public function get vo():SimpleEnvelopeVO
		{
			return data as SimpleEnvelopeVO;
		}
		public function getCopy():Object
		{
			var obj:SimpleEnvelopeVO = new SimpleEnvelopeVO(vo.effectNumber);
			obj.amount = vo.amount;
			obj.effectNumber = vo.effectNumber;
			return obj;
		}
		
	}  
}