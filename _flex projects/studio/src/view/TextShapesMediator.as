package view
{
	import Interfaces.IDesignElement;
	import Interfaces.IDesignElementProxy;
	
	import appFacade.ApplicationConstants;
	
	import events.ArcTextLayoutEvent;
	import events.SimpleEnvelopeEvent;
	import events.TextEvent;
	
	import model.design.DesignColorListProxy;
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import view.components.text.TextShapes;
	
	public class TextShapesMediator extends Mediator implements IMediator
	{
		public static const NAME:String = 'TextShapesMediator';
		private var _textuid:String;
		
		protected var propertiesView:TextShapes;

		public function TextShapesMediator(viewComponent:Object )  
		{  
			super( NAME, viewComponent );
		}
		override public function onRegister():void  
		{
			propertiesView = new TextShapes();
			propertiesView.visible = false;
			propertiesView.addEventListener(TextEvent.TEXT_ENVELOPE_CHANGE, handleEnvelopeChange);
			propertiesView.addEventListener(TextEvent.TEXT_LAYOUT_CHANGE, handleTextLayoutChange);
			propertiesView.addEventListener(SimpleEnvelopeEvent.AMOUNT_CHANGE, handleSimpleEnvelopeAmountChange);
			propertiesView.addEventListener(SimpleEnvelopeEvent.AMOUNT_CHANGING, handleSimpleEnvelopeAmountChanging);
			propertiesView.addEventListener(ArcTextLayoutEvent.RADIO_CHANGE, handleArcTextLayoutRadioChange);
			propertiesView.addEventListener(ArcTextLayoutEvent.RADIO_CHANGING, handleArcTextLayoutRadioChanging);
			viewComponent.addElement( propertiesView );
		}
		override public function listNotificationInterests():Array  
		{
			return [
				ApplicationConstants.ELEMENT_SELECTED,
				TextProxy.ENVELOPE_CHANGED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED
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
					if(element is TextVO)
					{
						updateControls(proxy as TextProxy);
					}
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					updateControls(null);
					break;
				case TextProxy.LAYOUT_CHANGED:
				case TextProxy.ENVELOPE_CHANGED:
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
				propertiesView.setShape(proxy.vo.layout, proxy.vo.envelope);
				propertiesView.visible = true;
			}else
			{
				_textuid = "";
				propertiesView.visible = false;
			}
		}
		private function handleEnvelopeChange(event:TextEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_ENVELOPE,{envelope:event.data,uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleTextLayoutChange(event:TextEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_TEXT_LAYOUT,{layout:event.data,uid:_textuid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleSimpleEnvelopeAmountChange(event:SimpleEnvelopeEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_SIMPLE_ENVELOPE_AMOUNT,{amount:event.data.amount,uid:event.data.uid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleSimpleEnvelopeAmountChanging(event:SimpleEnvelopeEvent):void
		{
			sendNotification(ApplicationConstants.CHANGING_SIMPLE_ENVELOPE_AMOUNT,{amount:event.data.amount,uid:event.data.uid},NAME);
		}
		private function handleArcTextLayoutRadioChange(event:ArcTextLayoutEvent):void
		{
			sendNotification(ApplicationConstants.CHANGE_ARC_TEXT_LAYOUT_RADIO,{radio:event.data.radio,uid:event.data.uid},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleArcTextLayoutRadioChanging(event:ArcTextLayoutEvent):void
		{
			sendNotification(ApplicationConstants.CHANGING_ARC_TEXT_LAYOUT_RADIO,{radio:event.data.radio,uid:event.data.uid},NAME);
		}
	}
}