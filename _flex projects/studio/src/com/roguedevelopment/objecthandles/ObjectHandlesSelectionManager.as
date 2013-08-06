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
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	[Event(name="removedFromSelection", type="com.roguedevelopment.objecthandles.SelectionEvent")]
	[Event(name="selectionCleared", type="com.roguedevelopment.objecthandles.SelectionEvent")]
	[Event(name="addedToSelection", type="com.roguedevelopment.objecthandles.SelectionEvent")]
	public class ObjectHandlesSelectionManager extends EventDispatcher
	{
		public var currentlySelected:Array = [];
		
		
		public function ObjectHandlesSelectionManager()
		{}
		
		public function addToSelected( model:Object ) : void
		{

			if( currentlySelected.indexOf( model ) != -1 ) { return; } // already selected
			
			
			if( currentlySelected.length > 0 ){
				var locked:Boolean = isSelectionLocked();
				
				if( locked && !model.isLocked ) {
					return;
				}
				
				if( !locked && model.isLocked ) {
					return;
				}
			}
			
				
			
			currentlySelected.push(model);
			var event:SelectionEvent = new SelectionEvent( SelectionEvent.ADDED_TO_SELECTION );
			event.targets.push( model );
			dispatchEvent( event );
			
		}
		
		public function isSelected( model:Object ) : Boolean
		{
			return currentlySelected.indexOf( model ) != -1;
		}

		public function setSelected( model:Object ) : void
		{
			
			clearSelection();			
			addToSelected( model );			
		}
		
		public function removeFromSelected( model:Object ) : void
		{
			var ind:int = currentlySelected.indexOf(model);
			if( ind == -1 ) { return; }
			
			currentlySelected.splice(ind,1);
			
			var event:SelectionEvent = new SelectionEvent( SelectionEvent.REMOVED_FROM_SELECTION);
			event.targets.push(model);			
			dispatchEvent( event );
			
		}

		public function clearSelection(  ) : void
		{
			var event:SelectionEvent = new SelectionEvent( SelectionEvent.SELECTION_CLEARED );
			event.targets = currentlySelected;
			currentlySelected = [];						
			dispatchEvent( event );			
		}


		public function isSelectionLocked():Boolean {
			for each(var model:Object in currentlySelected) {
				if(model.hasOwnProperty("isLocked")) {
					if(model.isLocked) {
						return true;
					}
				}
			}
			
			return false;
		}		
		
		
		public function getGeometry() : DragGeometry
		{
			var obj:Object;
			var rv:DragGeometry;
			// no selected objects
			if( currentlySelected.length == 0 ) { return null; }
			if( currentlySelected.length == 1) {
				// only one selected object
				obj = currentlySelected[0];
				rv = new DragGeometry();
				
				if( obj.hasOwnProperty("x") ) rv.x = obj["x"];
				if( obj.hasOwnProperty("y") ) rv.y = obj["y"];
				if( obj.hasOwnProperty("width") ) rv.width = obj["width"];
				if( obj.hasOwnProperty("height") ) rv.height = obj["height"];
				if( obj.hasOwnProperty("rotation") ) rv.rotation = obj["rotation"];
				if( obj.hasOwnProperty("isLocked") ) rv.isLocked = obj["isLocked"];
				
				return rv;
			} else {
				// a lot of selected objects
				return calculateMultiGeometry();

			}
			return null;
		}

		protected function calculateMultiGeometry() : DragGeometry
		{
			var rv:DragGeometry;
			var lx1: Number = Number.POSITIVE_INFINITY; // top left bounds
			var ly1: Number = Number.POSITIVE_INFINITY;
			var lx2: Number = Number.NEGATIVE_INFINITY; // bottom right bounds
			var ly2: Number = Number.NEGATIVE_INFINITY;

			var matrix:Matrix = new Matrix();
			var temp:Point = new Point();
			var temp2:Point = new Point();
			
			for each(var modelObject:Object in currentlySelected) 
			{			
				matrix.identity();
				if( modelObject.hasOwnProperty("rotation") )
				{
					matrix.rotate( toRadians(modelObject.rotation) );
				}
				matrix.translate( modelObject.x, modelObject.y );
				
				
				temp.x=0; // Check top left
				temp.y=0;
				temp = matrix.transformPoint(temp);				
			
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );

				temp.x=0; // Check bottom left
				temp.y=modelObject.height;
				temp = matrix.transformPoint(temp);				
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );

				temp.x=modelObject.width; // Check top right
				temp.y=0;
				temp = matrix.transformPoint(temp);				
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );

				temp.x=modelObject.width; // Check top right
				temp.y=modelObject.height;
				temp = matrix.transformPoint(temp);				
				lx1 = Math.min(lx1, temp.x );
				ly1 = Math.min(ly1, temp.y );
				lx2 = Math.max(lx2, temp.x );
				ly2 = Math.max(ly2, temp.y );

				
			}
			rv = new DragGeometry();
			rv.rotation = 0;
			rv.x = lx1;
			rv.y = ly1;
			rv.width = lx2 - lx1;
			rv.height = ly2 - ly1;
			rv.isLocked = isSelectionLocked();
			return rv;
		}
		
		protected static function toRadians( degrees:Number ) :Number
		{
			return degrees * Math.PI / 180;
		}		
		
		public function getGeometryForObject(a:Object) : DragGeometry
		{
			// Just return coordinates of object
			
				var obj:Object = a;
				var rv:DragGeometry = new DragGeometry();
				
				if( obj.hasOwnProperty("x") ) rv.x = obj["x"];
				if( obj.hasOwnProperty("y") ) rv.y = obj["y"];
				if( obj.hasOwnProperty("width") ) rv.width = obj["width"];
				if( obj.hasOwnProperty("height") ) rv.height = obj["height"];
				if( obj.hasOwnProperty("rotation") ) rv.rotation = obj["rotation"];
				if( obj.hasOwnProperty("isLocked") ) rv.isLocked = obj["isLocked"];
				
				return rv;
		}


	}
}