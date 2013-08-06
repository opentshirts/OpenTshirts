package model.elements.text.layout
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class NormalTextLayoutProxy extends Proxy implements IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'NormalTextLayoutProxy';
		
		public function NormalTextLayoutProxy(value_object:Object)  
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
			var elementXml:XML = <text_layout/>;
			elementXml.@name = vo.name;
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			//nothing
		}
		public function get vo():NormalTextLayoutVO
		{
			return data as NormalTextLayoutVO;
		}
		
		public function getCopy():Object
		{
			var obj:NormalTextLayoutVO = new NormalTextLayoutVO();
			return obj;
		}
		
	}  
}