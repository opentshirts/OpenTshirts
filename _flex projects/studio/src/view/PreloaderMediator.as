package view
{
	import flash.display.DisplayObject;
	
	import mx.managers.PopUpManager;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import view.components.Preloader;
	
	  
	public class PreloaderMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'PreloaderMediator';  
		  
		protected var preloader:Preloader;  
		private var _currentLoadings:uint = 0;
		  
		public function PreloaderMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent );  
		}
		  
		override public function onRegister():void  
		{  
			//preloader = new Preloader();
			//this.preloader.visible = false;
			//viewComponent.addElement( preloader );
			
		}
		override public function listNotificationInterests():Array  
		{  
			return [ 
				ApplicationConstants.LOAD_OBJECT_START, 
				ApplicationConstants.LOAD_OBJECT_PROGRESS, 
				ApplicationConstants.LOAD_OBJECT_COMPLETE, 
				ApplicationConstants.LOAD_OBJECT_ERROR
			]
		}  
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();  
			
			  
			switch ( name )  
			{  
				
				case ApplicationConstants.LOAD_OBJECT_START:
					_currentLoadings++;
					break;
				case ApplicationConstants.LOAD_OBJECT_PROGRESS:
					//this.preloader.progress = notification.getBody().percent / _currentLoadings;
					//this.preloader.progress = notification.getBody().percent;
					break;
				case ApplicationConstants.LOAD_OBJECT_COMPLETE:
					_currentLoadings--;
					break;
				case ApplicationConstants.LOAD_OBJECT_ERROR:
					trace("********* ApplicationConstants.LOAD_OBJECT_ERROR "+ notification.getBody());
					_currentLoadings--;
					break;

			}
			/*if(_currentLoadings>0)
			{
				if(!this.preloader.parent) {
					PopUpManager.addPopUp(preloader,viewComponent as DisplayObject,true);
					PopUpManager.centerPopUp(preloader);
				}
			}else{
				PopUpManager.removePopUp(preloader);
			}*/
		}
	
	 }  
}