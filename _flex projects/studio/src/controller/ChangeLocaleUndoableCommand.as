package controller
{
	import model.SettingsProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	//MAPPED WITH ApplicationConstants.CHANGE_LOCALE
	public class ChangeLocaleUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !(note.getBody() is String) )
			{
				throw new Error("Could not execute " + this + ". String object expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeLocaleUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var locale:String = getNote().getBody() as String;

			//save previous values into snapshot for undo
			//getNote().setBody( settingsProxy.vo.currentLoc );
			
			settingsProxy.setLocale(locale);
			
		}
		private function get settingsProxy():SettingsProxy
		{
			return facade.retrieveProxy( SettingsProxy.NAME ) as SettingsProxy;
		}
		
		override public function getCommandName():String
		{
			return "ChangeLocaleUndoableCommand";
		}
	}
}