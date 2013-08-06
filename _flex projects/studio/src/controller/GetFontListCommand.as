package controller
{
	import model.ConfigurationProxy;
	import model.elements.text.FontListProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	 
	//MAPPER WITH 
	public class GetFontListCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{  
			fontListProxy.getService(configurationProxy.vo.fontsServiceURL);
		}
		private function get fontListProxy():FontListProxy
		{  
			return facade.retrieveProxy( FontListProxy.NAME ) as FontListProxy;  
		} 
		private function get configurationProxy():ConfigurationProxy  
		{  
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;  
		}  
	}
}