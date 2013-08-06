package Interfaces
{
	import flash.display.Sprite;
	import flash.events.IEventDispatcher;

	public interface IProductComponent extends IEventDispatcher
	{
		function get fillsContainer():Sprite;
		function get shaderContainer():Sprite;
		function set source(value:Object):void;
		function set colors(array_colors:Vector.<uint>):void;
		
	}
}