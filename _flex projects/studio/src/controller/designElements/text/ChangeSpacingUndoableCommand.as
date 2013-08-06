package controller.designElements.text
{
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_TEXT_SPACING
	public class ChangeSpacingUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("spacing") )
			{
				throw new Error("Could not execute " + this + ". uid and spacing expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeSpacingUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var spacing:Number = getNote().getBody().spacing;
			
			var proxy:TextProxy = facade.retrieveProxy(uid) as TextProxy;
			
			//save previous values into snapshot for undo
			//var vo:TextVO = designProxy.getDesignElement(uid) as TextVO;
			var vo:TextVO = proxy.vo;
			var snapshot:Object = {uid:uid, spacing:vo.spacing};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			
			//var proxy:TextProxy = facade.retrieveProxy(TextProxy.NAME+uid) as TextProxy;
			proxy.setSpacing(spacing);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeSpacingUndoableCommand";
		}
	}
}