package view
{
	
	import Interfaces.IDesignElement;
	import Interfaces.IDesignElementProxy;
	
	import events.ClipartEvent;
	import events.DesignColorPickerEvent;
	
	import model.elements.cliparts.ClipartColorStateEnum;
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	import model.elements.cliparts.vo.LayerVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;
	
	import view.components.clipart.ClipartProperties;
	
	  
	public class ClipartPropertiesMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ClipartPropertiesMediator';
		
		protected var propertiesView:ClipartProperties;
		private var _clipartuid:String;
		//private var prevSelectedItems:Vector.<int>;
		
		public function ClipartPropertiesMediator(viewComponent:Object )  
		{  
			super( NAME, viewComponent );
		}
		override public function onRegister():void  
		{  
			propertiesView = new ClipartProperties();
			propertiesView.visible = false;
			propertiesView.addEventListener(ClipartEvent.COLOR_STATE_CHANGE, onColorStateChange);
			propertiesView.addEventListener(ClipartEvent.INVERT, onInvertChange);
			propertiesView.addEventListener(DesignColorPickerEvent.COLOR_CHANGE, handleColorChange);
			viewComponent.addElement( propertiesView );
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED,
				ApplicationConstants.DESIGN_COLOR_SELECTED,
				ClipartProxy.COLOR_STATE_CHANGED,
				ClipartProxy.LAYER_COLOR_CHANGED,
				ClipartProxy.INVERTED
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{
			var uid:String;
			var proxy:IDesignElementProxy;
			switch ( note.getName() )
			{
				case ApplicationConstants.ELEMENT_SELECTED:
					uid = note.getBody().uid;
					proxy = facade.retrieveProxy(note.getBody().uid) as IDesignElementProxy;
					var element:IDesignElement = proxy.designElement;
					if(element is ClipartVO)
					{
						updateControls(proxy as ClipartProxy);
					}
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					updateControls(null);
					break;
				case ApplicationConstants.DESIGN_COLOR_SELECTED:
					handleDesignColorSelected(note);
					break;
				case ClipartProxy.COLOR_STATE_CHANGED:
				case ClipartProxy.LAYER_COLOR_CHANGED:
				case ClipartProxy.INVERTED:
					uid = note.getBody().uid;
					if(_clipartuid==uid)
					{
						proxy = facade.retrieveProxy(uid) as IDesignElementProxy;
						updateControls(proxy as ClipartProxy);
					}
					break;
			}
		}
		private function updateControls(proxy:ClipartProxy):void
		{
			if(proxy)
			{			
				_clipartuid = proxy.vo.uid;
				//propertiesView.clipart = proxy.vo;
				propertiesView.inverted = proxy.vo.inverted;
				propertiesView.colorState = proxy.vo.colorState;
				propertiesView.fullColorEnabled = (proxy.vo.layers.length>=3);
				propertiesView.duoColorEnabled = (proxy.vo.layers.length>=2);
				propertiesView.layers = proxy.getCurrentLayers();
				propertiesView.canInvert = (proxy.vo.layers.length>1 && proxy.vo.colorState==ClipartColorStateEnum.ONE_COLOR);
				propertiesView.visible = true;
				propertiesView.showTintHint(false);
			}else
			{
				_clipartuid = "";
				//prevSelectedItems = null;
				propertiesView.visible = false;
				//propertiesView.clipart = null;
			}
		}
		
		private function onInvertChange(event:ClipartEvent):void
		{
			sendNotification(ApplicationConstants.CLIPART_INVERT_COLOR, {uid:_clipartuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function onColorStateChange(event:ClipartEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_CLIPART_COLOR_STATE, {colorState:event.data, uid:_clipartuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}

		protected function handleColorChange(e:DesignColorPickerEvent):void  
		{   
			var arrayLayers:Array = new Array();
			
			//for each(var layer:LayerVO in propertiesView.layersList.selectedItems)
			//{
				arrayLayers.push({index:e.data.layerIndex, color:e.data.color});
			//}
			sendNotification(ApplicationConstants.CHANGE_COLOR_CLIPART_LAYER, {layers:arrayLayers, uid:_clipartuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		
		private function handleDesignColorSelected(note:INotification):void
		{
			if(_clipartuid!="") {
				if(propertiesView.layersList.selectedItems.length>0)
				{
					propertiesView.showTintHint(false);
					var arrayLayers:Array = new Array();
					for each(var layer:LayerVO in propertiesView.layersList.selectedItems)
					{
						arrayLayers.push({index:layer.index, color:note.getBody()});
					}
					sendNotification(ApplicationConstants.CHANGE_COLOR_CLIPART_LAYER, {layers:arrayLayers, uid:_clipartuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
				}else
				{
					propertiesView.showTintHint(true);
				}
			}
		}
		
	 }  
}