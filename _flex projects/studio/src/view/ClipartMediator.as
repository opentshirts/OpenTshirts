package view
{
	
	import Interfaces.IDesignElementMediator;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import view.components.clipart.ClipartComponent;
	import view.components.designElement.DesignElementBase;
	
	  
	public class ClipartMediator extends Mediator implements IDesignElementMediator
	{  
		public static const NAME:String = 'ClipartMediator';
		 
		private var _vo:ClipartVO;
		
		public function ClipartMediator(vo:ClipartVO)
		{  
			var viewComponent:Object = new ClipartComponent();
			
			super( NAME, viewComponent );
			
			_vo = vo;
		}
		override public function getMediatorName():String
		{
			return _vo.uid;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerDesignElementMediator()
			
			clipartComponent.addEventListener(Event.OPEN, onStartHandler);
			clipartComponent.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			clipartComponent.addEventListener(Event.COMPLETE, loaderComplete);
			clipartComponent.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			

			
			invalidateComponent();
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			removeDesignElementMediator();
			
			clipartComponent.removeEventListener(Event.OPEN, onStartHandler);
			clipartComponent.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			clipartComponent.removeEventListener(Event.COMPLETE, loaderComplete);
			clipartComponent.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				ClipartProxy.CLIPART_DATA_READY, ///getService complete successfuly
				ClipartProxy.COLOR_STATE_CHANGED,
				ClipartProxy.LAYER_COLOR_CHANGED,
				ClipartProxy.INVERTED
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{

			switch ( note.getName() )
			{
				case ClipartProxy.CLIPART_DATA_READY:
				case ClipartProxy.COLOR_STATE_CHANGED:
				case ClipartProxy.INVERTED:
				case ClipartProxy.LAYER_COLOR_CHANGED:
					var uid:String = String(note.getBody().uid);
					if (_vo.uid == uid )
					{
						invalidateComponent();
					}
					break;
			}
		}

		private function invalidateComponent():void
		{
			//invalidate visual element
			clipartComponent.layers =  _vo.layers;
			clipartComponent.source = _vo.swf_file;

		}

		private function get clipartComponent():ClipartComponent
		{
			return viewComponent as ClipartComponent;
		}
		
		/**
		 *  >> IDesignElementMediator
		 * */
		private function registerDesignElementMediator():void
		{
			facade.registerMediator(new DesignElementMediator(designElementBase, designElementVO));
		}
		private function removeDesignElementMediator():void
		{
			facade.removeMediator(DesignElementMediator.NAME+_vo.uid);
		}
		public function get designElementBase():DesignElementBase
		{
			return viewComponent as DesignElementBase;
		}
		public function get designElementVO():DesignElementVO
		{
			return _vo as DesignElementVO;
		}
		/**
		 *  << IDesignElementMediator
		 * */

		
		/**
		 *  >> Loader handlers
		 * */
		private function onStartHandler(event:Event):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME);  
		}
		private function loaderComplete(event:Event):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME  );
		}
		private function onProgressHandler(e:ProgressEvent):void
		{
			var pct:Number = e.bytesTotal == 0 ? 0 : Math.round( (e.bytesLoaded / e.bytesTotal)*100 );
			trace(pct)
			sendNotification(ApplicationConstants.LOAD_OBJECT_PROGRESS, {percent:pct}, NAME);  
		}
		private function ioErrorHandler(_event:IOErrorEvent):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_ERROR, _event.toString()+_event.type, NAME); 
		}
		/**
		 *  >> Loader handlers
		 * */
	 }  
}