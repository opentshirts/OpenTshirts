package view
{
	
	import Interfaces.IEnvelopeMediator;
	
	import model.elements.text.envelope.NoEnvelopeVO;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.text.TextComponent;
	
	public class NoEnvelopeMediator extends Mediator implements IEnvelopeMediator
	{  
		public static const NAME:String = 'NoEnvelopeMediator';
		 
		private var _vo:NoEnvelopeVO;
		
		public function NoEnvelopeMediator(vo:NoEnvelopeVO)  
		{  
			super( NAME, null );
			_vo = vo;
		}
		override public function getMediatorName():String
		{
			return _vo.uid;
		}

		private function invalidateComponent():void
		{
			//invalidate visual element
			textComponent.envelope = _vo;
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