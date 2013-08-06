package controller.designElements
{
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.LOCK_ELEMENT_PROPORTIONS
	public class LockElementProportionsUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("maintainProportions") )
			{
				throw new Error("Could not execute " + this + ". uid and maintainProportions expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( LockElementProportionsUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var maintainProportions:Boolean = getNote().getBody().maintainProportions;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			var snapshot:Object = {uid:uid, maintainProportions:vo.maintainProportions};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setMaintainProportions(maintainProportions);
			
		}
		
		override public function getCommandName():String
		{
			return "LockElementProportionsUndoableCommand";
		}
	}
}