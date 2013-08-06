package controller.designElements
{
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.SET_DESIGN_ELEMENT_INDEX
	public class SetDesignElementIndexUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("index") )
			{
				throw new Error("Could not execute " + this + ". uid and index expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( SetDesignElementIndexUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var index:int = getNote().getBody().index;
			
			var proxy:DesignProxy = compositionProxy.currentDesignProxy;
			
			//save previous values into snapshot for undo
			var snapshot:Object = {uid:uid, index:proxy.vo.elements.getItemIndex( uid )};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setElementIndex(uid, index);
			
		}
		
		override public function getCommandName():String
		{
			return "SetDesignElementIndexUndoableCommand";
		}
		
		
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
	}
}