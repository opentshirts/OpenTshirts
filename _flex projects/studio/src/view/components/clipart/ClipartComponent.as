package view.components.clipart
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	
	import model.elements.cliparts.vo.LayerVO;
	
	import utils.DisplayObjectUtil;
	
	import view.components.designElement.DesignElementBase;
	
	public class ClipartComponent extends DesignElementBase
	{		
		private var layerSprite:Vector.<Sprite> = new Vector.<Sprite>();
		
		protected var loader:Loader = new Loader();
		protected var loaderContentChanged:Boolean = false;
		
		protected var _source:String;
		protected var sourceChanged:Boolean = false;
		
		private var _layers:Vector.<LayerVO>;
		protected var layersChanged:Boolean = false;
		
		
		public function ClipartComponent()
		{
			super();
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
		protected function invalidateLayers():void
		{
			if(layersChanged || loaderContentChanged)
			{
				layersChanged = false;
				loaderContentChanged = false;
				if(layerSprite.length==layers.length)
				{
					for (var i:int = 0; i < layerSprite.length; i++) 
					{
						if(layers[i])
						{
							layerSprite[i].alpha = (!layers[i].visible)?0:layers[i].actualColor.alpha;
							DisplayObjectUtil.tint(layerSprite[i],layers[i].actualColor.hexa);
						}
					}
				}else{
					trace("layerSprite and layers not same length");
				}
			}
			
		}
		override public function updateCanvasColor():void
		{
			layersChanged = true;
			invalidateLayers();
		}
		private function onStartHandler(event:Event):void
		{
			this.dispatchEvent(event); //dispatch start event
		}
		private function loaderComplete(event:Event):void
		{
			var mc:Sprite = loader.content as Sprite;
			
			//clear container
			while (container.numChildren>0) container.removeChildAt(0);
			container.addChild(mc);
			
			for (var i:uint=0; i<mc.numChildren; i++) {
				if (mc.getChildAt(i) is Sprite) {
					var mc_child:Sprite = mc.getChildAt(i) as Sprite;
					layerSprite.push(mc_child); //save references to each layer
				} 
				else
				{
					trace("childNotSprite");
				}
			}
			
			setUnscaledSize(mc.width,mc.height);

			loaderContentChanged = true;
			invalidateLayers();
			
			//dispatch complete event
			this.dispatchEvent(event);
			
		}
		private function onProgressHandler(event:ProgressEvent):void
		{
			this.dispatchEvent(event); //dispatch progress event
		}
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			trace("Error loading swf"+event.toString());
			this.dispatchEvent(event); //dispatch error event
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			this.dispatchEvent(event); //dispatch error event
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

		public function get layers():Vector.<LayerVO>
		{
			return _layers;
		}

		public function set layers(value:Vector.<LayerVO>):void
		{
			_layers = value;
				
			layersChanged = true;
			
			invalidateLayers();
		}


	}
}