package controller
{
	import model.design.SavedCompositionProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//mapped with ApplicationConstants.IMPORT_COMPOSITION
	public class ImportCompositionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if ( !(note.getBody() is String) )
			{
				throw new Error("Could not execute " + this + ". id_composition (UUID) expected as body of the note");
			}
			var p:SavedCompositionProxy = facade.retrieveProxy( SavedCompositionProxy.NAME ) as SavedCompositionProxy;
			p.importComposition(note.getBody() as String);
			
		}

	}
}