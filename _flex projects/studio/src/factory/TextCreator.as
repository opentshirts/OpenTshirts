package factory
{
	import Interfaces.IDesignElement;
	
	
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.TextMediator;
	
	public class TextCreator implements ICreator
	{
		private var designElement:IDesignElement;
		
		public function TextCreator(designElement:IDesignElement)
		{
			this.designElement = designElement;
		}
		public function createMediator():IMediator
		{
			return new TextMediator(designElement as TextVO);
		}
		public function createProxy():IProxy
		{
			return new TextProxy(designElement as TextVO);
		}
	}
}