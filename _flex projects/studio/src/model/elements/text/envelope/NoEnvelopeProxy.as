package model.elements.text.envelope
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class NoEnvelopeProxy extends Proxy implements IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'NoEnvelopeProxy';
		
		public function NoEnvelopeProxy(value_object:Object)  
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
		public function saveToXML():XML {
			var elementXml:XML = <envelope/>;
			elementXml.@type = vo.type;
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			//do nothing
		}
		public function get vo():NoEnvelopeVO
		{
			return data as NoEnvelopeVO;
		}
		public function getCopy():Object
		{
			var obj:NoEnvelopeVO = new NoEnvelopeVO();
			return obj;
		}
		
	}  
}