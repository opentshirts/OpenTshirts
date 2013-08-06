package controller
{
	import Interfaces.IClonableProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.ClipboardProxy;
	import model.design.CompositionProxy;
	import model.design.vo.DesignVO;
	import model.elements.vo.DesignElementVO;
	import model.products.vo.RegionVO;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//mapped with ApplicationConstants.DUPLICATE_DESIGN
	public class DuplicateDesignCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			//this will only works if you have 2 design areas (one on each view)
			var areaFrom:RegionVO = compositionProxy.currentDesignArea;
			var areaTO:RegionVO;
			for each (var view_vo:ViewVO in areaFrom.view.product.views) 
			{
				for each (var region_vo:RegionVO in view_vo.regions) 
				{
					if(region_vo.view != areaFrom.view) {
						areaTO = region_vo;
						break;
						break;
					}
				}				
			}
			
			
			
			sendNotification(ApplicationConstants.SELECT_ALL,null,null);
			sendNotification(ApplicationConstants.SHORCUT_COPY,null, null);
			
			compositionProxy.currentDesignArea = areaTO;
			sendNotification(ApplicationConstants.SHORCUT_PASTE,null, null);
			
			compositionProxy.currentDesignArea = areaFrom;
			
		}
		
		private function get clipboardProxy():ClipboardProxy
		{
			return facade.retrieveProxy( ClipboardProxy.NAME ) as ClipboardProxy;
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}

	}
}