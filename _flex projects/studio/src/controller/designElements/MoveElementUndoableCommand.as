package controller.designElements
{
	import flash.geom.Point;
	
	import model.design.CompositionProxy;
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;
	
	//mapped with ApplicationConstants.DESIGN_ELEMENT_MOVED
	public class MoveElementUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("x") || !note.getBody().hasOwnProperty("y") )
			{
				throw new Error("Could not execute " + this + ". x, y and uid expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( MoveElementUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			//TODO: implementes constraint so the usea cannot move the element outside the printable area
			var uid:String = getNote().getBody().uid;
			var x:Number = getNote().getBody().x;
			var y:Number = getNote().getBody().y;
			
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			
			var center:Point = new Point(x,y);
			/*
			center.x+=vo.width/2;
			center.y+=vo.height/2;
			
			//arreglar esto y despues hacer el create acount y recovery pass y despues order
			
			center.x = (center.x<0)?0:center.x;
			center.y = (center.y<0)?0:center.y;
			center.x = (center.x>compositionProxy.currentDesignArea.width)?compositionProxy.currentDesignArea.width:center.x;
			center.y = (center.y>compositionProxy.currentDesignArea.height)?compositionProxy.currentDesignArea.height:center.x;
			
			center.x-=vo.width/2;
			center.y-=vo.height/2;*/
			
			var snapshot:Object = {uid:uid, x:vo.x, y:vo.y};
			
			
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			
			

			proxy.setPosition(center.x,center.y);
			
			
			
			/*var uid:String = getNote().getBody().uid;
			var x:Number = getNote().getBody().x;
			var y:Number = getNote().getBody().y;
			
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			
			//save previous values into snapshot for undo
			var vo:DesignElementVO = proxy.vo;
			var snapshot:Object = {uid:uid, x:vo.x, y:vo.y};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			proxy.setPosition(x,y);*/
			
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		override public function getCommandName():String
		{
			return "MoveElementUndoableCommand";
		}
	}
}