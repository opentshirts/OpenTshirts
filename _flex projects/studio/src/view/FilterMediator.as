package view
{
	
	import com.roguedevelopment.objecthandles.OHObjectModel;
	
	import flash.filters.BitmapFilter;
	
	import model.design.DesignColorListProxy;
	import model.elements.filters.FilterProxy;
	import model.elements.filters.FilterVO;
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.ShadowProxy;
	
	import mx.events.PropertyChangeEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import view.components.designElement.DesignElementBase;
	
	  
	public class FilterMediator extends Mediator implements IMediator
	{  
		public static const NAME:String = 'FilterMediator';
		 
		private var _vo:FilterVO;
		
		public function FilterMediator(viewComponent:Object, vo:FilterVO)  
		{  
			super( NAME, viewComponent );
			_vo = vo;
		}
		override public function getMediatorName():String
		{
			return NAME + _vo.uid;
		}
		override public function listNotificationInterests():Array  
		{
			return [ 
				FilterProxy.VISIBLE_CHANGE,
				ApplicationConstants.ZOOM_CHANGED
				
			];  
		}  
		override public function onRegister():void
		{			
			invalidate();
		}
		override public function handleNotification(note:INotification):void
		{
			var filter:Object;
			var ohModel:OHObjectModel;
			
			switch ( note.getName() )
			{
				
				case FilterProxy.VISIBLE_CHANGE:
					if(_vo.uid==note.getBody().uid)
					{
						//viewSprite.elementFilters = _localModel.filters;
						break;
					}
					break;

				case ApplicationConstants.ZOOM_CHANGED:
					//for filters scale
					//viewSprite.zoomScale = note.getBody() as Number;
					break;
			}
		}

		private function invalidate():void
		{
			//invalidate visual element
			//viewSprite.elementFilters = _localModel.filters;
		}
		
		
		public function get viewSprite():BitmapFilter
		{
			return viewComponent as BitmapFilter;
		}
		
	 }  
}