package controller.designElements
{
	import model.elements.DesignElementProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	//mapped with ApplicationConstants.UPDATE_UNSCALED_SIZE
	public class UpdateUnscaledSizeCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void  
		{  
			var unscaledWidth:Number = note.getBody().size.width;
			var unscaledHeight:Number = note.getBody().size.height;
			var uid:String = note.getBody().uid;
			
			var designElementProxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			designElementProxy.setUnscaledSize(unscaledWidth, unscaledHeight);
		}
	}
}