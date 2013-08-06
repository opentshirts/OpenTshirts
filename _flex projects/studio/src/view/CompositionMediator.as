package view
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;

	public class CompositionMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'CompositionMediator';
		
		public function CompositionMediator(viewComponent:Object)  
		{  
			super( NAME, viewComponent );
		}
		override public function onRegister():void
		{
			/* composition's product */
			facade.registerMediator( new CurrentProductMediator(compositionContainer)); 
		}		
		private function get currentProductMediator():CurrentProductMediator
		{
			return facade.retrieveMediator(CurrentProductMediator.NAME) as CurrentProductMediator; 
		}

		public function get compositionContainer():Group
		{
			return viewComponent as Group;
		}
	}  
}