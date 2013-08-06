package factory
{
	
	import model.elements.text.envelope.NoEnvelopeProxy;
	import model.elements.text.envelope.NoEnvelopeVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.NoEnvelopeMediator;
	
	public class NoEnvelopeCreator implements ICreator
	{
		private var vo:NoEnvelopeVO;
		
		public function NoEnvelopeCreator(vo:NoEnvelopeVO)
		{
			this.vo = vo;
		}
		public function createMediator():IMediator
		{
			return new NoEnvelopeMediator(vo);
		}
		public function createProxy():IProxy
		{
			return new NoEnvelopeProxy(vo);
		}
	}
}