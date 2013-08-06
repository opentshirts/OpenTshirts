package factory
{
	
	
	import model.elements.filters.ShadowProxy;
	import model.elements.filters.ShadowVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.ShadowMediator;
	
	public class ShadowFilterCreator implements ICreator
	{
		private var vo:ShadowVO;
		
		public function ShadowFilterCreator(vo:ShadowVO)
		{
			this.vo = vo;
		}
		public function createMediator():IMediator
		{
			return new ShadowMediator(vo);
		}
		public function createProxy():IProxy
		{
			return new ShadowProxy(vo);
		}
	}
}