package model.elements
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.design.vo.DesignColorVO;
	import model.elements.filters.FilterNameEnum;
	import model.elements.filters.FilterVO;
	import model.elements.filters.OutlineVO;
	import model.elements.filters.ShadowVO;
	import model.elements.vo.DesignElementVO;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class DesignElementProxy extends Proxy implements IProxy, ITintableElementProxy, IXMLProxy
	{  
		public static const NAME:String = 'DesignElementProxy';
		public static const ELEMENT_CREATED:String = NAME+'ELEMENT_CREATED';
		public static const UNSCALED_SIZE_CHANGE:String = NAME+'UNSCALED_SIZE_CHANGE';
		public static const POSITION_CHANGE:String = NAME + 'POSITION_CHANGE';
		public static const SIZE_CHANGE:String = NAME + 'SIZE_CHANGE';
		public static const FLIP_CHANGE:String = NAME + 'FLIP_CHANGE';
		public static const ROTATION_CHANGE:String = NAME + 'ROTATION_CHANGE';
		public static const IS_LOCKED_CHANGE:String = NAME + 'IS_LOCKED_CHANGE';
		public static const MAINTAIN_PROPORTION_CHANGE:String = NAME + 'MAINTAIN_PROPORTION_CHANGE';
		public static const FILTER_ADDED:String = NAME + 'FILTER_ADDED';
		
		public function DesignElementProxy(value_object:Object)  
		{  
			super( NAME, value_object  );

		}
		override public function getProxyName():String
		{
			return NAME + vo.uid;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			sendNotification(ApplicationConstants.REGISTER_MEDIATOR,vo,NAME);
		}
		
		public function setPosition(x:Number, y:Number):void
		{	
			vo.x = x;
			vo.y = y;
			sendNotification(POSITION_CHANGE,{x:vo.x, y:vo.y, uid:vo.uid},NAME);
		}
		public function setSize(width:Number, height:Number):void
		{
			vo.width = width;
			vo.height = height;
			
			sendNotification(SIZE_CHANGE,{width:vo.width, height:vo.height, uid:vo.uid},NAME);
		}
		public function setFlip(flipH:Boolean, flipV:Boolean):void
		{
			vo.flipH = flipH;
			vo.flipV = flipV;
			setRotation(vo.rotation*-1);
			
			sendNotification(FLIP_CHANGE,{flipH:vo.flipH, flipV:vo.flipV, uid:vo.uid},NAME);
		}
		public function flipH():void
		{
			vo.flipH = !vo.flipH;
			setRotation(vo.rotation*-1);
			
			sendNotification(FLIP_CHANGE,{flipH:vo.flipH, flipV:vo.flipV, uid:vo.uid},NAME);
		}
		public function flipV():void
		{
			vo.flipV = !vo.flipV;
			setRotation(vo.rotation*-1);
			
			sendNotification(FLIP_CHANGE,{flipH:vo.flipH, flipV:vo.flipV, uid:vo.uid},NAME);
		}
		public function setWidth(newWidth:Number):void
		{
			if(vo.maintainProportions && vo.width>0)
			{
				var scale:Number = newWidth/vo.width;
				vo.width = newWidth;
				vo.height *= scale;
			}else
			{
				vo.width = newWidth;
			}
			sendNotification(SIZE_CHANGE,{width:vo.width, height:vo.height, uid:vo.uid},NAME);
		}
		public function setHeight(newHeight:Number):void
		{
			if(vo.maintainProportions && vo.height>0)
			{
				var scale:Number = newHeight/vo.height;
				vo.height = newHeight;
				vo.width *= scale
			}else
			{
				vo.height = newHeight;
			}
			sendNotification(SIZE_CHANGE,{width:vo.width, height:vo.height, uid:vo.uid},NAME);
		}
		public function setRotation(rotation:Number):void
		{
			vo.rotation = rotation;
			
			sendNotification(ROTATION_CHANGE,{rotation:vo.rotation, uid:vo.uid},NAME);
		}
		public function setLocked(value:Boolean):void
		{
			vo.isLocked = value;
			
			sendNotification(IS_LOCKED_CHANGE,{isLocked:vo.isLocked, uid:vo.uid},NAME);
		}
		public function setMaintainProportions(value:Boolean):void
		{
			vo.maintainProportions = value;
			
			sendNotification(MAINTAIN_PROPORTION_CHANGE,{maintainProportions:vo.maintainProportions, uid:vo.uid},NAME);
		}
		
		
		public function setUnscaledSize(unscaledWidth:Number, unscaledHeight:Number):void
		{
			setUnscaledWidth(unscaledWidth);
			setUnscaledHeight(unscaledHeight);
			
			sendNotification(SIZE_CHANGE,{width:vo.width, height:vo.height, uid:vo.uid},NAME);
		}
		private function setUnscaledWidth(value:Number):void
		{
			if(value<=0)
			{
				trace("invalid unscaled width:",value);
				return;
			}
			if(vo.unscaledWidth>0)
			{
				//keep actual scale
				var newWidthScale:Number = value / vo.unscaledWidth;
				
				vo.unscaledWidth = value;
				
				vo.width = vo.width * newWidthScale;
			}else
			{
				vo.unscaledWidth = value;
				if(vo.width==0)
				{
					vo.width = vo.unscaledWidth;
				}
			}
			
		}
		private function setUnscaledHeight(value:Number):void
		{
			if(value<=0)
			{
				trace("invalid unscaled height:",value);
				return;
			}
			if(vo.unscaledHeight>0)
			{
				//keep actual scale
				var newHeightScale:Number = value / vo.unscaledHeight;
				
				vo.unscaledHeight = value;
				
				vo.height = vo.height * newHeightScale;
			}else
			{
				vo.unscaledHeight = value;
				if(vo.height==0)
				{
					vo.height = vo.unscaledHeight;
				}
			}
			
		}
		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			for each ( var filter:Object in vo.filters )
			{
				var filterProxy:ITintableElementProxy = facade.retrieveProxy(filter.uid) as ITintableElementProxy;
				colors = colors.concat(filterProxy.getColors());
			}
			return colors;
		}

		public function saveToXML():XML {
			var elementXml:XML = <base/>;
			//elementXml.@uid = vo.uid;
			elementXml.@isLocked = vo.isLocked;
			elementXml.@rotation = vo.rotation;
			elementXml.@y = vo.y;
			elementXml.@x = vo.x;
			elementXml.@height = vo.height;
			elementXml.@width = vo.width;
			elementXml.@depth = vo.depth;
			elementXml.@flipV = vo.flipV;
			elementXml.@flipH = vo.flipH;
			elementXml.@unscaledWidth = vo.unscaledWidth;
			elementXml.@unscaledHeight = vo.unscaledHeight;
			elementXml.@maintainProportions = vo.maintainProportions;
			
			var filtersXml:XML = <filters/>;
			for each ( var filter:FilterVO in vo.filters )
			{
				var proxy:IXMLProxy = facade.retrieveProxy(filter.uid) as IXMLProxy;
				filtersXml.appendChild(proxy.saveToXML());
			}
			elementXml.appendChild(filtersXml);
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.depth = int(xml.@depth);
			vo.height = Number(xml.@height);
			vo.width = Number(xml.@width);
			vo.isLocked = xml.@isLocked == "true" ? true : false;
			vo.maintainProportions = xml.@maintainProportions == "true" ? true : false;
			vo.rotation = Number(xml.@rotation);
			//vo.uid = xml.@uid; //si reemplazo el id, el proxy ya quedo registrado con otro id mas arriba
			vo.unscaledHeight = Number(xml.@unscaledHeight);
			vo.unscaledWidth = Number(xml.@unscaledWidth);
			vo.x =  Number(xml.@x);
			vo.y =  Number(xml.@y);
			vo.flipH =  xml.@flipH == "true" ? true : false;
			vo.flipV =  xml.@flipV == "true" ? true : false;
			//filters
			var filterVO:FilterVO;
			var proxy:IXMLProxy;
			for each ( var filterXML:XML in xml.filters.filter )  
			{
				switch(String(filterXML.@name))
				{
					case FilterNameEnum.OUTLINE:
						filterVO = new OutlineVO();
						break;
					case FilterNameEnum.SHADOW:
						filterVO = new ShadowVO();
						break;
				}
				proxy = filterVO.creator.createProxy() as IXMLProxy;
				proxy.loadFromXML(filterXML);
				facade.registerProxy(proxy);
				addFilter(filterVO);
			}
			
		}

		public function addFilter(filter:FilterVO):void
		{
			vo.filters.addItem(filter);
			sendNotification(FILTER_ADDED,{uid:vo.uid, filter_uid:filter.uid},NAME);
		}
		public function getFilterFromUID(filteruid:String):Object
		{
			for each ( var filter:Object in vo.filters )
			{
				if ( filter.uid == filteruid )
					return filter;
			}
			return null;
		}
		
		public function copyProperties(obj:DesignElementVO):void {
			obj.width = vo.width;
			obj.height = vo.height;
			obj.unscaledWidth = vo.unscaledWidth;
			obj.unscaledHeight = vo.unscaledHeight;
			obj.x = vo.x;
			obj.y = vo.y;
			obj.depth = vo.depth;
			obj.rotation = vo.rotation;
			obj.isLocked = vo.isLocked;
			obj.flipV = vo.flipV;
			obj.flipH = vo.flipH;
			obj.maintainProportions = vo.maintainProportions;
			
			for each (var filterVO:FilterVO in vo.filters) 
			{
				var proxy:IClonableProxy = facade.retrieveProxy(filterVO.uid) as IClonableProxy;
				var clone:FilterVO = FilterVO(proxy.getCopy());
				facade.registerProxy(clone.creator.createProxy());
				obj.filters.addItem(clone);
			}

		}
		
		public function get vo():DesignElementVO
		{
			return data as DesignElementVO;
		}
		
	}  
}