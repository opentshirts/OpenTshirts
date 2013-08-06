package controller.designElements.cliparts
{
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CLIPART_INVERT_COLOR
	public class InvertClipartColorUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") )
			{
				throw new Error("Could not execute " + this + ". uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( InvertClipartColorUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			
			var proxy:ClipartProxy = facade.retrieveProxy(uid) as ClipartProxy;
			
			//save previous values into snapshot for undo
			var vo:ClipartVO = proxy.vo;
			var snapshot:Object = {uid:uid};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.invert()
			
		}
		
		override public function getCommandName():String
		{
			return "InvertClipartColorUndoableCommand";
		}
	}
}