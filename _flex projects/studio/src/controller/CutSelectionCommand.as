package controller
{
	import Interfaces.IClonableProxy;
	
	import model.ClipboardProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//mapped with ApplicationConstants.CUT
	public class CutSelectionCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if ( !(note.getBody().objs is Array) )
			{
				throw new Error("Could not execute " + this + ". Array expected as body of the note");
			}
			
			clipboardProxy.clear();
			for each (var uid:String in note.getBody().objs) 
			{
				var proxy:IClonableProxy = facade.retrieveProxy(uid) as IClonableProxy;
				
				clipboardProxy.add(DesignElementVO(proxy.getCopy()));
			}
			
		}
		
		private function get clipboardProxy():ClipboardProxy
		{
			return facade.retrieveProxy( ClipboardProxy.NAME ) as ClipboardProxy;
		}

	}
}