package view
{
	
	import Interfaces.IFilterMediator;
	
	import com.roguedevelopment.objecthandles.OHObjectModel;
	
	import events.DesignElementEvent;
	
	import model.design.DesignColorListProxy;
	import model.elements.DesignElementProxy;
	import model.elements.filters.FilterVO;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import appFacade.ApplicationConstants;
	
	import view.components.designElement.DesignElementBase;
	
	  
	public class DesignElementMediator extends Mediator implements IMediator
	{  
		public static const NAME:String = 'DesignElementMediator';
		 
		private var _vo:DesignElementVO;
		
		public function DesignElementMediator(viewComponent:Object, vo:DesignElementVO)  
		{  
			super( NAME, viewComponent );
			viewSprite.addEventListener(DesignElementEvent.UNSCALED_SIZE_CHANGE, onUnscaledSizeChange);
			this._vo = vo;
			
		}
		override public function getMediatorName():String
		{
			return NAME + _vo.uid;
		}
		override public function listNotificationInterests():Array  
		{
			return [ 
				ApplicationConstants.DESIGN_ELEMENT_MOVING,
				ApplicationConstants.DESIGN_ELEMENT_RESIZING,
				ApplicationConstants.DESIGN_ELEMENT_ROTATING,
				ApplicationConstants.ZOOM_CHANGED,
				DesignElementProxy.POSITION_CHANGE,
				DesignElementProxy.SIZE_CHANGE,
				DesignElementProxy.ROTATION_CHANGE,
				DesignElementProxy.FLIP_CHANGE,
				//DesignElementProxy.IS_LOCKED_CHANGE,
				//DesignElementProxy.MAINTAIN_PROPORTION_CHANGE,
				DesignElementProxy.FILTER_ADDED,
				DesignColorListProxy.CANVAS_COLOR_CHANGE
				
			];  
		}  
		override public function onRegister():void
		{			
			//invalidate
			viewSprite.setPos(_vo.x, _vo.y);
			viewSprite.setSize(_vo.width, _vo.height);
			viewSprite.rot = _vo.rotation;
			viewSprite.setFlip(_vo.flipH, _vo.flipV);
			for each (var filter:FilterVO in _vo.filters) 
			{
				var mediator:IFilterMediator = facade.retrieveMediator(filter.uid) as IFilterMediator;
				mediator.setTarget(viewSprite);
			}

		}
		override public function handleNotification(note:INotification):void
		{
			var filter:Object;
			var ohModel:OHObjectModel;
			
			switch ( note.getName() )
			{
				
				// >> notifications from ObjectHandlesMediator
				case ApplicationConstants.DESIGN_ELEMENT_MOVING:
					ohModel = note.getBody() as OHObjectModel;
					if (ohModel.uid == _vo.uid )
						viewSprite.setPos(ohModel.x, ohModel.y);
					break;
				case ApplicationConstants.DESIGN_ELEMENT_RESIZING:
					ohModel = note.getBody() as OHObjectModel;
					if (ohModel.uid == _vo.uid )
					{
						viewSprite.setSize(ohModel.width, ohModel.height);
						viewSprite.setPos(ohModel.x, ohModel.y);
					}
					break;
				case ApplicationConstants.DESIGN_ELEMENT_ROTATING:
					ohModel = note.getBody() as OHObjectModel;
					if (ohModel.uid == _vo.uid )
					{
						viewSprite.rot = ohModel.rotation;
						viewSprite.setPos(ohModel.x, ohModel.y);
					}
					break;
				// << end notifications from ObjectHandlesMediator
				
				
				// >> notifications from DesignElementProxy
				case DesignElementProxy.POSITION_CHANGE:
					if ( note.getBody().uid == _vo.uid )
					{
						viewSprite.setPos(_vo.x, _vo.y); //position may change with rotation
					}
					break;
				case DesignElementProxy.SIZE_CHANGE:
					if ( note.getBody().uid == _vo.uid )
					{
						viewSprite.setSize(_vo.width, _vo.height);
					}
					break;
				case DesignElementProxy.FLIP_CHANGE:
					if ( note.getBody().uid == _vo.uid )
					{
						viewSprite.setFlip(_vo.flipH, _vo.flipV);
					}
					break;
				case DesignElementProxy.ROTATION_CHANGE:
					if ( note.getBody().uid == _vo.uid )
					{
						viewSprite.rot = _vo.rotation;
					}
					break;
				/*case DesignElementProxy.IS_LOCKED_CHANGE:
					if ( note.getBody().uid == _vo.uid )
					{
					}
					break;*/
				/*case DesignElementProxy.MAINTAIN_PROPORTION_CHANGE:
					if ( note.getBody().uid == _vo.uid )
					{
					}
					break;*/
				case DesignElementProxy.FILTER_ADDED:
					if ( note.getBody().uid == _vo.uid )
					{
						var mediator:IFilterMediator = facade.retrieveMediator(note.getBody().filter_uid) as IFilterMediator;
						mediator.setTarget(viewSprite);
					}
					break;
				case DesignColorListProxy.CANVAS_COLOR_CHANGE:
					viewSprite.updateCanvasColor();
					break;
				// << end notifications from DesignElementProxy
				
				
			}
		}


		private function onUnscaledSizeChange(event:DesignElementEvent):void
		{
			var isNewElement:Boolean = (_vo.width==0 && _vo.height==0 && event.data.width>0 && event.data.height>0 );
			
			sendNotification(ApplicationConstants.UPDATE_UNSCALED_SIZE, {size:event.data, uid:_vo.uid}, NAME );
			
			if(isNewElement)
				sendNotification(ApplicationConstants.MAXIMIZE_ELEMENT, {uid:_vo.uid}, UndoableCommandTypeEnum.NON_RECORDABLE_COMMAND  ); 
		}
		
		public function get viewSprite():DesignElementBase
		{
			return viewComponent as DesignElementBase;
		}
		
	 }  
}