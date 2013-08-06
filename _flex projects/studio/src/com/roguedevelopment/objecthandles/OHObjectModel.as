package com.roguedevelopment.objecthandles
{
	import Interfaces.IIdentifiable;

	public class OHObjectModel implements IIdentifiable, IMoveable, IResizeable
	{
		[Bindable] public var uid:String;
		[Bindable] public var x:Number=0;
		[Bindable] public var y:Number=0;
		[Bindable] public var width:Number=0;
		[Bindable] public var height:Number=0;
		[Bindable] public var rotation:Number=0;
		[Bindable] public var maintainProportions:Boolean = true;
		[Bindable] public var isLocked:Boolean = false;
		
		public function copyFromObject( other:Object ) : void
		{
			uid=other.uid;
			x=other.x;
			y=other.y;
			width=other.width;
			height=other.height;
			rotation=other.rotation;
			maintainProportions=other.maintainProportions;
			isLocked=other.isLocked;
		}
	}
}