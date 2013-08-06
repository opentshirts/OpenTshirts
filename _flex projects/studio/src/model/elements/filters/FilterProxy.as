package model.elements.filters
{	  
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FilterProxy extends Proxy implements IProxy, IXMLProxy
	{  
		public static const NAME:String = 'FilterProxy';
		public static const FILTER_CREATED:String = NAME + 'FILTER_CREATED';
		public static const VISIBLE_CHANGE:String = NAME + 'VISIBLE_CHANGE';
		
		
		public function FilterProxy(value_object:Object)  
		{  
			super( NAME, value_object  );  
			
		}
		override public function getProxyName():String
		{
			return NAME + vo.uid;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			sendNotification(ApplicationConstants.REGISTER_MEDIATOR,vo,NAME);
		}
		public function setVisible(value:Boolean):void
		{
			vo.visible = value;
			sendNotification(VISIBLE_CHANGE, {uid:vo.uid, visible:vo.visible},NAME);
		}
		public function get vo():FilterVO
		{
			return data as FilterVO;
		}
		public function saveToXML():XML {
			var elementXml:XML = <base/>;
			//elementXml.@uid = vo.uid;
			elementXml.@visible = vo.visible;
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.visible = xml.@visible == "true" ? true : false;
			//vo.uid = String(xml.@uid);
		}
		
		public function copyProperties(obj:FilterVO):void {
			obj.visible = vo.visible;
			obj.index = vo.index;			
		}
		
	}  
}