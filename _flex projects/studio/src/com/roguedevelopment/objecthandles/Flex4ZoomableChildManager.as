package com.roguedevelopment.objecthandles
{
	import flash.display.DisplayObject;

	public class Flex4ZoomableChildManager extends Flex4ChildManager
	{
		private static var _parentScale:Number = 1;
		private static var childs:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		
		public static function set parentScale(value:Number):void
		{
			_parentScale = value;
			for (var i:uint = 0; i < childs.length; i++) 
			{
				childs[i].scaleX = childs[i].scaleY = inverseScale;
			}
			
		}
		public static function get inverseScale():Number
		{
			return 1/_parentScale;
		}
		
		override public function addChild(container:Object, child:Object):void
		{
			super.addChild(container, child);
			child.scaleX = child.scaleY = inverseScale;
			childs.push(child);
		}
		override public function removeChild(container:Object, child:Object):void
		{
			super.removeChild(container, child);
			for (var i:uint = 0; i < childs.length; i++) 
			{
				if(childs[i]==child)
				{
					childs.splice(i,1);
					break;
				}
			}
		}
	}
}