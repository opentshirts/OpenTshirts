package controller.designElements.text
{
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_TEXT
	public class ChangeTextUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("text") )
			{
				throw new Error("Could not execute " + this + ". uid and text expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeTextUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var text:String = getNote().getBody().text;
			
			var proxy:TextProxy = facade.retrieveProxy(uid) as TextProxy;
			
			//save previous values into snapshot for undo
			var vo:TextVO = proxy.vo;
			var snapshot:Object = {uid:uid, text:vo.text};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setText(text);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeTextUndoableCommand";
		}
	}
}