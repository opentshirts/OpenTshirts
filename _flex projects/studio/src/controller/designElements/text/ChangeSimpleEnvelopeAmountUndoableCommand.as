package controller.designElements.text
{
	import model.elements.text.envelope.SimpleEnvelopeProxy;
	import model.elements.text.envelope.SimpleEnvelopeVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_SIMPLE_ENVELOPE_AMOUNT
	public class ChangeSimpleEnvelopeAmountUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("amount") )
			{
				throw new Error("Could not execute " + this + ". uid and amount expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeSimpleEnvelopeAmountUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var amount:Number = getNote().getBody().amount;
			
			var proxy:SimpleEnvelopeProxy = facade.retrieveProxy(uid) as SimpleEnvelopeProxy;
			var vo:SimpleEnvelopeVO = proxy.vo;
			
			var snapshot:Object = {uid:uid, amount:vo.amount};
			
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setAmount(amount);

		}
		
		override public function getCommandName():String
		{
			return "ChangeSimpleEnvelopeAmountUndoableCommand";
		}
	}
}