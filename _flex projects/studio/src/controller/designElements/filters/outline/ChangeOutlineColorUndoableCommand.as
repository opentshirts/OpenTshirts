package controller.designElements.filters.outline
{
	import model.design.vo.DesignColorVO;
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.OutlineVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.OUTLINE_COLOR_CHANGE
	public class ChangeOutlineColorUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("color")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". color and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeOutlineColorUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var color:DesignColorVO = getNote().getBody().color;
			
			var proxy:OutlineProxy = facade.retrieveProxy(filteruid) as OutlineProxy;
			
			//save previous values into snapshot for undo
			var vo:OutlineVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, color:vo.color};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setColor(color);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeOutlineColorUndoableCommand";
		}
	}
}