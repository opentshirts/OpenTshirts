package controller
{
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	import model.design.vo.DesignVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with SavedCompositionProxy.ADD_DESIGN
	public class ProcessAddTemplateCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var design:Object =  note.getBody().design as Object;
			var designXML:XML = new XML( design );
			compositionProxy.currentDesignProxy.clear();
			compositionProxy.currentDesignProxy.loadFromXML(designXML);			
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}

	}
}