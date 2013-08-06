package controller.designElements.filters
{
	import Interfaces.IDesignElementMediator;
	
	import model.elements.filters.FilterProxy;
	import model.elements.filters.FilterVO;
	import model.elements.filters.OutlineVO;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;
	
	import view.DesignElementMediator;

	//mapped with ApplicationConstants.FILTER_VISIBILITY_CHANGE
	public class ChangeFilterVisibilityUndoableCommand extends UndoableCommandBase
	{

		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("visible")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". visible and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeFilterVisibilityUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var visible:Boolean = getNote().getBody().visible;
			
			var proxy:FilterProxy = facade.retrieveProxy(FilterProxy.NAME+filteruid) as FilterProxy;
			
			//save previous values into snapshot for undo
			var vo:FilterVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, visible:vo.visible};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setVisible(visible);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeFilterVisibilityUndoableCommand";
		}
	}
}