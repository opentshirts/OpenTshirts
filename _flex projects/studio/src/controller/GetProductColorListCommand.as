package controller
{
	import model.ConfigurationProxy;
	import model.products.ProductColorListProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	 
	public class GetProductColorListCommand extends SimpleCommand implements ICommand  
	{  
		override public function execute(notification:INotification):void  
		{  
			productColorListProxy.getService(configurationProxy.vo.productColorsServiceURL);
		}
		
		private function get productColorListProxy():ProductColorListProxy  
		{  
			return facade.retrieveProxy( ProductColorListProxy.NAME ) as ProductColorListProxy;  
		}  
		private function get configurationProxy():ConfigurationProxy  
		{  
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;  
		}  
	}
}