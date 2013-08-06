package com.roguedevelopment.objecthandles.decorators
{
	import flash.display.Sprite;

	public interface IDecorator
	{
		function updateSelected( allObject:Array, selectedObjects:Array, drawingCanvas:Sprite ) : void;
		function updatePosition( allObject:Array, selectedObjects:Array, movedObjects:Array, drawingCanvas:Sprite ) : void;
		function cleanup(drawingCanvas:Sprite ):void;
	}
	
	
}