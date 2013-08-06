package controller.designElements
{
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	public class MoveResizeRotateElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") 
				|| !note.getBody().hasOwnProperty("x") || !note.getBody().hasOwnProperty("y")
				|| !note.getBody().hasOwnProperty("width") || !note.getBody().hasOwnProperty("height")
				|| !note.getBody().hasOwnProperty("rotation"))
			{
				throw new Error("Could not execute " + this + ". x, y, width, height, rotation and uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( MoveResizeRotateElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var x:Number = getNote().getBody().x;
			var y:Number = getNote().getBody().y;
			var width:Number = getNote().getBody().width;
			var height:Number = getNote().getBody().height;
			var rotation:Number = getNote().getBody().rotation;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			var snapshot:Object = {uid:uid, x:vo.x, y:vo.y, width:vo.width, height:vo.height, rotation:vo.rotation};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setPosition(x,y);
			proxy.setSize(width,height);
			proxy.setRotation(rotation);
			
		}
		
		override public function getCommandName():String
		{
			return "MoveResizeRotateElementUndoableCommand";
		}
	}
}