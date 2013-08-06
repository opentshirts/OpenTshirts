package com.roguedevelopment.objecthandles.decorators
{
	
	
	import com.roguedevelopment.objecthandles.ObjectChangedEvent;
	import com.roguedevelopment.objecthandles.ObjectHandles;
	import com.roguedevelopment.objecthandles.SelectionEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class DecoratorManager
	{
		protected var drawLayer:Sprite;
		protected var decorators:Array = [];
		protected var subDrawLayers:Object = {};
		protected var objectHandles:ObjectHandles;
		
		public function DecoratorManager(objectHandles:ObjectHandles, drawLayer:Sprite)
		{
			this.drawLayer = drawLayer;
			this.objectHandles = objectHandles;
			
			objectHandles.selectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, onSelectionChanged );
			objectHandles.selectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, onSelectionChanged );
			objectHandles.selectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, onSelectionChanged );
			objectHandles.selectionManager.addEventListener(SelectionEvent.SELECTED, onSelectionChanged );
			
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVING, onPositionChanged );
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZING, onPositionChanged );
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATING, onPositionChanged );
			
		}
		
		public function updateNow() : void
		{
			for each(var decorator:IDecorator in decorators )
			{				
				decorator.updateSelected( objectHandles.modelList, objectHandles.selectionManager.currentlySelected, subDrawLayers[decorator] );
				decorator.updatePosition( objectHandles.modelList, objectHandles.selectionManager.currentlySelected,objectHandles.modelList ,subDrawLayers[decorator] );
			}			
		}
		
		protected function onSelectionChanged(event:Event):void
		{
			for each(var decorator:IDecorator in decorators )
			{				
				decorator.updateSelected( objectHandles.modelList, objectHandles.selectionManager.currentlySelected, subDrawLayers[decorator] );
			}
			
		}
		
		protected function onPositionChanged(event:ObjectChangedEvent):void
		{
			for each(var decorator:IDecorator in decorators )
			{				
				decorator.updatePosition( objectHandles.modelList, objectHandles.selectionManager.currentlySelected, event.relatedObjects ,subDrawLayers[decorator] );
			}
			
		}		
		public function addDecorator( decorator:IDecorator ) : void
		{
			var subDrawLayer:Sprite = new Sprite();
			drawLayer.addChild(subDrawLayer);
			
			decorators.push(decorator);
			subDrawLayers[decorator] = subDrawLayer;			
		}


		
	}
}