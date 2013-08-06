package controller
{
	import appFacade.ApplicationConstants;
	
	import flash.net.URLRequest;
	import flash.net.URLRequestHeader;
	import flash.net.URLRequestMethod;
	import flash.net.navigateToURL;
	import flash.utils.ByteArray;
	
	import model.design.SavedCompositionProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.CurrentProductMediator;

	//mapped with ApplicationConstants.EXPORT_IMAGE
	public class ExportImageCommand extends SimpleCommand implements ICommand
	{

		override public function execute(note:INotification):void
		{
			var snapshot:ByteArray = currentProductMediator.getCurrentViewSnapshot();
			if(snapshot===null)
			{
				sendNotification(ApplicationConstants.ALERT_ERROR,"ERROR: Empty design.");
				return;
			}
			
			var header:URLRequestHeader = new URLRequestHeader("Content-type", "application/octet-stream");
			var jpgURLRequest:URLRequest = new URLRequest("exportimage.php?name=opentshirts - snapshot.png");
			jpgURLRequest.requestHeaders.push(header);
			jpgURLRequest.method = URLRequestMethod.POST;
			jpgURLRequest.data = snapshot;
			navigateToURL(jpgURLRequest, "_blank");
			
		}
		
		private function get savedCompositionProxy():SavedCompositionProxy
		{
			return facade.retrieveProxy( SavedCompositionProxy.NAME ) as SavedCompositionProxy;
		}
		private function get currentProductMediator():CurrentProductMediator
		{
			return facade.retrieveMediator( CurrentProductMediator.NAME ) as CurrentProductMediator;
		}

		
	}
}