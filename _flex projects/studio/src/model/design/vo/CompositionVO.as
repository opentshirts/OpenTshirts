package model.design.vo
{
	import model.products.vo.RegionVO;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	//SINGLETON
	public class CompositionVO
	{
		private static var instance:CompositionVO;
		public var name:String;
		public var id:String;
		public var selectedProductID:String;
		public var currentDesignArea:RegionVO;
		public var designs:ArrayCollection;
		public var uid:String;
		
		
		public function CompositionVO(pvt:SingletonEnforcer)
		{
			if ( pvt == null ) 
			{
				throw new Error("Use getInstance() method instead");
			}
			
			uid = UIDUtil.createUID();
			designs = new ArrayCollection();
		}
		
		public static function getInstance():CompositionVO
		{
			if( instance == null ) instance = new CompositionVO( new SingletonEnforcer() );
			return instance;
		}
		
	}
}

internal class SingletonEnforcer{}