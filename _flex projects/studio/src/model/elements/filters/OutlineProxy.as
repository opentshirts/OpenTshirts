package model.elements.filters
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class OutlineProxy extends Proxy implements ITintableElementProxy, IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'OutlineProxy';
		public static const OUTLINE_THICKNESS_CHANGE:String = NAME + 'OUTLINE_THICKNESS_CHANGE';
		public static const OUTLINE_COLOR_CHANGE:String = NAME + 'OUTLINE_COLOR_CHANGE';
		private var filterProxy:FilterProxy;
		
		public function OutlineProxy(value_object:Object)  
		{  
			super( NAME, value_object  );  

			
			filterProxy = new FilterProxy(vo);
		}
		override public function getProxyName():String
		{
			return vo.uid;
		}
		override public function onRegister():void
		{
			super.onRegister();

			facade.registerProxy(filterProxy);
		}
		public function setThickness(value:Number):void
		{
			vo.thickness = value;
			
			sendNotification(OUTLINE_THICKNESS_CHANGE,{uid:vo.uid,thickness:vo.thickness},NAME);
		}
		public function setColor(value:DesignColorVO):void
		{
			vo.color = value;
			sendNotification(OUTLINE_COLOR_CHANGE,{uid:vo.uid,color:vo.color},NAME);
		}
		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			if (filter.visible)	colors.push(vo.color);
			return colors;
		}
		public function saveToXML():XML {
			var elementXml:XML = <filter/>;
			elementXml.@name = vo.name;
			elementXml.@color = vo.color.id;
			elementXml.@thickness = vo.thickness;
			elementXml.appendChild(filterProxy.saveToXML());
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.color = designColorListProxy.getColorFromId(String(xml.@color));
			vo.thickness = Number(xml.@thickness);
			filterProxy.loadFromXML(xml.base[0]);
		}
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;
		}
		public function get vo():OutlineVO
		{
			return data as OutlineVO;
		}
		private function get filter():FilterVO
		{
			return data as FilterVO;
		}
		
		public function getCopy():Object
		{
			//return same object with different UID
			var obj:OutlineVO = new OutlineVO();
			obj.color  = vo.color;
			obj.thickness  = vo.thickness;			
			filterProxy.copyProperties(obj);
			
			return obj;
			
		}
		
	}  
}