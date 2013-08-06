package components
{
	import appFacade.ApplicationFacade;
	
	import flash.external.ExternalInterface;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;

	public class AppLogic extends Group
	{
		
		public function AppLogic()
		{
			super();
			addEventListener(FlexEvent.CREATION_COMPLETE, init);
		}
		
		protected function init(event:FlexEvent):void
		{
			start();
			ExternalInterface.call("onCreationComplete");
		}
		
		// start the app.
		protected function start():void
		{
			ApplicationFacade.getInstance().startup(this);
		}
		
	}
}