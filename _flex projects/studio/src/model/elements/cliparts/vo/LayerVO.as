package model.elements.cliparts.vo
{
	import model.design.vo.DesignColorVO;
	import mx.utils.UIDUtil;
	
	public class LayerVO
	{
		public var uid:String;
		/**
		 * color setted by admin
		 * */
		public var defaultColor:DesignColorVO;
		/**
		 * layer's name
		 * */		
		public var name:String;
		/**
		 * layer's index
		 * */		
		public var index:uint;
		/**
		 * whether to hide or show this layer
		 * */
		//[Bindable] 
		public var visible:Boolean;
		/**
		 * whether to hide or show this layer's color picker
		 * */
		//[Bindable] 
		public var tintable:Boolean;
		/**
		 * 
		 * */	
		//[Bindable] 
		public var actualColor:DesignColorVO;
		
		
		public function LayerVO()
		{
			uid = UIDUtil.createUID();
		}

	}
}