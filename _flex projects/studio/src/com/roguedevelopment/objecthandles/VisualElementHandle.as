package com.roguedevelopment.objecthandles
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	
	import spark.core.SpriteVisualElement;
	
	/**
	 * A handle class based on SpriteVisualElement which is suitable for adding to
	 * a Flex 4 Group based container.
	 **/
	public class VisualElementHandle extends SpriteVisualElement implements IHandle
	{
		
		private var _descriptor:HandleDescription;		
		private var _targetModel:Object;
		private var _loader:Loader;
		private var container:Sprite;
		private var _handle_resize:Sprite;
		private var _handle_rotate:Sprite;

		protected var isOver:Boolean = false;
		
		public function get handleDescriptor():HandleDescription
		{
			return _descriptor;
		}
		public function set handleDescriptor(value:HandleDescription):void
		{
			_descriptor = value;
		}
		public function get targetModel():Object
		{
			return _targetModel;
		}
		public function set targetModel(value:Object):void
		{
			_targetModel = value;
		}
		
		public function VisualElementHandle()
		{
			super();
			this.mouseChildren = false;
			this.buttonMode = true;
			this.addEventListener( MouseEvent.ROLL_OUT, onRollOut );
			this.addEventListener( MouseEvent.ROLL_OVER, onRollOver );
			container = new Sprite();
			addChild(container);
			//redraw();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, errorHandler);
			
			_loader.load(new URLRequest("image/handle_resize.png"));

		}
		
		protected function completeHandler(e:Event):void {
			var handler_img:Bitmap = _loader.content as Bitmap;
			handler_img.x = -handler_img.width/2;
			handler_img.y = -handler_img.height/2;
			container.addChild(_loader);
			clearListeners();				
		}
		
		protected function errorHandler(e:IOErrorEvent):void {
			trace("Error loading image! Here's the error:\n" + e);
			clearListeners();
		}
		
		protected function clearListeners():void {
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, completeHandler);
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, errorHandler);
		}
		
		protected function onRollOut( event : MouseEvent ) : void
		{
			isOver = false;
			redraw();
		}
		protected function onRollOver( event:MouseEvent):void
		{
			isOver = true;
			redraw();
		}
		
		public function redraw() : void
		{
			graphics.clear();
			if( isOver )
			{
				graphics.lineStyle(2,0x3dff40);
				graphics.beginFill(0xFF0000	,1);				
			}
			else
			{
				graphics.lineStyle(2,0xFFFFFF);
				graphics.beginFill(0x000000,1);
			}
			
			graphics.drawRect(-4,-4,8,8);
			graphics.endFill();
			
		}
	}
}