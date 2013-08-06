package model.elements.cliparts
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	import model.elements.cliparts.vo.LayerVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LayerProxy extends Proxy implements ITintableElementProxy, IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'LayerProxy';
		
		public function LayerProxy(value_object:Object)  
		{  
			super( NAME, value_object  );
		}
		
		override public function getProxyName():String
		{
			return vo.uid;
		}
		
		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			if(vo.visible)
				colors.push(vo.actualColor)
			return colors;
		}

		public function saveToXML():XML {
			var elementXml:XML = <layer/>;
			//elementXml.@uid = vo.uid;
			elementXml.@name = vo.name;
			elementXml.@index = vo.index;
			elementXml.@visible = vo.visible;
			elementXml.@tintable = vo.tintable;
			elementXml.@defaultColor = vo.defaultColor.id;
			elementXml.@actualColor = vo.actualColor.id;
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.actualColor = designColorListProxy.getColorFromId(String(xml.@actualColor));
			vo.defaultColor = designColorListProxy.getColorFromId(String(xml.@defaultColor));
			vo.index = uint(xml.@index);
			vo.name = String(xml.@name);
			vo.tintable = xml.@tintable == "true" ? true : false;
			//vo.uid = String(xml.@uid);
			vo.visible = xml.@visible == "true" ? true : false;
		}
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;
		}
		public function get vo():LayerVO
		{
			return data as LayerVO;
		}
		
		public function getCopy():Object
		{
			//return same object with different UID
			var obj:LayerVO = new LayerVO();
			
			obj.defaultColor  = vo.defaultColor;
			obj.name  = vo.name;
			obj.index  = vo.index;
			obj.actualColor  = vo.actualColor;
			obj.visible  = vo.visible;
			obj.tintable  = vo.tintable;			
			
			return obj;
			
		}
		
	}  
}