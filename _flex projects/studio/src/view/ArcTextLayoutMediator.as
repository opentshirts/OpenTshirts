package view
{
	
	import Interfaces.ITextLayoutMediator;
	
	import model.elements.text.layout.ArcTextLayoutProxy;
	import model.elements.text.layout.ArcTextLayoutVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import view.components.text.TextComponent;
	
	public class ArcTextLayoutMediator extends Mediator implements ITextLayoutMediator
	{  
		public static const NAME:String = 'ArcTextLayoutMediator';
		 
		private var _vo:ArcTextLayoutVO;
		
		public function ArcTextLayoutMediator(vo:ArcTextLayoutVO)  
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
				ArcTextLayoutProxy.RADIO_CHANGED,
				ApplicationConstants.CHANGING_ARC_TEXT_LAYOUT_RADIO
			];
		}

		override public function handleNotification( note:INotification ):void
		{
			switch ( note.getName() )
			{
				case ArcTextLayoutProxy.RADIO_CHANGED:
					if ( note.getBody().uid == _vo.uid )
					{
						invalidateComponent();
					}
					break;
				case ApplicationConstants.CHANGING_ARC_TEXT_LAYOUT_RADIO:
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
			textComponent.layout = _vo;
			textComponent.invalidateText();
		}
		public function setTextComponent(value:TextComponent):void
		{
			viewComponent = value;
			invalidateComponent();
		}
		private function get textComponent():TextComponent
		{
			return viewComponent as TextComponent;
		}
	 }  
}