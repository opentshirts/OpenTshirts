package Interfaces
{
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	
	import view.components.designElement.DesignElementBase;

	public interface IDesignElementMediator extends IMediator
	{
		function get designElementVO():DesignElementVO
		function get designElementBase():DesignElementBase
			
	}
}