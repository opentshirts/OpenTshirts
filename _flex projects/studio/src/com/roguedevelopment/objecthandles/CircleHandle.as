package com.roguedevelopment.objecthandles
{
	import com.roguedevelopment.objecthandles.SpriteHandle;

	/**
	 * A simple circle based handle instead of the square one.  This is more of an example
	 * on how to do alterntative handles.
	 **/
	public class CircleHandle extends SpriteHandle
	{
		public function CircleHandle()
		{
			super();
		}
	
		override public function redraw():void
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
				graphics.beginFill(0x51ffee,1);
			}
			
			graphics.drawCircle(0,0,6);
			graphics.endFill();
		}
		
	}
}