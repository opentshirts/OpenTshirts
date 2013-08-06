package controller
{
	import Interfaces.IClonableProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.ClipboardProxy;
	import model.design.CompositionProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with ApplicationConstants.PASTE
	public class PasteSelectionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
		
			for each (var clone:DesignElementVO in clipboardProxy.vo) 
			{
				var proxy:IClonableProxy = facade.retrieveProxy(clone.uid) as IClonableProxy;
				
				var obj:DesignElementVO = DesignElementVO(proxy.getCopy());
				facade.registerProxy(obj.creator.createProxy());
				
				sendNotification(ApplicationConstants.ADD_ELEMENT_TO_DESIGN, {element_uid:obj.uid, design_uid:compositionProxy.currentDesignProxy.vo.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			}
			
		}
		
		private function get clipboardProxy():ClipboardProxy
		{
			return facade.retrieveProxy( ClipboardProxy.NAME ) as ClipboardProxy;
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
	}
}