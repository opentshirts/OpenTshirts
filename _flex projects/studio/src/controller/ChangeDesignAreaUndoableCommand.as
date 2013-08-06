package controller
{
	import appFacade.ApplicationConstants;
	
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	import model.products.RegionProxy;
	import model.products.vo.RegionVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with ApplicationConstants.CHANGE_DESIGN_AREA
	public class ChangeDesignAreaUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !(note.getBody() is RegionVO) )
			{
				throw new Error("Could not execute " + this + ". RegionVO object expected as body of the note");
			}

			super.execute( note );
			registerUndoCommand( ChangeDesignAreaUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var region:RegionVO = getNote().getBody() as RegionVO;
			var currentRegion:RegionVO = compositionProxy.currentDesignArea;
			
			//save previous values into snapshot for undo
			getNote().setBody( currentRegion );
			
			var designProxy:DesignProxy = facade.retrieveProxy(region.view.design.uid) as DesignProxy;
			designProxy.fitElements(region.width, region.height);
			designProxy.setLocation(region);
			
			compositionProxy.currentDesignArea = region;
			
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeDesignAreaUndoableCommand";
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		
	}
}