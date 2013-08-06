package controller.designElements.filters.shadow
{
	import model.elements.filters.ShadowProxy;
	import model.elements.filters.ShadowVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.SHADOW_THICKNESS_CHANGE
	public class ChangeShadowThicknessUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("thickness")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". thickness and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeShadowThicknessUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var thickness:Number = getNote().getBody().thickness;
			
			var proxy:ShadowProxy = facade.retrieveProxy(filteruid) as ShadowProxy;
			
			//save previous values into snapshot for undo
			var vo:ShadowVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, thickness:vo.thickness};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setThickness(thickness);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeShadowThicknessUndoableCommand";
		}
	}
}