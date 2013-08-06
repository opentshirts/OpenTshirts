package model.products
{	  
	import model.products.vo.RegionVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class RegionProxy extends Proxy implements IProxy  
	{  
		public static const NAME:String = 'RegionProxy';
		
		public function RegionProxy(value_object:Object)  
		{  
			super( NAME, value_object  );
		}
		
		override public function getProxyName():String
		{
			return NAME + vo.view.product.id + "_" + vo.view.view_index + "_" + vo.region_index;
		}

		public function get vo():RegionVO
		{
			return data as RegionVO;
		}
		
	}  
}