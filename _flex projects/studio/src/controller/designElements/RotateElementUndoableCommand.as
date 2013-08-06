package controller.designElements
{
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	public class RotateElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("rotation"))
			{
				throw new Error("Could not execute " + this + ". rotation and uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( RotateElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var rotation:Number = getNote().getBody().rotation;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			var snapshot:Object = {uid:uid, rotation:vo.rotation};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setRotation(rotation);
			
		}
		
		override public function getCommandName():String
		{
			return "RotateElementUndoableCommand";
		}
	}
}