package controller
{
	import model.design.CompositionProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//mapped with ApplicationConstants.CHANGE_COMPOSITION_DATA
	public class ChangeCompositionDataCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if(note.getBody().hasOwnProperty("id_composition"))
			{
				compositionProxy.setID(note.getBody().id_composition as String);
			}
			if(note.getBody().hasOwnProperty("name"))
			{
				compositionProxy.setName(note.getBody().name as String);
			}
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}

	}
}