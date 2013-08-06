package com.roguedevelopment.objecthandles.decorators
{
	import com.roguedevelopment.objecthandles.ObjectHandles;
	
	import flash.display.Sprite;
	
	/**
	 * This is an example decorator that draws a white border around all the selected objects.
	 **/
	public class OutlineDecorator implements IDecorator
	{
		public function OutlineDecorator()
		{
		}
		
		protected function updateDecoration(selectedObjects:Array, drawingCanvas:Sprite):void
		{
			drawingCanvas.graphics.clear();
			drawingCanvas.graphics.lineStyle( 5, 0xeeeeee, 1 );
			
			for each ( var model:Object in selectedObjects )
			{
				drawingCanvas.graphics.drawRect( model.x, model.y, model.width, model.height );					
			}
		}
		
		public function updateSelected( allObject:Array, selectedObjects:Array, drawingCanvas:Sprite ) : void
		{
			updateDecoration( selectedObjects, drawingCanvas );
		}
		public function updatePosition( allObject:Array, selectedObjects:Array, movedObjects:Array, drawingCanvas:Sprite ) : void
		{
			updateDecoration( selectedObjects, drawingCanvas );
		}
		public function cleanup(drawingCanvas:Sprite ):void
		{
			drawingCanvas.graphics.clear();
		}
	}
}