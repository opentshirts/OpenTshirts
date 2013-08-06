package controller.designElements.text
{
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_FONT
	public class ChangeFontUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("font") )
			{
				throw new Error("Could not execute " + this + ". uid and font expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeFontUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var font:String = getNote().getBody().font;
			
			var proxy:TextProxy = facade.retrieveProxy(uid) as TextProxy;
			
			//save previous values into snapshot for undo
			var vo:TextVO = proxy.vo;
			var snapshot:Object = {uid:uid, font:vo.font};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			
			//var proxy:TextProxy = facade.retrieveProxy(TextProxy.NAME+uid) as TextProxy;
			proxy.setFont(font);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeFontUndoableCommand";
		}
	}
}