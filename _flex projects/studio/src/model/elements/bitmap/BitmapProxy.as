package model.elements.bitmap
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IDesignElement;
	import Interfaces.IDesignElementProxy;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	import model.elements.DesignElementProxy;
	import model.elements.bitmap.vo.BitmapVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class BitmapProxy extends Proxy implements IDesignElementProxy , ITintableElementProxy, IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'BitmapProxy';
		public static const SOURCE_CHANGE:String = NAME + 'SOURCE_CHANGE';
		public static const COLORS_CHANGE:String = NAME + 'COLORS_CHANGE';
		public static const HIDDEN_COLORS_CHANGE:String = NAME + 'HIDDEN_COLORS_CHANGE';
		
		private var designElementProxy:DesignElementProxy;
		
		public function BitmapProxy(value_object:Object)  
		{  
			super( NAME, value_object  );
			
			designElementProxy = new DesignElementProxy(vo);
			
		}
		override public function onRegister():void
		{
			super.onRegister();
			/* registrar tambien con DesignElementProxy que se ocupa de cambios en ancho alto x y rot etc */
			facade.registerProxy(designElementProxy);
		}
		override public function getProxyName():String
		{
			return vo.uid;
		}
		
		public function setSource(src:String):void
		{
			vo.source = src;
			sendNotification(SOURCE_CHANGE,{uid:vo.uid} , NAME);
		}
		public function setColors(colors:Vector.<DesignColorVO>):void
		{
			vo.colors = colors;
			sendNotification(COLORS_CHANGE,{uid:vo.uid} , NAME);
		}
		public function setHiddenColors(hidden_colors:Vector.<uint>):void
		{
			vo.hidden_colors = hidden_colors;
			sendNotification(HIDDEN_COLORS_CHANGE,{uid:vo.uid} , NAME);
		}
		public function setIdBitmap(id_bitmap:String):void
		{
			vo.id_bitmap = id_bitmap;
		}	
		
		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			colors = colors.concat(vo.colors);
			colors = colors.concat(designElementProxy.getColors());
			return colors;
		}
		
		public function saveToXML():XML {
			var elementXml:XML = <design_element/>;
			elementXml.@id = vo.id_bitmap
			elementXml.@type = vo.type;
			elementXml.@source = vo.source;
			
			var hiddenColorsXml:XML = <hidden_colors/>;
			for (var i:uint=0; i<vo.hidden_colors.length; i++) {
				var h_col:XML = <color/>;
				h_col.@uint = vo.hidden_colors[i];
				hiddenColorsXml.appendChild(h_col);
			}
			elementXml.appendChild(hiddenColorsXml);
			
			var colorsXml:XML = <colors/>;
			for (var j:uint=0; j<vo.colors.length; j++) {
				var col:XML = <color/>;
				col.@id = vo.colors[j].id;
				colorsXml.appendChild(col);
			}
			elementXml.appendChild(colorsXml);
			
			elementXml.appendChild(designElementProxy.saveToXML());
			
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.source = String(xml.@source);
			vo.id_bitmap = String(xml.@id);
			
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			for each ( var colorXML:XML in xml.colors.color )  
			{
				var colorVO:DesignColorVO = designColorListProxy.getColorFromId(colorXML.@id);
				if(colorVO) {
					colors.push(colorVO);
				}
			}				
			setColors(colors);
			
			
			var hidden_colors:Vector.<uint> = new Vector.<uint>();
			for each ( var hidden_colorXML:XML in xml.hidden_colors.color )  
			{
				var cuint:uint = uint(hidden_colorXML.@uint);
				hidden_colors.push(hidden_colorXML.@uint);
			}
			setHiddenColors(hidden_colors);
			
			designElementProxy.loadFromXML(xml.base[0]);
			
		}
		
		public function get vo():BitmapVO
		{
			return data as BitmapVO;
		}
		public function get designElement():IDesignElement
		{
			return data as IDesignElement;
		}
		private function get designColorListProxy():DesignColorListProxy
		{  
			return facade.retrieveProxy(DesignColorListProxy.NAME) as DesignColorListProxy;
		}
		
		public function getCopy():Object
		{
			//return same object with different UID
			var obj:BitmapVO = new BitmapVO();
			obj.id_bitmap  = vo.id_bitmap;
			obj.source  = vo.source;
			obj.colors  = vo.colors.concat();
			obj.hidden_colors  = vo.hidden_colors.concat();			
			designElementProxy.copyProperties(obj);
			
			return obj;
			
		}
		
	}  
}