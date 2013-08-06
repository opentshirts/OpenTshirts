package view.components.designElement
{
	import events.DesignElementEvent;
	
	import flash.display.Sprite;
	
	import spark.core.SpriteVisualElement;
	
	public class DesignElementBase extends SpriteVisualElement
	{
		public var container:Sprite = new Sprite();
		protected var _w:Number;
		protected var _h:Number;
		protected var sizeChanged:Boolean = false;
		
		protected var _flipH:Boolean = false;
		protected var _flipV:Boolean = false;
		
		protected var _unscaledWidth:Number;
		protected var _unscaledHeight:Number;
		//protected var unscaledSizeChanged:Boolean = false;
		
		protected var _xPos:Number;
		protected var _yPos:Number;
		protected var posChanged:Boolean = false;
		
		protected var _rot:Number;
		protected var rotChanged:Boolean = false;
		

		
		
		public function DesignElementBase()
		{
			super();
			/*this.graphics.beginFill(0xFF0000);
			this.graphics.drawRect(0,0,100,100);
			this.graphics.endFill();*/
			addChild(container);
			container.useHandCursor = true;
			container.buttonMode = true
			container.mouseChildren = false;
		}



		protected function invalidateElementSize():void
		{
			///don't resize and rotate the same displayObject
			if(sizeChanged)
			{
				sizeChanged = false;
				//this.container.width = _w; 
				//this.container.height = _h;
				this.container.scaleX = _w/_unscaledWidth; 
				this.container.scaleY = _h/_unscaledHeight;
				trace("container.width "+(this.container.width));
				
				invalidateFlip();
				
				this.dispatchEvent(new DesignElementEvent(DesignElementEvent.SIZE_CHANGE, false, false, {width: _w, height:_h}));
				
			}
		}
		protected function invalidatePosition():void
		{
			if(posChanged)
			{
				posChanged = false;
				
				this.x = _xPos;
				this.y = _yPos;
				
				this.dispatchEvent(new DesignElementEvent(DesignElementEvent.POSITION_CHANGE, false, false, {x: _xPos, y:_yPos}));
			}
		}
		protected function invalidateFlip():void
		{
			if(_flipH)
			{
				this.container.scaleX = Math.abs(this.container.scaleX)*-1;
				this.container.x = this.container.width;
			}else
			{
				this.container.scaleX = Math.abs(this.container.scaleX);
				this.container.x = 0;
			}
			
			if(_flipV)
			{
				this.container.scaleY = (this.container.scaleY>0)?this.container.scaleY*-1:this.container.scaleY;
				this.container.y = this.container.height;
			}else
			{
				this.container.scaleY = Math.abs(this.container.scaleY);
				this.container.y = 0;
			}
		}
		protected function invalidateRotation():void
		{
			if(rotChanged)
			{
				rotChanged = false;
				
				this.rotation = rot;
				
				this.dispatchEvent(new DesignElementEvent(DesignElementEvent.ROTATION_CHANGE, false, false, {rotation: rot}));
			}
		}

		public function setSize(width:Number, height:Number):void
		{
			_h = height;
			_w = width;
			
			sizeChanged = true;
			
			invalidateElementSize();
		}
		public function setFlip(flipH:Boolean, flipV:Boolean):void
		{
			_flipH = flipH;
			_flipV = flipV;
			
			invalidateFlip();
		}
		

		public function setUnscaledSize(uwidth:Number, uheight:Number):void
		{
			_unscaledWidth = uwidth;
			_unscaledHeight = uheight;
			//unscaledSizeChanged = true;
			this.dispatchEvent(new DesignElementEvent(DesignElementEvent.UNSCALED_SIZE_CHANGE, false, false, {width: uwidth, height:uheight}));
			
		}


		public function setPos(posx:Number, posy:Number):void
		{
			_xPos = posx;
			_yPos = posy;
			
			posChanged = true;
			
			invalidatePosition();
		}
		public function get rot():Number
		{
			return _rot;
		}

		public function set rot(value:Number):void
		{
			_rot = value;
			
			rotChanged = true;
			
			invalidateRotation();
		}
		
		public function updateCanvasColor():void
		{
			//override if necessary
		}


	}
}