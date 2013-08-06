package view
{
	import appFacade.ApplicationConstants;
	
	import events.DesignColorPickerEvent;
	
	import model.design.CompositionProxy;
	import model.design.UsedColorPaletteProxy;
	import model.products.vo.RegionVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	
	import view.components.designElement.UsedDesignColorList;
	
	  
	public class UsedDesignColorListMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'UsedDesignColorListMediator';
		
		protected var colorList:UsedDesignColorList; 
		private var keep_hidden:Boolean = false;
		
		public function UsedDesignColorListMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent ); 
		}
		override public function onRegister():void  
		{  
			colorList = new UsedDesignColorList();
			colorList.visible = false;
			colorList.addEventListener(DesignColorPickerEvent.COLOR_CHANGE, handleColorChange);
			viewComponent.addElement( colorList );
		}

		override public function listNotificationInterests():Array  
		{  
			return [ 
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED,
				CompositionProxy.CURRENT_DESIGN_AREA_CHANGED,
				ApplicationConstants.HIDE_COLORS_USED_PANEL
				
			];  
		}  
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();  
			var body:Object = notification.getBody();  
			  
			switch ( name )  
			{  
				case ApplicationConstants.ELEMENT_SELECTED:
					if(!keep_hidden) { colorList.visible = true; }
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					colorList.visible = false;
					break;
				case CompositionProxy.CURRENT_DESIGN_AREA_CHANGED:
					var designArea:RegionVO = body as RegionVO;
					var proxy:UsedColorPaletteProxy = this.facade.retrieveProxy(UsedColorPaletteProxy.NAME+designArea.view.design.uid) as UsedColorPaletteProxy;
					colorList.colors = proxy.designColors;
					break;
				case ApplicationConstants.HIDE_COLORS_USED_PANEL:
					colorList.visible = false;
					keep_hidden = true;
					break;
			}
		}
		private function handleColorChange(event:DesignColorPickerEvent):void
		{
			sendNotification(ApplicationConstants.DESIGN_COLOR_SELECTED,event.data.color, NAME);
		}
		private function get controls():Group
		{
			return viewComponent as Group;
		}
	 }  
}