package controller
{
	import appFacade.ApplicationConstants;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//mapped with ApplicationConstants.DUPLICATE_ELEMENT
	public class DuplicateElementCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			sendNotification(ApplicationConstants.SHORCUT_COPY,null, null);
			sendNotification(ApplicationConstants.SHORCUT_PASTE,null, null);
		}
		

	}
}