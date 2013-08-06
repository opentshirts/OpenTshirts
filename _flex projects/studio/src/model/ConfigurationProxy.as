package model
{	  
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.vo.ConfigurationVO;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	  
	
	public class ConfigurationProxy extends Proxy implements IProxy  
	{  
		public static const NAME:String = 'ConfigurationProxy';  	  
		public static const APP_DATA_READY:String = NAME + 'APP_DATA_READY'; 
		private var ro:RemoteObject; 	  
		
		public function ConfigurationProxy()  
		{  
			super( NAME, new ConfigurationVO() );  
		}
		
		public function getService():void  
		{ 
			var request:URLRequest = new URLRequest(); 
			var loader:URLLoader   = new URLLoader();  
			  
			sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME); 
			
			request.url = ConfigurationVO.dataURL;  
			  
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);  
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			loader.addEventListener(Event.COMPLETE, handleComplete);  
			  
			loader.load( request );  
		}  
		  
		protected function handleComplete(e:Event):void  
		{  
			var data:XML = new XML( e.target.data );
			vo.studio_id = data.studioId;
			vo.gateway = data.gateway;
			vo.productsServiceURL = data.products.@api_link;
			vo.productColorsServiceURL = data.productColors.@api_link;
			vo.designColorsServiceURL = data.designColors.@api_link;
			vo.clipartsServiceURL = data.cliparts.@api_link;
			vo.settingsServiceURL = data.settings.@api_link;
			vo.languageServiceURL = data.language.@api_link;
			vo.fontsServiceURL = data.fonts.@api_link;
			
			sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME); 
			
			sendNotification(ApplicationConstants.STUDIO_ID_CHANGE, vo.studio_id, NAME);  
			sendNotification(APP_DATA_READY);  
		}
		
		 protected function handleProgress(e:ProgressEvent):void  
		{  
			var pct:Number = e.bytesTotal == 0 ? 0 : Math.round( (e.bytesLoaded / e.bytesTotal)*100 );
			sendNotification(ApplicationConstants.LOAD_OBJECT_PROGRESS, { percent:pct }, NAME);  
		}  
		
		protected function onXMLLoadError(_event:IOErrorEvent):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_ERROR, _event.toString()+_event.type, NAME);  
		}
		  
		public function get vo():ConfigurationVO 
		{  
			return data as ConfigurationVO;  
		}
		
		/**
		 * Send price parameters using AMFPHP CompositionService
		 * */
		public function setPriceParameters(viewsArray:Array):void  
		{  
			ro = new RemoteObject;
			ro.destination = 'amfphp';
			ro.source = 'CompositionService';
			
			ro.endpoint =  vo.gateway;
			
			ro.addEventListener(ResultEvent.RESULT, handleResult);
			ro.addEventListener(FaultEvent.FAULT, handleFault);
			ro.setPriceParameters(vo.studio_id, viewsArray);
		}  
		private function handleResult(event:ResultEvent):void{
			trace("result : " + event.result);
			if(event.result.hasOwnProperty("ERROR"))
			{
				sendNotification(ApplicationConstants.ALERT_ERROR,event.result.ERROR,NAME);
			}
			sendNotification(ApplicationConstants.PRICE_PARAMETERS_CHANGE);
		}
		private function handleFault(event:FaultEvent):void{
			trace("fault : " + event.message);
			sendNotification(ApplicationConstants.ALERT_ERROR,event.fault.faultString + ": " + event.fault.faultDetail,NAME);
			sendNotification(ApplicationConstants.PRICE_PARAMETERS_CHANGE);
		}
		
		/**
		 * Send parameters using AMFPHP CompositionService
		 * */
		public function setParamSession(key:String, value:Object):void  
		{  
			ro = new RemoteObject;
			ro.destination = 'amfphp';
			ro.source = 'CompositionService';
			
			ro.endpoint =  vo.gateway;
			
			ro.addEventListener(ResultEvent.RESULT, setParamSessionHandleResult);
			ro.addEventListener(FaultEvent.FAULT, setParamSessionHandleFault);
			ro.setParameter(vo.studio_id, key, value);
		}  
		private function setParamSessionHandleResult(event:ResultEvent):void{
			trace("result : " + event.result);
			if(event.result.hasOwnProperty("ERROR"))
			{
				sendNotification(ApplicationConstants.ALERT_ERROR,event.result.ERROR,NAME);
			}
		}
		private function setParamSessionHandleFault(event:FaultEvent):void{
			trace("fault : " + event.message);
			sendNotification(ApplicationConstants.ALERT_ERROR,event.fault.faultString + ": " + event.fault.faultDetail,NAME);
		}
		
		
	}  
}