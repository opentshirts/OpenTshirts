package controller
{
	import model.ConfigurationProxy;
	import model.LanguageProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	 
	public class GetLanguageCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{  
			languageProxy.getService(configurationProxy.vo.languageServiceURL);
		}
		private function get languageProxy():LanguageProxy  
		{  
			return facade.retrieveProxy( LanguageProxy.NAME ) as LanguageProxy;  
		}
		private function get configurationProxy():ConfigurationProxy  
		{  
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;  
		}  
	}
}