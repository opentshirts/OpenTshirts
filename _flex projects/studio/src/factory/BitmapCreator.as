package factory
{
	import Interfaces.IDesignElement;
	
	import model.elements.bitmap.BitmapProxy;
	import model.elements.bitmap.vo.BitmapVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;
	
	import view.BitmapMediator;
	
	public class BitmapCreator implements ICreator
	{
		private var designElement:IDesignElement;
		
		public function BitmapCreator(designElement:IDesignElement)
		{
			this.designElement = designElement;
		}
		
		public function createMediator():IMediator
		{
			return new BitmapMediator(designElement as BitmapVO);
		}
		public function createProxy():IProxy
		{
			return new BitmapProxy(designElement as BitmapVO);
		}
	}
}