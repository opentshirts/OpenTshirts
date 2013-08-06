package view
{
	
	//import com.roguedevelopment.objecthandles.DragGeometry;
	import appFacade.ApplicationConstants;
	
	import com.roguedevelopment.objecthandles.Flex4HandleFactory;
	import com.roguedevelopment.objecthandles.Flex4ZoomableChildManager;
	import com.roguedevelopment.objecthandles.OHObjectModel;
	import com.roguedevelopment.objecthandles.ObjectChangedEvent;
	import com.roguedevelopment.objecthandles.ObjectHandlesModified;
	import com.roguedevelopment.objecthandles.SelectionEvent;
	import com.roguedevelopment.objecthandles.constraints.SizeConstraint;
	
	import flash.events.IEventDispatcher;
	
	import model.elements.DesignElementProxy;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import spark.components.Group;

	  
	public class ObjectHandlesMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ObjectHandlesMediator';

		protected var objectHandles:ObjectHandlesModified;
		private var _uid:String;
		private var _active:Boolean = true;
		
		public function ObjectHandlesMediator(viewComponent:Object, uid:String)  
		{  
			super( NAME, viewComponent );
			_uid = uid;
			
			objectHandles = new ObjectHandlesModified( objectHandlesContainer , null, new Flex4HandleFactory() , new Flex4ZoomableChildManager() );
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVED, onObjectMoved);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZED, onObjectResized);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATED, onObjectRotated);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_MOVING, onObjectMoving);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_RESIZING, onObjectResizing);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_ROTATING, onObjectRotating);
			objectHandles.addEventListener(ObjectChangedEvent.OBJECT_REMOVED, onObjectRemoved);
			objectHandles.selectionManager.addEventListener(SelectionEvent.REMOVED_FROM_SELECTION, onSelectionChange)
			objectHandles.selectionManager.addEventListener(SelectionEvent.ADDED_TO_SELECTION, onSelectionChange)
			objectHandles.selectionManager.addEventListener(SelectionEvent.SELECTION_CLEARED, onSelectionChange)
				
			
			var constraint:SizeConstraint = new SizeConstraint();
			constraint.minWidth = 5;
			constraint.minHeight = 5;
			objectHandles.addDefaultConstraint( constraint );	
			

		}
		override public function getMediatorName():String
		{
			return NAME+_uid;
		}

		public function get objectHandlesContainer():Group
		{
			return viewComponent as Group;
		}
		
		override public function listNotificationInterests():Array  
		{
			return [ 
				ApplicationConstants.ZOOM_CHANGED,
				ApplicationConstants.OH_REGISTER_ELEMENT,
				ApplicationConstants.OH_UNREGISTER_ELEMENT,
				ApplicationConstants.SHORTCUT_DELETE_KEY_PRESSED,
				ApplicationConstants.SHORTCUT_ALIGN_TO_CENTER_H,
				ApplicationConstants.SHORTCUT_ALIGN_TO_CENTER_V,
				ApplicationConstants.SHORTCUT_MAXIMIZE_ELEMENT,
				ApplicationConstants.SHORTCUT_FLIP_H_ELEMENT,
				ApplicationConstants.SHORTCUT_FLIP_V_ELEMENT,
				ApplicationConstants.SHORTCUT_ALIGN_TO_TOP,
				ApplicationConstants.SHORTCUT_ALIGN_TO_BOTTOM,
				ApplicationConstants.SHORTCUT_ALIGN_TO_LEFT,
				ApplicationConstants.SHORTCUT_ALIGN_TO_RIGHT,
				ApplicationConstants.SHORCUT_COPY,
				ApplicationConstants.SHORCUT_CUT,
				ApplicationConstants.SHORCUT_PASTE,
				ApplicationConstants.CLEAR_SELECTION,
				ApplicationConstants.SELECT_ALL,
				ApplicationConstants.SELECT_ELEMENT,
				DesignElementProxy.POSITION_CHANGE,
				DesignElementProxy.SIZE_CHANGE,
				DesignElementProxy.ROTATION_CHANGE,
				DesignElementProxy.IS_LOCKED_CHANGE,
				DesignElementProxy.MAINTAIN_PROPORTION_CHANGE
			];  
		}
		public function set active(value:Boolean):void
		{
			_active = value;  
		}
		override public function handleNotification(note:INotification):void
		{
			//OH_REGISTER_ELEMENT and OH_UNREGISTER_ELEMENT should not skip
			if(note.getName() != ApplicationConstants.OH_REGISTER_ELEMENT && note.getName()!=ApplicationConstants.OH_UNREGISTER_ELEMENT) {
				if(!_active) {//if not active just exit
					return;
				}
			}
			
			
			
			var objectModel:OHObjectModel;
			switch ( note.getName() )
			{
				case ApplicationConstants.ZOOM_CHANGED:
					//keep handles sizes
					Flex4ZoomableChildManager.parentScale = note.getBody() as Number;
					break;
				case ApplicationConstants.OH_REGISTER_ELEMENT:
					if(note.getBody().ohUID == _uid)
					{
						registerElement(note.getBody().model, IEventDispatcher(note.getBody().viewComponent));
					}
					break;
				case ApplicationConstants.OH_UNREGISTER_ELEMENT:
					unregisterElement(String(note.getBody().uid));
					break;
				case ApplicationConstants.SHORTCUT_DELETE_KEY_PRESSED:
					for each(var obj:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.REMOVE_SELECTED_ELEMENT, obj.uid, NAME);
					}
					objectHandles.selectionManager.clearSelection();
					break;
				case ApplicationConstants.SHORTCUT_ALIGN_TO_CENTER_H:
					for each(var obj2:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.ALIGN_TO_CENTER_H, {uid:obj2.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_ALIGN_TO_CENTER_V:
					for each(var obj3:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.ALIGN_TO_CENTER_V, {uid:obj3.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_MAXIMIZE_ELEMENT:
					for each(var obj4:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.MAXIMIZE_ELEMENT, {uid:obj4.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_FLIP_H_ELEMENT:
					for each(var obj5:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.FLIP_H_ELEMENT, {uid:obj5.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_FLIP_V_ELEMENT:
					for each(var obj6:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.FLIP_V_ELEMENT, {uid:obj6.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_ALIGN_TO_TOP:
					for each(var obj7:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.ALIGN_TO_TOP, {uid:obj7.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_ALIGN_TO_BOTTOM:
					for each(var obj8:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.ALIGN_TO_BOTTOM, {uid:obj8.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_ALIGN_TO_LEFT:
					for each(var obj9:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.ALIGN_TO_LEFT, {uid:obj9.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORTCUT_ALIGN_TO_RIGHT:
					for each(var obj10:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						sendNotification(ApplicationConstants.ALIGN_TO_RIGHT, {uid:obj10.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORCUT_COPY:
					var objs:Array = new Array();
					for each(var obj11:OHObjectModel in objectHandles.selectionManager.currentlySelected)
					{
						objs.push(obj11.uid);
					}
					if(objs.length>0) {
						sendNotification(ApplicationConstants.COPY, {objs:objs}, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
					}
					break;
				case ApplicationConstants.SHORCUT_PASTE:
					sendNotification(ApplicationConstants.PASTE, null, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
					break;
				case ApplicationConstants.CLEAR_SELECTION:
					clearSelection();
					break;
				case ApplicationConstants.SELECT_ALL:
					selectAll();
					break;
				case ApplicationConstants.SELECT_ELEMENT:
					selectElement(note.getBody().uid as String);
					break;
				case DesignElementProxy.POSITION_CHANGE:
					objectModel = getModelFromUID(note.getBody().uid);
					if (objectModel)
					{
						objectModel.x = note.getBody().x;
						objectModel.y = note.getBody().y;
					}
					break;
				case DesignElementProxy.SIZE_CHANGE:
					objectModel = getModelFromUID(note.getBody().uid);
					if (objectModel)
					{
						objectModel.width = note.getBody().width;
						objectModel.height = note.getBody().height;
					}
					break;
				case DesignElementProxy.ROTATION_CHANGE:
					objectModel = getModelFromUID(note.getBody().uid);
					if (objectModel)
					{
						objectModel.rotation = note.getBody().rotation;
					}
					break;
				case DesignElementProxy.IS_LOCKED_CHANGE:
					objectModel = getModelFromUID(note.getBody().uid);
					if (objectModel)
					{
						objectModel.isLocked = note.getBody().isLocked;
					}
					break;
				case DesignElementProxy.MAINTAIN_PROPORTION_CHANGE:
					objectModel = getModelFromUID(note.getBody().uid);
					if (objectModel)
					{
						objectModel.maintainProportions = note.getBody().maintainProportions;
					}
					break;
			}
		}
		
		private function registerElement(dataModel:Object, visualDisplay:IEventDispatcher):void
		{
			var objectModel:OHObjectModel = new OHObjectModel();
			objectModel.copyFromObject(dataModel);
			objectHandles.registerComponent(objectModel, visualDisplay );
		}
		
		private function unregisterElement(uid:String):void
		{
			var objectModel:OHObjectModel = getModelFromUID(uid);
			if (objectModel)
			{
				objectHandles.unregisterModel(objectModel);
			}
		}
		public function clearSelection():void
		{
			objectHandles.selectionManager.clearSelection();
		}
		private function selectAll():void
		{
			objectHandles.selectionManager.clearSelection();
			
			for each(var obj:Object in objectHandles.modelList)
			{
				if(obj is OHObjectModel) //because first registered model is multiselectobject model
					objectHandles.selectionManager.addToSelected(obj);
			}
		}
		private function selectElement(uid:String):void
		{
			objectHandles.selectionManager.clearSelection();
			
			for each(var obj:Object in objectHandles.modelList)
			{
				if(obj is OHObjectModel && obj.uid==uid)
					objectHandles.selectionManager.addToSelected(obj);
			}
		}
		private function getModelFromUID(uid:String):OHObjectModel
		{
			for each(var obj:Object in objectHandles.modelList)
			{
				if(obj is OHObjectModel && obj.uid==uid)
				{
					return OHObjectModel(obj);
				}
			}
			return null;
		}
		private function onSelectionChange(event:SelectionEvent):void
		{
			if(objectHandles.selectionManager.currentlySelected.length==1) //single selection
			{
				sendNotification(ApplicationConstants.ELEMENT_SELECTED, {uid: objectHandles.selectionManager.currentlySelected[0].uid}, NAME);
			}else if(objectHandles.selectionManager.currentlySelected.length==0) //no selection
			{
				sendNotification(ApplicationConstants.SELECTION_CLEARED, null, NAME);
			}else//multiple selection
			{
				sendNotification(ApplicationConstants.MULTIPLE_ELEMENT_SELECTED, objectHandles.selectionManager.currentlySelected, NAME);
			}
			
		}
		/**
		 * dispatched by objectHandles every time an object is moved
		 * */
		private function onObjectMoved(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_MOVED, {uid:objectModel.uid, x:objectModel.x, y:objectModel.y},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			}
		}
		/**
		 * dispatched by objectHandles every time an object is resized
		 * */
		private function onObjectResized(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				//position also change when resized
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_MOVED_ROTATED_RESIZED, {uid:objectModel.uid, width:objectModel.width, height:objectModel.height, x:objectModel.x, y:objectModel.y, rotation:objectModel.rotation},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			}
		}
		/**
		 * dispatched by objectHandles every time an object is rotated
		 * */
		private function onObjectRotated(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				//position also change when rotated
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_MOVED_ROTATED_RESIZED, {uid:objectModel.uid, width:objectModel.width, height:objectModel.height, x:objectModel.x, y:objectModel.y, rotation:objectModel.rotation},UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			}
		}
		
		private function onObjectRemoved(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				sendNotification(ApplicationConstants.REMOVE_SELECTED_ELEMENT, objectModel.uid, NAME);
			}
			objectHandles.selectionManager.clearSelection();

		}
		
		
		
		
		private function onObjectMoving(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_MOVING, objectModel ,NAME);
			}
		}
		private function onObjectResizing(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_RESIZING, objectModel,NAME);
			}
		}
		private function onObjectRotating(event:ObjectChangedEvent):void
		{
			for each(var objectModel:OHObjectModel in event.relatedObjects)
			{
				sendNotification(ApplicationConstants.DESIGN_ELEMENT_ROTATING, objectModel,NAME);
			}
		}

	 }  
}