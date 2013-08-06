package controller.designElements.bitmap
{
	import appFacade.ApplicationConstants;
	
	import model.ConfigurationProxy;
	import model.design.CompositionProxy;
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	import model.elements.bitmap.BitmapProxy;
	import model.elements.bitmap.vo.BitmapVO;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with ApplicationFacade.CREATE_BITMAP
	public class CreateBitmapCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			if(!compositionProxy.currentDesignProxy)
			{
				sendNotification(ApplicationConstants.SHOW_MSG, {msg:ResourceManager.getInstance().getString('languageResources','SELECT_PRODUCT_FIRST'), type:0});					
				return;
			}
			
			var bm:BitmapVO = new BitmapVO();
			var bmProxy:BitmapProxy = bm.creator.createProxy() as BitmapProxy;
			facade.registerProxy(bmProxy);
			bmProxy.setIdBitmap(note.getBody().id_bitmap);
			bmProxy.setSource(note.getBody().source);
			var colorsArray:Array = note.getBody().used_colors as Array;
			if(colorsArray && colorsArray.length>0) {
				var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
				for each (var id_design_color:String in colorsArray) 
				{
					var colorVO:DesignColorVO = designColorListProxy.getColorFromId(id_design_color);
					if(colorVO) {
						colors.push(colorVO);
					}
				}				
				bmProxy.setColors(colors);
			}
			
			var hiddenColorsArray:Array = note.getBody().hidden_colors as Array;
			if(hiddenColorsArray && hiddenColorsArray.length>0) {
				var hidden_colors:Vector.<uint> = new Vector.<uint>();
				for each (var color:uint in hiddenColorsArray) 
				{
					if(color is uint) {
						hidden_colors.push(color);
					}
				}				
				bmProxy.setHiddenColors(hidden_colors);
			}
			
			sendNotification(ApplicationConstants.ADD_ELEMENT_TO_DESIGN, {element_uid:bm.uid, design_uid:compositionProxy.currentDesignProxy.vo.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			sendNotification(ApplicationConstants.SELECT_ELEMENT, {uid:bm.uid});
		}
		private function get designColorListProxy():DesignColorListProxy 
		{  
			return facade.retrieveProxy(DesignColorListProxy.NAME) as DesignColorListProxy;
		}
		private function get configurationProxy():ConfigurationProxy 
		{  
			return facade.retrieveProxy(ConfigurationProxy.NAME) as ConfigurationProxy;
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		
	}
}