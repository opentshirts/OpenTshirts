package controller
{
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.design.CompositionProxy;
	import model.design.vo.DesignVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with SavedCompositionProxy.LOADED
	public class ProcessLoadedCompositionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			var name:String = String(note.getBody().name);
			var id_composition:String = String(note.getBody().id_composition);
			var id_product:String = String(note.getBody().id_product);
			var id_product_color:String = String(note.getBody().id_product_color);
			var designs:Array =  note.getBody().designs as Array;
			
			//set composition name
			sendNotification(ApplicationConstants.CHANGE_COMPOSITION_DATA, {name:name, id_composition:id_composition}, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
			
			//set product
			sendNotification(ApplicationConstants.CHANGE_PRODUCT, {id_product:id_product,id_product_color:id_product_color} , UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
			
			///set product color
			//sendNotification(ApplicationConstants.CHANGE_PRODUCT_COLOR, id_product_color, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
			
			//set designs
			var designProxy:IXMLProxy;
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
				
				designProxy = facade.retrieveProxy(design.uid) as IXMLProxy;
				designProxy.loadFromXML(designXML);
			}
			
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}

	}
}