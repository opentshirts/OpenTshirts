package model.products.vo
{
	public class ProductColorVO
	{
		[Bindable]
		public var name:String;
		public var id:String;
		public var need_white_base:Boolean;
		public var hexas:Vector.<uint> = new Vector.<uint>();

	}
}