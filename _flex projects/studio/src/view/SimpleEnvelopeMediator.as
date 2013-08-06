package view
{
	
	import Interfaces.IEnvelopeMediator;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import model.elements.text.envelope.SimpleEnvelopeProxy;
	import model.elements.text.envelope.SimpleEnvelopeVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import view.components.text.EnvelopeComponent;
	import view.components.text.TextComponent;
	
	public class SimpleEnvelopeMediator extends Mediator implements IEnvelopeMediator
	{  
		public static const NAME:String = 'SimpleEnvelopeMediator';
		 
		private var _vo:SimpleEnvelopeVO;
		
		public function SimpleEnvelopeMediator(vo:SimpleEnvelopeVO)  
		{  
			super( NAME, null );
			_vo = vo;
		}
		override public function getMediatorName():String
		{
			return _vo.uid;
		}
		override public function listNotificationInterests():Array 
		{
			return [
				SimpleEnvelopeProxy.AMOUNT_CHANGED,
				ApplicationConstants.CHANGING_SIMPLE_ENVELOPE_AMOUNT
			];
		}
		
		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case SimpleEnvelopeProxy.AMOUNT_CHANGED:
					if ( note.getBody().uid == _vo.uid )
					{
						invalidateComponent();
					}
					break;
				case ApplicationConstants.CHANGING_SIMPLE_ENVELOPE_AMOUNT:
					if ( note.getBody().uid == _vo.uid )
					{
						//invalidateComponent();
					}
					break;
			}
		}
		private function invalidateComponent():void
		{
			//invalidate visual element
			textComponent.envelope = _vo;
			textComponent.invalidateText();
			/*if(textComponent)
			{
				var dobj:DisplayObject = textComponent.container.getChildAt(0);
				dobj.visible = true;
				var envelopeTextComponent:EnvelopeComponent = new EnvelopeComponent();
				envelopeTextComponent.displayObject = dobj;
				envelopeTextComponent.envelopeEffect = _vo.effectNumber;
				envelopeTextComponent.amount = _vo.amount;
				envelopeTextComponent.draw();
				//patch (there must be a better way)
				dobj.visible = false;
				while (textComponent.container.numChildren>1) textComponent.container.removeChildAt(1);
				textComponent.container.addChild(envelopeTextComponent);
				
				textComponent.setUnscaledSize(envelopeTextComponent.width,envelopeTextComponent.height);
			}*/
		}
		/*private function onTextUpdated(event:Event):void
		{
			invalidateComponent();
		}*/
		public function setTextComponent(value:TextComponent):void
		{
			viewComponent = value;
			//textComponent.addEventListener(TextComponent.UPDATED, onTextUpdated);
			invalidateComponent();
		}
		private function get textComponent():TextComponent
		{
			return viewComponent as TextComponent;
		}
	 }  
}