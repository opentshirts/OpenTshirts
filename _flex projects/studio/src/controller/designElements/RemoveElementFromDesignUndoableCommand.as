package controller.designElements
{
	import model.design.DesignProxy;
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.
	public class RemoveElementFromDesignUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("element_uid") || !note.getBody().hasOwnProperty("design_uid") )
			{
				throw new Error("Could not execute " + this + ". element_uid and design_uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( AddElementAtIndexToDesignUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var element_uid:String = getNote().getBody().element_uid;
			var design_uid:String = getNote().getBody().design_uid;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+element_uid) as DesignElementProxy;
			var vo:DesignElementVO = proxy.vo;
			
			//save previous value into the note, for undo
			getNote().setBody( {element_uid:element_uid, design_uid:design_uid, index:vo.depth} ); 
			
			var designProxy:DesignProxy = facade.retrieveProxy(design_uid) as DesignProxy;
			designProxy.removeDesignElement(element_uid);
			
		}
		override public function getCommandName():String
		{
			return "RemoveElementFromDesignUndoableCommand";
		}
	}
}