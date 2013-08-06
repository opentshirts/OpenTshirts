package controller.designElements.cliparts
{
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_CLIPART_COLOR_STATE
	public class ChangeClipartColorStateUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("colorState") )
			{
				throw new Error("Could not execute " + this + ". uid and colorState expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeClipartColorStateUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var colorState:uint = getNote().getBody().colorState;
			
			var proxy:ClipartProxy = facade.retrieveProxy(uid) as ClipartProxy;
			
			//save previous values into snapshot for undo
			var vo:ClipartVO = proxy.vo;
			var snapshot:Object = {uid:uid, colorState:vo.colorState};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setColorState(colorState);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeClipartColorStateUndoableCommand";
		}
	}
}