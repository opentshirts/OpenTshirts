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
    
    import flash.geom.Matrix;
    import flash.geom.Point;

	
	/** 
	 * This is a constraint which causes the resized component to maintain a constant aspect ration.
	 *    
	 **/

    public class MaintainProportionConstraint implements IConstraint
    {
    	private var origin:Point = new Point(0,0);
    	
    	
        public function applyConstraint(original:DragGeometry, translation:DragGeometry, resizeHandleRole:uint):void
        {                   
        	if( ! HandleRoles.isResize( resizeHandleRole ) ) return;
        	
            var originalProportion:Number = original.width / original.height;  // x/y
            var possiblePos1:Point = new Point( translation.width, translation.width / originalProportion );
            var possiblePos2:Point = new Point( translation.height * originalProportion, translation.height );
            var originalPoint:Point = new Point( translation.width, translation.height);
            var distance1:Number = Point.distance( possiblePos1, originalPoint );
            var distance2:Number = Point.distance( possiblePos2, originalPoint );
            
            var target:Point;
            
            if( !(HandleRoles.isResizeDown(resizeHandleRole) || HandleRoles.isResizeUp(resizeHandleRole)) )
            {
            	// only resize left/right
            	target =  possiblePos1 ;
            }
            else if( !(HandleRoles.isResizeLeft(resizeHandleRole) || HandleRoles.isResizeRight(resizeHandleRole)) )
            {
            	// only resize up/down
            	target = possiblePos2;
            }
            else
            {
            	target = distance1 < distance2 ? possiblePos1 : possiblePos2;	
            }
             
            translation.width = target.x;
            translation.height = target.y;	
            

         
        }


   
        
    }
}