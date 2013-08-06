package model.elements.text
{	  
	import Interfaces.IServiceProxy;
	
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.elements.text.vo.FontVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class FontListProxy extends Proxy implements IProxy  , IServiceProxy
	{  
		public static const NAME:String = 'FontListProxy';  	  
		public static const FONTS_READY:String = NAME + 'FONTS_READY';	  
		private var _loaded:Boolean = false; 	
		
		public function FontListProxy()
		{  
			super( NAME, new ArrayCollection  );  
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
			
				for each ( var fontXML:XML in data.font )  
				{
					var fontVO:FontVO = new FontVO();
					fontVO.id = String(fontXML.id);
					fontVO.name = fontXML.name;
					fontVO.swf_src =  fontXML.swf_file;
					fontVO.preview_src = fontXML.preview;				
					addItem(fontVO);
				}
				
				_loaded = true;
				
				sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME);   
				sendNotification(FONTS_READY, fonts);  
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
		
		public function get fonts():ArrayCollection
		{
			return data as ArrayCollection;
		}
		public function getDefaultFont():String
		{
			if(fonts.length>0) 
			{
				if(getFontByName("College Slab")) {
					return getFontByName("College Slab").name;
				} else {
					return FontVO(fonts[0]).name;
				}
			} else 
			{
				return '';
			}
		}
		public function getFontByName(fname:String):FontVO
		{
			for each (var font:FontVO in fonts)
			{
				if(font.name == fname)
				{
					return font;
				}
			}
			return null;
		}
		
		
		// add an item to the data    
		public function addItem( item:Object ):void
		{
			fonts.addItem( item );
		}
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
	}  
}