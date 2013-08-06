package controller.designElements
{
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	//mapped with ApplicationConstants.DESIGN_ELEMENT_RESIZED
	public class ResizeElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("width") || !note.getBody().hasOwnProperty("height") )
			{
				throw new Error("Could not execute " + this + ". width, height and uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ResizeElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var width:Number = getNote().getBody().width;
			var height:Number = getNote().getBody().height;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			var snapshot:Object = {uid:uid, width:vo.width, height:vo.height};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setSize(width,height);
			
		}
		
		override public function getCommandName():String
		{
			return "ResizeElementUndoableCommand";
		}
	}
}