package controller.designElements.cliparts
{
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_COLOR_CLIPART_LAYER
	public class ChangeClipartLayerColorUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("layers") )
			{
				throw new Error("Could not execute " + this + ". uid and layers expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeClipartLayerColorUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var layers:Array = getNote().getBody().layers;
			
			var proxy:ClipartProxy = facade.retrieveProxy(uid) as ClipartProxy;
			
			//save previous values into snapshot for undo
			var vo:ClipartVO = proxy.vo;
			var snapshotLayers:Array = new Array(layers.length);
			for each(var layerobj:Object in layers)
			{
				snapshotLayers.push({index:layerobj.index, color:vo.layers[layerobj.index].actualColor});
			}
			
			var snapshot:Object = {uid:uid, layers:snapshotLayers};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			for each(var layer:Object in layers)
			{
				proxy.setColorAlpha(layer.index, layer.color);
			}
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeClipartLayerColorUndoableCommand";
		}
	}
}