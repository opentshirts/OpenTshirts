package controller.designElements.filters.shadow
{
	import model.elements.filters.ShadowProxy;
	import model.elements.filters.ShadowVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.SHADOW_ANGLE_CHANGE
	public class ChangeShadowAngleUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("angle")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". angle and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeShadowAngleUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var angle:Number = getNote().getBody().angle;
			
			var proxy:ShadowProxy = facade.retrieveProxy(filteruid) as ShadowProxy;
			
			//save previous values into snapshot for undo
			var vo:ShadowVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, angle:vo.angle};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setAngle(angle);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeShadowAngleUndoableCommand";
		}
	}
}