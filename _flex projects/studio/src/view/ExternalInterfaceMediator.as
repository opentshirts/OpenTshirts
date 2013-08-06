package view
{
	import appFacade.ApplicationConstants;
	
	import flash.external.ExternalInterface;
	
	import model.design.CompositionProxy;
	import model.design.SavedCompositionProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	

	public class ExternalInterfaceMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ExternalInterfaceMediator';
		 
		
		public function ExternalInterfaceMediator(viewComponent:Object=null)  
		{  
			super( NAME );
		}
		
		override public function onRegister():void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.addCallback("addClipart", addClipartCallback);
				ExternalInterface.addCallback("addText", addTextCallback);
				ExternalInterface.addCallback("setProduct", setProduct);
				ExternalInterface.addCallback("loadComposition", loadComposition);
				ExternalInterface.addCallback("importComposition", importComposition);
				ExternalInterface.addCallback("addTemplate", addTemplate);
				ExternalInterface.addCallback("saveComposition", saveComposition);
				ExternalInterface.addCallback("exportImage", exportImage);
				ExternalInterface.addCallback("changeProductColor", changeProductColor);
				//ExternalInterface.addCallback("changeLanguage", changeLanguage);
				ExternalInterface.addCallback("zoomIn", handleZoomIn);
				ExternalInterface.addCallback("zoomOut", handleZoomOut);
				ExternalInterface.addCallback("zoomArea", handleZoomArea);
				ExternalInterface.addCallback("clearSelection", handleClearSelection);
				ExternalInterface.addCallback("duplicate", handleDuplicate);
				ExternalInterface.addCallback("selectAll", handleSelectAll);
				ExternalInterface.addCallback("fitToArea", handleFitToArea);
				ExternalInterface.addCallback("undo", handleUndo);
				ExternalInterface.addCallback("redo", handleRedo);
				ExternalInterface.addCallback("setCompositionName", setCompositionName);
				ExternalInterface.addCallback("addBitmap", addBitmapCallback);
				ExternalInterface.addCallback("hideUsedColors", hideUsedColors);
				ExternalInterface.addCallback("filterColors", filterColors);
				
				//workarround for mousewheel on firefox
				//http://cookbooks.adobe.com/post_Workaround_to_support_mouse_wheel_for_FireFox_with-13086.html
				ExternalInterface.addCallback("handleWheel", handleWheel);
				
				
			}
		}
		override public function listNotificationInterests():Array  
		{
			return [ 
				ApplicationConstants.READY,
				ApplicationConstants.ALERT_ERROR,
				CompositionProxy.PRODUCT_CHANGED,
				SavedCompositionProxy.ERROR_SAVING,
				SavedCompositionProxy.SAVED_SUCCESSFULLY,
				ApplicationConstants.PRICE_PARAMETERS_CHANGE,
				ApplicationConstants.LOAD_OBJECT_START, 
				ApplicationConstants.LOAD_OBJECT_PROGRESS, 
				ApplicationConstants.LOAD_OBJECT_COMPLETE, 
				ApplicationConstants.LOAD_OBJECT_ERROR,
				ApplicationConstants.SHOW_CLIPART_LIST,
				ApplicationConstants.SHOW_EXPORT_IMAGE,
				ApplicationConstants.SHOW_PRODUCT_LIST,
				ApplicationConstants.STUDIO_ID_CHANGE
			];  
		}
		  
		override public function handleNotification(note:INotification):void
		{
			switch ( note.getName() )
			{
				case ApplicationConstants.READY:
					ExternalInterface.call("onApplicationReady");
					break;
				case ApplicationConstants.ALERT_ERROR:
					ExternalInterface.call("alertError",note.getBody());
					break;
				case CompositionProxy.PRODUCT_CHANGED:
					ExternalInterface.call("onProductChanged", note.getBody());
					break;
				case SavedCompositionProxy.SAVED_SUCCESSFULLY:
					ExternalInterface.call("onSaveDesignCompletedSuccessfully");
					break;
				case SavedCompositionProxy.ERROR_SAVING:
					ExternalInterface.call("saveDesignError",note.getBody());
					break;
				case ApplicationConstants.PRICE_PARAMETERS_CHANGE:
					ExternalInterface.call("onPriceChange");
					break;
				case ApplicationConstants.LOAD_OBJECT_START:
					ExternalInterface.call("onLoadObjectStart");
					break;
				case ApplicationConstants.LOAD_OBJECT_PROGRESS:
					ExternalInterface.call("onLoadObjectProgress",note.getBody().percent);
					break;
				case ApplicationConstants.LOAD_OBJECT_COMPLETE:
					ExternalInterface.call("onLoadObjectComplete");
					break;
				case ApplicationConstants.LOAD_OBJECT_ERROR:
					ExternalInterface.call("onLoadObjectError",note.getBody());
					break;
				case ApplicationConstants.SHOW_CLIPART_LIST:
					ExternalInterface.call("showClipartList",'');
					break;
				case ApplicationConstants.SHOW_PRODUCT_LIST:
					ExternalInterface.call("showProductList");
					break;
				case ApplicationConstants.SHOW_EXPORT_IMAGE:
					ExternalInterface.call("showTemplateList");
					break;
				case ApplicationConstants.STUDIO_ID_CHANGE:
					ExternalInterface.call("onStudioIdChange", note.getBody());
			}
		}
		private function addClipartCallback(id_clipart:String):void
		{
			sendNotification(ApplicationConstants.CREATE_CLIPART,id_clipart, NAME);
		}
		private function addBitmapCallback(id_bitmap:String, source:String, used_colors:Array, hidden_colors:Array):void
		{
			sendNotification(ApplicationConstants.CREATE_BITMAP,{id_bitmap:id_bitmap, source:source, used_colors:used_colors, hidden_colors:hidden_colors}, NAME);
		}
		private function addTextCallback():void
		{
			sendNotification(ApplicationConstants.CREATE_TEXT, null, NAME);
		}
		private function loadComposition(id_composition:String):void
		{
			sendNotification(ApplicationConstants.LOAD_COMPOSITION, id_composition, NAME);
		}
		private function importComposition(id_composition:String):void
		{
			sendNotification(ApplicationConstants.IMPORT_COMPOSITION, id_composition, NAME);
		}
		private function addTemplate(id_design:String):void
		{
			sendNotification(ApplicationConstants.ADD_TEMPLATE, id_design, NAME);
		}
		private function saveComposition():void
		{
			sendNotification(ApplicationConstants.SAVE_COMPOSITION, null, NAME);
		}
		private function setProduct(product_info:Object):void
		{
			sendNotification(ApplicationConstants.CHANGE_PRODUCT,product_info, NAME);
		}
		private function exportImage():void
		{
			sendNotification(ApplicationConstants.EXPORT_IMAGE, null, NAME);
		}
		private function changeProductColor(id_product_color:String):void
		{
			sendNotification(ApplicationConstants.CHANGE_PRODUCT_COLOR, String(id_product_color), UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}		
		private function handleWheel(event:Object):void
		{
			sendNotification(ApplicationConstants.MOUSE_WHEEL, event, NAME);
		}
		/*private function changeLanguage(lang:String):void
		{
			sendNotification(ApplicationConstants.CHANGE_LOCALE, lang, NAME);
		}*/
		private function handleZoomIn():void
		{
			sendNotification(ApplicationConstants.ZOOM_IN, null, NAME);
		}
		private function handleZoomOut():void
		{
			sendNotification(ApplicationConstants.ZOOM_OUT, null, NAME);
		}
		private function handleZoomArea():void
		{
			sendNotification(ApplicationConstants.ZOOM_TO_AREA, null, NAME);
		}
		private function setCompositionName(name:String):void
		{
			sendNotification(ApplicationConstants.CHANGE_COMPOSITION_DATA, {name:name}, NAME);
		}
		private function handleClearSelection():void
		{
			sendNotification(ApplicationConstants.CLEAR_SELECTION,null, NAME);
		}
		private function handleSelectAll():void
		{
			sendNotification(ApplicationConstants.SELECT_ALL,null, NAME);
		}
		private function handleDuplicate():void
		{
			sendNotification(ApplicationConstants.DUPLICATE_ELEMENT,null, NAME);
		}
		private function handleFitToArea():void
		{
			sendNotification(ApplicationConstants.SHORTCUT_MAXIMIZE_ELEMENT,null, NAME);
		}
		private function handleUndo():void
		{
			sendNotification(ApplicationConstants.UNDO,null, NAME);
		}
		private function handleRedo():void
		{
			sendNotification(ApplicationConstants.REDO,null, NAME);
		}
		private function hideUsedColors():void
		{
			sendNotification(ApplicationConstants.HIDE_COLORS_USED_PANEL,null, NAME);
		}
		private function filterColors(colors:Array):void
		{
			sendNotification(ApplicationConstants.FILTER_COLORS,{colors:colors}, NAME);
		}
		
		
		
		
		
		

	}  
}