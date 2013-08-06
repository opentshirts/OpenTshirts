package model.elements.filters
{
	import factory.OutlineFilterCreator;
	
	import model.design.vo.DesignColorVO;
	
	public class OutlineVO extends FilterVO
	{
		private var _color:DesignColorVO;
		private var _thickness:Number;
		
		
		public function OutlineVO()
		{
			super();
			_creator = new OutlineFilterCreator(this);
		}

		

		override public function get name():String
		{
			return FilterNameEnum.OUTLINE;
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
		

	}
}