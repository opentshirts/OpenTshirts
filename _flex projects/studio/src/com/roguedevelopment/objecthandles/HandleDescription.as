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
    import flash.geom.Point;
    
    import mx.core.IFactory;
    
    public class HandleDescription
    {       
    	[Bindable]
        public var role:uint;
        public var percentageOffset:Point;
        public var offset:Point;
        public var handleFactory:IFactory;
        public var constraint:IFactory;
        
        
        /**
        * Creates a new handle description.
        * 
        * @param role a value from HandleRoles
        * @param percentageOffset Where should this handle go as a percent of the height/width of the component?  For instance (50,50) would center it
        * 						  and (100,0) would be the top right corner.
        * 
        * @param offset After the percentageOffset is applied, how many pixes should we offset the handle by?
        * @param handleFactory An IFactory that can create the DisplayObject for this handle.  By default you get a grey box.  Customize this
        * 					   to have different handle graphics.
        * @param constraint Allows you to have custom constraints for some of the handles.
        * 
        **/ 
        public function HandleDescription(role:uint, percentageOffset:Point, offset:Point, handleFactory:IFactory = null, constraint:IFactory = null ) 
        {
            this.role = role;
            this.percentageOffset = percentageOffset;
            this.offset = offset;
            this.handleFactory = handleFactory;
            this.constraint = constraint;
        }
    }
}