package view
{
	import appFacade.ApplicationConstants;
	
	import flash.utils.ByteArray;
	
	import model.design.CompositionProxy;
	import model.products.vo.ProductVO;
	import model.products.vo.RegionVO;
	import model.products.vo.ViewVO;
	
	import mx.core.IVisualElementContainer;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;

	
	
	public class CurrentProductMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'CurrentProductMediator';  
		
		private var productsContainer:Group;
		private var currentProductVO:ProductVO;
		private var currentProductViewMediator:ProductViewMediator;
		
		  
		public function CurrentProductMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent );
			
			productsContainer = new Group();

			compositionContainer.addElement(productsContainer);			
		}

		override public function listNotificationInterests():Array  
		{  
			return [
				ApplicationConstants.CURRENT_PRODUCT_CHANGE,
				CompositionProxy.CURRENT_DESIGN_AREA_CHANGED
			];
		}
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();
			switch ( name )
			{
				case ApplicationConstants.CURRENT_PRODUCT_CHANGE:
					handleProductChange(ProductVO(notification.getBody()));
					break;
				case CompositionProxy.CURRENT_DESIGN_AREA_CHANGED:
					var region:RegionVO = notification.getBody() as RegionVO;
					currentProductViewMediator = facade.retrieveMediator(ProductViewMediator.NAME+region.view.uid) as ProductViewMediator;
					break;
			}

		}
		private function handleProductChange(vo:ProductVO):void
		{
			clearCurrentProductViewMediators();
			
			currentProductVO = vo;
			
			addCurrentProductViewMediators();
			
		}
		private function addCurrentProductViewMediators():void
		{
			for each (var viewVO:ViewVO in currentProductVO.views) 
			{
				var med:ProductViewMediator = new ProductViewMediator(viewVO);
				productsContainer.addElement(med.productViewComponent);
				facade.registerMediator(med);
			}
		}
		private function clearCurrentProductViewMediators():void
		{
			if(currentProductVO)
			{
				for each (var productView:ViewVO in currentProductVO.views) 
				{
					var med:ProductViewMediator = facade.retrieveMediator(ProductViewMediator.NAME+productView.uid) as ProductViewMediator; 
					productsContainer.removeElement(med.productViewComponent);
					facade.removeMediator(med.getMediatorName());
				}
				
			}
		}
		public function getSnapshots():Array
		{
			if(!currentProductVO)
			{
				return null;
			}
			var snapshots:Array = new Array();
			for each (var productView:ViewVO in currentProductVO.views) 
			{
				var med:ProductViewMediator = facade.retrieveMediator(ProductViewMediator.NAME+productView.uid) as ProductViewMediator; 
				var byteArray:ByteArray = med.getProductSnapshot();
				if(byteArray)
				{
					snapshots.push(byteArray);
				}	
			}
			return snapshots;
		}
		public function getDesignSnapshots():Array
		{
			if(!currentProductVO)
			{
				return null;
			}
			var snapshots:Array = new Array();
			for each (var productView:ViewVO in currentProductVO.views) 
			{
				var med:ProductViewMediator = facade.retrieveMediator(ProductViewMediator.NAME+productView.uid) as ProductViewMediator; 
				var byteArray:ByteArray = med.getDesignSnapshot();
				if(byteArray)
				{
					snapshots.push(byteArray);
				}	
			}
			return snapshots;
		}
		public function getCurrentViewSnapshot():ByteArray
		{
			if(!currentProductViewMediator)
			{
				return null;
			}
			return currentProductViewMediator.getDesignSnapshot();
		}
		private function get compositionContainer():IVisualElementContainer
		{
			return this.viewComponent as IVisualElementContainer;
		}
	 }  
}