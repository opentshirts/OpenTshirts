package preloader
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import mx.events.EffectEvent;
	import mx.events.FlexEvent;
	import mx.events.RSLEvent;
	import mx.events.ResizeEvent;
	import mx.preloaders.IPreloaderDisplay;
	
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Sine;
	
	/**
	 * Implements a custom Flex preloader by drawing a colored circle with variable radius based on content being loaded (rsl/app. swf) and 
	 * fraction of total amount loaded.  Illustrates how to subclass Sprite when implementing the <code>IPreloaderDisplay</code> interface.
	  * 
	  * @author jim armstrong (reference: http://blog.lyraspace.com/2010/04/15/another-custom-flex-preloader-but-with-rsl-support/, which contains
	 * links to original tutorials by Jesse Warden and Bernhard Hirschmann.
	  * 
	  */  
	public class CustomPreloader extends Sprite implements IPreloaderDisplay
	{
		
		private var textField:TextField;
		
		// IPreloader properties
		protected var _backgroundAlpha:Number;
		protected var _backgroundColor:uint;
		protected var _backgroundImage:Object;
		protected var _backgroundSize:String;
		protected var _preloader:Sprite; 
		protected var _stageHeight:Number;
		protected var _stageWidth:Number;
		
		// custom preloader thingies
		protected var _rslDownloading:Boolean;
		protected var _rslFraction:Number;
		protected var _swfFraction:Number;
		protected var _rslBytes:Number;
		protected var _rslTotal:Number;
		
		// circle radius
		/*protected var _innerRadius:Number;
		protected var _middleRadius:Number;
		protected var _outerRadius:Number;*/
		
		public function CustomPreloader()
		{
			super();
			_backgroundAlpha = 1;
			_backgroundColor = 0xffffff;
			_backgroundSize  = "";
			_stageHeight     = 0;
			_stageWidth      = 0;
			
			_rslDownloading = false;
			_rslFraction    = 1; // in case RSL's are already downloaded
			_swfFraction    = 0;
			_rslBytes       = 0;
			_rslTotal       = 0;
			
			/*_innerRadius  = 50;
			_middleRadius = 100;
			_outerRadius  = 200;*/
			
			/*textField = new TextField();
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.background = true;
			textField.backgroundColor = 0xFF0000;
			textField.text = "Loading Design Studio..."
			addChild(textField);*/
			
			ExternalInterface.call("onLoadObjectStart");
		}
		
		public function get backgroundAlpha():Number
		{
			if( !isNaN(_backgroundAlpha) )
				return _backgroundAlpha;
			else
				return 1;
		}
		
		public function set backgroundAlpha(value:Number):void
		{
			_backgroundAlpha = value;
		}
		
		public function get backgroundColor():uint
		{
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_backgroundColor = value;
		}
		
		public function get backgroundImage():Object
		{
			return _backgroundImage;
		}
		
		public function set backgroundImage(value:Object):void
		{
			_backgroundImage = value;
		}
		
		public function get backgroundSize():String
		{
			return _backgroundSize;
		}
		
		public function set backgroundSize(value:String):void
		{
			_backgroundSize = value;
		}
		
		public function set preloader(value:Sprite):void
		{
			_preloader = value;
			
			// Loading RSL's into cache
			_preloader.addEventListener(RSLEvent.RSL_PROGRESS, rslProgressHandler);
			_preloader.addEventListener(RSLEvent.RSL_COMPLETE, rslCompleteHandler);
			_preloader.addEventListener(RSLEvent.RSL_ERROR   , rslErrorHandler   );
			
			// Application Loading
			_preloader.addEventListener(ProgressEvent.PROGRESS, progressHandler);    
			_preloader.addEventListener(Event.COMPLETE        , completeHandler);
			
			// Initialization 
			_preloader.addEventListener(FlexEvent.INIT_PROGRESS, initProgressHandler);
			_preloader.addEventListener(FlexEvent.INIT_COMPLETE, initCompleteHandler);
			
			// note that stageWidth should be the same as  _preloader.parent.stage.stageWidth
			centerPreloader();
		}
		
		public function get stageHeight():Number 
		{
			return _stageHeight;
		}
		
		public function set stageHeight(value:Number):void 
		{
			if( !isNaN(value) && value != _stageHeight )
				_stageHeight = value;
		}
		
		public function get stageWidth():Number 
		{
			return _stageWidth;
		}
		
		public function set stageWidth(value:Number):void 
		{
			if( !isNaN(value) && value != _stageWidth )
				_stageWidth = value;
		}
		
		public function initialize():void
		{ 
			this.stage.addEventListener(ResizeEvent.RESIZE, resizeHandler);
			updateProgress();
		}
		private function resizeHandler(e:Event=null):void
		{
			centerPreloader();
		}
		private function centerPreloader():void
		{
			//textField.x = (stageWidth - textField.width) / 2;
			//textField.y = (stageHeight - textField.height) / 2;
		}
		/**
		 * Updates the progress bar.
		 */
		private function updateProgress():void 
		{
			var p:Number = Math.round( (_rslFraction*100 + _swfFraction*100) / 2 );
			//textField.text = "Loading Design Studio..."+p+"%";
			
			ExternalInterface.call("onLoadObjectProgress",p);
			
		}
		/*protected function draw():void
		{
			var color:uint = 0x000000; // default color
			
			if( _swfFraction > 0 )
			{
				// exercise - make the color tween from yellow to green
				color             = _swfFraction < 1 ? 0xffff00 : 0x00ff00;
				var radius:Number = (1-_swfFraction)*_middleRadius + _rslFraction*_outerRadius;
			}
			else
			{
				color  = 0xff0000;
				radius = (1-_rslFraction)*_innerRadius + _rslFraction*_middleRadius;
			}
			graphics.clear();
			graphics.beginFill(color);
			graphics.drawCircle(0.5*stageWidth, 0.5*stageHeight, radius);
			graphics.endFill();
			
		}*/
		
		protected function rslProgressHandler(event:RSLEvent):void
		{
			_rslDownloading = true;	
			_rslBytes       = event.bytesLoaded;        
			_rslTotal       = event.bytesTotal;
			_rslFraction    = _rslBytes / _rslTotal;
			
			//trace("onRSLDownloadProgress: rslBytesLoaded " + _rslBytes);
			//trace("onRSLDownloadProgress: rslBytesTotal " + _rslTotal);
			//trace("RSL ** Progress: " + _rslFraction * 100 + "%");
			
			updateProgress();
		}
		
		protected function rslCompleteHandler(event:RSLEvent):void
		{
			//trace("RSL -- Complete: 100% - bytes total: " + event.bytesTotal + event.url.url);
			_rslFraction = 1;
			updateProgress();
		}
		
		protected function rslErrorHandler(event:RSLEvent):void
		{
			// handle error condition here 
			//trace("onRSLError: " + event.errorText + " - " + event.url);
		}
		
		protected function progressHandler(event:ProgressEvent):void
		{
			var swfBytes:Number = event.bytesLoaded;
			var swfTotal:Number = event.bytesTotal;
			
			/*if( _rslDownloading ) 
			{
				swfBytes -= _rslBytes;
				swfTotal -= _rslTotal;
			}*/
			
			_swfFraction = swfBytes / swfTotal;
			
			//trace("SWF -- Progress: " + _swfFraction * 100 + "%");
			//trace("onSWFDownloadProgress: swfBytesLoaded " + swfBytes);
			//trace("onSWFDownloadProgress: swfBytesTotal " + swfTotal);
			updateProgress();
		}
		
		protected function completeHandler(event:Event):void
		{
			//trace("onSWFDownloadComplete: 100%");
			_swfFraction = 1;
			updateProgress();
		}
		
		protected function initProgressHandler(event:FlexEvent):void
		{
			//trace("onFlexInitProgress: Initializing...");
			// this is dispatched during application initializion phases such as calls to measure(), commitProperties(), updateDisplayList(), blah, blah
		}
		
		protected function initCompleteHandler(event:FlexEvent):void
		{
			// the app. is fully initialized
			//trace("onFlexInitComplete");
			/*var anim:Animate = new Animate();
			anim.addEventListener(EffectEvent.EFFECT_END, onEffectEndHandler);
			anim.easer = new Sine(.3);
			anim.duration = 100;
			anim.target = textField;
			var motionPaths:Vector.<MotionPath> = new Vector.<MotionPath>();
			motionPaths.push(new SimpleMotionPath("alpha",textField.alpha, 0));
			anim.motionPaths = motionPaths;
			anim.play();*/
			onEffectEndHandler();
			
		}
		protected function onEffectEndHandler(event:EffectEvent = null):void
		{
			this.stage.removeEventListener(ResizeEvent.RESIZE, resizeHandler);
			dispatchEvent( new Event(Event.COMPLETE) );  // comment this out; your preloader will never go away :)
			ExternalInterface.call("onLoadObjectComplete");
		}
	}
}