package com.roguedevelopment.objecthandles
{
	import flash.display.DisplayObject;
	
	import mx.core.Container;

	/**
	 * A class that knows how to add and remove children from a Flex 3 based component using
	 * either addChild or rawChildren.addChild
	 **/
	public class Flex3ChildManager implements IChildManager
	{
		public function Flex3ChildManager()
		{
		}
		
		public function addChild(container:Object, child:Object):void
		{
			if( container is Container )
			{
				(container as Container).rawChildren.addChild(child as DisplayObject);
			}			           
			else
			{
				container.addChild( child as DisplayObject);
			}
		}
		
		public function removeChild(container:Object, child:Object):void
		{
			if( container is Container )
			{
				(container as Container).rawChildren.removeChild(child as DisplayObject);
			}
			else
			{
				container.removeChild( child as DisplayObject);
			}
		}
	}
}