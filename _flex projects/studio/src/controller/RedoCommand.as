package controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.CommandsHistoryProxy;
	
	// mapped with ApplicationConstants.REDO
	public class RedoCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if ( commandsHistoryProxy.canRedo )
				commandsHistoryProxy.getNext().redo();
		}
		private function get commandsHistoryProxy():CommandsHistoryProxy
		{
			return facade.retrieveProxy( CommandsHistoryProxy.NAME ) as CommandsHistoryProxy;
		}
	}
}