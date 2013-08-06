package factory
{
	import Interfaces.IDesignElement;
	
	
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.ClipartMediator;
	
	public class ClipartCreator implements ICreator
	{
		private var designElement:IDesignElement;
		
		public function ClipartCreator(designElement:IDesignElement)
		{
			this.designElement = designElement;
		}
		
		public function createMediator():IMediator
		{
			return new ClipartMediator(designElement as ClipartVO);
		}
		public function createProxy():IProxy
		{
			return new ClipartProxy(designElement as ClipartVO);
		}
	}
}