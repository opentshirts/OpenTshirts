package 
{
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.core.SpriteVisualElement;
	
	/**
	 * ...
	 * @author Jose Andriani joseandriani@gmail.com
	 */
	public class Region extends Group
	{
		public var index:String;
		//private var name:String;
		private var w:Number;
		private var h:Number;
		private var loader:Loader = new Loader();
		private var region_container:SpriteVisualElement;
		private var mask_image:Bitmap;
		
		
		public static var scale:Number = 0;
		
		
		public function Region(index:String, w:Number, h:Number, name:String, xpos:Number, ypos:Number)
		{
			this.index = index;
			this.region_container = new SpriteVisualElement();
			this.region_container.blendMode = BlendMode.INVERT;
			addElement(region_container);
			update(w,h,name)
			this.region_container.x = xpos;
			this.region_container.y = ypos;			
			this.region_container.addEventListener(MouseEvent.MOUSE_DOWN, rectMouseDown);
		}
		
		public function loadImage(url:String):void {
			//clear container
			while (region_container.numChildren>0) region_container.removeChildAt(0);
			
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			loader.load(new URLRequest(url));
		}
		private function onIOError(event:Event):void
		{
			
		}
		
		private function loaderComplete(event:Event):void
		{
			mask_image = loader.content as Bitmap;
			region_container.addChild(mask_image);
			drawRect();
		}

		public function update(w:Number, h:Number, name:String):void {
			this.w = w;
			this.h = h;
			this.name = name;
			toolTip = name;
			drawRect();
		}
		public function drawRect():void
		{
			region_container.graphics.clear();
			region_container.graphics.beginFill(0x000000, .2);
			region_container.graphics.lineStyle(2,0xFFFFFF,1,true,LineScaleMode.NONE);
			region_container.graphics.drawRect(0, 0, this.w*scale, this.h*scale);
			region_container.graphics.endFill();
			
			if(mask_image) {
				mask_image.width = this.w*scale;
				mask_image.height = this.h*scale;
			}
			
			
			region_container.buttonMode = true;
		}
		public function get xPos():Number
		{
			return this.region_container.x;
		}
		public function get yPos():Number
		{
			return this.region_container.y;
		}
		private function rectMouseDown(event:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, rectStopDrag);
			region_container.startDrag();
		}
		private function rectStopDrag(event:MouseEvent):void
		{
			region_container.stopDrag();
			stage.removeEventListener(MouseEvent.MOUSE_UP, rectStopDrag);
			dispatchEvent(new Event(Event.CHANGE));
		}
	}
}