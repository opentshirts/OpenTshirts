package com.roguedevelopment.objecthandles.decorators
{
	import flash.display.Sprite;
	
	/**
	 * This is a sample decorator that draws lines between all the objects.
	 **/
	public class WebDecorator implements IDecorator
	{
		public function WebDecorator()
		{
		}
		
		protected function drawWeb( objects:Array, drawingCanvas:Sprite):void
		{
			drawingCanvas.graphics.clear();
			drawingCanvas.graphics.lineStyle(5,0x777777);
			for( var i:int = 1 ; i < objects.length ; i++ )
			{
				for( var j:int=(i+1) ; j < objects.length ; j++ )
				{
					drawingCanvas.graphics.moveTo( objects[i].x + objects[i].width/2, objects[i].y + objects[i].height/2 );		
					drawingCanvas.graphics.lineTo( objects[j].x + objects[j].width/2, objects[j].y + objects[j].height/2 );
				}
			}
			
		}
		
		public function updateSelected(allObject:Array, selectedObjects:Array, drawingCanvas:Sprite):void
		{
			drawWeb(allObject,drawingCanvas);
				
		}
		
		public function updatePosition(allObject:Array, selectedObjects:Array, movedObjects:Array, drawingCanvas:Sprite):void
		{
			drawWeb(allObject,drawingCanvas);
		}
		
		public function cleanup(drawingCanvas:Sprite):void
		{
		}
	}
}