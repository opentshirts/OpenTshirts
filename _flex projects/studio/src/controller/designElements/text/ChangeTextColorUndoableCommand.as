package controller.designElements.text
{
	import model.design.vo.DesignColorVO;
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_TEXT_COLOR
	public class ChangeTextColorUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("color") )
			{
				throw new Error("Could not execute " + this + ". uid and color expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeTextColorUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var color:DesignColorVO = getNote().getBody().color;
			
			
			var proxy:TextProxy = facade.retrieveProxy(uid) as TextProxy;
			
			//save previous values into snapshot for undo
			var vo:TextVO = proxy.vo;
			var snapshot:Object = {uid:uid, color:vo.color};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			
			proxy.setColor(color);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeTextColorUndoableCommand";
		}
	}
}