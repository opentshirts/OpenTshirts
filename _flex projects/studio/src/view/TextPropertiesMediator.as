package view
{
	
	import Interfaces.IDesignElement;
	import Interfaces.IDesignElementProxy;
	
	import appFacade.ApplicationConstants;
	
	import events.DesignColorPickerEvent;
	import events.TextEvent;
	
	import model.design.DesignColorListProxy;
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import view.components.text.TextProperties;
	
	  
	public class TextPropertiesMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'TextPropertiesMediator';
		
		protected var propertiesView:TextProperties;
		private var _textuid:String;
		
		public function TextPropertiesMediator(viewComponent:Object )  
		{  
			super( NAME, viewComponent );
		}
		override public function onRegister():void  
		{  
			propertiesView = new TextProperties();
			propertiesView.visible = false;
			propertiesView.addEventListener(TextEvent.TEXT_CHANGE, onTextChange);
			propertiesView.addEventListener(TextEvent.FONT_CHANGE, handleFontChange);
			propertiesView.addEventListener(TextEvent.TEXT_SPACING_CHANGE, handleSpacingChange);
			propertiesView.addEventListener(TextEvent.TEXT_SPACING_CHANGING, handleSpacingChanging);
			propertiesView.addEventListener(DesignColorPickerEvent.COLOR_CHANGE, handleColorChange);
			viewComponent.addElement( propertiesView );
			
			facade.registerMediator(new FontListMediator(propertiesView.fontList));
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED,
				ApplicationConstants.DESIGN_COLOR_SELECTED,
				DesignColorListProxy.DESIGN_COLORS_CHANGE,
				TextProxy.TEXT_CHANGED,
				TextProxy.FONT_CHANGED,
				TextProxy.SPACING_CHANGED,
				TextProxy.COLOR_CHANGED
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{ 
			var uid:String;
			var proxy:IDesignElementProxy;
			//			trace(note.getName());
			switch ( note.getName() )
			{
				case ApplicationConstants.ELEMENT_SELECTED:
					uid = note.getBody().uid;
					proxy = facade.retrieveProxy(note.getBody().uid) as IDesignElementProxy;
					var element:IDesignElement = proxy.designElement;
					if(element is TextVO)
					{
						updateControls(proxy as TextProxy);
					}
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					updateControls(null);
					break;
				case ApplicationConstants.DESIGN_COLOR_SELECTED:
					handleDesignColorSelected(note);
					break;
				case DesignColorListProxy.DESIGN_COLORS_CHANGE:
					propertiesView.colors = DesignColorListMediator.colors;
					break;
				case TextProxy.TEXT_CHANGED:
				case TextProxy.FONT_CHANGED:
				case TextProxy.SPACING_CHANGED:
				case TextProxy.COLOR_CHANGED:
					uid = note.getBody().uid;
					if(_textuid==uid)
					{
						proxy = facade.retrieveProxy(uid) as IDesignElementProxy;
						updateControls(proxy as TextProxy);
					}
					break;
				
			}
		}
		private function updateControls(proxy:TextProxy):void
		{
			if(proxy)
			{
				_textuid = proxy.vo.uid;
				propertiesView.text = proxy.vo.text;
				propertiesView.color = proxy.vo.color.hexa;
				propertiesView.font = proxy.vo.font;
				propertiesView.spacing = proxy.vo.spacing;
				propertiesView.visible = true;
			}else
			{
				_textuid = "";
				propertiesView.visible = false;
			}
		}
		
		private function onTextChange(event:TextEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_TEXT,{text:event.data,uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}

		protected function handleFontChange(event:TextEvent):void  
		{   
			sendNotification(ApplicationConstants.CHANGE_FONT,{font:event.data,uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleSpacingChanging(event:TextEvent):void
		{
			sendNotification(ApplicationConstants.CHANGING_TEXT_SPACING,{spacing:event.data,uid:_textuid},NAME);
		}
		protected function handleSpacingChange(event:TextEvent):void  
		{   
			sendNotification(ApplicationConstants.CHANGE_TEXT_SPACING,{spacing:event.data,uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		
		
		private function handleDesignColorSelected(note:INotification):void
		{
			if(_textuid!="") {
				sendNotification(ApplicationConstants.CHANGE_TEXT_COLOR, {color:note.getBody(), uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			}
		}
		
		private function handleColorChange(event:DesignColorPickerEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_TEXT_COLOR, {color:event.data.color, uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		
	 }  
}