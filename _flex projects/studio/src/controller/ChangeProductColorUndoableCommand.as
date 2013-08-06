package controller
{
	import model.design.CompositionProxy;
	import model.design.DesignColorListProxy;
	import model.products.ProductColorListProxy;
	import model.products.vo.ProductColorVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	//MAPPED WITH ApplicationConstants.CHANGE_PRODUCT_COLOR
	public class ChangeProductColorUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !(note.getBody() is String) || productColorListProxy.getItemFromId(String(note.getBody()))===null )
			{
				throw new Error("Could not execute " + this + ". valid id_product_color expected as body of the note");
			}
			
			if(compositionProxy.productColor && String(note.getBody()) == compositionProxy.productColor.id)
			{
				//if is the same color..do not save as undoable command
				trace("same that actual color...don't save command "); 
				note.setType(UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
				
			}
			super.execute( note );
			registerUndoCommand( ChangeProductColorUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var color:ProductColorVO = productColorListProxy.getItemFromId(String(getNote().getBody()));

			//save previous values into snapshot for undo
			if(compositionProxy.productColor)
			{
				getNote().setBody( compositionProxy.productColor.id );
			}
			
			//this works fine only for simple color products
			designColorListProxy.updateCanvasColor(color.hexas[0]);

			compositionProxy.productColor = color;
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeProductColorUndoableCommand";
		}
		
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;
		}
		
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		private function get productColorListProxy():ProductColorListProxy
		{
			return facade.retrieveProxy( ProductColorListProxy.NAME ) as ProductColorListProxy;
		}
		
		
	}
}