package controller.designElements.filters.shadow
{
	import model.elements.filters.ShadowProxy;
	import model.elements.filters.ShadowVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.SHADOW_DISTANCE_CHANGE
	public class ChangeShadowDistanceUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("distance")|| !note.getBody().hasOwnProperty("filteruid") )
			{
				throw new Error("Could not execute " + this + ". distance and filteruid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeShadowDistanceUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var filteruid:String = getNote().getBody().filteruid;
			var distance:Number = getNote().getBody().distance;
			
			var proxy:ShadowProxy = facade.retrieveProxy(filteruid) as ShadowProxy;
			
			//save previous values into snapshot for undo
			var vo:ShadowVO = proxy.vo;
			var snapshot:Object = {filteruid:filteruid, distance:vo.distance};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setDistance(distance);
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeShadowDistanceUndoableCommand";
		}
	}
}