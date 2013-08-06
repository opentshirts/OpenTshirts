package factory
{
	
	import model.elements.text.layout.NormalTextLayoutProxy;
	import model.elements.text.layout.NormalTextLayoutVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.NormalTextLayoutMediator;
	
	public class NormalTextLayoutCreator implements ICreator
	{
		private var vo:NormalTextLayoutVO;
		
		public function NormalTextLayoutCreator(vo:NormalTextLayoutVO)
		{
			this.vo = vo;
		}
		public function createMediator():IMediator
		{
			return new NormalTextLayoutMediator(vo);
		}
		public function createProxy():IProxy
		{
			return new NormalTextLayoutProxy(vo);
		}
	}
}