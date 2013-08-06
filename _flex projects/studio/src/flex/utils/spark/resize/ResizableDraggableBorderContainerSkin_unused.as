package flex.utils.spark.resize
{
	import mx.events.FlexEvent;
	
	import spark.skins.spark.BorderContainerSkin;
	
	public class ResizableDraggableBorderContainerSkin_unused extends BorderContainerSkin
	{
		private var resizeHandle:ResizeHandleLines;
		public var resizeManager:ResizeManager;
		public var moveManager:MoveManager;
		
		public function ResizableDraggableBorderContainerSkin_unused()
		{
			super();
			this.addEventListener(FlexEvent.CREATION_COMPLETE, created);
		}

		
		private function created(event:FlexEvent):void {
			if (hostComponent.minWidth == 0) {
				hostComponent.minWidth = minWidth;
			}
			if (hostComponent.minHeight == 0) {
				hostComponent.minHeight = minHeight;
			}
			resizeManager = new ResizeManager(hostComponent, resizeHandle);
			moveManager = new MoveManager(hostComponent, contentGroup);
		}
		//--------------------------------------------------------------------------
		//
		//  Overridden methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 *  @private 
		 */ 
		override protected function createChildren():void
		{
			super.createChildren();
			
			resizeHandle = new ResizeHandleLines();
			resizeHandle.right = 5;
			resizeHandle.bottom = 5;
			addElement(resizeHandle);
		}
		
		
		/**
		 *  @private 
		 */ 
		override protected function measure():void
		{	   
			super.measure();
			/*measuredWidth = contentGroup.measuredWidth;
			measuredHeight = contentGroup.measuredHeight;
			measuredMinWidth = contentGroup.measuredMinWidth;
			measuredMinHeight = contentGroup.measuredMinHeight;
			
			var borderWeight:Number = getStyle("borderWeight");
			
			if (hostComponent && hostComponent.borderStroke)
				borderWeight = hostComponent.borderStroke.weight;
			
			if (borderWeight > 0)
			{
				var borderSize:int = borderWeight * 2;
				measuredWidth += borderSize;
				measuredHeight += borderSize;
				measuredMinWidth += borderSize;
				measuredMinHeight += borderSize;
			}*/
		}
	}
}