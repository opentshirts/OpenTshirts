package model.products
{	  
	import appFacade.ApplicationConstants;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import model.products.vo.ProductColorVO;
	import model.products.vo.ProductVO;
	import model.products.vo.RegionVO;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class ProductProxy extends Proxy implements IProxy  
	{  
		public static const NAME:String = 'ProductProxy';
		public static const PRODUCT_CREATED:String = NAME + 'PRODUCT_CREATED';
		
		public function ProductProxy(value_object:Object)  
		{  
			super( NAME, value_object  );
		}
		
		override public function getProxyName():String
		{
			return NAME + vo.id;
		}

		public function getService():void  
		{  
			if(vo.dataLoaded===true)
			{
				sendNotification(PRODUCT_CREATED, vo, NAME  );
			}else
			{
				var request:URLRequest = new URLRequest(); 
				var loader:URLLoader   = new URLLoader();  
				  
				sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME); 
				
				request.url = vo.apiLink;  
				  
				loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);  
				loader.addEventListener(IOErrorEvent.IO_ERROR, onXMLLoadError);
				loader.addEventListener(Event.COMPLETE, handleComplete);
				
				loader.load( request );  
			}
		}  
		  
		protected function handleComplete(e:Event):void  
		{  
			var productXML:XML  = new XML( e.target.data );
			
			if(productXML.error != undefined) {
				sendNotification(ApplicationConstants.ALERT_ERROR,String(productXML.error));
			} else {
				
				vo.id = String(productXML.id_product);
				vo.name = productXML.name;
				
				///product colors
				for each ( var colorXML:XML in productXML.colors.color)  
				{
					///we need color list already loaded here
					var productColor:ProductColorVO = productColorListProxy.getItemFromId(String(colorXML.id_product_color));
					if(productColor) {
						vo.availableColors.addItem(productColor);
					}
					if(String(colorXML.id_product_color) == String(productXML.default_color)) {
						vo.defaultColor = productColor;
					}
				}
				//vo.defaultColor = productColorListProxy.getItemFromId(String(productXML.default_color));
				if(!vo.currentColor)
				{
					vo.currentColor = vo.defaultColor;
				}
				
				///product view
				for each ( var viewXML:XML in productXML.views.view)  
				{
					var view_vo:ViewVO = new ViewVO();
					view_vo.view_index = String(viewXML.view_index);
					view_vo.name = String(viewXML.name);
					view_vo.product = vo;
					view_vo.shadeSrc = String(viewXML.shade);
					if(viewXML.underfill) {
						view_vo.underFill = String(viewXML.underfill);
					}
					view_vo.scale = Number(viewXML.regions_scale);
					for each ( var fill:XML in viewXML.fills.fill)  
					{
						view_vo.fillsSrc.push(String(fill.image));
					}
					for each ( var regionXML:XML in viewXML.regions.region)  
					{
						var region_vo:RegionVO = new RegionVO();
						region_vo.region_index = String(regionXML.region_index);
						region_vo.name = String(regionXML.name);
						region_vo.x = Number(regionXML.x);
						region_vo.y = Number(regionXML.y);
						region_vo.unscaledWidth = Number(regionXML.width);
						region_vo.unscaledHeight = Number(regionXML.height);
						region_vo.view = view_vo;
						region_vo.scale = Number(viewXML.regions_scale);
						region_vo.mask_url = String(regionXML.mask);
						
						facade.registerProxy(new RegionProxy(region_vo));
						view_vo.regions.addItem(region_vo);
						
						if(productXML.default_view == view_vo.view_index && productXML.default_region == region_vo.region_index)
						{
							vo.defaultRegion = region_vo;
						}
					}
					
					vo.views.addItem(view_vo);
					
				}
				
				vo.dataLoaded = true;
				sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME  );
				sendNotification(PRODUCT_CREATED, vo, NAME  );
				
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
		private function get productColorListProxy():ProductColorListProxy
		{
			return this.facade.retrieveProxy(ProductColorListProxy.NAME) as ProductColorListProxy;
		}
		public function get vo():ProductVO
		{
			return data as ProductVO;
		}
		
	}  
}