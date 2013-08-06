package factory
{
	
	import model.elements.text.layout.ArcTextLayoutProxy;
	import model.elements.text.layout.ArcTextLayoutVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.ArcTextLayoutMediator;
	
	public class ArcTextLayoutCreator implements ICreator
	{
		private var vo:ArcTextLayoutVO;
		
		public function ArcTextLayoutCreator(vo:ArcTextLayoutVO)
		{
			this.vo = vo;
		}
		public function createMediator():IMediator
		{
			return new ArcTextLayoutMediator(vo);
		}
		public function createProxy():IProxy
		{
			return new ArcTextLayoutProxy(vo);
		}
	}
}