package model
{	  
	import Interfaces.IServiceProxy;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.vo.SettingsVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import appFacade.ApplicationConstants;
	
	public class SettingsProxy extends Proxy implements IProxy , IServiceProxy
	{  
		public static const NAME:String = 'SettingsProxy';  	  
		public static const SETTINGS_READY:String = NAME + 'SETTINGS_READY'; 
		public static const CHANGE_LOCALE:String = NAME + 'CHANGE_LANGUAGE'; 
		private var _loaded:Boolean = false; 	  
		
		public function SettingsProxy()
		{  
			super( NAME, new SettingsVO  );  
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
			//vo.defaultLoc = data.config_language;
			_loaded = true;
			
			//setLocale(vo.defaultLoc);
			
			sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME );  
			sendNotification(SETTINGS_READY, vo);
		}
		public function setLocale(loc:String):void
		{
			/*vo.currentLoc = loc;
			sendNotification(CHANGE_LOCALE, vo.currentLoc, NAME);*/
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
		
		public function get vo():SettingsVO
		{
			return data as SettingsVO;
		}
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
	}  
}