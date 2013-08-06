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
 
package com.roguedevelopment.objecthandles.constraints
{
	import com.roguedevelopment.objecthandles.DragGeometry;
	import com.roguedevelopment.objecthandles.HandleRoles;
	import com.roguedevelopment.objecthandles.IConstraint;
	
	/**
	 * This is a constraint that makes an object stay within a certain bounds.
	 * 
	 * This isn't really done yet.  It doesn't handle rotated objects well
	 **/
	public class MovementConstraint implements IConstraint
	{
		public var minX:Number;
		public var minY:Number;
		public var maxX:Number;
		public var maxY:Number;

		public function applyConstraint( original:DragGeometry, translation:DragGeometry, resizeHandleRole:uint ) : void
		{
			if(!isNaN(maxX))
			{
				if((original.x + translation.x + original.width +
					translation.width) > maxX)
				{
					if(HandleRoles.isMove(resizeHandleRole))
					{
						translation.x = maxX - (original.x + original.width);
					}
					else if(HandleRoles.isResizeRight(resizeHandleRole))
					{
						translation.width = maxX - (original.x + translation.x +
							original.width);
						
					}
				}
			}
			
			if(!isNaN(maxY))
			{
				if((original.y + translation.y + original.height +
					translation.height) > maxY)
				{
					if(HandleRoles.isMove(resizeHandleRole))
					{
						translation.y = maxY - (original.y + original.height);
					}
					else if(HandleRoles.isResizeDown(resizeHandleRole))
					{
						translation.height = maxY - (original.y + translation.y +
							original.height);
						
					}
				}
			}
			
			if(!isNaN(minX))
			{
				if((original.x + translation.x) < minX)
				{
					translation.x = minX - original.x;
				}
				if(HandleRoles.isResizeLeft(resizeHandleRole) && original.x -
					translation.width < minX)
				{
					translation.width = - minX + original.x;
				}
			}
			
			if(!isNaN(minY))
			{
				if((original.y + translation.y) < minY)
				{
					translation.y = minY - original.y;
				}
				if(HandleRoles.isResizeUp(resizeHandleRole) && original.y -
					translation.height < minY)
				{
					translation.height = - minY + original.y;
				}
				
			}
		}

	}
}