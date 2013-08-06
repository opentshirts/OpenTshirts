package controller
{
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/*
	mapped with 
		DesignProxy.DESIGN_ELEMENT_ADDED
		DesignProxy.DESIGN_ELEMENT_REMOVED
		ClipartProxy.COLOR_STATE_CHANGED
		ClipartProxy.INVERTED
		ClipartProxy.LAYER_COLOR_CHANGED
		DesignElementProxy.FILTER_ADDED
		TextProxy.COLOR_CHANGED
		FilterProxy.VISIBLE_CHANGE
		OutlineProxy.OUTLINE_COLOR_CHANGE
		ShadowProxy.SHADOW_COLOR_CHANGE
	*/
	public class UpdateUsedColorPaletteCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if (note.getBody().hasOwnProperty("design_uid") )
			{
				DesignProxy(facade.retrieveProxy(note.getBody().design_uid)).updateUsedColors();
			}else if(compositionProxy.currentDesignProxy)
			{
				compositionProxy.currentDesignProxy.updateUsedColors();
			}
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
	}
}