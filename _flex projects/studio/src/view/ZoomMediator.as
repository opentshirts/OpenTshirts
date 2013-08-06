package view
{
	import appFacade.ApplicationConstants;
	
	import flash.display.DisplayObject;
	
	import model.design.CompositionProxy;
	import model.products.vo.RegionVO;
	
	import mx.events.EffectEvent;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import spark.components.Group;
	import spark.effects.Animate;
	import spark.effects.animation.MotionPath;
	import spark.effects.animation.SimpleMotionPath;
	import spark.effects.easing.Sine;
	
	
	public class ZoomMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ZoomMediator';
		private var currentArea:RegionVO;
		private var _pane:Group;
		private var anim:Animate;
		  
		public function ZoomMediator(viewComponent:Object, pane:Group)  
		{  
			super( NAME, viewComponent );
			_pane = pane;
			
			anim = new Animate();
			anim.addEventListener(EffectEvent.EFFECT_END, onZoomEnd);
			anim.addEventListener(EffectEvent.EFFECT_UPDATE, onZoomUpdate);
		}
		override public function listNotificationInterests():Array  
		{  
			return [
				CompositionProxy.CURRENT_DESIGN_AREA_CHANGED,
				ApplicationConstants.ZOOM_IN,
				ApplicationConstants.ZOOM_OUT,
				ApplicationConstants.ZOOM_TO_AREA,
				ApplicationConstants.STAGE_RESIZE
			];
		}
		  
		override public function handleNotification(notification:INotification):void  
		{  
			var name:String = notification.getName();
			var newScale:Number;
			switch ( name )
			{
				case CompositionProxy.CURRENT_DESIGN_AREA_CHANGED:
					currentArea = notification.getBody() as RegionVO;
					sendNotification(ApplicationConstants.ZOOM_TO_AREA, null, NAME);
					break;
				case ApplicationConstants.ZOOM_IN:
				case ApplicationConstants.ZOOM_OUT:
					var zoomAmount:Number;
					if(name==ApplicationConstants.ZOOM_IN)
					{
						zoomAmount = 1;
					}else
					{
						zoomAmount = -1;
					}
					newScale = compositionContainer.scaleX+zoomAmount*compositionContainer.scaleX/2;
					
					newScale = Math.max(newScale, .1);///minscale .1
					newScale = Math.min(newScale, 6);///maxscale 6
					
					if(newScale != compositionContainer.scaleX)
					{
						setScale(newScale);
					}
					break;
				case ApplicationConstants.ZOOM_TO_AREA:
					var margin:Number = 200;
					//fit by height
					newScale = _pane.height / (currentArea.height+margin);
					if((currentArea.width+margin)*newScale>_pane.width)
					{
						//fit by width
						newScale = _pane.width / (currentArea.width+margin);
					}
					setScale(newScale);
					break;
				case ApplicationConstants.STAGE_RESIZE:
					setScale(compositionContainer.scaleX);
					break;
			}
		}
		private function setScale(scale:Number):void
		{
			if(!currentArea) //currentArea not setted yet
			{
				return;
			}
			var motionPaths:Vector.<MotionPath> = new Vector.<MotionPath>();
			motionPaths.push(new SimpleMotionPath("scaleX",compositionContainer.scaleX, scale));
			motionPaths.push(new SimpleMotionPath("scaleY",compositionContainer.scaleY, scale));
			motionPaths.push(new SimpleMotionPath("y",compositionContainer.y, (_pane.height - currentArea.height*scale)/2 - currentArea.y*scale));
			motionPaths.push(new SimpleMotionPath("x",compositionContainer.x, (_pane.width - currentArea.width*scale)/2 - currentArea.x*scale));
			
			anim.stop();
			anim.easer = new Sine(.3);
			anim.duration = 500;
			anim.target = compositionContainer;
			anim.motionPaths = motionPaths;
			sendNotification(ApplicationConstants.ZOOM_ANIMATION_START, compositionContainer.scaleX, NAME);
			anim.play();
			
			
			///no animation
			/*compositionContainer.scaleX = scale;
			compositionContainer.scaleY = scale;
			compositionContainer.y = (_pane.height - currentArea.height*scale)/2 - currentArea.y*scale;
			compositionContainer.x = (_pane.width - currentArea.width*scale)/2 - currentArea.x*scale;
			sendNotification(ApplicationConstants.ZOOM_CHANGED, compositionContainer.scaleX, NAME);*/
			
		}
		private function onZoomUpdate(event:EffectEvent):void
		{
			sendNotification(ApplicationConstants.ZOOM_CHANGED, compositionContainer.scaleX, NAME);
		}
		private function onZoomEnd(event:EffectEvent):void
		{
			sendNotification(ApplicationConstants.ZOOM_ANIMATION_END, compositionContainer.scaleX, NAME);
			//sendNotification(ApplicationConstants.ZOOM_CHANGED, compositionContainer.scaleX, NAME);
		}
		public function get compositionContainer():DisplayObject
		{
			return viewComponent as DisplayObject;
		}
		
	 }  
}