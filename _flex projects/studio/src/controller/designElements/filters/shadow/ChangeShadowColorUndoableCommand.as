package controller.designElements.filters.shadow
{
	import model.elements.filters.ShadowProxy;
	import model.elements.filters.ShadowVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	import model.design.vo.DesignColorVO;

	//mapped with ApplicationConstants.SHADOW_COLOR_CHANGE
	public class ChangeShadowColorUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("color")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". color and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeShadowColorUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var color:DesignColorVO = getNote().getBody().color;
			
			var proxy:ShadowProxy = facade.retrieveProxy(filteruid) as ShadowProxy;
			
			//save previous values into snapshot for undo
			var vo:ShadowVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, color:vo.color};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setColor(color);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeShadowColorUndoableCommand";
		}
	}
}