package view.components.bitmap
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import utils.BitmapDataUtil;
	import utils.DisplayObjectUtil;
	
	import view.components.designElement.DesignElementBase;
	
	public class BitmapComponent extends DesignElementBase
	{				
		private var bitmap:Bitmap;
		private var _hidden_colors:Vector.<uint>;
		private var original_bd:BitmapData;
		protected var loader:Loader = new Loader();		
		protected var _source:String;
		protected var sourceChanged:Boolean = false;		
		
		public function BitmapComponent()
		{
			super();
			_hidden_colors = new Vector.<uint>();
		}
		
		protected function invalidateSource():void
		{
			if(sourceChanged)
			{
				sourceChanged = false;
				
				//add listeners before load
				loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartHandler);
				loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
				loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
				//load clipart
				loader.load(new URLRequest(_source));
			}
			
		}
		
		private function onStartHandler(event:Event):void
		{
			this.dispatchEvent(event); //dispatch start event
		}
		private function loaderComplete(event:Event):void
		{
			bitmap = loader.content as Bitmap;
			bitmap.smoothing = true;
			original_bd = bitmap.bitmapData;
			
			//clear container
			while (container.numChildren>0) container.removeChildAt(0);
			container.addChild(bitmap);
			
			this.invalidate();
			
			setUnscaledSize(bitmap.width,bitmap.height);
			
			//dispatch complete event
			this.dispatchEvent(event);
			
		}
		private function invalidate():void
		{
			//DisplayObjectUtil.convertoToGrayScale(container);
			//BitmapDataUtil.convertToTransparent(bd);	
			if(bitmap && bitmap.bitmapData && _hidden_colors.length>0) {
				bitmap.bitmapData = BitmapDataUtil.transparentPixel(original_bd, _hidden_colors[0]);	
			}
			
		}
		
		
		private function onProgressHandler(event:ProgressEvent):void
		{
			this.dispatchEvent(event); //dispatch progress event
		}
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("Error loading bitmap"+event.toString());
			this.dispatchEvent(event); //dispatch error event
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			this.dispatchEvent(event); //dispatch error event
		}
		
		
		public function set hidden_colors(value:Vector.<uint>):void {
			_hidden_colors = value;
			this.invalidate();			
		}
		
		public function get hidden_colors():Vector.<uint>
		{
			return _hidden_colors;
		}
		
		public function set source(value:String):void {
			if(value!=_source)//if is the same source already loaded
			{
				_source = value;
				sourceChanged = true;
				
				invalidateSource();
			}
		}
		
		public function get source():String
		{
			return _source;
		}

		


	}
}