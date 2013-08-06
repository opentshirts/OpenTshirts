package model.design
{	  
	
	import appFacade.ApplicationConstants;
	
	import flash.utils.ByteArray;
	
	import model.ConfigurationProxy;
	import model.design.vo.CompositionVO;
	
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.RemoteObject;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class SavedCompositionProxy extends Proxy implements IProxy
	{  
		public static const NAME:String = 'SavedCompositionProxy';
		public static const LOADED:String = NAME + 'LOADED';
		public static const IMPORT:String = NAME + 'IMPORT';
		public static const ADD_DESIGN:String = NAME + 'ADD_DESIGN';
		public static const SAVED_SUCCESSFULLY:String = NAME + 'SAVED_SUCCESSFULLY';
		public static const ERROR_SAVING:String = NAME + 'ERROR_SAVING';
		private var ro:RemoteObject;	
		
		public function SavedCompositionProxy()  
		{  
			super( NAME, CompositionVO.getInstance());
		}
		
		public function loadComposition(id_composition:String):void  
		{  
			ro = new RemoteObject;
			ro.destination = 'amfphp';
			ro.source = 'CompositionService';
			
			ro.endpoint =  configurationProxy.vo.gateway;
			
			ro.addEventListener(ResultEvent.RESULT, handleLoadCompositionResult);
			ro.addEventListener(FaultEvent.FAULT, handleLoadCompositionFault);
			ro.loadComposition(id_composition, configurationProxy.vo.studio_id);  
		}  
		
		private function handleLoadCompositionResult(event:ResultEvent):void
		{
			var composition:Object = event.result.composition;
			var designs:Array = event.result.designs;
			
			sendNotification(LOADED,{name:composition.name, id_product:composition.id_product, id_product_color:composition.id_product_color , id_composition: composition.id_composition, designs:designs},NAME);
			
		}
		private function handleLoadCompositionFault(event:FaultEvent):void{
			trace("fault : " + event.message);
			sendNotification(ApplicationConstants.ALERT_ERROR,event.fault.faultString + ": " + event.fault.faultDetail,NAME);
		}
		
		public function importComposition(id_composition:String):void  
		{  
			ro = new RemoteObject;
			ro.destination = 'amfphp';
			ro.source = 'CompositionService';
			
			ro.endpoint =  configurationProxy.vo.gateway;
			
			ro.addEventListener(ResultEvent.RESULT, handleImportCompositionResult);
			ro.addEventListener(FaultEvent.FAULT, handleLoadCompositionFault);
			ro.loadComposition(id_composition, configurationProxy.vo.studio_id); 
		} 
		private function handleImportCompositionResult(event:ResultEvent):void
		{
			var composition:Object = event.result.composition;
			var designs:Array = event.result.designs;
			
			sendNotification(IMPORT,{id_product:composition.id_product, id_product_color:composition.id_product_color , designs:designs},NAME);
			
		} 
		public function importDesign(id_design:String):void  
		{  
			ro = new RemoteObject;
			ro.destination = 'amfphp';
			ro.source = 'CompositionService';
			
			ro.endpoint =  configurationProxy.vo.gateway;
			
			ro.addEventListener(ResultEvent.RESULT, handleImportDesignResult);
			ro.addEventListener(FaultEvent.FAULT, handleLoadCompositionFault);
			ro.loadDesign(id_design);  
		} 
		private function handleImportDesignResult(event:ResultEvent):void
		{
			var design:Object = event.result.design;
			
			sendNotification(ADD_DESIGN,{design:design},NAME);
			
		} 
	
		
		/**
		 * Save composition using AMFPHP CompositionService
		 * */
		public function saveDesign(compositionXML:XML, streams_array:Array, streams_design_array:Array, viewsArray:Array):void  
		{  
			ro = new RemoteObject;
			ro.destination = 'amfphp';
			ro.source = 'CompositionService';
			
			ro.endpoint =  configurationProxy.vo.gateway;
			
			ro.addEventListener(ResultEvent.RESULT, handleResult);
			ro.addEventListener(FaultEvent.FAULT, handleFault);
			ro.saveComposition(compositionXML.toXMLString(), streams_array, configurationProxy.vo.studio_id,  streams_design_array, viewsArray);
		}  
		private function handleResult(event:ResultEvent):void{
			trace("result : " + event.result);
			if(event.result.hasOwnProperty("ERROR"))
			{
				sendNotification(ERROR_SAVING,event.result.ERROR,NAME);
			}else
			{
				compositionProxy.vo.id = event.result.id_composition;
				sendNotification(SAVED_SUCCESSFULLY,event.result.id_composition,NAME);
			}
			
		}
		private function handleFault(event:FaultEvent):void{
			trace("fault : " + event.message);
			sendNotification(ERROR_SAVING,event.message.toString(),NAME);
		}
			

		private function get designColorListProxy():DesignColorListProxy
		{
			return this.facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;
		}
		private function get compositionProxy():CompositionProxy
		{
			return this.facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		private function get configurationProxy():ConfigurationProxy  
		{  
			return this.facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;  
		}  

	}  
}