package view.components.product
{
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	
	import spark.components.Group;
	import spark.components.Image;
	
	[Event(name="complete", type="flash.events.Event")]
	
	
	public class ProductViewComponent extends Group
	{
		private var _numColors:uint;
		private var _bImageLoadComplete:Boolean = false;
		
		private var _colors:Vector.<uint> = new Vector.<uint>();
		private var _bColorsChange:Boolean = false;
		
		private var _shade_url:String;
		private var _bShadeSourceChange:Boolean = false;
		
		private var _fills:Vector.<String>;
		private var _bFillSourceChange:Boolean = false;
		
		private var _fillImages:Vector.<Image> = new Vector.<Image>();
		
		private var _underFill:String;
		private var _bUnderFillChange:Boolean = false;
		
		
		public var underFillContainer:Group;
		public var fillsContainer:Group;
		public var underShade:Group;
		public var shaderContainer:Group;
		public var overShade:Group;
		
		
		public function ProductViewComponent() 
		{
			super();
			/*this.graphics.beginFill(0xFF0000);
			this.graphics.drawCircle(0,0,10);
			this.graphics.endFill();*/
		}
		

		public function get underFill():String
		{
			return _underFill;
		}

		public function set underFill(value:String):void
		{
			_underFill = value;
			_bUnderFillChange = true;
			
			invalidateDisplayList();
		}

		public function get fills():Vector.<String>
		{
			return _fills;
		}
		
		public function set fills(value:Vector.<String>):void
		{
			_fills = value;
			_bFillSourceChange = true;
			
			invalidateDisplayList();
		}
		
		public function get shade_url():String
		{
			return _shade_url;
		}
		
		public function set shade_url(value:String):void
		{
			_shade_url = value;
			_bShadeSourceChange = true;
			
			invalidateDisplayList();
		}
		
		public function get colors():Vector.<uint>
		{
			return _colors;
		}
		
		public function set colors(value:Vector.<uint>):void
		{
			_colors = value;
			_bColorsChange = true;
			
			invalidateDisplayList();
		}
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(!underFillContainer)
			{
				underFillContainer  = new Group();
				addElement(underFillContainer);
			}
			if(!fillsContainer)
			{
				fillsContainer  = new Group();
				addElement(fillsContainer);
			}
			if(!underShade)
			{
				underShade  = new Group();
				addElement(underShade);
			}
			if(!shaderContainer)
			{
				shaderContainer  = new Group();
				//disable click on shade because is over design elements
				shaderContainer.mouseChildren = false;
				shaderContainer.mouseEnabled = false;
				
				///convert image to grayscale
				var matrix:Array = [0.3, 0.59, 0.11, 0, 0,
									0.3, 0.59, 0.11, 0, 0,
									0.3, 0.59, 0.11, 0, 0,
									  0,    0,    0, 1, 0];
				var grayscaleFilter:ColorMatrixFilter = new ColorMatrixFilter(matrix);
				var filters:Array = shaderContainer.filters;
				filters.push(grayscaleFilter);
				shaderContainer.filters = filters; 
				
				///set blend mode to multiply in order to work with JPG images
				shaderContainer.blendMode = BlendMode.MULTIPLY;
				addElement(shaderContainer);
			}
			if(!overShade)
			{
				overShade  = new Group();
				//disable click on shade because is over design elements
				//overShade.mouseChildren = false;
				//overShade.mouseEnabled = false;
				addElement(overShade);
			}
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if(_bColorsChange || _bImageLoadComplete)
			{
				_bColorsChange = false;
				_bImageLoadComplete = false;
				
				
				if(_fillImages.length!=colors.length)
				{
					//trace("error rango fills:"+_fillImages.length+"   / colors:"+colors.length);
				}else
				{
					for(var i:uint=0; i<_fillImages.length; i++)
					{
						if(_fillImages[i])
						{
							tint(_fillImages[i], colors[i]);
						}
					}
				}
				
				scaleContent(unscaledWidth, unscaledHeight);
				
			}
			if(_bUnderFillChange)
			{
				_bUnderFillChange = false;
				
				underFillContainer.removeAllElements();
				if(_underFill) {
					var underfill_img:spark.components.Image = new spark.components.Image();
					underfill_img.smooth = true;
					underfill_img.source = _underFill;
					
					//shader_img.addEventListener(Event.OPEN, onStartHandler);
					this.dispatchEvent(new Event(Event.OPEN));
					underfill_img.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
					underfill_img.addEventListener(Event.COMPLETE, loaderComplete);
					underfill_img.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					underfill_img.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);					
					
					underFillContainer.addElement(underfill_img);
				}
			}
			if(_bShadeSourceChange)
			{
				_bShadeSourceChange = false;
				
				shaderContainer.removeAllElements();
				if(_shade_url) {
					var shader_img:spark.components.Image = new spark.components.Image();
					shader_img.smooth = true;
					shader_img.source = _shade_url;
					
					//shader_img.addEventListener(Event.OPEN, onStartHandler);
					this.dispatchEvent(new Event(Event.OPEN));
					shader_img.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
					shader_img.addEventListener(Event.COMPLETE, loaderComplete);
					shader_img.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
					shader_img.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);					
					
					shaderContainer.addElement(shader_img);
				}
			}
			
			if(_bFillSourceChange)
			{
				_bFillSourceChange = false;
				
				fillsContainer.removeAllElements();
				//_fillImages = new Vector.<Image>();
				while(_fillImages.length>0) _fillImages.pop();
				//trace(_fillImages)
				if(fills) {
					var j:uint = 0;
					for each(var fill:Object in fills)
					{
						var img:spark.components.Image = null;
						if(fill)
						{
							//trace("add fill "+j+" "+fill)
							img = new spark.components.Image();
							img.smooth = true;
							img.source = fill;
							
							//img.addEventListener(Event.OPEN, onStartHandler);
							this.dispatchEvent(new Event(Event.OPEN));
							img.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);
							img.addEventListener(Event.COMPLETE, loaderComplete);
							img.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
							img.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
							
							fillsContainer.addElement(img);
							
							
						}else{
							//trace("fill not added "+j+" fill:"+fill);
						}
						_fillImages.push(img);//add even if is null for colors index
						j++;
					}
				}
			}
		}
		private function scaleContent(unscaledWidth:Number, unscaledHeight:Number):void
		{
			//based on from mx.controls.SWFLoader doScaleContent
			var interiorWidth:Number = unscaledWidth;
			var interiorHeight:Number = unscaledHeight;
			
			var newXScale:Number = contentWidth == 0 ?
				1 :
				interiorWidth / contentWidth;
			var newYScale:Number = contentHeight == 0 ?
				1 :
				interiorHeight / contentHeight;
			
			var scale:Number;
			
			if (newXScale > newYScale)
			{
				x = Math.floor((interiorWidth - contentWidth * newYScale) * .5); //0=left | .5=center | 1=right 
				y = 0;
				scale = newYScale;
			}
			else
			{
				y = Math.floor((interiorHeight - contentHeight * newXScale) * .0); //0=top | .5=middle | 1=bottom 
				x = 0;
				scale = newXScale;
				
			}
			
			// Scale by the same amount in both directions.
			this.scaleX = scale;
			this.scaleY = scale;
			
			/*this.fillsContainer.scaleX = this.fillsContainer.scaleY = scale;
			this.shaderContainer.scaleX = this.shaderContainer.scaleY = scale;
			this.elementsContainer.scaleX = this.elementsContainer.scaleX = scale;*/
			
		}
		
		
		private function tint(dobj:DisplayObject, color:uint):void 
		{
			var colorTransform:ColorTransform = dobj.transform.colorTransform;
			colorTransform.color=color;
			dobj.transform.colorTransform = colorTransform;
		}
		
		private function onStartHandler(event:Event):void
		{
			this.dispatchEvent(event); //dispatch start event
		}
		
		private function loaderComplete(event:Event):void
		{
			_bImageLoadComplete = true;
			invalidateDisplayList();
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
		
		
	}
}