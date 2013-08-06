package controller.designElements
{
	import model.elements.DesignElementProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import appFacade.ApplicationConstants;

	//mapped with ApplicationConstants.RESET_ELEMENT_PROPORTIONS
	public class ResetElementProportionsCommand extends SimpleCommand
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

			if(vo.unscaledHeight>0 && vo.height>0 && vo.unscaledWidth>0 && vo.width>0) {
				var scaleY:Number = vo.height / vo.unscaledHeight;
				var scaleX:Number = vo.width / vo.unscaledWidth;
				var scale:Number = (scaleX>scaleY)?scaleY:scaleX;
				
				var newHeight:Number = vo.unscaledHeight*scale;
				var newWidth:Number  = vo.unscaledWidth*scale;
				
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_RESIZED, {uid:uid, width:newWidth, height:newHeight},note.getType());
			}
			
		}
	}
}