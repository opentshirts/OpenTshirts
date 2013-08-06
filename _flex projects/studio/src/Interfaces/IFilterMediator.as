package Interfaces
{
	import org.puremvc.as3.interfaces.IMediator;
	
	import view.components.designElement.DesignElementBase;

	public interface IFilterMediator extends IMediator
	{
		function setTarget(value:DesignElementBase):void
			
	}
}