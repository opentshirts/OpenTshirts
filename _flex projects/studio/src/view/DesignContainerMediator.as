package view
{
	
	import Interfaces.IDesignElementMediator;
	
	import appFacade.ApplicationConstants;
	
	import com.adobe.images.PNGEncoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.LineScaleMode;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import model.design.CompositionProxy;
	import model.design.DesignProxy;
	import model.products.vo.RegionVO;
	import model.products.vo.ViewVO;
	
	import org.puremvc.as3.interfaces.IMediator;
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	import spark.components.Group;
	import spark.components.Image;
	import spark.core.SpriteVisualElement;

	  
	public class DesignContainerMediator extends Mediator implements IMediator  
	{  
		public static const NAME:String = 'DesignContainerMediator';
		
		private var _designContainer:ViewVO;
		private var _currentDesignArea:RegionVO;
		private var _active:Boolean = false;
		private var mask_loader:Loader = new Loader();
		private var mask_image:Bitmap;
		private var mask_image_area:Bitmap;
		
		private var _ohMediator:ObjectHandlesMediator;
		protected var _designElementsAndHandlersContainer:Group;
		protected var _mask:SpriteVisualElement;
		protected var _validArea:SpriteVisualElement;
		//protected var _invalidArea:SpriteVisualElement;
		protected var _designElementsContainer:Group;
		protected var _handlersContainer:Group;
		protected var designAreaRect:SpriteVisualElement;
		
		/**
		 * Este mediador crea los elementos contenedores para el
		 * rectangulo del area, los elementos de diseño y los handles.
		 * Dibuja el rectangulo del area actual
		 * y administra la adicion y eliminacion de designElements
		 * tambien registra el mediador para los handles de este design
		 * y registra/unregistra componentes para object handles
		 * */
		public function DesignContainerMediator(viewComponent:Object,designContainer:ViewVO)  
		{  
			super( NAME, viewComponent );
			
			_designContainer = designContainer;	
			
			addChilds();

			
			
		}
		private function addChilds():void
		{
			designAreaRect = new SpriteVisualElement();
			
			_validArea = new SpriteVisualElement();
			//_invalidArea = new SpriteVisualElement();
			_validArea.alpha = 0;
			_validArea.blendMode = BlendMode.INVERT;
			designContainerComponent.addEventListener(MouseEvent.MOUSE_OVER, onAreaOver);
			designContainerComponent.addEventListener(MouseEvent.MOUSE_OUT, onAreaOut);
			designAreaRect.addChild(_validArea);
			//designAreaRect.addChild(_invalidArea);
			
			designContainerComponent.addElement(designAreaRect);
			
			_designElementsAndHandlersContainer = new Group();
			_designElementsContainer = new Group();
			_handlersContainer = new Group();
			_designElementsAndHandlersContainer.addElement(_designElementsContainer);
			_designElementsAndHandlersContainer.addElement(_handlersContainer);
			
			designContainerComponent.addElement(_designElementsAndHandlersContainer);
			

			_mask = new SpriteVisualElement();
			_designElementsContainer.mask = _mask;
		}
		override public function onRegister():void
		{
			super.onRegister();
			_ohMediator = new ObjectHandlesMediator(_handlersContainer, _designContainer.uid );
			facade.registerMediator( _ohMediator);
			
			if(_designContainer.design.elements.length>0)
			{
				addDesignElements();
			}
			
			/*if(_designContainer.design.currentRegion)
			{				
				var regProxy:RegionProxy = facade.retrieveProxy(RegionProxy.NAME+_designContainer.design.currentRegion) as RegionProxy;
				setDesignArea(regProxy.vo);
			}*/
			
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			removeElements();
			
			facade.removeMediator( _ohMediator.getMediatorName());	
			
		}
		override public function getMediatorName():String
		{
			return NAME+_designContainer.uid;
		}
		private function onAreaOver(event:MouseEvent):void
		{
			_validArea.alpha = .4;
		}
		private function onAreaOut(event:MouseEvent):void
		{
			_validArea.alpha = 0;
		}
		
		public function getDesignArea():RegionVO
		{
			return _currentDesignArea;
		}

		public function setDesignArea(value:RegionVO):void
		{

			_currentDesignArea = value;
			
			designContainerComponent.x = _currentDesignArea.x;
			designContainerComponent.y = _currentDesignArea.y;
			
			//clear container
			while (_mask.numChildren>0) _mask.removeChildAt(0);
			while (_validArea.numChildren>0) _validArea.removeChildAt(0);
			if(_currentDesignArea.mask_url!="") {
				loadMaskImage(_currentDesignArea.mask_url);
			}
			
			drawArea();
			
		}


		public function get designContainerComponent():Group
		{
			return viewComponent as Group;
		}
		
		public function get designElementsAndHandlersContainer():Group
		{
			return _designElementsAndHandlersContainer;
		}

		/**
		 * Remove and unregister all visual elements and mediators registered for previous design model.
		 * Must be called before set new model
		 * */
		private function removeElements():void
		{
			//get old designArea's designs element
			for each(var uid:String in _designContainer.design.elements )
			{
				removeElement(uid);
			}
		}

		private function addElement(uid:String):void
		{
			//get element mediator from id
			var mediator:IDesignElementMediator = facade.retrieveMediator(uid) as IDesignElementMediator;
			//register for handles
			sendNotification(ApplicationConstants.OH_REGISTER_ELEMENT, {model:mediator.designElementVO, viewComponent:mediator.designElementBase, ohUID:_designContainer.uid}, NAME);
			//add to displayList
			_designElementsContainer.addElementAt(mediator.designElementBase,mediator.designElementVO.depth);
		}

		private function removeElement(uid:String):void
		{
			//get element mediator from id
			var mediator:IDesignElementMediator = facade.retrieveMediator(uid) as IDesignElementMediator;
			
			//remove from Object Handlers Component
			sendNotification(ApplicationConstants.OH_UNREGISTER_ELEMENT, {uid:uid}, NAME);
			
			try
			{
				//remove from displayList
				_designElementsContainer.removeElement(mediator.designElementBase);
			} 
			catch(error:Error) 
			{
				trace(error.message)
			}
		}
		public function clearForSnapshot():void
		{
			_ohMediator.clearSelection();
			_validArea.alpha = 0;
		}
		public function getSnapshot():ByteArray
		{
			//hide selection before take snapshot
			clearForSnapshot();

			/**
			* In AIR 1.5 and Flash Player 10, the maximum size for a BitmapData object is 8,191 pixels in width or height, 
			* and the total number of pixels cannot exceed 16,777,215 pixels. (So, if a BitmapData object is 8,191 pixels wide, 
			* it can only be 2,048 pixels high.) In Flash Player 9 and earlier and AIR 1.1 and earlier, the limitation is 
			* 2,880 pixels in height and 2,880 in width.
			**/
			var mat:Matrix = new Matrix();
			var scale:Number = 3;
			mat.scale(scale,scale);
			var w:Number = _currentDesignArea.width * scale;
			var h:Number = _currentDesignArea.height * scale;
			
			var source:BitmapData = new BitmapData(w, h,true,0x00FFFFFF);//alpha cero
			
			source.draw(designElementsContainer.parent,mat,null,null,null,true);
			

			var stream:ByteArray = PNGEncoder.encode(source);
			return stream;
		}
		/**
		 * draw rectangle for printable area
		 * */
		private function drawArea():void
		{
			designContainerComponent.x = _currentDesignArea.x;
			designContainerComponent.y = _currentDesignArea.y;
			
			
			
			if(mask_image && mask_image_area) {
				_validArea.graphics.clear();
				_mask.graphics.clear();
				mask_image.width = _currentDesignArea.width;
				mask_image.height = _currentDesignArea.height;
				mask_image_area.width = _currentDesignArea.width;
				mask_image_area.height = _currentDesignArea.height;
				
			} else {
				
				//fill validArea
				_validArea.graphics.clear();
				_validArea.graphics.beginFill(0xFFFFFF, .5);
				_validArea.graphics.lineStyle(2,0xFFFFFF,1,false,LineScaleMode.NORMAL);
				_validArea.graphics.drawRect(
				0, 
				0, 
				_currentDesignArea.width, 
				_currentDesignArea.height);
				_validArea.graphics.endFill();
				
				//fill mask
				_mask.graphics.clear();
				_mask.graphics.beginFill(0xFFFFFF, 1);
				_mask.graphics.drawRect(
				0, 
				0, 
				_currentDesignArea.width, 
				_currentDesignArea.height);
				_mask.graphics.endFill();
				
			}
			
			
			
		}
		
		private function loadMaskImage(url:String):void {
			mask_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, maskLoaderComplete);
			mask_loader.load(new URLRequest(url));
		}
		private function maskLoaderComplete(event:Event):void
		{
			mask_image = mask_loader.content as Bitmap;
			_mask.addChild(mask_image);
			//mask_image.cacheAsBitmap = true;
			_mask.cacheAsBitmap = true;
			_designElementsContainer.cacheAsBitmap = true;
			
			var bd:BitmapData = mask_image.bitmapData;
			mask_image_area = new Bitmap(bd);
			_validArea.addChild(mask_image_area);
			drawArea();
		}
		
		/**
		 * draw all design model's elements
		 * */
		private function addDesignElements():void
		{
			for each(var uid:String in _designContainer.design.elements )
			{
				addElement(uid);
				
			}
		}
		private function containsElement(element_uid:String):Boolean
		{
			for each(var uid:String in _designContainer.design.elements )
			{
				if(uid==element_uid)
				{
					return true;
				}
			}
			return false;
		}
		//--------------------------------------------------------------------------
		//
		//  IMediator
		//
		//--------------------------------------------------------------------------
		override public function listNotificationInterests():Array  
		{
				return [ 
					ApplicationConstants.REMOVE_SELECTED_ELEMENT,
					DesignProxy.DESIGN_ELEMENT_ADDED,
					DesignProxy.DESIGN_ELEMENT_REMOVED,
					DesignProxy.DESIGN_ORDER_CHANGE,
					CompositionProxy.CURRENT_DESIGN_AREA_CHANGED
				];  
		}
		  
		override public function handleNotification(note:INotification):void
		{
			var element_uid:String;
			var design_uid:String;
			
			switch ( note.getName() )
			{
				case ApplicationConstants.REMOVE_SELECTED_ELEMENT:
					element_uid = note.getBody() as String;
					if(containsElement(element_uid))
					{
						sendNotification(ApplicationConstants.REMOVE_ELEMENT_FROM_DESIGN, {element_uid:element_uid, design_uid:_designContainer.design.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
					}
					break;
				case DesignProxy.DESIGN_ELEMENT_ADDED:
					design_uid = note.getBody().design_uid;
					if(design_uid==_designContainer.design.uid)
					{
						element_uid = note.getBody().element_uid;
						addElement(element_uid);
					}
					break;
				case DesignProxy.DESIGN_ELEMENT_REMOVED:
					design_uid = note.getBody().design_uid;
					if(design_uid==_designContainer.design.uid)
					{
						element_uid = note.getBody().element_uid;
						removeElement(element_uid);
					}
					break;
				case DesignProxy.DESIGN_ORDER_CHANGE:
					design_uid = note.getBody().design_uid;
					if(design_uid==_designContainer.design.uid)
					{
						var mediator:IDesignElementMediator = facade.retrieveMediator(note.getBody().uid) as IDesignElementMediator;
						_designElementsContainer.setElementIndex(mediator.designElementBase,note.getBody().index);
					}
					break;
				case CompositionProxy.CURRENT_DESIGN_AREA_CHANGED:
					var designArea:RegionVO = note.getBody() as RegionVO;
					active = (_designContainer==designArea.view);
					if(_active)
					{
						setDesignArea(designArea);
					}
					break;
			}
		}
		
		
		private function set active(value:Boolean):void
		{
			if(value)
			{
				activate();
			}else
			{
				deactivate();
			}
		}
		
		private function deactivate():void
		{
			_active = false;
			//designContainerComponent.visible = false;
			//facade.removeMediator(_ohMediator.getMediatorName());
			_ohMediator.active = false;
			//removeElements();
			//sendNotification(ApplicationConstants.CLEAR_SELECTION, null, NAME);
		}
		private function activate():void
		{
			_active = true;
			//redrawDesign();
			//designContainerComponent.visible = true;
			//facade.registerMediator(_ohMediator);
			_ohMediator.active = true;
		}

		public function get designElementsContainer():Group
		{
			return _designElementsContainer;
		}

		
	 }  
}