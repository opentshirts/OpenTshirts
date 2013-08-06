package controller
{
	import model.ConfigurationProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class InitCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var configurationProxy:ConfigurationProxy 	= facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;
			configurationProxy.getService();
			
		}
		
	}
}