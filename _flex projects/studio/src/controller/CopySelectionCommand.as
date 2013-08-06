package controller
{
	import Interfaces.IClonableProxy;
	
	import model.ClipboardProxy;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	//mapped with ApplicationConstants.COPY
	public class CopySelectionCommand extends SimpleCommand implements ICommand
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
				var obj:DesignElementVO = DesignElementVO(proxy.getCopy());
				facade.registerProxy(obj.creator.createProxy());
				clipboardProxy.add(DesignElementVO(obj));
			}
			clipboardProxy.vo.sortOn("depth", Array.NUMERIC);
			
		}
		
		private function get clipboardProxy():ClipboardProxy
		{
			return facade.retrieveProxy( ClipboardProxy.NAME ) as ClipboardProxy;
		}

	}
}