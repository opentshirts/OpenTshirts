package controller
{
	import Interfaces.IServiceProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.LanguageProxy;
	import model.SettingsProxy;
	import model.design.DesignColorListProxy;
	import model.elements.text.FontListProxy;
	import model.products.ProductColorListProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//MAPPED WITH ApplicationConstants.READY
	public class CheckAppReadyCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{			
			var proxyArray:Array = [
									SettingsProxy.NAME,
									LanguageProxy.NAME,
									DesignColorListProxy.NAME,
									ProductColorListProxy.NAME,
									FontListProxy.NAME
									]
			
			var allLoaded:Boolean = true;
			for (var i:uint = 0; i < proxyArray.length; i++) 
			{
				var proxy:IServiceProxy = this.facade.retrieveProxy(proxyArray[i]) as IServiceProxy;
				if(!proxy.loaded) {
					allLoaded = false;
				}
			}

			if(allLoaded)
			{
				sendNotification(ApplicationConstants.READY); 
			}
		}		
	}
}