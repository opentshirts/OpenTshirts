package model.elements.cliparts.vo
{
	import Interfaces.IDesignElement;
	
	import factory.ClipartCreator;
	
	import model.elements.DesignElementType;
	import model.elements.vo.DesignElementVO;
	
	
	public class ClipartVO extends DesignElementVO implements IDesignElement
	{
		public var id_clipart:String;
		public var name:String;
		public var thumb_src:String;
		public var api_link:String;
		public var swf_file:String;
		public var colorState:uint;
		public var inverted:Boolean = false;
		public var layers:Vector.<LayerVO> = new Vector.<LayerVO>();
		public var dataLoaded:Boolean = false;
		
		public function ClipartVO()
		{
			super();
			_creator = new ClipartCreator(this);
		}
		public function get type():String
		{
			return DesignElementType.CLIPART;
		}
	}
}