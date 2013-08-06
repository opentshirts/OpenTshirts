package controller
{
	import model.ConfigurationProxy;
	import model.SettingsProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	 
	public class GetSettingsCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{  
			settingsProxy.getService(configurationProxy.vo.settingsServiceURL);
		}
		private function get settingsProxy():SettingsProxy  
		{  
			return facade.retrieveProxy( SettingsProxy.NAME ) as SettingsProxy;  
		}
		private function get configurationProxy():ConfigurationProxy  
		{  
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;  
		}  
	}
}