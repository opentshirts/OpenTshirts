package view
{
	import appFacade.ApplicationConstants;
	
	import events.ProductEvent;
	
	import model.products.vo.ProductVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import spark.components.List;
	
	import view.components.product.ProductProperties;
	
	  
	public class ProductPropertiesMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ViewsListMediator';  
		  
		protected var viewstList:ProductProperties;  
		  
		public function ProductPropertiesMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent );  
		}
		  
		override public function onRegister():void  
		{  
			viewstList = new ProductProperties();
			viewstList.visible = false;
			viewstList.addEventListener(ProductEvent.VIEW_CHANGE, handleViewChange);
			viewstList.addEventListener(ProductEvent.COLOR_CHANGE, handleColorChange);
			viewstList.addEventListener(ProductEvent.LOAD_PRODUCT_LIST,loadProductList);
			viewComponent.addElement( viewstList );
			
		}
		
		override public function listNotificationInterests():Array  
		{  
			return [ 
				ApplicationConstants.CURRENT_PRODUCT_CHANGE,
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED
			];  
		}  
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();  
			
			  
			switch ( name )  
			{  
				case ApplicationConstants.CURRENT_PRODUCT_CHANGE:
					var product:ProductVO = notification.getBody() as ProductVO;  
					viewstList.colors = product.availableColors;
					viewstList.views = product.views;
					viewstList.producName = product.name;
					viewstList.visible = true;
					break;
				case ApplicationConstants.ELEMENT_SELECTED:
					viewstList.visible = false;
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					viewstList.visible = true;
					break;
			} 
		 }
		
		protected function handleViewChange(e:ProductEvent):void  
		{   
			sendNotification(ApplicationConstants.CHANGE_DESIGN_AREA,List(e.data).selectedItem,UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			List(e.data).selectedIndex = -1;
		}
		private function loadProductList(event:ProductEvent):void
		{
			sendNotification(ApplicationConstants.SHOW_PRODUCT_LIST,null, "ExternalInterfaceMediator");
		}
		protected function handleColorChange(e:ProductEvent):void  
		{   
			sendNotification(ApplicationConstants.CHANGE_PRODUCT_COLOR, e.data , UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
	 }  
}