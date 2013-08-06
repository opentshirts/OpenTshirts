package model.elements.bitmap.vo
{
	import Interfaces.IDesignElement;
	
	import factory.BitmapCreator;
	
	import model.design.vo.DesignColorVO;
	import model.elements.DesignElementType;
	import model.elements.vo.DesignElementVO;
	
	
	public class BitmapVO extends DesignElementVO implements IDesignElement
	{
		public var source:String;
		public var colors:Vector.<DesignColorVO>;
		public var hidden_colors:Vector.<uint>;
		public var id_bitmap:String;
		
		public function BitmapVO()
		{
			super();
			colors = new Vector.<DesignColorVO>();
			hidden_colors = new Vector.<uint>;
			_creator = new BitmapCreator(this);
		}
		public function get type():String
		{
			return DesignElementType.BITMAP;
		}
	}
}