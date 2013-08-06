package model.elements.cliparts
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IDesignElement;
	import Interfaces.IDesignElementProxy;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	import model.elements.DesignElementProxy;
	import model.elements.cliparts.vo.ClipartVO;
	import model.elements.cliparts.vo.LayerVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ClipartProxy extends Proxy implements IDesignElementProxy , ITintableElementProxy, IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'ClipartProxy';
		public static const CLIPART_DATA_READY:String = NAME + 'CLIPART_DATA_READY';
		public static const COLOR_STATE_CHANGED:String = NAME + 'COLOR_STATE_CHANGED';
		public static const LAYER_COLOR_CHANGED:String = NAME + 'LAYER_COLOR_CHANGED';
		public static const INVERTED:String = NAME + 'INVERTED';
		
		private var designElementProxy:DesignElementProxy;
		
		public function ClipartProxy(value_object:Object)  
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
		public function getService():void  
		{  
			if(vo.dataLoaded===true)
			{
				trace("data xml already loaded.")
				return;
			}
			
			var request:URLRequest = new URLRequest(); 
			var loader:URLLoader   = new URLLoader();  
			  
			sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME); 
			
			request.url = vo.api_link;  
			  
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);  
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			loader.addEventListener(Event.COMPLETE, handleComplete);  
			
			loader.load( request );  
		}  
		  
		protected function handleComplete(e:Event):void  
		{  
			var clipartXML:XML  = new XML( e.target.data );
			
			vo.id_clipart = String(clipartXML.id_clipart);
			vo.name = clipartXML.name;
			vo.swf_file = clipartXML.swf_file;
			var i:uint = 0;
			for each ( var layerXML:XML in clipartXML.layers.layer)  
			{
				var layerVO:LayerVO = new LayerVO();
				layerVO.index = i;
				var color:DesignColorVO = designColorListProxy.getColorFromId(String(layerXML.design_color));
				layerVO.defaultColor = color;
				layerVO.actualColor = color;
				layerVO.name = unescape(layerXML.name);
				//vo.layers.addItem(layerVO);
				vo.layers.push(layerVO);
				
				var layerProxy:LayerProxy = new LayerProxy(layerVO);
				facade.registerProxy(layerProxy);
				
				i++;
			}

			vo.dataLoaded = true;
			
			sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME  );
			sendNotification(CLIPART_DATA_READY, {uid:vo.uid}, NAME  );
			
			//default state
			

			if(vo.layers.length>=2)
			{
				setColorState(ClipartColorStateEnum.DUO_COLOR);
			} else {
				setColorState(ClipartColorStateEnum.ONE_COLOR);
			}
			
		}
		
		protected function handleProgress(e:ProgressEvent):void  
		{
			var pct:Number = e.bytesTotal == 0 ? 0 : Math.round( (e.bytesLoaded / e.bytesTotal)*100 );
			sendNotification(ApplicationConstants.LOAD_OBJECT_PROGRESS, {percent:pct}, NAME);
		}
		protected function onXMLLoadError(_event:IOErrorEvent):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_ERROR, _event.toString()+_event.type, NAME); 
		}
		
		public function setColorState(value:uint):void
		{
			switch(value) 
			{ 
				case ClipartColorStateEnum.ONE_COLOR: 
					setOneColor();
					break; 
				case ClipartColorStateEnum.DUO_COLOR: 
					setTwoColors();
					break; 
				case ClipartColorStateEnum.FULL_COLOR: 
					setFullColor();
					break; 
				default: 
					throw new Error("Not a valid state: "+value); 
					break; 
			}
		}
		private function setOneColor():void 
		{
			vo.colorState = ClipartColorStateEnum.ONE_COLOR;
			
			hideAndDisableLayers();
			
			///set outline color as background and set dummy base to default
			if (vo.layers.length>0) {//dummy
				if(!vo.inverted)
				{
					vo.layers[0].actualColor = vo.layers[0].defaultColor
					vo.layers[0].tintable = true;
					vo.layers[0].visible = true;
				}else
				{
					vo.layers[0].actualColor = designColorListProxy.canvasColor;
				}
			}
			if (vo.layers.length>1) {//outline
				if(!vo.inverted)
				{
					vo.layers[1].actualColor = designColorListProxy.canvasColor;
				}else
				{
					vo.layers[1].actualColor = vo.layers[1].defaultColor;
					vo.layers[1].tintable = true;
					vo.layers[1].visible = true;
				}
			}
			sendNotification(COLOR_STATE_CHANGED,{uid:vo.uid, colorState:vo.colorState, layers:vo.layers} , NAME);
		}
		private function setTwoColors():void 
		{
			vo.colorState = ClipartColorStateEnum.DUO_COLOR;
			
			hideAndDisableLayers();
			
			if (vo.layers.length>0) {//dummy
				vo.layers[0].actualColor = vo.layers[0].defaultColor
				vo.layers[0].tintable = true;
				vo.layers[0].visible = true;
			}
			if (vo.layers.length>1) {//outline
				vo.layers[1].actualColor = vo.layers[1].defaultColor;
				vo.layers[1].tintable = true;
				vo.layers[1].visible = true;
			}
			sendNotification(COLOR_STATE_CHANGED, {uid:vo.uid, colorState:vo.colorState, layers:vo.layers}, NAME);
		}
		private function setFullColor():void 
		{
			vo.colorState = ClipartColorStateEnum.FULL_COLOR;
			///show all layers
			for (var i:int = 0; i < vo.layers.length; i++) 
			{
				//show layers
				vo.layers[i].tintable = true;
				vo.layers[i].visible = true;
				//set to default color
				vo.layers[i].actualColor = vo.layers[i].defaultColor;
			}
			///tint dummy base to white and disable edit
			if (vo.layers.length>0) { 
				vo.layers[0].actualColor = designColorListProxy.whiteBaseColor;
				vo.layers[0].tintable = false;
				vo.layers[0].visible = true;
			};
			sendNotification(COLOR_STATE_CHANGED, {uid:vo.uid, colorState:vo.colorState, layers:vo.layers}, NAME);
		}
		private function hideAndDisableLayers():void
		{
			for (var i:int = 0; i < vo.layers.length; i++) 
			{
				vo.layers[i].visible = false;
				vo.layers[i].tintable = false;
			}
		}
		public function invert():void 
		{
			if ((vo.colorState == ClipartColorStateEnum.ONE_COLOR) && vo.layers.length>1) 
			{
				vo.inverted = !vo.inverted;
				
				var auxEnabled:Boolean = vo.layers[0].tintable;
				var auxColor:DesignColorVO = vo.layers[0].actualColor;
				var auxVisible:Boolean = vo.layers[0].visible;
				//var auxAlpha:Number = vo.layers[0].alpha;
				
				vo.layers[0].tintable = vo.layers[1].tintable;
				vo.layers[0].actualColor = vo.layers[1].actualColor;
				vo.layers[0].visible = vo.layers[1].visible;
				//vo.layers[0].alpha = vo.layers[1].alpha;
				
				vo.layers[1].tintable = auxEnabled;
				vo.layers[1].actualColor = auxColor;
				vo.layers[1].visible = auxVisible;
				//vo.layers[1].alpha = auxAlpha;
				
				sendNotification(INVERTED, {uid:vo.uid, inverted:vo.inverted, layers:vo.layers} , NAME);
			} 
			else 
			{
				throw new Error("Invert function called in no ONE COLOR State mode or there is no clipart layers");
				return;
			}
		}
		public function setColorAlpha(index:uint, color:DesignColorVO):void 
		{
			if (index>=vo.layers.length) {
				throw new Error("Index out of range");
				return;
			}
			vo.layers[index].actualColor = color;
			sendNotification(LAYER_COLOR_CHANGED, {uid:vo.uid, layers:vo.layers} , NAME);
		}
		/**
		 * return ArrayCollection of tintable layers only.
		 * */
		public function getCurrentLayers():ArrayCollection
		{
			var current:ArrayCollection = new ArrayCollection();
			for each ( var layer:LayerVO in vo.layers)
			{
				if(layer.tintable)
					current.addItem(layer);
			}
			return current;
		}
		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			for each ( var layer:LayerVO in vo.layers)
			{
				var proxy:ITintableElementProxy = facade.retrieveProxy(layer.uid) as ITintableElementProxy;
				colors = colors.concat(proxy.getColors());
			}
			colors = colors.concat(designElementProxy.getColors());
			return colors;
		}
		public function saveToXML():XML {
			var elementXml:XML = <design_element/>;
			elementXml.@type = vo.type;
			elementXml.@id = vo.id_clipart;
			elementXml.@name = vo.name;
			elementXml.@swf_file = vo.swf_file;
			elementXml.@colorState = vo.colorState;
			elementXml.@inverted = vo.inverted;
			elementXml.@dataLoaded = vo.dataLoaded;
			//elementXml.@visible_colors = getColorsString();
			elementXml.appendChild(designElementProxy.saveToXML());
			var layersXml:XML = <layers/>;
			for (var i:uint=0; i<vo.layers.length; i++) {
				var proxy:IXMLProxy = facade.retrieveProxy(vo.layers[i].uid) as IXMLProxy;
				layersXml.appendChild(proxy.saveToXML())
			}
			elementXml.appendChild(layersXml);
			return elementXml;
		}
		protected function getColorsString():String
		{
			var vector:Vector.<DesignColorVO> = this.getColors();
			var str:String = "";
			var separator:String = "";
			for each(var color:DesignColorVO in vector)
			{
				str += separator + color.id;
				separator = ",";
			}
			return str;
		}
		public function getColorState():uint
		{
			return vo.colorState;
		}
		public function loadFromXML(xml:XML):void {
			vo.colorState = uint(xml.@colorState);
			vo.dataLoaded = xml.@dataLoaded == "true" ? true : false;
			vo.id_clipart = String(xml.@id);
			vo.inverted = xml.@inverted == "true" ? true : false;
			vo.name = String(xml.@name);
			vo.swf_file = String(xml.@swf_file);
			for each ( var layerXML:XML in xml.layers.layer )  
			{
				var layer:LayerVO = new LayerVO();
				vo.layers.push(layer);
				var layerProxy:LayerProxy = new LayerProxy(layer);
				layerProxy.loadFromXML(layerXML);
				facade.registerProxy(layerProxy);
			}
			designElementProxy.loadFromXML(xml.base[0]);
			
		}
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy(DesignColorListProxy.NAME) as DesignColorListProxy;
		}

		
		public function get vo():ClipartVO
		{
			return data as ClipartVO;
		}
		public function get designElement():IDesignElement
		{
			return data as IDesignElement;
		}
		
		
		public function getCopy():Object
		{
			//return same object with different UID
			var obj:ClipartVO = new ClipartVO();

			obj.id_clipart  = vo.id_clipart;
			obj.name  = vo.name;
			obj.thumb_src  = vo.thumb_src;
			obj.api_link  = vo.api_link;
			obj.swf_file  = vo.swf_file;
			obj.colorState  = vo.colorState;
			obj.inverted  = vo.inverted;
			obj.dataLoaded  = vo.dataLoaded;
			
			for each (var layerVO:LayerVO in vo.layers) 
			{
				var clonableProxy:IClonableProxy = facade.retrieveProxy(layerVO.uid) as IClonableProxy;
				var lay_clone:LayerVO = LayerVO(clonableProxy.getCopy());
				var layerProxy:LayerProxy = new LayerProxy(lay_clone);
				facade.registerProxy(layerProxy);
				obj.layers.push(lay_clone);
			}
					
			designElementProxy.copyProperties(obj);
			
			return obj;
			
		}
		
	}  
}