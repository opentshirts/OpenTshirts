package view
{
	
	import Interfaces.ITextLayoutMediator;
	
	import model.elements.text.layout.NormalTextLayoutVO;
	
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.text.TextComponent;
	
	public class NormalTextLayoutMediator extends Mediator implements ITextLayoutMediator
	{  
		public static const NAME:String = 'NormalTextLayoutMediator';
		 
		private var _vo:NormalTextLayoutVO;
		
		public function NormalTextLayoutMediator(vo:NormalTextLayoutVO)  
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