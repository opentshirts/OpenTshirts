package controller
{
	import org.puremvc.as3.patterns.command.MacroCommand;

	//MAPPED WITH ApplicationConstants.STARTUP
	public class StartupCommand extends MacroCommand
	{
		override protected function initializeMacroCommand():void
		{
			addSubCommand( PrepModelCommand );
			addSubCommand( PrepViewCommand );
			addSubCommand( InitCommand );
		}		
	}
}