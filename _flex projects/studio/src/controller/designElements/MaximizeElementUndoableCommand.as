package controller.designElements
{
	import model.design.CompositionProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	import appFacade.ApplicationConstants;
	
	//mapped with ApplicationConstants.MAXIMIZE_ELEMENT
	public class MaximizeElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") )
			{
				throw new Error("Could not execute " + this + ". uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( MaximizeElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			/*
			Set element size to fit area and then reset proportions in order to keep original aspec ratio
			*/
			sendNotification(ApplicationConstants.DESIGN_ELEMENT_RESIZED, {uid:uid, width:compositionProxy.currentDesignArea.width, height:compositionProxy.currentDesignArea.height}, getNote().getType());
			sendNotification(ApplicationConstants.RESET_ELEMENT_PROPORTIONS, {uid:uid},  getNote().getType());
			
			/*
			Center object into area
			*/
			sendNotification(ApplicationConstants.ALIGN_TO_CENTER_H, {uid:uid},  getNote().getType());
			sendNotification(ApplicationConstants.ALIGN_TO_CENTER_V, {uid:uid},  getNote().getType());
			
		}
		
		override public function getCommandName():String
		{
			return "MaximizeElementUndoableCommand";
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		
	}
	
}