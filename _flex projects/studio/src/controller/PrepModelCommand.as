package controller
{
	import model.ClipboardProxy;
	import model.ConfigurationProxy;
	import model.LanguageProxy;
	import model.SettingsProxy;
	import model.design.CompositionProxy;
	import model.design.DesignColorListProxy;
	import model.design.DesignProxy;
	import model.design.SavedCompositionProxy;
	import model.design.UsedColorPaletteProxy;
	import model.elements.DesignElementProxy;
	import model.elements.bitmap.BitmapProxy;
	import model.elements.cliparts.ClipartProxy;
	import model.elements.filters.FilterProxy;
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.ShadowProxy;
	import model.elements.text.FontListProxy;
	import model.elements.text.TextProxy;
	import model.products.ProductColorListProxy;
	import model.products.ProductProxy;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.CommandsHistoryProxy;

	public class PrepModelCommand extends SimpleCommand
	{
		override public function execute(notification:INotification):void
		{
			
			facade.registerCommand(ConfigurationProxy.APP_DATA_READY, GetServicesCommand ); ///config xml loaded
			
			facade.registerCommand(ProductProxy.PRODUCT_CREATED, InitializeProductCommand); 
			facade.registerCommand(SavedCompositionProxy.LOADED, ProcessLoadedCompositionCommand); 
			facade.registerCommand(SavedCompositionProxy.IMPORT, ProcessImportCompositionCommand); 
			facade.registerCommand(SavedCompositionProxy.ADD_DESIGN, ProcessAddTemplateCommand); 
			
			
			/*
			* register with each notification that could change the colors used
			*/
			facade.registerCommand(DesignProxy.DESIGN_ELEMENT_ADDED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(DesignProxy.DESIGN_ELEMENT_REMOVED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(ClipartProxy.COLOR_STATE_CHANGED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(ClipartProxy.INVERTED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(ClipartProxy.LAYER_COLOR_CHANGED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(DesignElementProxy.FILTER_ADDED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(TextProxy.COLOR_CHANGED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(FilterProxy.VISIBLE_CHANGE, UpdateUsedColorPaletteCommand );
			facade.registerCommand(OutlineProxy.OUTLINE_COLOR_CHANGE, UpdateUsedColorPaletteCommand );
			facade.registerCommand(ShadowProxy.SHADOW_COLOR_CHANGE, UpdateUsedColorPaletteCommand );
			facade.registerCommand(CompositionProxy.CURRENT_DESIGN_AREA_CHANGED, UpdateUsedColorPaletteCommand );
			facade.registerCommand(BitmapProxy.COLORS_CHANGE, UpdateUsedColorPaletteCommand );
			///when changing the number of colors, request for a new quote for screenprinting
			facade.registerCommand(UsedColorPaletteProxy.PALETTE_CHANGE, UpdatePriceCommand);
			///when changing the size of pritable area, request for a new quote for DTG
			facade.registerCommand(CompositionProxy.CURRENT_DESIGN_AREA_CHANGED, UpdatePriceCommand);
			
			//for copy paste
			facade.registerProxy( new ClipboardProxy());
			//for undoable commands
			facade.registerProxy( new CommandsHistoryProxy());
			///compositions
			facade.registerProxy( new CompositionProxy());
			///config xml
			facade.registerProxy( new ConfigurationProxy());
			//saved design
			facade.registerProxy( new SavedCompositionProxy());
			//settings
			facade.registerProxy( new SettingsProxy());
			//language
			facade.registerProxy( new LanguageProxy());
			//products colors
			facade.registerProxy( new ProductColorListProxy());
			//design colors
			facade.registerProxy( new DesignColorListProxy());
			//font list
			facade.registerProxy( new FontListProxy());
			
		}
	}
}