package view
{
	import appFacade.ApplicationConstants;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import model.design.CompositionProxy;
	import model.products.vo.ProductColorVO;
	import model.products.vo.RegionVO;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	
	import view.components.product.ProductViewComponent;
	
	
	/**
	 * 13-12-11 por ahora lo unico que hace este mediador es pintar el producto 
	 * y ocultarse/mostrarse segun el area a editar 
	 * */
	public class ProductViewMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ProductViewMediator';  
		
		private var _vo:ViewVO;
		private var designContainerMediator:DesignContainerMediator;
		private var drawTimer:Timer;
		
		
		public function ProductViewMediator(vo:ViewVO)  
		{  
			_vo = vo;
			super( NAME, new ProductViewComponent() );
			productViewComponent.addEventListener(Event.COMPLETE, onComplete);
			productViewComponent.visible = false;
			productViewComponent.underFill = _vo.underFill;
			productViewComponent.shade_url = _vo.shadeSrc;
			productViewComponent.fills = _vo.fillsSrc;
			
			
			
			drawTimer = new Timer(1000,0);
			drawTimer.addEventListener(TimerEvent.TIMER, drawDesignTimer);
			
			
			
		}
		private function onComplete(event:Event):void
		{
			drawDesign();
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			var designContainerComponent:Group = new Group();
			container.addElement(designContainerComponent);
			designContainerMediator = new DesignContainerMediator(designContainerComponent, _vo);
			facade.registerMediator(designContainerMediator);
			
			productViewComponent.addEventListener(Event.OPEN, onStartHandler);
			productViewComponent.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			productViewComponent.addEventListener(Event.COMPLETE, loaderComplete);
			productViewComponent.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			
			drawTimer.start();
			
			
			
		}
		
		override public function onRemove():void
		{
			super.onRemove();
			
			facade.removeMediator(designContainerMediator.getMediatorName());
			
			productViewComponent.removeEventListener(Event.OPEN, onStartHandler);
			productViewComponent.removeEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			productViewComponent.removeEventListener(Event.COMPLETE, loaderComplete);
			productViewComponent.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			container.removeAllElements();
			
			drawTimer.stop();
			
			
		}
		
		private function get container():Group
		{
			return productViewComponent.underShade;
		}
		
		override public function getMediatorName():String
		{
			return NAME + _vo.uid;
		}
		
		override public function listNotificationInterests():Array  
		{  
			return [
				CompositionProxy.PRODUCT_COLOR_CHANGED,
				CompositionProxy.CURRENT_DESIGN_AREA_CHANGED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED
			];
		}
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();
			switch ( name )
			{
				case CompositionProxy.PRODUCT_COLOR_CHANGED:
					var color:ProductColorVO = notification.getBody() as ProductColorVO;
					productViewComponent.colors = color.hexas;
					break;
				case CompositionProxy.CURRENT_DESIGN_AREA_CHANGED:
					var designArea:RegionVO = notification.getBody() as RegionVO;
					if(_vo==designArea.view)
					{
						productViewComponent.visible = true;
					}else
					{
						productViewComponent.visible = false;
					}
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					//drawDesign();
					break;
			}
		}
		public function getProductSnapshot():ByteArray
		{
			if(_vo.design.elements.length==0)
				return null;
			
			//hide selection before take snapshot
			designContainerMediator.clearForSnapshot();
			
			//productViewComponent.scaleX = productViewComponent.scaleY = 5;
			/**
			 * In AIR 1.5 and Flash Player 10, the maximum size for a BitmapData object is 8,191 pixels in width or height, 
			 * and the total number of pixels cannot exceed 16,777,215 pixels. (So, if a BitmapData object is 8,191 pixels wide, 
			 * it can only be 2,048 pixels high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the limitation is 
			 * 2,880 pixels in height and 2,880 in width.
			 **/
			var mat:Matrix = new Matrix();
			var scale:Number = 1;
			mat.scale(scale,scale);
			var w:Number = productViewComponent.width * scale;
			var h:Number = productViewComponent.height * scale;
			
			var source:BitmapData = new BitmapData (w, h,true,0x00FFFFFF);//alpha cero
			source.draw(productViewComponent,mat,null,null,null,true);
			
			//productViewComponent.scaleX = productViewComponent.scaleY = 1;
			
			var stream:ByteArray = PNGEncoder.encode(source);
			return stream;
		}
		public function getDesignSnapshot():ByteArray
		{
			if(_vo.design.elements.length==0)
				return null;
			return designContainerMediator.getSnapshot();
			
		}
		public function get productViewComponent():ProductViewComponent
		{
			return this.viewComponent as ProductViewComponent;
		}
		
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
		private function drawDesignTimer(event:TimerEvent):void
		{
			drawDesign();
		}
		private function drawDesign():void {
			if(productViewComponent.width>0) {
				var mat:Matrix = new Matrix();
				var scale:Number = 1;
				mat.scale(scale,scale);
				var w:Number = productViewComponent.width * scale;
				var h:Number = productViewComponent.height * scale;
				
				var source:BitmapData = new BitmapData(w, h,true,0x00FFFFFF);//alpha cero
				source.draw(productViewComponent,mat,null,null,null,true);
				
				_vo.bd = source;
			}
		}
	 }  
}