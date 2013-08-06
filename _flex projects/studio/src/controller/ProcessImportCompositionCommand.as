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

	//mapped with SavedCompositionProxy.IMPORT
	public class ProcessImportCompositionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var id_product:String = String(note.getBody().id_product);
			var id_product_color:String = String(note.getBody().id_product_color);
			var designs:Array =  note.getBody().designs as Array;
			
			//set product
			sendNotification(ApplicationConstants.CHANGE_PRODUCT, {id_product:id_product,id_product_color:id_product_color} , UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
			
			//set designs
			var designProxy:DesignProxy;
			for(var i:uint=0; i< designs.length; i++)
			{
				var viewIndex:uint;
				var designXML:XML = new XML( designs[i] );
				if(designXML.@viewIndex) {
					viewIndex = uint(designXML.@viewIndex);
				} else {
					viewIndex = i;
				}
				while (compositionProxy.vo.designs.length<=viewIndex) {
					compositionProxy.addDesign();
				} 
				var design:DesignVO;				
				design = compositionProxy.vo.designs[viewIndex];
					
				designProxy = facade.retrieveProxy(design.uid) as DesignProxy;
				designProxy.clear();
				designProxy.loadFromXML(designXML);
			}
			
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}

	}
}