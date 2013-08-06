package model.products.vo
{
	import Interfaces.IIdentifiable;
	
	import model.design.vo.DesignVO;
	
	import mx.utils.UIDUtil;

	public class RegionVO implements IIdentifiable
	{
		[Bindable] public var region_index:String;
		[Bindable] public var name:String;
		public var view:ViewVO;
		public var unscaledWidth:Number;
		public var unscaledHeight:Number;
		[Bindable] public var x:Number;
		[Bindable] public var y:Number;
		[Bindable] public var constrainToBounds:Boolean;
		[Bindable] public var design:DesignVO;
		[Bindable] public var scale:Number;
		public var mask_url:String;

		
		private var _uid:String;
		
		public function RegionVO()
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
		
		[Bindable]
		public function get width():Number
		{
			return unscaledWidth*scale;
		}

		public function set width(value:Number):void
		{
			unscaledWidth = value/scale;
		}

		[Bindable]
		public function get height():Number
		{
			return unscaledHeight*scale;
		}

		public function set height(value:Number):void
		{
			unscaledHeight = value/scale;
		}


	}
}