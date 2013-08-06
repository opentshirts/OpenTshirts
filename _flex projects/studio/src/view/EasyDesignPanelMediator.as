package view
{
	import appFacade.ApplicationConstants;
	
	import events.ClipartEvent;
	import events.ProductEvent;
	import events.TextEvent;
	
	import flash.external.ExternalInterface;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.designElement.EasyDesignPanel;
	
	public class EasyDesignPanelMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'EasyDesignPanelMediator';
		protected var propertiesView:EasyDesignPanel;
		private var _elementuid:String;
		public function EasyDesignPanelMediator(viewComponent:Object)
		{
			super(NAME, viewComponent);
		}
		override public function onRegister():void  
		{
			propertiesView = new EasyDesignPanel();
			propertiesView.visible = true;
			propertiesView.addEventListener(TextEvent.TEXT_ADD,handleAddText);
			propertiesView.addEventListener(ClipartEvent.LOAD_CLIPART_LIST,loadClipartList);
			propertiesView.addEventListener(ProductEvent.LOAD_EXPORT_IMAGE,loadExportImage);
			propertiesView.addEventListener(ProductEvent.LOAD_PRODUCT_LIST,loadProductList);
			propertiesView.addEventListener(ProductEvent.SAVE_DESIGN,saveDesign);
			viewComponent.addElement( propertiesView );
		}
		private function handleAddText(event:TextEvent):void
		{
			
			sendNotification(ApplicationConstants.CREATE_TEXT, null, NAME);		
		}
		private function loadClipartList(event:ClipartEvent):void
		{
			sendNotification(ApplicationConstants.SHOW_CLIPART_LIST,null, "ExternalInterfaceMediator");
			
		}
		private function loadExportImage(event:ProductEvent):void
		{
			sendNotification(ApplicationConstants.SHOW_EXPORT_IMAGE,null, "ExternalInterfaceMediator");
		}
		private function loadProductList(event:ProductEvent):void
		{
			sendNotification(ApplicationConstants.SHOW_PRODUCT_LIST,null, "ExternalInterfaceMediator");
		}
		private function saveDesign(event:ProductEvent):void
		{
			/*var obj:Object = new Object();
			obj.id_product = "95"//"40";
			obj.id_product_color = "01732976-ad0f-11e1-b67a-0026b953001b"//"0d0b8d19-ad00-11e1-b67a-0026b953001b";
			sendNotification(ApplicationConstants.CHANGE_PRODUCT,obj, "ExternalInterfaceMediator");*/
		}
	}
}