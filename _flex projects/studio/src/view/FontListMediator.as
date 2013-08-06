package view
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.utils.Dictionary;
	
	import model.elements.text.FontListProxy;
	import model.elements.text.vo.FontVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import spark.components.List;

	  
	public class FontListMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'FontListMediator';  

		private var fontDic:Dictionary = new Dictionary();
		private var _fonts:ArrayCollection;
		  
		public function FontListMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent );
		}
		
		override public function listNotificationInterests():Array  
		{  
			return [ 
				FontListProxy.FONTS_READY,
				ApplicationConstants.LOAD_FONT
			];  
		}  
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();  
			
			switch ( name )  
			{  
				case FontListProxy.FONTS_READY:
					_fonts = notification.getBody() as ArrayCollection;
					fontList.dataProvider = _fonts;
					break;
				case ApplicationConstants.LOAD_FONT:
					var fontName:String = String(notification.getBody());
					var src:String = getFontSrcFromName(fontName);
					if(src)
					{
						fontDic[src] = fontName;
						loadFont(src);
					}else
					{
						trace("font not found in list!");
					}
					break;
			}
		}
		
		private function onStartHandler(event:Event):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_START, null, NAME);  
		}
		private function onComplete(e:Event):void 
		{
			var fontName:String = fontDic[e.target.loader.name];
			sendNotification(ApplicationConstants.LOAD_OBJECT_COMPLETE, null, NAME  ); 
			sendNotification(ApplicationConstants.FONT_LOADED, fontName, NAME);
		}
		private function getFontSrcFromName(fname:String):String
		{
			for each (var font:FontVO in _fonts)
			{
				if(font.name == fname)
				{
					return font.swf_src;
				}
			}
			return null;
		}
		public function loadFont(url:String):void {
			var ldrContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			var loader:Loader = new Loader();
			loader.name = url;
			loader.contentLoaderInfo.addEventListener(Event.OPEN, onStartHandler);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onProgressHandler);  
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			loader.load(new URLRequest(url), ldrContext);
		}
		private function onProgressHandler(e:ProgressEvent):void
		{
			var pct:Number = e.bytesTotal == 0 ? 0 : Math.round( (e.bytesLoaded / e.bytesTotal)*100 );
			sendNotification(ApplicationConstants.LOAD_OBJECT_PROGRESS, {percent:pct}, NAME);  
		}
		private function ioErrorHandler(_event:IOErrorEvent):void
		{
			sendNotification(ApplicationConstants.LOAD_OBJECT_ERROR, _event.toString()+_event.type, NAME); 
		}
		private function get fontList():List
		{
			return viewComponent as List;
		}
	 }  
}