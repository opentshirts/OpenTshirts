package com.roguedevelopment.objecthandles
{
	import com.roguedevelopment.objecthandles.constraints.MaintainProportionConstraint;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import mx.core.IFactory;
	
	import utils.MathUtils;
	
	public class ObjectHandlesModified extends ObjectHandles
	{
		public function ObjectHandlesModified(container:Sprite, selectionManager:ObjectHandlesSelectionManager=null, handleFactory:IFactory=null, childManager:IChildManager=null)
		{
			super(container, selectionManager, handleFactory, childManager);
		}
		
		//author: Ruy Díaz Jara diazruy@gmail.com
		override protected function applyRotate( event:MouseEvent, proposed:DragGeometry ) : void {
			super.applyRotate( event, proposed );
			// If Shift key is being held, rotatate in 15 degree increments
			if( event.shiftKey ) {
				var totalRotation:Number = originalGeometry.rotation + proposed.rotation;
				proposed.rotation = MathUtils.roundToMultiple( totalRotation, 15 ) - originalGeometry.rotation; 
			}
		}
		
		//for single object constraint		
		//author: Jose Andriani joseandriani@gmail.com
		override protected function applySingleObjectConstraints(modelObject:Object, originalGeometry:DragGeometry, translation:DragGeometry, currentDragRole:uint):void
		{
			super.applySingleObjectConstraints(modelObject, originalGeometry, translation, currentDragRole);
			
			if( modelObject.maintainProportions )
			{
				var constraint:IConstraint = new MaintainProportionConstraint();
				constraint.applyConstraint( originalGeometry, translation, currentDragRole );
			} 
		}
			
	}
}