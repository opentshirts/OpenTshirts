package controller.designElements.text
{
	import model.elements.text.layout.ArcTextLayoutProxy;
	import model.elements.text.layout.ArcTextLayoutVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_ARC_TEXT_LAYOUT_RADIO
	public class ChangeArcTextLayoutRadioUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("radio") )
			{
				throw new Error("Could not execute " + this + ". uid and radio expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeArcTextLayoutRadioUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var radio:Number = getNote().getBody().radio;
			
			var proxy:ArcTextLayoutProxy = facade.retrieveProxy(uid) as ArcTextLayoutProxy;
			var vo:ArcTextLayoutVO = proxy.vo;
			
			var snapshot:Object = {uid:uid, radio:vo.radio};
			
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setRadio(radio);

		}
		
		override public function getCommandName():String
		{
			return "ChangeArcTextLayoutRadioUndoableCommand";
		}
	}
}