package appFacade
{
	public class ApplicationConstants
	{
		public static const NAME:String    = 'ApplicationConstants';  
		//application
		public static const STARTUP:String = NAME + 'StartUp';  
		public static const READY:String = NAME + 'READY';   
		//THIS NOTIFICATION IS TRIGGERED FROM PROXYS - MAYBE SHOULD BE DEFINED IN A BETTER PLACE
		public static const REGISTER_MEDIATOR:String = NAME + 'REGISTER_MEDIATOR';   
		public static const SHOW_MSG:String = NAME + 'SHOW_MSG'; 
		public static const EXPORT_IMAGE:String = NAME + 'EXPORT_IMAGE';
		public static const EXPORT_IMAGE_CLICK:String = NAME + 'EXPORT_IMAGE_CLICK';
		public static const ALERT_ERROR:String = NAME + 'ALERT_ERROR';   
		public static const PRICE_PARAMETERS_CHANGE:String = NAME + 'PRICE_PARAMETERS_CHANGE';
		public static const STUDIO_ID_CHANGE:String = NAME + 'STUDIO_ID_CHANGE';
		public static const HIDE_COLORS_USED_PANEL:String	= NAME + 'HIDE_COLORS_USED_PANEL';
		public static const FILTER_COLORS:String	= NAME + 'FILTER_COLORS';
		
		
		
		///loading
		public static const LOAD_OBJECT_START:String = NAME + 'LoadObjectStart';  
		public static const LOAD_OBJECT_COMPLETE:String = NAME + 'LoadObjectComplete';  
		public static const LOAD_OBJECT_PROGRESS:String = NAME + 'LoadObjectProgress'; 
		public static const LOAD_OBJECT_ERROR:String = NAME + 'LoadObjectError'; 
		
		///product
		public static const SHOW_EXPORT_IMAGE:String = NAME + "SHOW_EXPORT_IMAGE";
		public static const CURRENT_DESIGN_AREA_CHANGED:String	= NAME + 'CURRENT_DESIGN_AREA_CHANGED';
		public static const CURRENT_PRODUCT_CHANGE:String	= NAME + 'CURRENT_PRODUCT_CHANGE';
		public static const CREATE_PRODUCT:String	= NAME + 'CREATE_PRODUCT';
		public static const CHANGE_PRODUCT:String	= NAME + 'CHANGE_PRODUCT';
		public static const CHANGE_PRODUCT_COLOR:String	= NAME + 'CHANGE_PRODUCT_COLOR';
		public static const CHANGE_COMPOSITION_DATA:String	= NAME + 'CHANGE_COMPOSITION_DATA';
		
		//design
		public static const SAVE_COMPOSITION:String	= NAME + 'SAVE_COMPOSITION';
		public static const LOAD_COMPOSITION:String	= NAME + 'LOAD_COMPOSITION';
		public static const IMPORT_COMPOSITION:String	= NAME + 'IMPORT_COMPOSITION';
		public static const ADD_TEMPLATE:String	= NAME + 'ADD_TEMPLATE';
		public static const CHANGE_DESIGN_AREA:String	= NAME + 'CHANGE_DESIGN_AREA';
		public static const ADD_ELEMENT_TO_DESIGN:String	= NAME + 'ADD_ELEMENT_TO_DESIGN';
		public static const ADD_ELEMENT_AT_INDEX_TO_DESIGN:String	= NAME + 'ADD_ELEMENT_AT_INDEX_TO_DESIGN';
		public static const REMOVE_ELEMENT_FROM_DESIGN:String	= NAME + 'REMOVE_ELEMENT_FROM_DESIGN';
		public static const REMOVE_SELECTED_ELEMENT:String	= NAME + 'REMOVE_SELECTED_ELEMENT';
		public static const ELEMENT_CREATED:String	= NAME + 'ELEMENT_CREATED';
		
		
		//design elements
		//public static const REMOVE_ELEMENT:String	= NAME + 'REMOVE_ELEMENT';
		public static const DESIGN_COLOR_SELECTED:String = NAME+'DESIGN_COLOR_SELECTED';
		public static const DESIGN_ELEMENT_UPDATED:String = NAME + 'DESIGN_ELEMENT_UPDATED';
		public static const MAXIMIZE_ELEMENT:String = NAME + 'MAXIMIZE_ELEMENT';
		public static const UPDATE_UNSCALED_SIZE:String = NAME + 'UPDATE_UNSCALED_SIZE';
		public static const DESIGN_ELEMENT_MOVING:String = NAME + 'DESIGN_ELEMENT_MOVING'; 
		public static const DESIGN_ELEMENT_MOVED:String = NAME + 'DESIGN_ELEMENT_MOVED'; 
		public static const DESIGN_ELEMENT_ROTATING:String = NAME + 'DESIGN_ELEMENT_ROTATING'; 
		public static const DESIGN_ELEMENT_ROTATED:String = NAME + 'DESIGN_ELEMENT_ROTATED'; 
		public static const DESIGN_ELEMENT_RESIZING:String = NAME + 'DESIGN_ELEMENT_RESIZING';
		public static const DESIGN_ELEMENT_RESIZED:String = NAME + 'DESIGN_ELEMENT_RESIZED'; 
		public static const DESIGN_ELEMENT_MOVED_ROTATED_RESIZED:String = NAME + 'DESIGN_ELEMENT_MOVED_ROTATED_RESIZED'; 
		public static const SET_DESIGN_ELEMENT_INDEX:String = NAME + 'SET_DESIGN_ELEMENT_INDEX';
		public static const FLIP_H_ELEMENT:String = NAME + 'FLIP_H_ELEMENT';
		public static const FLIP_V_ELEMENT:String = NAME + 'FLIP_V_ELEMENT';
		
		
		//arrange
		public static const ELEMENT_TO_TOP:String = NAME + 'ELEMENT_TO_TOP'; 
		public static const ELEMENT_TO_BOTTOM:String = NAME + 'ELEMENT_TO_BOTTOM'; 
		public static const ELEMENT_FORWARD:String = NAME + 'ELEMENT_FORWARD'; 
		public static const ELEMENT_BACKWARD:String = NAME + 'ELEMENT_BACKWARD'; 
		//align
		public static const ALIGN_TO_TOP:String = NAME + "ALIGN_TO_TOP";
		public static const ALIGN_TO_BOTTOM:String = NAME + "ALIGN_TO_BOTTOM";
		public static const ALIGN_TO_LEFT:String = NAME + "ALIGN_TO_LEFT";
		public static const ALIGN_TO_RIGHT:String = NAME + "ALIGN_TO_RIGHT";
		public static const ALIGN_TO_CENTER_H:String = NAME + "ALIGN_TO_CENTER_H";
		public static const ALIGN_TO_CENTER_V:String = NAME + "ALIGN_TO_CENTER_V"; 
		
		public static const LOCK_ELEMENT:String = NAME + 'LOCK_ELEMENT'; 
		public static const LOCK_ELEMENT_PROPORTIONS:String = NAME + 'LOCK_ELEMENT_PROPORTIONS';  
		public static const RESET_ELEMENT_PROPORTIONS:String = NAME + 'RESET_ELEMENT_PROPORTIONS'; 
		
		public static const FILTER_VISIBILITY_CHANGE:String = NAME + 'FILTER_VISIBILITY_CHANGE';
		
		public static const OUTLINE_COLOR_CHANGE:String = NAME + 'OUTLINE_COLOR_CHANGE';
		public static const OUTLINE_THICKNESS_CHANGE:String = NAME + 'OUTLINE_THICKNESS_CHANGE';
		public static const OUTLINE_THICKNESS_CHANGING:String = NAME + 'OUTLINE_THICKNESS_CHANGING';
		
		public static const SHADOW_COLOR_CHANGE:String = NAME + 'SHADOW_COLOR_CHANGE';
		public static const SHADOW_THICKNESS_CHANGE:String = NAME + 'SHADOW_THICKNESS_CHANGE';
		public static const SHADOW_THICKNESS_CHANGING:String = NAME + 'SHADOW_THICKNESS_CHANGING';
		public static const SHADOW_DISTANCE_CHANGE:String = NAME + 'SHADOW_DISTANCE_CHANGE';
		public static const SHADOW_DISTANCE_CHANGING:String = NAME + 'SHADOW_DISTANCE_CHANGING';
		public static const SHADOW_ANGLE_CHANGE:String = NAME + 'SHADOW_ANGLE_CHANGE';
		public static const SHADOW_ANGLE_CHANGING:String = NAME + 'SHADOW_ANGLE_CHANGING';
		
		
		public static const SHOW_CLIPART_LIST:String	= NAME + 'SHOW_CLIPART_LIST';
		public static const SHOW_PRODUCT_LIST:String	= NAME + 'SHOW_PRODUCT_LIST';
		
		//OH
		public static const OH_REGISTER_ELEMENT:String	= NAME + 'OH_REGISTER_ELEMENT';
		public static const OH_UNREGISTER_ELEMENT:String	= NAME + 'OH_UNREGISTER_ELEMENT';
		
		//CLIPART
		public static const CREATE_CLIPART:String	= NAME + 'CREATE_CLIPART';
		public static const CHANGE_COLOR_CLIPART_LAYER:String	= NAME + 'CHANGE_COLOR_CLIPART_LAYER';
		public static const CHANGE_CLIPART_COLOR_STATE:String	= NAME + 'CHANGE_CLIPART_COLOR_STATE';
		public static const CLIPART_INVERT_COLOR:String	= NAME + 'CLIPART_INVERT_COLOR';
		
		//BITMAP
		public static const CREATE_BITMAP:String	= NAME + 'CREATE_BITMAP';
		
		//TEXT
		public static const CREATE_TEXT:String	= NAME + 'CREATE_TEXT';
		public static const CHANGE_TEXT_LAYOUT:String	= NAME + 'CHANGE_TEXT_LAYOUT';
		public static const CHANGE_ARC_TEXT_LAYOUT_RADIO:String	= NAME + 'CHANGE_ARC_TEXT_LAYOUT_RADIO';
		public static const CHANGING_ARC_TEXT_LAYOUT_RADIO:String	= NAME + 'CHANGING_ARC_TEXT_LAYOUT_RADIO';
		public static const CHANGE_SIMPLE_ENVELOPE_AMOUNT:String	= NAME + 'CHANG_SIMPLE_ENVELOPE_AMOUNT';
		public static const CHANGING_SIMPLE_ENVELOPE_AMOUNT:String	= NAME + 'CHANGING_SIMPLE_ENVELOPE_AMOUNT';
		public static const CHANGE_ENVELOPE:String	= NAME + 'CHANGE_ENVELOPE';
		public static const CHANGE_TEXT:String	= NAME + 'CHANGE_TEXT';
		public static const CHANGE_TEXT_SPACING:String	= NAME + 'CHANGE_TEXT_SPACING';
		//public static const CHANGE_TEXT_SHAPE:String	= NAME + 'CHANGE_TEXT_SHAPE';
		//public static const CHANGING_TEXT_SHAPE:String	= NAME + 'CHANGING_TEXT_SHAPE';
		public static const CHANGING_TEXT_SPACING:String	= NAME + 'CHANGING_TEXT_SPACING';
		public static const CHANGE_TEXT_COLOR:String	= NAME + 'CHANGE_TEXT_COLOR';
		public static const CHANGE_FONT:String	= NAME + 'CHANGE_FONT';
		public static const LOAD_FONT:String	= NAME + 'LOAD_FONT';
		public static const FONT_LOADED:String	= NAME + 'FONT_LOADED';
		
		//SELECTION
		public static const ELEMENT_SELECTED:String	= NAME + 'ELEMENT_SELECTED';
		public static const MULTIPLE_ELEMENT_SELECTED:String	= NAME + 'MULTIPLE_ELEMENT_SELECTED';
		public static const SELECTION_CLEARED:String	= NAME + 'SELECTION_CLEARED';
		public static const CLEAR_SELECTION:String	= NAME + 'CLEAR_SELECTION';
		public static const SELECT_ALL:String	= NAME + 'SELECT_ALL';
		public static const SELECT_ELEMENT:String	= NAME + 'SELECT_ELEMENT';
		public static const COPY:String	= NAME + 'COPY';
		public static const CUT:String	= NAME + 'CUT';
		public static const PASTE:String	= NAME + 'PASTE';
		public static const SHORCUT_COPY:String	= NAME + 'SHORCUT_COPY';
		public static const SHORCUT_CUT:String	= NAME + 'SHORCUT_CUT';
		public static const SHORCUT_PASTE:String	= NAME + 'SHORCUT_PASTE';
		
		//USER INTERACTION
		public static const APP_CLICK:String = NAME + 'APP_CLICK';
		public static const CHANGE_LOCALE:String = NAME + 'CHANGE_LOCALE';
		public static const ZOOM_OUT:String = NAME + 'ZOOM_OUT';
		public static const ZOOM_IN:String = NAME + 'ZOOM_IN';
		public static const ZOOM_TO_AREA:String = NAME + 'ZOOM_TO_AREA';
		public static const ZOOM_CHANGED:String = NAME + 'ZOOM_CHANGED';
		public static const ZOOM_ANIMATION_START:String = NAME + 'ZOOM_ANIMATION_START';
		public static const ZOOM_ANIMATION_END:String = NAME + 'ZOOM_ANIMATION_END';
		public static const STAGE_RESIZE:String = NAME + 'STAGE_RESIZE';
		public static const SHORTCUT_DELETE_KEY_PRESSED:String = NAME + 'SHORTCUT_DELETE_KEY_PRESSED';
		public static const SHORTCUT_ALIGN_TO_CENTER_H:String = NAME + 'SHORTCUT_ALIGN_TO_CENTER_H';
		public static const SHORTCUT_ALIGN_TO_CENTER_V:String = NAME + 'SHORTCUT_ALIGN_TO_CENTER_V';
		public static const SHORTCUT_MAXIMIZE_ELEMENT:String = NAME + 'SHORTCUT_MAXIMIZE_ELEMENT';
		public static const SHORTCUT_FLIP_H_ELEMENT:String = NAME + 'SHORTCUT_FLIP_H_ELEMENT';
		public static const SHORTCUT_FLIP_V_ELEMENT:String = NAME + 'SHORTCUT_FLIP_V_ELEMENT';
		public static const SHORTCUT_ALIGN_TO_TOP:String = NAME + 'SHORTCUT_ALIGN_TO_TOP';
		public static const SHORTCUT_ALIGN_TO_BOTTOM:String = NAME + 'SHORTCUT_ALIGN_TO_BOTTOM';
		public static const SHORTCUT_ALIGN_TO_LEFT:String = NAME + 'SHORTCUT_ALIGN_TO_LEFT';
		public static const SHORTCUT_ALIGN_TO_RIGHT:String = NAME + 'SHORTCUT_ALIGN_TO_RIGHT';
		public static const MOUSE_WHEEL:String = NAME + 'MOUSE_WHEEL';
		public static const DUPLICATE_DESIGN:String = NAME + 'DUPLICATE_DESIGN';
		public static const DUPLICATE_ELEMENT:String = NAME + 'DUPLICATE_ELEMENT';
		public static const UNDO:String = NAME + 'UNDO';
		public static const REDO:String = NAME + 'REDO';
		
		
		
		
		
	}
}