package model.design
{	  
	
	import Interfaces.IDesignElement;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import appFacade.ApplicationConstants;
	
	import model.design.vo.DesignColorVO;
	import model.design.vo.DesignVO;
	import model.elements.DesignElementProxy;
	import model.elements.DesignElementType;
	import model.elements.bitmap.vo.BitmapVO;
	import model.elements.cliparts.ClipartColorStateEnum;
	import model.elements.cliparts.ClipartProxy;
	import model.elements.cliparts.vo.ClipartVO;
	import model.elements.text.vo.TextVO;
	import model.elements.vo.DesignElementVO;
	import model.products.vo.RegionVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;
	
	public class DesignProxy extends Proxy implements IXMLProxy, ITintableElementProxy
	{  
		public static const NAME:String = 'DesignProxy';
		
		public static const DESIGN_ELEMENT_ADDED:String	= NAME  + " DESIGN_ELEMENT_ADDED";
		public static const DESIGN_ELEMENT_REMOVED:String	= NAME  + " DESIGN_ELEMENT_REMOVED";
		public static const DESIGN_ORDER_CHANGE:String = NAME  + " DESIGN_ORDER_CHANGE";
		
		private var usedColorListProxy:UsedColorPaletteProxy
		
		public function DesignProxy(vo:DesignVO)  
		{  
			super( NAME, vo);
		}
		
		override public function onRegister():void
		{
			usedColorListProxy = new UsedColorPaletteProxy(vo.uid);
			facade.registerProxy(usedColorListProxy);
		}
		
		override public function getProxyName():String
		{
			return vo.uid;
		}
		
		/**
		 * Adds a design element in this design and send a notification to be able to update the view 
		 * @param designElementVO
		 */
		public function addDesignElement(uid:String):void
		{
			//add to the end of the list
			addDesignElementAt(uid, vo.elements.length);
		}
		public function addDesignElementAt(uid:String, index:int):void
		{
			vo.elements.addItemAt(uid,index);
			updateDepthElements();
			
			sendNotification( DESIGN_ELEMENT_ADDED, {element_uid:uid, design_uid:vo.uid} );
		}
		private function updateDepthElements():void
		{
			for (var i:int=0; i<vo.elements.length; i++)
			{
				var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+vo.elements[i]) as DesignElementProxy;
				var element:DesignElementVO = proxy.vo;
				element.depth = i;
			}

		}
		/**
		 * Removes the design element having the given uid 
		 * @param uid The uid of the design Element
		 * 
		 */
		public function removeDesignElement ( uid:String ):void
		{
			if ( vo.elements.contains(uid) )
			{
				vo.elements.removeItemAt( vo.elements.getItemIndex( uid ) );
				updateDepthElements();
				sendNotification( DESIGN_ELEMENT_REMOVED, {element_uid:uid, design_uid:vo.uid} );
			}else
			{
				throw new Error("trying to remove a non existing element");
			}
		} 
		public function clear():void
		{
			for each ( var uid:String in vo.elements )
			{
				removeDesignElement(uid);
			}
		} 
		
		public function setElementIndex(elementuid:String, index:uint):void
		{
			if(index<0 || index>=vo.elements.length)
			{
				trace("index out of range");
				return;
			}
			var targetObj:Object = vo.elements.getItemAt(index);
			var elementIndex:int = vo.elements.getItemIndex( elementuid );
			if(elementIndex==index) return;
			
			vo.elements.removeItemAt(elementIndex);
			vo.elements.addItemAt(elementuid,index);
			updateDepthElements();
			sendNotification(DESIGN_ORDER_CHANGE,{uid:elementuid, index:index, design_uid:vo.uid},NAME);
		}
		
		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			for each ( var uid:String in vo.elements )
			{
				var designElementProxy:ITintableElementProxy = facade.retrieveProxy(uid) as ITintableElementProxy;
				colors = colors.concat(designElementProxy.getColors());
			}
			return colors;
		}
		public function setLocation(loc:RegionVO):void
		{
			vo.currentLocation = loc;			
		}
		public function getElements():ArrayCollection
		{
			return vo.elements;			
		}
		public function fitElements(newWidth:Number, newHeight:Number):void
		{
			if(vo.currentAreaWidth>0 && vo.currentAreaHeight>0 && (vo.currentAreaWidth!=newWidth || vo.currentAreaHeight!=newHeight))
			{
				var newXScale:Number = newWidth/vo.currentAreaWidth;
				var newYScale:Number = newHeight/vo.currentAreaHeight;
				
				var scale:Number;
				var x:Number;
				var y:Number;
				if(newXScale>=1 && newYScale>=1)
				{
					//rellenar
					scale = Math.max(newXScale,newYScale);
					x = Math.floor((newWidth - vo.currentAreaWidth * scale) * .5); //0=left | .5=center | 1=right 
					y = Math.floor((newHeight - vo.currentAreaHeight * scale) * .5); //0=top | .5=middle | 1=bottom 
					
				}else //ajustar
				{
					//ajustar
					scale = Math.min(newXScale,newYScale);
					x = Math.floor((newWidth - vo.currentAreaWidth * scale) * .5); //0=left | .5=center | 1=right 
					y = Math.floor((newHeight - vo.currentAreaHeight * scale) * .5); //0=top | .5=middle | 1=bottom 
				}
				
				//adjust element to fit in new area
				for each(var uid:String in vo.elements )
				{
					var proxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+uid) as DesignElementProxy;
					proxy.setSize(proxy.vo.width*scale, proxy.vo.height*scale);
					proxy.setPosition(x+proxy.vo.x*scale,y+proxy.vo.y*scale);
				}
			}
			vo.currentAreaWidth = newWidth;
			vo.currentAreaHeight = newHeight;
		}
		
		public function saveToXML():XML {
			var elementXml:XML = <design/>;
			//elementXml.@uid = vo.uid;
			
			/*var regProxy:RegionProxy = facade.retrieveProxy(RegionProxy.NAME+designArea.designContainer.design.currentDesignAreaID) as RegionProxy;
			var oldArea:RegionVO = regProxy.vo;*/
			var compProxy:CompositionProxy = facade.retrieveProxy(CompositionProxy.NAME) as CompositionProxy;
			var index:int = compProxy.getDesignIndex(vo);
			
			elementXml.@viewIndex = index;
			elementXml.@currentAreaWidth = vo.currentAreaWidth;
			elementXml.@currentAreaHeight = vo.currentAreaHeight;
			
			for each ( var uid:String in vo.elements )
			{
				var proxy:IXMLProxy = facade.retrieveProxy(uid) as IXMLProxy;
				elementXml.appendChild(proxy.saveToXML())
			}
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			var el:IDesignElement;
			var elProxy:IXMLProxy;
			
			vo.currentAreaWidth = xml.@currentAreaWidth;
			vo.currentAreaHeight = xml.@currentAreaHeight;

			for each ( var elementXML:XML in xml.design_element )  
			{
				switch(String(elementXML.@type))
				{
					case DesignElementType.TEXT:
						el = new TextVO();
						break;
					case DesignElementType.CLIPART:
						el = new ClipartVO();
						break;
					case DesignElementType.BITMAP:
						el = new BitmapVO();
						break;
				}
				elProxy = el.creator.createProxy() as IXMLProxy;
				elProxy.loadFromXML(elementXML);
				facade.registerProxy(elProxy);
				sendNotification(ApplicationConstants.ADD_ELEMENT_TO_DESIGN, {element_uid:el.uid, design_uid:vo.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);
			}
			
			updateUsedColors();
		}
		public function hasClipartFullColor():Boolean
		{
			for each ( var uid:String in vo.elements )
			{
				var clipartProxy:ClipartProxy = facade.retrieveProxy(uid) as ClipartProxy;
				if(clipartProxy)
				{
					if(clipartProxy.getColorState()==ClipartColorStateEnum.FULL_COLOR)
					{
						return true;
					}
				}
				
			}
			return false;
		}
		public function updateUsedColors():void
		{
			usedColorListProxy.setColors(getColors());
		}
		public function get vo():DesignVO
		{
			return this.data as DesignVO;
		}
		
	}  
}