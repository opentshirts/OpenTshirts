package model.design.vo
{
	import model.products.vo.RegionVO;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	public class DesignVO
	{
		/**
		 * array of design elements contained in designElementsContainer
		 */
		public var elements:ArrayCollection = new ArrayCollection();
		/**
		* Unique Identifier. The UID has the form "XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" where X is a hexadecimal digit (0-9, A-F).
		*/
		public var uid:String;

		public var currentAreaWidth:Number;
		public var currentAreaHeight:Number;
		public var currentLocation:RegionVO;
		
		public function DesignVO()
		{
			uid = UIDUtil.createUID();
		}
	}
}