package
{
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	
	import spark.core.SpriteVisualElement;
	
	public class ClipartComponent extends SpriteVisualElement
	{
		private var layerSprite:Vector.<Sprite>;
		private var defaultColors:Vector.<uint>;
		
		private var container:Sprite = new Sprite();
		private var loader:Loader = new Loader();
		public static const CHILD_NOT_MC:String = "CHILD_NOT_MC";
		public static const LAYERS_NUM_CHANGE:String = "LAYERS_NUM_CHANGE";
		
		
		
		public function ClipartComponent()
		{
			super();
			this.addChild(container);
		}
		public function setSource(source:String):void
		{
			//add listeners before load
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
			//load clipart
			loader.load(new URLRequest(source));
		}
		public function setLayerColor(layerIndex:uint, layerColor:String):void
		{
			if(layerSprite) {
				if(layerIndex>=0 && layerIndex<layerSprite.length)
				{
					tint(layerSprite[layerIndex], uint("0x" + layerColor));
				}
			}
		}
		public function getNumLayers():uint
		{
			return layerSprite.length;
		}
		private function tint(sp:Sprite, color:uint):void {
			var colorTransform:ColorTransform = sp.transform.colorTransform;
			colorTransform.color=color;
			sp.transform.colorTransform = colorTransform;
		}
		private function onStartHandler(event:Event):void
		{
			this.dispatchEvent(event); //dispatch start event
		}
		private function loaderComplete(event:Event):void
		{
			var mc:Sprite = loader.content as Sprite;
			
			if(!mc)
			{
				this.dispatchEvent(new Event(CHILD_NOT_MC));
				return;
			}
			//clear container
			while (container.numChildren>0) container.removeChildAt(0);
			container.addChild(mc);
			
			layerSprite = new Vector.<Sprite>();
			defaultColors = new Vector.<uint>();
			
			for (var i:uint=0; i<mc.numChildren; i++) {
				if (mc.getChildAt(i) is Sprite) {
					var mc_child:Sprite = mc.getChildAt(i) as Sprite;
					layerSprite.push(mc_child); //save references to each layer
					var currentTint:uint = mc_child.transform.colorTransform.color;
					defaultColors.push(currentTint);
				} 
				else
				{
					this.dispatchEvent(new Event(CHILD_NOT_MC));
				}
			}
			container.width = 280;
			container.scaleY = container.scaleX;
			if(container.height>280) {
				container.height = 280;
				container.scaleX = container.scaleY;
			}
			//dispatch complete event
			this.dispatchEvent(event);
			

			this.dispatchEvent(new Event(LAYERS_NUM_CHANGE));
			
		}
		private function onProgressHandler(event:ProgressEvent):void
		{
			this.dispatchEvent(event); //dispatch progress event
		}
		private function ioErrorHandler(event:IOErrorEvent):void
		{
			this.dispatchEvent(event); //dispatch error event
		}
		private function httpStatusHandler(event:HTTPStatusEvent):void
		{
			this.dispatchEvent(event); //dispatch error event
		}
		
	}
}