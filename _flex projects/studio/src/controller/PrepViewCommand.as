package controller
{
	import components.AppLayout;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	import view.*;

	public class PrepViewCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			var app:AppLayout = note.getBody() as AppLayout;
			
			facade.registerMediator( new ExternalInterfaceMediator() );
			
			facade.registerMediator( new ApplicationMediator( app ) );
			
			facade.registerMediator( new PreloaderMediator( app.controls));
			
			facade.registerMediator( new CompositionMediator( app.compositionContainer ));
			
			facade.registerMediator( new ZoomMediator( app.compositionContainer, app.compositionPane));
			
			/* product properties (name, views, colors) */
			facade.registerMediator( new ProductPropertiesMediator(app.controls));
			
			/* design colors list */
			facade.registerMediator( new DesignColorListMediator(app.controls));
			
			
			facade.registerMediator( new UsedDesignColorListMediator(app.controls));

			/* procut colors list */
			//facade.registerMediator( new ProductColorListMediator(app.controls));
			
			/* add clipart, text, product buttons */
			//facade.registerMediator( new ButtonsBarMediator(app.controls));
			
			/* zoom controls */
			//facade.registerMediator( new ZoomControlsMediator(app.controls));
			
			facade.registerMediator( new DesignElementPropertiesMediator(app.controls));
			facade.registerMediator( new FilterPropertiesMediator(app.controls));
			/* clipart properties */
			facade.registerMediator( new ClipartPropertiesMediator(app.controls));
			
			/* text properties */
			facade.registerMediator( new TextPropertiesMediator(app.controls));
			//facade.registerMediator( new EasyDesignPanelMediator(app.controls));
			facade.registerMediator( new TextShapesMediator(app.controls));
			
			
			
		}
		
	}
}