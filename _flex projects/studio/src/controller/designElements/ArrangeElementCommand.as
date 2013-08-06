package controller.designElements
{
	import model.design.CompositionProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;

	//mapped with 
		//ApplicationConstants.ELEMENT_BACKWARD
		//ApplicationConstants.ELEMENT_FORWARD
		//ApplicationConstants.ELEMENT_TO_TOP
		//ApplicationConstants.ELEMENT_TO_BOTTOM
	public class ArrangeElementCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") )
			{
				throw new Error("Could not execute " + this + ". uid expected as body of the note");
			}
			
			var uid:String = note.getBody().uid;
			var elementIndex:int = compositionProxy.currentDesignProxy.vo.elements.getItemIndex( uid );
			var targetIndex:int;
			switch ( note.getName() )
			{
				case ApplicationConstants.ELEMENT_BACKWARD:
					targetIndex = Math.max(elementIndex-1,0) ;
					break;
				case ApplicationConstants.ELEMENT_FORWARD:
					targetIndex = Math.min(elementIndex+1,compositionProxy.currentDesignProxy.vo.elements.length-1) ;
					break;
				case ApplicationConstants.ELEMENT_TO_TOP:
					targetIndex = compositionProxy.currentDesignProxy.vo.elements.length-1;
					break;
				case ApplicationConstants.ELEMENT_TO_BOTTOM:
					targetIndex = 0;
					break;
			}
			
			sendNotification(ApplicationConstants.SET_DESIGN_ELEMENT_INDEX, {uid:uid, index:targetIndex}, note.getType());
			
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
	}
}