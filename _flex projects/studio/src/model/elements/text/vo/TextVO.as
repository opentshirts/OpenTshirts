package model.elements.text.vo
{
	import Interfaces.IDesignElement;
	import Interfaces.IEnvelope;
	import Interfaces.ITextLayout;
	
	import factory.TextCreator;
	
	import model.design.vo.DesignColorVO;
	import model.elements.DesignElementType;
	import model.elements.vo.DesignElementVO;
	
	
	public class TextVO extends DesignElementVO implements IDesignElement
	{
		public var text:String;
		public var color:DesignColorVO;
		public var id_font:String;
		public var font:String;
		public var spacing:Number;
		public var envelope:IEnvelope;
		public var layout:ITextLayout;
		
		public function TextVO()
		{
			super();
			_creator = new TextCreator(this);
		}
		public function get type():String
		{
			return DesignElementType.TEXT;
		}
	}
}