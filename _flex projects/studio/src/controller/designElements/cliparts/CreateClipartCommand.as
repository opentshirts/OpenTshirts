package controller.designElements.cliparts
{
	import appFacade.ApplicationConstants;
	
	import model.ConfigurationProxy;
	import model.design.CompositionProxy;
	import model.elements.DesignElementProxy;
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with ApplicationFacade.CREATE_CLIPART
	public class CreateClipartCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			if(!compositionProxy.currentDesignProxy)
			{
				sendNotification(ApplicationConstants.SHOW_MSG, {msg:ResourceManager.getInstance().getString('languageResources','SELECT_PRODUCT_FIRST'), type:0});					
				return;
			}
			
			//notification body must be just id_clipart
			var id_clipart:String = String(note.getBody());
			
			//instanciate new clipart
			var cl:ClipartVO = new ClipartVO();
				
			//set clipart api link
			cl.api_link = configurationProxy.vo.clipartsServiceURL+id_clipart;
			
			//create and register proxy
			var clProxy:ClipartProxy = cl.creator.createProxy() as ClipartProxy;
			facade.registerProxy(clProxy);
			
			///asynchronous
			clProxy.getService();
			
			var elementProxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+cl.uid) as DesignElementProxy;
			elementProxy.setPosition(compositionProxy.currentDesignArea.x,compositionProxy.currentDesignArea.y);
			//add to current design
			sendNotification(ApplicationConstants.ADD_ELEMENT_TO_DESIGN, {element_uid:cl.uid, design_uid:compositionProxy.currentDesignProxy.vo.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			sendNotification(ApplicationConstants.SELECT_ELEMENT, {uid:cl.uid});
		}
		private function get configurationProxy():ConfigurationProxy 
		{  
			return facade.retrieveProxy(ConfigurationProxy.NAME) as ConfigurationProxy;
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		
	}
}