package controller
{
	import appFacade.ApplicationConstants;
	
	import model.ConfigurationProxy;
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	import model.design.UsedColorPaletteProxy;
	import model.products.ProductProxy;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	// mapped with UsedColorPaletteProxy.PALETTE_CHANGE
	public class UpdatePriceCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var viewsArray:Array = new Array();
			var productProxy:ProductProxy = facade.retrieveProxy(ProductProxy.NAME+compositionProxy.productID) as ProductProxy;
			if(productProxy) {
				for each(var product_view:ViewVO in productProxy.vo.views)
				{
					if(product_view.design)
					{
						var usedColorPaletteProxy:UsedColorPaletteProxy = facade.retrieveProxy(UsedColorPaletteProxy.NAME+product_view.design.uid) as UsedColorPaletteProxy;
						//does some color need whitebase?
						var colors_need_whitebase:Boolean = usedColorPaletteProxy.getNeedWhiteBase();
						var designProxy:DesignProxy = facade.retrieveProxy(product_view.design.uid) as DesignProxy;
						//is there some clipart in full state?
						var clipart_need_white_base:Boolean = designProxy.hasClipartFullColor();
						//If some color needs a white base OR there is at least one clipart in fullstate, then we need to apply a white base.
						var need_white_base:Boolean  = (colors_need_whitebase || clipart_need_white_base);
						
						var viewObj:Object = {
							name:product_view.name, 
							num_colors:usedColorPaletteProxy.designColors.source.length, 
							need_white_base:(need_white_base)?"true":"false",
							area_size_w:(product_view.design.currentLocation)?product_view.design.currentLocation.unscaledWidth:0, 
							area_size_h:(product_view.design.currentLocation)?product_view.design.currentLocation.unscaledHeight:0,
							num_elements:product_view.design.elements.length
						};
						viewsArray.push(viewObj);
					}
				}
				configurationProxy.setPriceParameters(viewsArray);
			}
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		private function get configurationProxy():ConfigurationProxy
		{
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;
		}
	}
}