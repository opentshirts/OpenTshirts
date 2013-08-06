package view
{
	
	import Interfaces.IFilterMediator;
	
	import events.DesignElementEvent;
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.GlowFilter;
	
	import model.elements.filters.FilterProxy;
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.OutlineVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import utils.ArrayUtil;
	
	import view.components.designElement.DesignElementBase;
	
	  
	public class OutlineMediator extends Mediator implements IFilterMediator
	{  
		public static const NAME:String = 'OutlineMediator';
		 
		private var _vo:OutlineVO;
		private var _target:DesignElementBase;
		private var _zoomScale:Number=1;
		
		public function OutlineMediator(vo:OutlineVO)
		{  
			var viewComponent:Object = new GlowFilter();
			
			super( NAME, viewComponent );
			
			this._vo = vo;
		}
		override public function getMediatorName():String
		{
			return _vo.uid;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerFilterMediator();
			
			invalidate();
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			removeFilterMediator();
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				FilterProxy.VISIBLE_CHANGE,
				OutlineProxy.OUTLINE_THICKNESS_CHANGE,
				OutlineProxy.OUTLINE_COLOR_CHANGE,
				ApplicationConstants.OUTLINE_THICKNESS_CHANGING,
				ApplicationConstants.ZOOM_CHANGED
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{

			switch ( note.getName() )
			{
				case FilterProxy.VISIBLE_CHANGE:
				case OutlineProxy.OUTLINE_THICKNESS_CHANGE:
				case OutlineProxy.OUTLINE_COLOR_CHANGE:
					var uid:String = String(note.getBody().uid);
					if (_vo.uid == uid )
					{
						invalidate();
					}
					break;
				case ApplicationConstants.ZOOM_CHANGED:
					//for filters scale
					_zoomScale = note.getBody() as Number;
					invalidate()
					break;
			}
		}

		private function invalidate():void
		{
			//invalidate visual element
			if(_target)
			{
				/**
				 * This is needed because: (from http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/filters/GlowFilter.html?filter_flex=4.5.1&filter_flashplayer=10.3&filter_air=2.6)
				 * This filter supports Stage scaling. However, it does not support general scaling, rotation, and skewing. If the object itself is scaled (if scaleX and scaleY are set to a value other than 1.0), the filter is not scaled. 
				 * It is scaled only when the user zooms in on the Stage.
				 * 
				 * */

				outline.blurX = _vo.thickness*Math.abs(_target.container.scaleX)*_zoomScale;
				outline.blurY = _vo.thickness*Math.abs(_target.container.scaleY)*_zoomScale;
				outline.color = _vo.color.hexa;
				outline.alpha = _vo.color.alpha;
				outline.strength = 255;
				outline.quality = BitmapFilterQuality.HIGH;
				
				/*if(_vo.visible)
				{
					_target.filters = ArrayUtil.addToArray(outline, _target.filters);
				}
				else
				{
					_target.filters = ArrayUtil.removeFromArray(outline, _target.filters);
				}*/
				if(!_vo.visible)
					outline.blurX = outline.blurY = outline.alpha = outline.strength = 0;
				
				
				_target.filters = _target.filters;
			}
		}
		
		private function get outline():GlowFilter
		{
			return viewComponent as GlowFilter;
		}
		private function onSizeChange(event:DesignElementEvent):void
		{
			invalidate();
		}
		public function setTarget( target:DesignElementBase ):void 
		{
			_target = target;
			_target.addEventListener( DesignElementEvent.SIZE_CHANGE, onSizeChange);
			
			_target.filters = ArrayUtil.addToArray(outline, _target.filters);
			
			invalidate();
		}
		private function registerFilterMediator():void
		{
			var filterMediator:FilterMediator = new FilterMediator(outline, _vo);
			facade.registerMediator(filterMediator);
		}
		private function removeFilterMediator():void
		{
			facade.removeMediator(FilterMediator.NAME+_vo.uid);
		}


	 }  
}