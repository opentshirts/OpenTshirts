package controller
{
	import appFacade.ApplicationConstants;
	
	import model.ConfigurationProxy;
	import model.design.CompositionProxy;
	import model.products.ProductColorListProxy;
	import model.products.ProductProxy;
	import model.products.vo.ProductVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	//MAPPED WITH ApplicationConstants.CHANGE_PRODUCT
	public class ChangeProductCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{
			if ( !(String(notification.getBody().id_product)) )
			{
				throw new Error("Could not execute " + this + ". id_product(String) expected in the body of the note");
			}
			
			var id_product:String = String(notification.getBody().id_product);
			//set composition's current product
			compositionProxy.productID = id_product;
			
			var productProxy:ProductProxy = facade.retrieveProxy(ProductProxy.NAME+id_product) as ProductProxy;
			var product:ProductVO;
			if(productProxy==null) {//proxy is not registered yet
				///create and register new proxy and vo
				product = new ProductVO();
				product.id = id_product;
				product.apiLink = configurationProxy.vo.productsServiceURL+product.id;
				
				if(notification.getBody().id_product_color is String)
				{
					var id_product_color:String = String(notification.getBody().id_product_color);
					product.currentColor = productColorListProxy.getItemFromId(id_product_color);
				}
				productProxy = new ProductProxy(product);
				facade.registerProxy(productProxy);
			}
			
			productProxy.getService();
			
			
		}
		
		private function get configurationProxy():ConfigurationProxy  
		{  
			return facade.retrieveProxy(ConfigurationProxy.NAME) as ConfigurationProxy;
		}
		private function get compositionProxy():CompositionProxy  
		{  
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;  
		}
		private function get productColorListProxy():ProductColorListProxy
		{
			return facade.retrieveProxy( ProductColorListProxy.NAME ) as ProductColorListProxy;
		}
	}
}