package controller
{
	
	
	import appFacade.ApplicationConstants;
	
	import model.design.CompositionProxy;
	import model.design.vo.CompositionVO;
	import model.design.vo.DesignVO;
	import model.products.vo.ProductVO;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with ProductProxy.PRODUCT_CREATED
	public class InitializeProductCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var product:ProductVO = note.getBody() as ProductVO;
			
			if(product.id==compositionProxy.productID) ///if it's current product
			{
				var compositionVo:CompositionVO = compositionProxy.vo;
				
				for(var viewIndex:uint = 0; viewIndex<product.views.length; viewIndex++) //for each product's view
				{
					var designForThisView:DesignVO;
					if(compositionVo.designs.length>viewIndex) //if there is already a design for this view just assign it
					{
						designForThisView = compositionVo.designs[viewIndex] as DesignVO;
					}else //creates a new design
					{
						designForThisView = compositionProxy.addDesign();
					}
					var view_vo:ViewVO = product.views[viewIndex] as ViewVO;
					view_vo.design = designForThisView;
					
				}
				sendNotification(ApplicationConstants.CURRENT_PRODUCT_CHANGE, product);
				sendNotification(ApplicationConstants.CHANGE_PRODUCT_COLOR, product.currentColor.id, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
				sendNotification(ApplicationConstants.CHANGE_DESIGN_AREA, product.defaultRegion, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
				
			}
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
	}
}