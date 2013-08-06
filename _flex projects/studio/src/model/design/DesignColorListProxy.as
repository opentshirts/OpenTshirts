package model.design
{	  
	import Interfaces.IServiceProxy;
	
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.design.vo.DesignColorVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DesignColorListProxy extends Proxy implements IProxy , IServiceProxy
	{  
		public static const NAME:String = 'DesignColorListProxy';  	  
		public static const DESIGN_COLORS_READY:String = NAME + 'DESIGN_COLORS_READY';
		public static const DESIGN_COLORS_CHANGE:String = NAME + 'DESIGN_COLORS_CHANGE';
		public static const CANVAS_COLOR_CHANGE:String = NAME + 'CANVAS_COLOR_CHANGE';
		
		
		private var _loaded:Boolean = false; 	
		
		private var _whiteBaseColor:DesignColorVO;
		private var _canvasColor:DesignColorVO;
		private var _defaultColor:DesignColorVO;
		
		private var _allColors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
		private var _filteredColors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
		private var _colorsFilterArray:Array;
		
		public function DesignColorListProxy()
		{  
			super( NAME); 
			
			_whiteBaseColor = new DesignColorVO();
			_whiteBaseColor.id = DesignColorVO.WHITEBASE;
			_whiteBaseColor.name = "(WHITE BASE)";
			_whiteBaseColor.hexa = 0xFFFFFF;
			_whiteBaseColor.need_white_base = false;
			_whiteBaseColor.isdefault = true;
			_whiteBaseColor.alpha = 1;
			//addItem(_whiteBaseColor);
			
			_canvasColor = new DesignColorVO();
			_canvasColor.id = DesignColorVO.PRODUCTCOLOR;
			_canvasColor.name = "(PRODUCT COLOR)";
			//_canvasColor.hexa = 0xFF0000;
			_canvasColor.alpha = 1;
			_canvasColor.isdefault = true;
			_canvasColor.need_white_base = false;
			addItem(_canvasColor);
		}
		
		public function getService(url:String):void  
		{  
			var request:URLRequest = new URLRequest(); 
			var loader:URLLoader   = new URLLoader();  
			  
			sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME); 
			
			request.url = url;  
			
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);  
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			loader.addEventListener(Event.COMPLETE, handleComplete);  
			  
			loader.load( request );  
		}  
		  
		protected function handleComplete(e:Event):void  
		{  
			var data:XML = new XML( e.target.data );
			if(data.error != undefined) {
				sendNotification(ApplicationConstants.ALERT_ERROR,String(data.error));
			} else {
				for each ( var colorXML:XML in data.design_color )  
				{
					var colorVO:DesignColorVO = new DesignColorVO();
					colorVO.id = String(colorXML.id);
					colorVO.name = colorXML.name;
					colorVO.hexa = uint("0x"+colorXML.hexa);
					colorVO.alpha = Number(colorXML.alpha)/100;
					colorVO.need_white_base = String(colorXML.need_white_base) == "1" ? true : false;
					colorVO.isdefault = String(colorXML.isdefault) == "1" ? true : false;
					addItem(colorVO);
					
					if(colorXML.hexa=="000000") {
						_defaultColor = colorVO;
					}
				}
				_loaded = true;
				
				this.filterColors(_colorsFilterArray);
				
				sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME  );  
				sendNotification(DESIGN_COLORS_READY, designColors);  
				sendNotification(DESIGN_COLORS_CHANGE, designColors);  
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
		
		public function get designColors():Vector.<DesignColorVO>
		{
			if(_filteredColors.length > 0) {
				return _filteredColors;
			} else {
				return _allColors;
			}
		}
		public function updateCanvasColor(hexa:uint):void
		{
			_canvasColor.hexa = hexa;
			sendNotification(CANVAS_COLOR_CHANGE, hexa, NAME);  
		}
		// add an item to the data    
		public function addItem( item:DesignColorVO ):void
		{
			_allColors.push( item );
		}
		
		public function getColorFromId(id:String):DesignColorVO
		{
			if(id==_whiteBaseColor.id) {
				return _whiteBaseColor;
			}
			for ( var i:int=0; i<designColors.length; i++ ) {
				if ( designColors[i].id == id ) {
					return designColors[i];
				}
			}
			return this.getDefaultColor();
		}
		public function filterColors(colorsFilter:Array):void
		{
			_colorsFilterArray = colorsFilter;
			
			_filteredColors = _allColors.filter(this.filter);
			
			sendNotification(DESIGN_COLORS_CHANGE, designColors);
			
		}
		
		private function filter(item:DesignColorVO, index:int, vector:Vector.<DesignColorVO>):Boolean {
			if(item.isdefault) {
				return true;
			}
			if(_colorsFilterArray) {
				for ( var i:int=0; i<_colorsFilterArray.length; i++ ) {
					if ( _colorsFilterArray[i] == item.id) {
						return true;
					}
				}	
			}
			return false;
		}

		public function getDefaultColor():DesignColorVO
		{
			if(_defaultColor) {
				return _defaultColor;
			} else {
				return designColors[1];			
			}
		}
		public function get whiteBaseColor():DesignColorVO
		{
			return _whiteBaseColor;
		}
		public function get canvasColor():DesignColorVO
		{
			return _canvasColor;
		}
		public function get loaded():Boolean
		{
			return _loaded;
		}
	}  
}