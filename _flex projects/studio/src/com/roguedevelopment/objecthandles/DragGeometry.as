/**
 *  Latest information on this project can be found at http://www.rogue-development.com/objectHandles.html
 * 
 *  Copyright (c) 2009 Marc Hughes 
 * 
 *  Permission is hereby granted, free of charge, to any person obtaining a 
 *  copy of this software and associated documentation files (the "Software"), 
 *  to deal in the Software without restriction, including without limitation 
 *  the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 *  and/or sell copies of the Software, and to permit persons to whom the Software 
 *  is furnished to do so, subject to the following conditions:
 * 
 *  The above copyright notice and this permission notice shall be included in all 
 *  copies or substantial portions of the Software.
 * 
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 *  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
 *  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT 
 *  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
 *  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
 *  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 
 * 
 *  See README for more information.
 * 
 **/
package com.roguedevelopment.objecthandles
{
	import flash.geom.Rectangle;
	
	/**
	 * Internally, ObjectHandles uses a DragGeometry to keep track of component during active
	 * moves, and is how it applies constraints to those moves.
	 **/
	public class DragGeometry
	{
		[Bindable] public var x:Number=0;
		[Bindable] public var y:Number=0;
		[Bindable] public var width:Number=0;
		[Bindable] public var height:Number=0;
		[Bindable] public var rotation:Number=0;
		[Bindable] public var isLocked:Boolean = false;

		public function clone() : DragGeometry
		{
			var rv:DragGeometry = new DragGeometry();
			rv.x = x;
			rv.y = y;
			rv.width = width;
			rv.height = height;
			rv.rotation = rotation;
			return rv;
		}

		public function copyFrom( other:DragGeometry ) : void
		{
			x=other.x;
			y=other.y;
			width=other.width;
			height=other.height;
			rotation=other.rotation;
		}

		
		public function getRectangle() : Rectangle
		{
			return new Rectangle(x,y,width,height);
		}
		
		public function toString() : String
		{
			return "[DragGeometry " + x + "," + y + "+" + width + "x" + height + "]"; 	
		}
	}
}