package controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.CommandsHistoryProxy;
	
	// mapped with ApplicationConstants.UNDO
	public class UndoCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if ( commandsHistoryProxy.canUndo ) 
				commandsHistoryProxy.getPrevious().undo();
		}
		private function get commandsHistoryProxy():CommandsHistoryProxy
		{
			return facade.retrieveProxy( CommandsHistoryProxy.NAME ) as CommandsHistoryProxy;
		}
	}
}