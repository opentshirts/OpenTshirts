package controller.designElements
{
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;
	
	import view.DesignElementMediator;

	//mapped with ApplicationConstants.LOCK_ELEMENT
	public class LockElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("isLocked") )
			{
				throw new Error("Could not execute " + this + ". uid and isLocked expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( LockElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var isLocked:Boolean = getNote().getBody().isLocked;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			var snapshot:Object = {uid:uid, isLocked:vo.isLocked};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setLocked(isLocked)
			
		}
		
		override public function getCommandName():String
		{
			return "LockElementUndoableCommand";
		}
		
	}
}