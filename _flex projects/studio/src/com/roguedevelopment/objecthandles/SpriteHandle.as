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
 

/**
 * A handle implementation based on Sprite, primarily for use in Flex 3.
 **/
package com.roguedevelopment.objecthandles
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class SpriteHandle extends Sprite implements IHandle
	{
		private var _descriptor:HandleDescription;		
		private var _targetModel:Object;
		protected var isOver:Boolean = false;
		
		public function get handleDescriptor():HandleDescription
		{
			return _descriptor;
		}
		public function set handleDescriptor(value:HandleDescription):void
		{
			_descriptor = value;
		}
		public function get targetModel():Object
		{
			return _targetModel;
		}
		public function set targetModel(value:Object):void
		{
			_targetModel = value;
		}
		
		public function SpriteHandle()
		{
			super();
			addEventListener( MouseEvent.ROLL_OUT, onRollOut );
			addEventListener( MouseEvent.ROLL_OVER, onRollOver );
			//redraw();
		}
		
		protected function onRollOut( event : MouseEvent ) : void
		{
			isOver = false;
			redraw();
		}
		protected function onRollOver( event:MouseEvent):void
		{
			isOver = true;
			redraw();
		}
		
		public function redraw() : void
		{
			graphics.clear();
			if( isOver )
			{
				graphics.lineStyle(1,0x3dff40);
				graphics.beginFill(0xc5ffc0	,1);				
			}
			else
			{
				graphics.lineStyle(1,0);
				graphics.beginFill(0xaaaaaa,1);
			}
			
			graphics.drawRect(-5,-5,10,10);
			graphics.endFill();
			
		}
		
	}
}