package view
{
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	
	import mx.collections.ArrayList;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import spark.components.Group;
	import spark.events.IndexChangeEvent;
	
	import utils.VectorUtil;
	
	import view.components.designElement.DesignColorList;
	import events.DesignColorPickerEvent;
	
	  
	public class DesignColorListMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'DesignColorListMediator';
		
		protected var colorList:DesignColorList; 
		//for share with color picker
		public static var colors:ArrayList = new ArrayList();
		
		public function DesignColorListMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent ); 
		}
		override public function onRegister():void  
		{  
			colorList = new DesignColorList();
			colorList.visible = false;
			//colorList.addEventListener(IndexChangeEvent.CHANGE, selectedColorChange);
			colorList.addEventListener(DesignColorPickerEvent.COLOR_CHANGE, handleColorChange);
			viewComponent.addElement( colorList );
		}

		/*private function selectedColorChange(event:IndexChangeEvent):void
		{
			var color:Object = colorList.selectedItem;
			sendNotification(ApplicationConstants.DESIGN_COLOR_SELECTED,color, NAME);
			colorList.selectedIndex = -1; ///para poder seleccionar otra vez el mismo
		}*/
		
		private function handleColorChange(event:DesignColorPickerEvent):void
		{
			sendNotification(ApplicationConstants.DESIGN_COLOR_SELECTED,event.data.color, NAME);
		}
		override public function listNotificationInterests():Array  
		{  
			return [ 
				DesignColorListProxy.DESIGN_COLORS_CHANGE, 
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED
			];  
		}  
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();  
			var body:Object = notification.getBody();  
			  
			switch ( name )  
			{  
				case DesignColorListProxy.DESIGN_COLORS_CHANGE:
					var colorVector:Vector.<DesignColorVO> = body as Vector.<DesignColorVO>;
					colors = new ArrayList(VectorUtil.toArray(colorVector));
					colorList.colors = colors;
					break;
				case ApplicationConstants.ELEMENT_SELECTED:
					//colorList.visible = true;
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					colorList.visible = false;
					break;
			} 
		}
		private function get controls():Group
		{
			return viewComponent as Group;
		}
	 }  
}