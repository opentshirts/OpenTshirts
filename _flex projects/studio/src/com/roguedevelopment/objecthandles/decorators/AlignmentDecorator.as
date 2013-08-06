package com.roguedevelopment.objecthandles.decorators
{
	import flash.display.Sprite;
	
	public class AlignmentDecorator implements IDecorator
	{
		public function AlignmentDecorator()
		{
		}
		
		
		public function updateSelected(allObject:Array, selectedObjects:Array, drawingCanvas:Sprite):void
		{
			drawingCanvas.graphics.clear();
		}
		
		public function updatePosition(allObject:Array, selectedObjects:Array, movedObjects:Array, drawingCanvas:Sprite):void
		{
			if( selectedObjects.length != 1 ) return;
			var o:Object = selectedObjects[0];
			drawingCanvas.graphics.clear();
			drawingCanvas.graphics.lineStyle(1,0x00aaaa,1);
			for each ( var other:Object in allObject )
			{
				if( other == o ) continue;
				if( Math.abs(o.x-other.x) < 1 ) drawVerticalLine(other.x,drawingCanvas);
				if( Math.abs(o.y-other.y) < 1 ) drawHorizontalLine(other.y,drawingCanvas);
				if( Math.abs((o.x+o.width)-(other.x+other.width)) < 1 ) drawVerticalLine(other.x+other.width,drawingCanvas);
				if( Math.abs((o.y+o.height)-(other.y + other.height)) < 1 ) drawHorizontalLine(other.y+other.height,drawingCanvas);

				if( Math.abs(o.x-(other.width+other.x)) < 1 ) drawVerticalLine(o.x,drawingCanvas);
				if( Math.abs(o.y-(other.y+other.height)) < 1 ) drawHorizontalLine(o.y,drawingCanvas);
				if( Math.abs((o.x+o.width)-other.x) < 1 ) drawVerticalLine(o.x+o.width,drawingCanvas);
				if( Math.abs((o.y+o.height)-other.y) < 1 ) drawHorizontalLine(o.y+o.height,drawingCanvas);

			}
			
		}

		
		protected function drawVerticalLine( x:Number, sprite:Sprite ) : void
		{
			sprite.graphics.moveTo(x,0);
			sprite.graphics.lineTo(x,3000);
		}
		protected function drawHorizontalLine( y:Number, sprite:Sprite ) : void
		{
			sprite.graphics.moveTo(0,y);
			sprite.graphics.lineTo(3000,y);
		}
		
		public function cleanup(drawingCanvas:Sprite):void
		{
			drawingCanvas.graphics.clear();
		}
	}
}