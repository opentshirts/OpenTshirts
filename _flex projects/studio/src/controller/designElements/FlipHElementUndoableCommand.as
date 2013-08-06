package controller.designElements
{
	import model.elements.DesignElementProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.FLIP_H_ELEMENT
	public class FlipHElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") )
			{
				throw new Error("Could not execute " + this + ". uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( FlipHElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			proxy.flipH();
			
		}
		
		override public function getCommandName():String
		{
			return "FlipHElementUndoableCommand";
		}
		
	}
}