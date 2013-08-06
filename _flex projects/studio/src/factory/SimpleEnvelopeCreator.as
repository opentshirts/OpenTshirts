package factory
{
	
	import model.elements.text.envelope.SimpleEnvelopeProxy;
	import model.elements.text.envelope.SimpleEnvelopeVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.SimpleEnvelopeMediator;
	
	public class SimpleEnvelopeCreator implements ICreator
	{
		private var vo:SimpleEnvelopeVO;
		
		public function SimpleEnvelopeCreator(vo:SimpleEnvelopeVO)
		{
			this.vo = vo;
		}
		public function createMediator():IMediator
		{
			return new SimpleEnvelopeMediator(vo);
		}
		public function createProxy():IProxy
		{
			return new SimpleEnvelopeProxy(vo);
		}
	}
}