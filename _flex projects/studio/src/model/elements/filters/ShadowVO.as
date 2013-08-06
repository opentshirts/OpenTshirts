package model.elements.filters
{
	import factory.ShadowFilterCreator;
	
	import model.design.vo.DesignColorVO;
	
	public class ShadowVO extends FilterVO
	{
		private var _color:DesignColorVO;
		private var _thickness:Number;
		private var _distance:Number;
		private var _angle:Number;
		
		public function ShadowVO()
		{
			super();
			_creator = new ShadowFilterCreator(this);
		}
		override public function get name():String
		{
			return FilterNameEnum.SHADOW;
		}
		[Bindable]
		public function get color():DesignColorVO
		{
			return _color;
		}

		public function set color(value:DesignColorVO):void
		{
			_color = value;
		}

		[Bindable]
		public function get thickness():Number
		{
			return _thickness;
		}

		public function set thickness(value:Number):void
		{
			_thickness = value;
		}
		[Bindable]
		public function get distance():Number
		{
			return _distance;
		}

		public function set distance(value:Number):void
		{
			_distance = value;
		}
		[Bindable]
		public function get angle():Number
		{
			return _angle;
		}

		public function set angle(value:Number):void
		{
			_angle = value;
		}

	}
}