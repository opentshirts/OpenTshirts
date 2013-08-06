package model
{	  
	import Interfaces.IServiceProxy;
	
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import mx.resources.ResourceBundle;
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class LanguageProxy extends Proxy implements IProxy , IServiceProxy
	{  
		public static const NAME:String = 'LanguageProxy';  	  
		public static const LANGUAGE_READY:String = NAME + 'LANGUAGE_READY'; 
		private var _loaded:Boolean = false; 	  
		
		public function LanguageProxy()
		{  
			super( NAME  );  
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
			_loaded = true;
			
			var myResources:ResourceBundle=new ResourceBundle(String(data.@code),"languageResources");
			for each (var node:XML in data.*)
			{
				myResources.content[String(node.localName())]=String(node);
			}
			ResourceManager.getInstance().addResourceBundle(myResources);
			
			ResourceManager.getInstance().update();
			
			ResourceManager.getInstance().localeChain = [String(data.@code)];

			sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME );  
			sendNotification(LANGUAGE_READY);
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
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
		
	}  
}