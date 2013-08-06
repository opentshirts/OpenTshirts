package appFacade
{
  import controller.*;
  import controller.designElements.*;
  import controller.designElements.bitmap.CreateBitmapCommand;
  import controller.designElements.cliparts.*;
  import controller.designElements.filters.*;
  import controller.designElements.filters.outline.*;
  import controller.designElements.filters.shadow.*;
  import controller.designElements.text.*;
  
  import model.*;
  
  import mx.core.UIComponent;
  
  import org.puremvc.as3.interfaces.IFacade;
  import org.puremvc.as3.patterns.facade.Facade;
  import org.puremvc.as3.patterns.observer.Notification;
  
  import view.*;
  
  
  public class ApplicationFacade extends Facade implements IFacade  
  {  
  
    public static function getInstance():ApplicationFacade  
    {  
      return (instance ? instance : new ApplicationFacade()) as ApplicationFacade;  
    }  
    
    override protected function initializeController():void  
    {  
      super.initializeController();  
     	
     	registerCommand(ApplicationConstants.STARTUP, StartupCommand );
		registerCommand(ApplicationConstants.READY, AppStartCommand );
		registerCommand(ApplicationConstants.REGISTER_MEDIATOR, RegisterMediatorCommand );
		registerCommand(ApplicationConstants.EXPORT_IMAGE, ExportImageCommand );
		registerCommand(ApplicationConstants.SAVE_COMPOSITION, SaveCompositionCommand);
		registerCommand(ApplicationConstants.LOAD_COMPOSITION, LoadCompositionCommand);
		registerCommand(ApplicationConstants.ADD_TEMPLATE, AddTemplateCommand);
		registerCommand(ApplicationConstants.IMPORT_COMPOSITION, ImportCompositionCommand);
		registerCommand(ApplicationConstants.CHANGE_COMPOSITION_DATA, ChangeCompositionDataCommand);
		registerCommand(ApplicationConstants.CHANGE_LOCALE, ChangeLocaleUndoableCommand);
		registerCommand(ApplicationConstants.FILTER_COLORS,FilterColorsCommand);

		/**
		 *  >> PRODUCT MAPPING COMMANDS
		 * */
		//registerCommand(ApplicationConstants.CREATE_PRODUCT, CreateProductCommand);
		registerCommand(ApplicationConstants.CHANGE_PRODUCT, ChangeProductCommand);
		registerCommand(ApplicationConstants.CHANGE_PRODUCT_COLOR, ChangeProductColorUndoableCommand );
		registerCommand(ApplicationConstants.CHANGE_DESIGN_AREA, ChangeDesignAreaUndoableCommand );
		
		
		/**
		 *  << PRODUCT MAPPING COMMANDS
		 * */
		//-----------------------------------
		/**
		 *  >> CLIPART MAPPING COMMANDS
		 * */
		registerCommand(ApplicationConstants.CREATE_CLIPART, CreateClipartCommand);
		registerCommand(ApplicationConstants.CHANGE_COLOR_CLIPART_LAYER, ChangeClipartLayerColorUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_CLIPART_COLOR_STATE, ChangeClipartColorStateUndoableCommand);
		registerCommand(ApplicationConstants.CLIPART_INVERT_COLOR, InvertClipartColorUndoableCommand);
		/**
		 *  << CLIPART MAPPING COMMANDS
		 * *///-----------------------------------
		/**
		 *  >> BITMAP MAPPING COMMANDS
		 * */
		registerCommand(ApplicationConstants.CREATE_BITMAP, CreateBitmapCommand);
		/**
		 *  << BITMAP MAPPING COMMANDS
		 * */
		//-----------------------------------
		/**
		 *  >> FILTERS MAPPING COMMANDS
		 * */
		registerCommand(ApplicationConstants.FILTER_VISIBILITY_CHANGE, ChangeFilterVisibilityUndoableCommand);
		registerCommand(ApplicationConstants.OUTLINE_COLOR_CHANGE, ChangeOutlineColorUndoableCommand);
		registerCommand(ApplicationConstants.OUTLINE_THICKNESS_CHANGE, ChangeOutlineThicknessUndoableCommand);
		registerCommand(ApplicationConstants.SHADOW_COLOR_CHANGE, ChangeShadowColorUndoableCommand);
		registerCommand(ApplicationConstants.SHADOW_THICKNESS_CHANGE, ChangeShadowThicknessUndoableCommand);
		registerCommand(ApplicationConstants.SHADOW_DISTANCE_CHANGE, ChangeShadowDistanceUndoableCommand);
		registerCommand(ApplicationConstants.SHADOW_ANGLE_CHANGE, ChangeShadowAngleUndoableCommand);
		/**
		 *  << FILTERS MAPPING COMMANDS
		 * */
		//-----------------------------------
		/**
		 *  >> TEXT MAPPING COMMANDS
		 * */
		registerCommand(ApplicationConstants.CREATE_TEXT, CreateTextCommand);
		registerCommand(ApplicationConstants.CHANGE_TEXT_LAYOUT, ChangeTextLayoutUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_ARC_TEXT_LAYOUT_RADIO, ChangeArcTextLayoutRadioUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_ENVELOPE, ChangeEnvelopeUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_SIMPLE_ENVELOPE_AMOUNT, ChangeSimpleEnvelopeAmountUndoableCommand);
		registerCommand(ApplicationConstants.CREATE_TEXT, CreateTextCommand);
		registerCommand(ApplicationConstants.CHANGE_TEXT, ChangeTextUndoableCommand);
		//registerCommand(ApplicationConstants.CHANGE_TEXT_SHAPE, ChangeTextShapeUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_TEXT_SPACING, ChangeSpacingUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_FONT, ChangeFontUndoableCommand);
		registerCommand(ApplicationConstants.CHANGE_TEXT_COLOR, ChangeTextColorUndoableCommand);
		/**
		 *  << TEXT MAPPING COMMANDS
		 * */
		//-----------------------------------
		/**
		 *  >> DESIGN ELEMENT MAPPING COMMANDS
		 * */
		registerCommand(ApplicationConstants.ADD_ELEMENT_TO_DESIGN, AddElementToDesignUndoableCommand);
		registerCommand(ApplicationConstants.ADD_ELEMENT_AT_INDEX_TO_DESIGN, AddElementAtIndexToDesignUndoableCommand);
		registerCommand(ApplicationConstants.REMOVE_ELEMENT_FROM_DESIGN, RemoveElementFromDesignUndoableCommand);
		registerCommand(ApplicationConstants.UPDATE_UNSCALED_SIZE, UpdateUnscaledSizeCommand );
		registerCommand(ApplicationConstants.MAXIMIZE_ELEMENT, MaximizeElementUndoableCommand );
		registerCommand(ApplicationConstants.DESIGN_ELEMENT_MOVED, MoveElementUndoableCommand);
		registerCommand(ApplicationConstants.DESIGN_ELEMENT_RESIZED, ResizeElementUndoableCommand);
		registerCommand(ApplicationConstants.DESIGN_ELEMENT_ROTATED, RotateElementUndoableCommand);
		registerCommand(ApplicationConstants.DESIGN_ELEMENT_MOVED_ROTATED_RESIZED, MoveResizeRotateElementUndoableCommand);
		registerCommand(ApplicationConstants.ALIGN_TO_BOTTOM, AlignElementCommand);
		registerCommand(ApplicationConstants.ALIGN_TO_TOP, AlignElementCommand);
		registerCommand(ApplicationConstants.ALIGN_TO_LEFT, AlignElementCommand);
		registerCommand(ApplicationConstants.ALIGN_TO_RIGHT, AlignElementCommand);
		registerCommand(ApplicationConstants.ALIGN_TO_CENTER_H, AlignElementCommand);
		registerCommand(ApplicationConstants.ALIGN_TO_CENTER_V, AlignElementCommand);
		registerCommand(ApplicationConstants.ELEMENT_BACKWARD, ArrangeElementCommand);
		registerCommand(ApplicationConstants.ELEMENT_FORWARD, ArrangeElementCommand);
		registerCommand(ApplicationConstants.ELEMENT_TO_TOP, ArrangeElementCommand);
		registerCommand(ApplicationConstants.ELEMENT_TO_BOTTOM, ArrangeElementCommand);
		registerCommand(ApplicationConstants.SET_DESIGN_ELEMENT_INDEX, SetDesignElementIndexUndoableCommand);
		registerCommand(ApplicationConstants.LOCK_ELEMENT, LockElementUndoableCommand);
		registerCommand(ApplicationConstants.LOCK_ELEMENT_PROPORTIONS, LockElementProportionsUndoableCommand);
		registerCommand(ApplicationConstants.RESET_ELEMENT_PROPORTIONS, ResetElementProportionsCommand);
		registerCommand(ApplicationConstants.FLIP_H_ELEMENT, FlipHElementUndoableCommand);
		registerCommand(ApplicationConstants.FLIP_V_ELEMENT, FlipVElementUndoableCommand);
		registerCommand(ApplicationConstants.COPY, CopySelectionCommand);
		registerCommand(ApplicationConstants.PASTE, PasteSelectionCommand);
		registerCommand(ApplicationConstants.CUT, CutSelectionCommand);
		registerCommand(ApplicationConstants.DUPLICATE_DESIGN, DuplicateDesignCommand);
		registerCommand(ApplicationConstants.DUPLICATE_ELEMENT, DuplicateElementCommand);
		registerCommand(ApplicationConstants.UNDO, UndoCommand);
		registerCommand(ApplicationConstants.REDO, RedoCommand);
		
		/**
		 *  << DESIGN ELEMENT MAPPING COMMANDS
		 * */
		
		
		
    }  	  
	
	
    public function startup(appContainer:UIComponent):void  
    {  
      sendNotification( ApplicationConstants.STARTUP, appContainer );  
    }  
  	  
    override public function sendNotification(notificationName:String, body:Object=null, type:String=null):void  
    {  
      trace( 'Sent ' + notificationName, "from: ", type ,"body: ", body );  	  
      notifyObservers( new Notification( notificationName, body, type ) );  
    }  
  }    
}