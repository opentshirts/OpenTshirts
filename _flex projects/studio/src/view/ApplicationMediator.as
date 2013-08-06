package view
{
	import appFacade.ApplicationConstants;
	
	import com.roguedevelopment.objecthandles.IHandle;
	
	import components.AppLayout;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Shape;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	
	import model.design.CompositionProxy;
	
	import mx.controls.Alert;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.CommandsHistoryProxy;
	

	public class ApplicationMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'ApplicationMediator';
		 
		private var commandHistoryProxy:CommandsHistoryProxy;
		
		public function ApplicationMediator(viewComponent:Object=null)  
		{  
			super( NAME, viewComponent );
		}
		
		override public function onRegister():void
		{
			commandHistoryProxy = facade.retrieveProxy( CommandsHistoryProxy.NAME ) as CommandsHistoryProxy;
			
			if(app.stage) 
			{
				onAddedToStage();
			}else{
				app.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
		}
		override public function listNotificationInterests():Array  
		{
			return [ 
				ApplicationConstants.APP_CLICK,
				ApplicationConstants.SHOW_MSG,
				ApplicationConstants.MOUSE_WHEEL
			];  
		}
		  
		override public function handleNotification(note:INotification):void
		{
			switch ( note.getName() )
			{
				case ApplicationConstants.APP_CLICK:
					///we've to find a better way to deal with deselection
					var event:MouseEvent = note.getBody() as MouseEvent;
					if(app.controls.contains(event.target as DisplayObject)) return; //if click on controls dont clear selection
					//if(app.topBar.contains(event.target as DisplayObject)) return; //if click on topbar dont clear selection
					//if(event.target is SwatchSkin || event.target.parent is SystemManager) return; //if click on colorpicker dont clear selection
					if(event.target is IHandle) return; //if click on object handles dont clear selection
					
					if(currentDesignAreaMediator)
					{
						if(DisplayObjectContainer(currentDesignAreaMediator.designElementsAndHandlersContainer).contains(event.target as DisplayObject)) return;
					}
					if(!app.contains(event.target as DisplayObject)) return;
					
					sendNotification(ApplicationConstants.CLEAR_SELECTION,null, NAME);
					break;
				case ApplicationConstants.SHOW_MSG:
					Alert.show(note.getBody().msg);
					break;
				case ApplicationConstants.MOUSE_WHEEL:
					handleWheel(note.getBody());
					break;
			}
		}
		private function handleWheel(event:Object): void {
			
			var obj:InteractiveObject = null;
			var objects:Array = app.stage.getObjectsUnderPoint(new Point(event.x, event.y));
			for (var i:int = objects.length - 1; i >= 0; i--) {
				if (objects[i] is InteractiveObject) {
					obj = objects[i] as InteractiveObject;
					break;
				} else {
					if (objects[i] is Shape && (objects[i] as Shape).parent) {
						obj = (objects[i] as Shape).parent;
						break;
					}
				}
			}
			if (obj) {
				var mEvent:MouseEvent = new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false,
					event.x, event.y, obj,
					event.ctrlKey, event.altKey, event.shiftKey,
					false, -Number(event.delta));
				obj.dispatchEvent(mEvent);
			}
		}
		private function onAddedToStage( event:Event=null ):void
		{
			app.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			app.stage.align = StageAlign.TOP_LEFT;
			app.stage.scaleMode = StageScaleMode.NO_SCALE;
			app.stage.addEventListener(Event.RESIZE, resizeHandler);
			
			
			app.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp );
			app.stage.addEventListener(MouseEvent.CLICK,onClick);
			app.compositionPane.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			
			
			layout();
		}
		private function resizeHandler(e:Event=null):void
		{
			layout();
			
			sendNotification(ApplicationConstants.STAGE_RESIZE, null, NAME);
		}
		private function layout():void
		{
			var paneMargin:uint = 0;
			app.compositionPane.width = app.stage.stageWidth - paneMargin - 400;
			app.compositionPane.height = app.stage.stageHeight - paneMargin;
			app.compositionPane.y = paneMargin/2;
			app.compositionPane.x = paneMargin/2;
			
			
			var controlMargin:Number = 10;
			app.controls.width = app.stage.stageWidth-controlMargin;
			app.controls.height = app.stage.stageHeight - controlMargin;
			app.controls.y = controlMargin*.5;
			app.controls.x = controlMargin*.5;
		}
		private function onKeyUp( event:KeyboardEvent ):void
		{
			//undo
			if ( event.ctrlKey && event.keyCode == Keyboard.Z)
			{
				if ( commandHistoryProxy.canUndo ) 
					commandHistoryProxy.getPrevious().undo();
			}
			//redo
			if ( event.ctrlKey && event.keyCode == Keyboard.Y )
			{
				if ( commandHistoryProxy.canRedo )
					commandHistoryProxy.getNext().redo();
			}
			//deselect
			if ( event.ctrlKey && event.keyCode == Keyboard.D )
			{
				sendNotification(ApplicationConstants.CLEAR_SELECTION,null, NAME);
			}
			//select all
			if ( event.ctrlKey && event.keyCode == Keyboard.A )
			{
				sendNotification(ApplicationConstants.SELECT_ALL,null, NAME);
			}
			if ( event.ctrlKey && event.keyCode == Keyboard.C )
			{
				sendNotification(ApplicationConstants.SHORCUT_COPY,null, NAME);
			}
			if ( event.ctrlKey && event.keyCode == Keyboard.V )
			{
				sendNotification(ApplicationConstants.SHORCUT_PASTE,null, NAME);
			}
			if ( event.ctrlKey && event.keyCode == Keyboard.X )
			{
				sendNotification(ApplicationConstants.SHORCUT_CUT,null, NAME);
			}
			//delete
			if (event.keyCode== Keyboard.DELETE )
			{
				sendNotification(ApplicationConstants.SHORTCUT_DELETE_KEY_PRESSED,event, NAME);
			}
			//ALIGN CENTER HORIZONTAL
			if ( !event.ctrlKey &&  event.keyCode == Keyboard.C )
			{
				sendNotification(ApplicationConstants.SHORTCUT_ALIGN_TO_CENTER_H,event, NAME);
			}
			//ALIGN CENTER VERTICAL
			if ( event.keyCode == Keyboard.E )
			{
				sendNotification(ApplicationConstants.SHORTCUT_ALIGN_TO_CENTER_V,event, NAME);
			}
			//MAXIMIZE ELEMENT TO AREA SIZE
			if ( event.keyCode == Keyboard.M )
			{
				sendNotification(ApplicationConstants.SHORTCUT_MAXIMIZE_ELEMENT,event, NAME);
			}	
			//FLIP ELEMENT HORIZONTALLY
			if ( event.keyCode == Keyboard.H )
			{
				sendNotification(ApplicationConstants.SHORTCUT_FLIP_H_ELEMENT,event, NAME);
			}	
			//FLIP ELEMENT VERTICALLY
			if ( !event.ctrlKey &&  event.keyCode == Keyboard.V )
			{
				sendNotification(ApplicationConstants.SHORTCUT_FLIP_V_ELEMENT,event, NAME);
			}	
			//ALIGN RIGHT
			if ( event.keyCode == Keyboard.NUMPAD_6 )
			{
				sendNotification(ApplicationConstants.SHORTCUT_ALIGN_TO_RIGHT,event, NAME);
			}	
			//ALIGN LEFT
			if ( event.keyCode == Keyboard.NUMPAD_4 )
			{
				sendNotification(ApplicationConstants.SHORTCUT_ALIGN_TO_LEFT,event, NAME);
			}	
			//ALIGN TOP
			if ( event.keyCode == Keyboard.NUMPAD_8 )
			{
				sendNotification(ApplicationConstants.SHORTCUT_ALIGN_TO_TOP,event, NAME);
			}	
			//ALIGN BOTTOM
			if ( event.keyCode == Keyboard.NUMPAD_2 )
			{
				sendNotification(ApplicationConstants.SHORTCUT_ALIGN_TO_BOTTOM,event, NAME);
			}
			//ZOOM IN
			if ( event.keyCode == Keyboard.NUMPAD_ADD )
			{
				sendNotification(ApplicationConstants.ZOOM_IN, .2, NAME);
			}
			//ZOOM OUT
			if ( event.keyCode == Keyboard.NUMPAD_DIVIDE )
			{
				sendNotification(ApplicationConstants.ZOOM_OUT, -.2, NAME);
			}
			//ZOOM AREA
			if ( event.keyCode == Keyboard.NUMPAD_MULTIPLY )
			{
				sendNotification(ApplicationConstants.ZOOM_TO_AREA, null, NAME);
			}
			//ZOOM AREA
			if ( event.ctrlKey &&  event.keyCode == Keyboard.NUMPAD_MULTIPLY )
			{
				sendNotification(ApplicationConstants.DUPLICATE_DESIGN, null, NAME);
			}
			
		}
		
		private function onClick(event:MouseEvent):void
		{
			sendNotification(ApplicationConstants.APP_CLICK,event, NAME);
		}
		
		private function onMouseWheel(event:MouseEvent):void
		{
			var zoomAmount:Number = Math.abs(event.delta/10);

			if(event.delta>0)  //zoom in
			{
				sendNotification(ApplicationConstants.ZOOM_IN,zoomAmount,NAME);
			}else if(event.delta<0)  //zoom out
			{
				sendNotification(ApplicationConstants.ZOOM_OUT,-zoomAmount,NAME);
			}
		}
		private function get currentProductMediator():CurrentProductMediator
		{
			return facade.retrieveMediator(CurrentProductMediator.NAME) as CurrentProductMediator; 
		}
		private function get currentDesignAreaMediator():DesignContainerMediator
		{
			try 
			{
				return facade.retrieveMediator(DesignContainerMediator.NAME+CompositionProxy(facade.retrieveProxy(CompositionProxy.NAME)).currentDesignArea.view.uid) as DesignContainerMediator;
			}
			catch (errObject:Error) {
				trace("An error occurred: " + errObject.message);
			}	
			return null; 
		}
		public function get app():AppLayout
		{
			return viewComponent as AppLayout;
		}
	}  
}