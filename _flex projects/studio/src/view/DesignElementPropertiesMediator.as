package view
{
	
	import appFacade.ApplicationConstants;
	
	import events.AlignEvent;
	import events.ArrangeEvent;
	
	import flash.events.Event;
	
	import model.design.CompositionProxy;
	import model.elements.DesignElementProxy;
	import model.products.vo.RegionVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import view.components.designElement.DesignElementProperties;
	
	  
	public class DesignElementPropertiesMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'DesignElementPropertiesMediator';
		
		protected var propertiesView:DesignElementProperties;
		private var _elementuid:String;
		private var designArea:RegionVO
		
		public function DesignElementPropertiesMediator(viewComponent:Object )  
		{  
			super( NAME, viewComponent );
		}
		override public function onRegister():void  
		{  
			propertiesView = new DesignElementProperties();
			propertiesView.visible = false;
			propertiesView.addEventListener(ArrangeEvent.BRING_BACKWARD, handleBringBackward);
			propertiesView.addEventListener(ArrangeEvent.BRING_FORWARD, handleBringForward);
			propertiesView.addEventListener(ArrangeEvent.BRING_TO_TOP, handleBringToTop);
			propertiesView.addEventListener(ArrangeEvent.BRING_TO_BOTTOM, handleBringToBottom);
			propertiesView.addEventListener(DesignElementProperties.LOCK, handleLock);
			propertiesView.addEventListener(DesignElementProperties.UNLOCK, handleUnlock);
			propertiesView.addEventListener(DesignElementProperties.UNLOCK_PROPORTIONS, handleUnlockProportions);
			propertiesView.addEventListener(DesignElementProperties.LOCK_PROPORTIONS, handleLockProportions);
			propertiesView.addEventListener(DesignElementProperties.RESET_PROPORTIONS, handleResetProportions);
			propertiesView.addEventListener(AlignEvent.ALIGN_TO_BOTTOM, handleAlignToBottom);
			propertiesView.addEventListener(AlignEvent.ALIGN_TO_TOP, handleAlignToTop);
			propertiesView.addEventListener(AlignEvent.ALIGN_TO_RIGHT, handleAlignToRight);
			propertiesView.addEventListener(AlignEvent.ALIGN_TO_LEFT, handleAlignToLeft);
			propertiesView.addEventListener(AlignEvent.ALIGN_TO_CENTER_H, handleAlignToCenterH);
			propertiesView.addEventListener(AlignEvent.ALIGN_TO_CENTER_V, handleAlignToCenterV);
			propertiesView.addEventListener(DesignElementProperties.SELECT_ALL, handleSelectAll);
			propertiesView.addEventListener(DesignElementProperties.FIT_TO_AREA, handleFit);
			propertiesView.addEventListener(DesignElementProperties.FLIP_H, handleFlipH);
			propertiesView.addEventListener(DesignElementProperties.FLIP_V, handleFlipV);
			propertiesView.addEventListener(DesignElementProperties.UNDO, handleUndo);
			propertiesView.addEventListener(DesignElementProperties.REDO, handleRedo);
			propertiesView.addEventListener(DesignElementProperties.DUPLICATE, handleDuplicate);
			propertiesView.addEventListener(DesignElementProperties.CLEAR_SELECTION, handleClearSelection);
			
			viewComponent.addElement( propertiesView );
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED,
				DesignElementProxy.POSITION_CHANGE,
				DesignElementProxy.SIZE_CHANGE,
				DesignElementProxy.ROTATION_CHANGE,
				DesignElementProxy.IS_LOCKED_CHANGE,
				DesignElementProxy.MAINTAIN_PROPORTION_CHANGE,
				CompositionProxy.CURRENT_DESIGN_AREA_CHANGED
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{
			var uid:String;
			var proxy:DesignElementProxy;
			switch ( note.getName() )
			{
				case ApplicationConstants.ELEMENT_SELECTED:
					uid = note.getBody().uid;
					proxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
					updateControls(proxy);
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					updateControls(null);
					break;
				case DesignElementProxy.POSITION_CHANGE:
				case DesignElementProxy.SIZE_CHANGE:
				case DesignElementProxy.ROTATION_CHANGE:
				case DesignElementProxy.IS_LOCKED_CHANGE:
				case DesignElementProxy.MAINTAIN_PROPORTION_CHANGE:
					uid = note.getBody().uid;
					if(_elementuid==uid)
					{
						proxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
						updateControls(proxy);
					}
					break;
				case CompositionProxy.CURRENT_DESIGN_AREA_CHANGED:
					designArea = note.getBody() as RegionVO;
					proxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
					updateControls(proxy);
					break;
			}
		}
		private function updateControls(proxy:DesignElementProxy):void
		{
			if(proxy)
			{
				propertiesView.txtWidth = String(Math.round(proxy.vo.width/designArea.view.scale*100)/100 ) + '"';
				propertiesView.txtHeight =  String(Math.round(proxy.vo.height/designArea.view.scale*100)/100) + '"';
				propertiesView.txtRotation =  String(Math.round(proxy.vo.rotation*100)/100);
				propertiesView.txtX = String(Math.round((proxy.vo.x)/designArea.view.scale*100)/100) + '"';;
				propertiesView.txtY =  String(Math.round((proxy.vo.y)/designArea.view.scale*100)/100) + '"';;
				
				propertiesView.locked = proxy.vo.isLocked;
				
				propertiesView.maintainProportions = proxy.vo.maintainProportions;
				
				_elementuid = proxy.vo.uid;
				propertiesView.visible = true;
			}else
			{
				trace("PROXY NULl");
				_elementuid = "";
				propertiesView.visible = false;
			}
		}
		private function handleResetProportions(event:Event):void
		{
			sendNotification(ApplicationConstants.RESET_ELEMENT_PROPORTIONS, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleUnlockProportions(event:Event):void
		{
			sendNotification(ApplicationConstants.LOCK_ELEMENT_PROPORTIONS, {uid:_elementuid, maintainProportions:false},  UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleLockProportions(event:Event):void
		{
			sendNotification(ApplicationConstants.LOCK_ELEMENT_PROPORTIONS, {uid:_elementuid, maintainProportions:true},  UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleBringBackward(event:ArrangeEvent):void
		{
			sendNotification(ApplicationConstants.ELEMENT_BACKWARD, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleBringForward(event:ArrangeEvent):void
		{
			sendNotification(ApplicationConstants.ELEMENT_FORWARD, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleBringToTop(event:ArrangeEvent):void
		{
			sendNotification(ApplicationConstants.ELEMENT_TO_TOP, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleBringToBottom(event:ArrangeEvent):void
		{
			sendNotification(ApplicationConstants.ELEMENT_TO_BOTTOM, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleLock(event:Event):void
		{
			sendNotification(ApplicationConstants.LOCK_ELEMENT, {uid:_elementuid, isLocked:true}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleUnlock(event:Event):void
		{
			sendNotification(ApplicationConstants.LOCK_ELEMENT, {uid:_elementuid, isLocked:false}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleAlignToBottom(event:AlignEvent):void
		{
			sendNotification(ApplicationConstants.ALIGN_TO_BOTTOM, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleAlignToTop(event:AlignEvent):void
		{
			sendNotification(ApplicationConstants.ALIGN_TO_TOP, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleAlignToRight(event:AlignEvent):void
		{
			sendNotification(ApplicationConstants.ALIGN_TO_RIGHT, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleAlignToLeft(event:AlignEvent):void
		{
			sendNotification(ApplicationConstants.ALIGN_TO_LEFT, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleAlignToCenterH(event:AlignEvent):void
		{
			sendNotification(ApplicationConstants.ALIGN_TO_CENTER_H, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleAlignToCenterV(event:AlignEvent):void
		{
			sendNotification(ApplicationConstants.ALIGN_TO_CENTER_V, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		
		private function handleSelectAll(event:Event):void
		{
			sendNotification(ApplicationConstants.SELECT_ALL,null, NAME);
		}
		private function handleFit(event:Event):void
		{
			sendNotification(ApplicationConstants.MAXIMIZE_ELEMENT, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleFlipH(event:Event):void
		{
			sendNotification(ApplicationConstants.FLIP_H_ELEMENT, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleFlipV(event:Event):void
		{
			sendNotification(ApplicationConstants.FLIP_V_ELEMENT, {uid:_elementuid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleUndo(event:Event):void
		{
			sendNotification(ApplicationConstants.UNDO,null, NAME);
		}
		private function handleRedo(event:Event):void
		{
			sendNotification(ApplicationConstants.REDO,null, NAME);
		}
		private function handleDuplicate(event:Event):void
		{
			sendNotification(ApplicationConstants.DUPLICATE_ELEMENT,null, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleClearSelection(event:Event):void
		{
			sendNotification(ApplicationConstants.CLEAR_SELECTION,null, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND);
		}
		
	 }  
}