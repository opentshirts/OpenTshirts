package model.elements.text.layout
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ArcTextLayoutProxy extends Proxy implements IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'ArcTextLayoutProxy';
		public static const RADIO_CHANGED:String = NAME + 'RADIO_CHANGED';
		
		public function ArcTextLayoutProxy(value_object:Object)  
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
		public function setRadio(value:Number):void
		{
			vo.radio = value;
			sendNotification(RADIO_CHANGED, {uid:vo.uid, radio:vo.radio}, NAME);
		}
		
		
		public function saveToXML():XML {
			var elementXml:XML = <text_layout/>;
			elementXml.@name = vo.name;
			elementXml.@radio = vo.radio;
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.radio = Number(xml.@radio);
		}
		public function get vo():ArcTextLayoutVO
		{
			return data as ArcTextLayoutVO;
		}
		public function getCopy():Object
		{
			var obj:ArcTextLayoutVO = new ArcTextLayoutVO();
			obj.radio = vo.radio;
			return obj;
		}
		
	}  
}