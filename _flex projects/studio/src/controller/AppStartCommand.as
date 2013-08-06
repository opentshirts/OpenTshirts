package controller
{
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//MAPPED WITH ApplicationConstants.READY
	public class AppStartCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			//START POINT
			//sendNotification(ApplicationConstants.SHOW_PRODUCT_LIST);
		}
	}
}