package model.elements.filters
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ShadowProxy extends Proxy implements ITintableElementProxy, IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'ShadowProxy';
		public static const SHADOW_THICKNESS_CHANGE:String = NAME + 'SHADOW_THICKNESS_CHANGE';
		public static const SHADOW_DISTANCE_CHANGE:String = NAME + 'SHADOW_DISTANCE_CHANGE';
		public static const SHADOW_ANGLE_CHANGE:String = NAME + 'SHADOW_ANGLE_CHANGE';
		public static const SHADOW_COLOR_CHANGE:String = NAME + 'SHADOW_COLOR_CHANGE';
		
		private var filterProxy:FilterProxy;
		
		public function ShadowProxy(value_object:Object)  
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
			
			sendNotification(SHADOW_THICKNESS_CHANGE,{uid:vo.uid,thickness:vo.thickness},NAME);
		}
		public function setColor(value:DesignColorVO):void
		{
			vo.color = value;
			
			sendNotification(SHADOW_COLOR_CHANGE,{uid:vo.uid,color:vo.color},NAME);
		}
		public function setAngle(value:Number):void
		{
			vo.angle = value;
			
			sendNotification(SHADOW_ANGLE_CHANGE,{uid:vo.uid,angle:vo.angle},NAME);
		}
		public function setDistance(value:Number):void
		{
			vo.distance = value;
			
			sendNotification(SHADOW_DISTANCE_CHANGE,{uid:vo.uid,distance:vo.distance},NAME);
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
			elementXml.@angle = vo.angle;
			elementXml.@distance = vo.distance;
			elementXml.@thickness = vo.thickness;
			elementXml.appendChild(filterProxy.saveToXML());
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.color = designColorListProxy.getColorFromId(String(xml.@color));
			vo.thickness = Number(xml.@thickness);
			vo.angle = Number(xml.@angle);
			vo.distance = Number(xml.@distance);
			filterProxy.loadFromXML(xml.base[0]);
		}
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;
		}
		public function get vo():ShadowVO
		{
			return data as ShadowVO;
		}
		private function get filter():FilterVO
		{
			return data as FilterVO;
		}
		
		public function getCopy():Object
		{
			//return same object with different UID
			var obj:ShadowVO = new ShadowVO();
			obj.color  = vo.color;
			obj.thickness  = vo.thickness;	
			obj.distance  = vo.distance;	
			obj.angle  = vo.angle;	
			filterProxy.copyProperties(obj);
			
			return obj;
			
		}	
		
	}  
}