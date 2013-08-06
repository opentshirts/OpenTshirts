package controller.designElements
{
	import model.elements.DesignElementProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import appFacade.ApplicationConstants;
	import model.design.CompositionProxy;
	
	//mapped with ApplicationConstants.ADJUST_ELEMENT_TO_CURRENT_AREA
	public class AdjustElementSizeToAreaCommand_unused extends SimpleCommand
	{
		override public function execute(note:INotification):void  
		{  
			if ( !note.getBody().hasOwnProperty("uid") )
			{
				throw new Error("Could not execute " + this + ". uid expected as body of the note");
			}
			
			var uid:String = note.getBody().uid;
			
			var designElementProxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
			designElementProxy.setSize(compositionProxy.currentDesignArea.width, compositionProxy.currentDesignArea.height);
			
			sendNotification(ApplicationConstants.RESET_ELEMENT_PROPORTIONS, {uid:uid});
		}
		
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		
	}
	
}