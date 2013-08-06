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
	import com.roguedevelopment.objecthandles.IConstraint;
	
	public class SizeConstraint implements IConstraint
	{
		public var maxWidth:Number;
		public var minWidth:Number;
		public var maxHeight:Number;
		public var minHeight:Number;
		
		public function applyConstraint( original:DragGeometry, translation:DragGeometry, resizeHandleRole:uint ) : void		
		{
			if( ! isNaN( maxWidth ) )
			{
				if( (original.width + translation.width) > maxWidth )
				{
					translation.width = maxWidth - original.width;
				}
			}
				
			if( ! isNaN( maxHeight ) )
			{
				if( (original.height + translation.height) > maxHeight )
				{
					translation.height = maxHeight - original.height;
				}
			}

			if( ! isNaN( minWidth ) )
			{							
				if( (original.width + translation.width) < minWidth )
				{
					translation.width = minWidth - original.width;
				}
			}

			if( ! isNaN( minHeight ) )
			{				
				if( (original.height + translation.height) < minHeight )
				{
					translation.height = minHeight - original.height;
				}
			}	
								
			
		}

	}
}