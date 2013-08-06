package controller
{
	import model.LanguageProxy;
	import model.SettingsProxy;
	import model.design.DesignColorListProxy;
	import model.elements.text.FontListProxy;
	import model.products.ProductColorListProxy;
	
	import org.puremvc.as3.patterns.command.MacroCommand;

	//MAPPED WITH ConfigurationProxy.APP_DATA_READY
	public class GetServicesCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			facade.registerCommand(SettingsProxy.SETTINGS_READY, CheckAppReadyCommand);
			facade.registerCommand(LanguageProxy.LANGUAGE_READY, CheckAppReadyCommand);
			facade.registerCommand(DesignColorListProxy.DESIGN_COLORS_READY, CheckAppReadyCommand);
			facade.registerCommand(ProductColorListProxy.PRODUCTS_COLORS_READY, CheckAppReadyCommand);
			facade.registerCommand(FontListProxy.FONTS_READY, CheckAppReadyCommand);
			
			//get services
			addSubCommand( GetSettingsCommand );
			addSubCommand( GetLanguageCommand );
			addSubCommand( GetDesignColorListCommand );
			addSubCommand( GetProductColorListCommand );
			addSubCommand( GetFontListCommand );
		}		
	}
}