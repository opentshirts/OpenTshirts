package controller.designElements
{
	import model.design.CompositionProxy;
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;

	//mapped with 
		//ApplicationConstants.ALIGN_TO_BOTTOM
		//ApplicationConstants.ALIGN_TO_TOP
		//ApplicationConstants.ALIGN_TO_LEFT
		//ApplicationConstants.ALIGN_TO_RIGHT
		//ApplicationConstants.ALIGN_TO_CENTER_H
		//ApplicationConstants.ALIGN_TO_CENTER_V
	public class AlignElementCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") )
			{
				throw new Error("Could not execute " + this + ". uid expected as body of the note");
			}
			
			var uid:String = note.getBody().uid;
			var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			var vo:DesignElementVO = proxy.vo;
			var xpos:Number = vo.x;
			var ypos:Number = vo.y;
			
			switch ( note.getName() )
			{
				case ApplicationConstants.ALIGN_TO_BOTTOM:
					ypos = compositionProxy.currentDesignArea.height - vo.height;
					break;
				case ApplicationConstants.ALIGN_TO_TOP:
					ypos = 0;
					break;
				case ApplicationConstants.ALIGN_TO_LEFT:
					xpos = 0;
					break;
				case ApplicationConstants.ALIGN_TO_RIGHT:
					xpos = compositionProxy.currentDesignArea.width - vo.width;
					break;
				case ApplicationConstants.ALIGN_TO_CENTER_H:
					xpos = (compositionProxy.currentDesignArea.width - vo.width) * .5;
					break;
				case ApplicationConstants.ALIGN_TO_CENTER_V:
					ypos = (compositionProxy.currentDesignArea.height - vo.height) * .5;
					break;
			}
			
			sendNotification(ApplicationConstants.DESIGN_ELEMENT_MOVED, {uid:uid, x:xpos, y:ypos},note.getType());
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
	}
}