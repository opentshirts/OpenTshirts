package controller
{
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	import model.design.SavedCompositionProxy;
	import model.design.UsedColorPaletteProxy;
	import model.elements.DesignElementProxy;
	import model.products.ProductProxy;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.CurrentProductMediator;

	//mapped with ApplicationConstants.SAVE_COMPOSITION
	public class SaveCompositionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			//save designs XML and composition into database
			var streams:Array = currentProductMediator.getSnapshots();
			if(streams===null)
			{
				sendNotification(SavedCompositionProxy.ERROR_SAVING,"error trying to get product snapshots");
				return;
			}
			if(streams.length==0)
			{
				sendNotification(SavedCompositionProxy.ERROR_SAVING,"Empty Design");
				return;
			}
			var streams_design:Array = currentProductMediator.getDesignSnapshots();
			if(streams_design===null)
			{
				sendNotification(SavedCompositionProxy.ERROR_SAVING,"error trying to get design snapshots");
				return;
			}
			if(streams_design.length==0)
			{
				sendNotification(SavedCompositionProxy.ERROR_SAVING,"Empty Design");
				return;
			}
			var compXML:XML = compositionProxy.saveToXML();
			if(compXML===null)
			{
				sendNotification(SavedCompositionProxy.ERROR_SAVING,"error trying to save compositionProxy xml");
				return;
			}
			
			var designsArray:Array = new Array();
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
						var elementsArray:Array = new Array();
						for each (var uid:String in designProxy.getElements()) 
						{
							var deProxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
							//elementsArray.push(deProxy.vo);
							elementsArray.push(uid);
						}						
						var designData:Object = {
							name:product_view.name, 
							num_colors:usedColorPaletteProxy.designColors.source.length, 
							need_white_base:need_white_base, 
							elements:elementsArray,
							area_size_w:(product_view.design.currentLocation)?product_view.design.currentLocation.unscaledWidth:0, 
							area_size_h:(product_view.design.currentLocation)?product_view.design.currentLocation.unscaledHeight:0,
							num_elements:product_view.design.elements.length
						};
						designsArray.push(designData);
					}
				}
			}			
			
			savedCompositionProxy.saveDesign(compXML, streams, streams_design, designsArray);		
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		private function get savedCompositionProxy():SavedCompositionProxy
		{
			return facade.retrieveProxy( SavedCompositionProxy.NAME ) as SavedCompositionProxy;
		}
		private function get currentProductMediator():CurrentProductMediator
		{
			return facade.retrieveMediator( CurrentProductMediator.NAME ) as CurrentProductMediator;
		}
	}
}