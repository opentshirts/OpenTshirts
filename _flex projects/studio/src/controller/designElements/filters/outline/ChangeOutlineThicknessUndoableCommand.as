package controller.designElements.filters.outline
{
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.OutlineVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.OUTLINE_THICKNESS_CHANGE
	public class ChangeOutlineThicknessUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("thickness")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". thickness and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeOutlineThicknessUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var thickness:Number = getNote().getBody().thickness;
			
			var proxy:OutlineProxy = facade.retrieveProxy(filteruid) as OutlineProxy;
			
			//save previous values into snapshot for undo
			var vo:OutlineVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, thickness:vo.thickness};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setThickness(thickness);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeOutlineThicknessUndoableCommand";
		}
	}
}