package model.products.vo
{
	import Interfaces.IIdentifiable;
	
	import flash.display.BitmapData;
	
	import model.design.vo.DesignVO;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;

	public class ViewVO implements IIdentifiable
	{
		
		public var view_index:String;
		[Bindable]
		public var product:ProductVO;
		[Bindable]
		public var name:String;
		private var _scale:Number;
		private var _design:DesignVO;
		[Bindable]
		public var underFill:String;
		[Bindable]
		public var shadeSrc:String;
		[Bindable]
		public var fillsSrc:Vector.<String> = new Vector.<String>();
		[Bindable]
		public var bd:BitmapData;
		
		//public var defaultRegion:RegionVO;
		//public var regions:Vector.<RegionVO> = new Vector.<RegionVO>();
		[Bindable]
		[ArrayElementType("model.products.vo.RegionVO")]
		public var regions:ArrayCollection = new ArrayCollection();
		private var _uid:String;
		public function ViewVO()
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

		public function get design():DesignVO
		{
			return _design;
		}

		public function set design(value:DesignVO):void
		{
			_design = value;
		}

		public function get scale():Number
		{
			return _scale;
		}

		public function set scale(value:Number):void
		{
			_scale = value;
		}

		
	}
}