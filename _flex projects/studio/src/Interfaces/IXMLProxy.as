package Interfaces
{
	import org.puremvc.as3.interfaces.IProxy;
	
	public interface IXMLProxy extends IProxy
	{
		function saveToXML():XML;
		function loadFromXML(xml:XML):void;
	}
}