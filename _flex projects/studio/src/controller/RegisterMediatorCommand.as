package controller
{
	import Interfaces.ICreatable;
	
	import org.puremvc.as3.interfaces.ICommand;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	/*
	mapped with 
		DesignElementProxy.ELEMENT_CREATED
		FilterProxy.FILTER_CREATED
	*/
	public class RegisterMediatorCommand extends SimpleCommand implements ICommand
	{
		override public function execute(note:INotification):void
		{
			if (note.getBody() is ICreatable )
			{
				var element:ICreatable = note.getBody() as ICreatable;
				facade.registerMediator( element.creator.createMediator() );
			}else
			{
				throw new Error("notification body is not a ICreatable object");
			}
		}
	}
}