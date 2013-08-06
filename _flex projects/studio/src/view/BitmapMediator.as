package view
{
	
	import Interfaces.IDesignElementMediator;
	
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	
	import model.elements.bitmap.BitmapProxy;
	import model.elements.bitmap.vo.BitmapVO;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import view.components.bitmap.BitmapComponent;
	import view.components.designElement.DesignElementBase;
	
	  
	public class BitmapMediator extends Mediator implements IDesignElementMediator
	{  
		public static const NAME:String = 'BitmapMediator';
		 
		private var _vo:BitmapVO;
		
		public function BitmapMediator(vo:BitmapVO)
		{  
			var viewComponent:Object = new BitmapComponent();
			
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
			
			bitmapComponent.addEventListener(Event.OPEN, onStartHandler);
			bitmapComponent.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			bitmapComponent.addEventListener(Event.COMPLETE, loaderComplete);
			bitmapComponent.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);

			invalidateComponent();
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			removeDesignElementMediator();
			
			bitmapComponent.removeEventListener(Event.OPEN, onStartHandler);
			bitmapComponent.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			bitmapComponent.removeEventListener(Event.COMPLETE, loaderComplete);
			bitmapComponent.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				BitmapProxy.SOURCE_CHANGE,
				BitmapProxy.HIDDEN_COLORS_CHANGE
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{

			switch ( note.getName() )
			{
				case BitmapProxy.SOURCE_CHANGE:
				case BitmapProxy.HIDDEN_COLORS_CHANGE:
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
			bitmapComponent.source = _vo.source;
			bitmapComponent.hidden_colors = _vo.hidden_colors;

		}

		private function get bitmapComponent():BitmapComponent
		{
			return viewComponent as BitmapComponent;
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