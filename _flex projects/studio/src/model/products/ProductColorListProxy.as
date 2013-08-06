package model.products
{	  
	import Interfaces.IServiceProxy;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.products.vo.ProductColorVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	import appFacade.ApplicationConstants;
	
	public class ProductColorListProxy extends Proxy implements IProxy  , IServiceProxy
	{  
		public static const NAME:String = 'ProductColorListProxy';  	  
		public static const PRODUCTS_COLORS_READY:String = NAME + 'PRODUCTS_COLORS_READY';	  
		private var _loaded:Boolean = false; 	
		
		public function ProductColorListProxy()
		{  
			super( NAME, new ArrayCollection  );  
		}
		
		public function getService(url:String):void  
		{  
			var request:URLRequest = new URLRequest(); 
			var loader:URLLoader   = new URLLoader();  
			  
			sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME); 
			
			request.url = url;  
			
			loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);  
			loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
			loader.addEventListener(Event.COMPLETE, handleComplete);  
			  
			loader.load( request );  
		}  
		  
		protected function handleComplete(e:Event):void  
		{  
			var data:XML = new XML( e.target.data );
			
			if(data.error != undefined) {
				sendNotification(ApplicationConstants.ALERT_ERROR,String(data.error));
			} else {
				
				for each ( var colorXML:XML in data.color )  
				{
					var colorVO:ProductColorVO = new ProductColorVO();
					colorVO.id = String(colorXML.id);
					colorVO.name = colorXML.name;
					colorVO.need_white_base = String(colorXML.need_white_base) == "1" ? true : false;

					for each ( var hexaXML:XML in colorXML.hexa_values.hexa )  
					{
						var coloruint:uint = uint("0x"+hexaXML);
						colorVO.hexas.push(coloruint);
					}
					
					addItem(colorVO);
				}
				_loaded = true;
				
				sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME  );  
				sendNotification(PRODUCTS_COLORS_READY, product_colors);  
				
			}
			
		}
		
		 protected function handleProgress(e:ProgressEvent):void  
		{  
			var pct:Number = e.bytesTotal == 0 ? 0 : Math.round( (e.bytesLoaded / e.bytesTotal)*100 );
			sendNotification(ApplicationConstants.LOAD_OBJECT_PROGRESS, {percent:pct}, NAME);  
		}  
		
		protected function onXMLLoadError(_event:IOErrorEvent):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_ERROR, _event.toString()+_event.type, NAME); 
		}
		
		public function get product_colors():ArrayCollection
		{
			return data as ArrayCollection;
		}
		
		// get item from id
		public function getItemFromId( id:String ):ProductColorVO
		{
			for ( var i:int=0; i<product_colors.length; i++ )
			{
				var color:ProductColorVO = product_colors[i] as ProductColorVO;
				if ( color.id == id ) {
					return color;
				}
			}
			return null;
		}
		
		
		
		// add an item to the data    
		public function addItem( item:Object ):void
		{
			product_colors.addItem( item );
		}
		
		// delete an item in the data
		/*public function deleteItem( item:Object ):void
		{
			var product_color:ProductColorVO = item as ProductColorVO;
			for ( var i:int=0; i<product_colors.length; i++ )
			{
				if ( product_colors[i].id == product_color.id ) {
					product_colors.removeItemAt(i);
				}
			}
		} */ 
		
		public function get loaded():Boolean
		{
			return _loaded;
		}
	}  
}