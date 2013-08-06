package model
{	  
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	  
	
	public class ClipboardProxy extends Proxy implements IProxy  
	{  
		public static const NAME:String = 'ClipboardProxy'; 	  
		
		public function ClipboardProxy()  
		{  
			super( NAME, new Array());  
		}
		
		  
		public function get vo():Array 
		{  
			return data as Array;  
		}
		
		public function add(obj:DesignElementVO):void 
		{
			vo.push(obj);
		}
		public function clear():void 
		{
			while(vo.length>0) {vo.pop()};
		}
	}  
}