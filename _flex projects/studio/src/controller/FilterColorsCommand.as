package controller
{
	import model.design.DesignColorListProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	 
	public class FilterColorsCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{  
			designColorListProxy.filterColors(notification.getBody().colors);
		}
		
		private function get designColorListProxy():DesignColorListProxy  
		{  
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;  
		} 
	}
}