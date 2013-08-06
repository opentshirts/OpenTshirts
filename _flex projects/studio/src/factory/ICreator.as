package factory
{
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.IProxy;

	public interface ICreator
	{
		function createMediator():IMediator
		function createProxy():IProxy
	}
}