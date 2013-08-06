package model.products.vo
{
	import Interfaces.IIdentifiable;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;
	
	public class ProductVO implements IIdentifiable
	{
		//product
		public var id:String;
		public var name:String;
		public var apiLink:String;
		public var dataLoaded:Boolean = false;
		
		[Bindable]	public var currentColor:ProductColorVO; //used in renderer.ViewListItemRenderer
		
		public var availableColors:ArrayCollection = new ArrayCollection();
		
		public var views:ArrayCollection = new ArrayCollection();
		
		//default values
		public var defaultColor:ProductColorVO;
		//public var defaultView:ViewVO;
		public var defaultRegion:RegionVO;
		
		private var _uid:String;
		public function ProductVO()
		{
			super();
			uid = UIDUtil.createUID();
		}
		public function get uid():String
		{
			return _uid;
		}
		
		public function set uid(value:String):void
		{
			_uid = value;
		}
		

	}
}