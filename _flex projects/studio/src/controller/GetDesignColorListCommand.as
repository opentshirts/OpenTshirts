package controller
{
	import model.ConfigurationProxy;
	import model.design.DesignColorListProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	 
	public class GetDesignColorListCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{  
			designColorListProxy.getService(configurationProxy.vo.designColorsServiceURL);
		}
		
		private function get designColorListProxy():DesignColorListProxy  
		{  
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;  
		}  
		private function get configurationProxy():ConfigurationProxy  
		{  
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;  
		}  
	}
}