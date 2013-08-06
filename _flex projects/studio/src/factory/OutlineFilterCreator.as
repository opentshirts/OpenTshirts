package factory
{
	
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.OutlineVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.OutlineMediator;
	
	public class OutlineFilterCreator implements ICreator
	{
		private var vo:OutlineVO;
		
		public function OutlineFilterCreator(vo:OutlineVO)
		{
			this.vo = vo;
		}
		public function createMediator():IMediator
		{
			return new OutlineMediator(vo);
		}
		public function createProxy():IProxy
		{
			return new OutlineProxy(vo);
		}
	}
}