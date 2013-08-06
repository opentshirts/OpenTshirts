package view
{
	
	import events.FilterEvent;
	
	import model.design.DesignColorListProxy;
	import model.elements.DesignElementProxy;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;
	
	import view.components.designElement.FiltersProperties;
	
	  
	public class FilterPropertiesMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'FilterPropertiesMediator';
		
		protected var propertiesView:FiltersProperties;
		private var _filters:ArrayCollection;
		
		public function FilterPropertiesMediator(viewComponent:Object )  
		{  
			super( NAME, viewComponent );
		}
		override public function onRegister():void  
		{  
			propertiesView = new FiltersProperties();
			propertiesView.visible = false;
			propertiesView.addEventListener(FilterEvent.VISIBILITY_CHANGE, handleVisibilityChange);
			propertiesView.addEventListener(FilterEvent.OUTLINE_THICKNESS_CHANGE, handleOutlineThicknessChange);
			propertiesView.addEventListener(FilterEvent.OUTLINE_THICKNESS_CHANGING, handleOutlineThicknessChanging);
			propertiesView.addEventListener(FilterEvent.OUTLINE_COLOR_CHANGE, handleOutlineColorChange);
			propertiesView.addEventListener(FilterEvent.SHADOW_ANGLE_CHANGE, handleShadowAngleChange);
			propertiesView.addEventListener(FilterEvent.SHADOW_ANGLE_CHANGING, handleShadowAngleChanging);
			propertiesView.addEventListener(FilterEvent.SHADOW_DISTANCE_CHANGE, handleShadowDistanceChange);
			propertiesView.addEventListener(FilterEvent.SHADOW_DISTANCE_CHANGING, handleShadowDistanceChanging);
			propertiesView.addEventListener(FilterEvent.SHADOW_THICKNESS_CHANGE, handleShadowThicknessChange);
			propertiesView.addEventListener(FilterEvent.SHADOW_THICKNESS_CHANGING, handleShadowThicknessChanging);
			propertiesView.addEventListener(FilterEvent.SHADOW_COLOR_CHANGE, handleShadowColorChange);
			viewComponent.addElement( propertiesView );
			
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				ApplicationConstants.ELEMENT_SELECTED,
				ApplicationConstants.SELECTION_CLEARED,
				ApplicationConstants.MULTIPLE_ELEMENT_SELECTED,
				DesignColorListProxy.DESIGN_COLORS_CHANGE
				/*,
				FilterProxy.VISIBLE_CHANGE,
				OutlineProxy.OUTLINE_THICKNESS_CHANGE,
				OutlineProxy.OUTLINE_COLOR_CHANGE,
				ShadowProxy.SHADOW_COLOR_CHANGE,
				ShadowProxy.SHADOW_THICKNESS_CHANGE,
				ShadowProxy.SHADOW_ANGLE_CHANGE,
				ShadowProxy.SHADOW_DISTANCE_CHANGE*/
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{
			switch ( note.getName() )
			{
				case ApplicationConstants.ELEMENT_SELECTED:
					var uid:String = note.getBody().uid;
					var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
					updateControls(proxy);
					break;
				case ApplicationConstants.SELECTION_CLEARED:
				case ApplicationConstants.MULTIPLE_ELEMENT_SELECTED:
					updateControls(null);
					break;
				case DesignColorListProxy.DESIGN_COLORS_CHANGE:
					propertiesView.colors = DesignColorListMediator.colors;
					break;
				///bindable properties
				/*case FilterProxy.VISIBLE_CHANGE:
				case OutlineProxy.OUTLINE_THICKNESS_CHANGE:
				case OutlineProxy.OUTLINE_COLOR_CHANGE:
				case ShadowProxy.SHADOW_COLOR_CHANGE:
				case ShadowProxy.SHADOW_THICKNESS_CHANGE:
				case ShadowProxy.SHADOW_ANGLE_CHANGE:
				case ShadowProxy.SHADOW_DISTANCE_CHANGE:
					if(_filters)
					{
						for each(var filter:Object in _filters)
						{
							if(filter.uid==note.getBody().filteruid)
							{
								filter.color = note.getBody().color;
								
								break;
							}
						}
					}
					break;*/
			}
		}
		private function updateControls(proxy:DesignElementProxy):void
		{
			if(proxy)
			{
				propertiesView.filterArray = proxy.vo.filters;
				propertiesView.visible = (proxy.vo.filters.length>0);
			}else
			{
				_filters = null;
				propertiesView.visible = false;
			}
		}
		private function handleOutlineColorChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.OUTLINE_COLOR_CHANGE, {color:event.data.color, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleVisibilityChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.FILTER_VISIBILITY_CHANGE, {visible:event.data.visible, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleOutlineThicknessChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.OUTLINE_THICKNESS_CHANGE, {thickness:event.data.thickness, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleOutlineThicknessChanging(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.OUTLINE_THICKNESS_CHANGING, {thickness:event.data.thickness, filteruid:event.data.uid}, NAME);
		}
		private function handleShadowThicknessChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_THICKNESS_CHANGE, {thickness:event.data.thickness, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleShadowThicknessChanging(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_THICKNESS_CHANGING, {thickness:event.data.thickness, filteruid:event.data.uid}, NAME);
		}
		private function handleShadowDistanceChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_DISTANCE_CHANGE, {distance:event.data.distance, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleShadowDistanceChanging(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_DISTANCE_CHANGING, {distance:event.data.distance, filteruid:event.data.uid}, NAME);
		}
		private function handleShadowAngleChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_ANGLE_CHANGE, {angle:event.data.angle, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
		private function handleShadowAngleChanging(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_ANGLE_CHANGING, {angle:event.data.angle, filteruid:event.data.uid}, NAME);
		}
		private function handleShadowColorChange(event:FilterEvent):void
		{
			sendNotification(ApplicationConstants.SHADOW_COLOR_CHANGE, {color:event.data.color, filteruid:event.data.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
		}
	 }  
}