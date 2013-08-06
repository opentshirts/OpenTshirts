package model.design
{	  
	
	import Interfaces.IXMLProxy;
	
	import model.ConfigurationProxy;
	import model.design.vo.CompositionVO;
	import model.design.vo.DesignVO;
	import model.products.ProductProxy;
	import model.products.vo.ProductColorVO;
	import model.products.vo.ProductVO;
	import model.products.vo.RegionVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class CompositionProxy extends Proxy
	{  
		public static const NAME:String = 'CompositionProxy';
		public static const PRODUCT_CHANGED:String = NAME + 'PRODUCT_CHANGED'; 
		public static const PRODUCT_COLOR_CHANGED:String = NAME + 'PRODUCT_COLOR_CHANGED'; 
		public static const NAME_CHANGED:String = NAME + 'NAME_CHANGED'; 
		public static const ID_CHANGED:String = NAME + 'ID_CHANGED'; 
		public static const CURRENT_DESIGN_AREA_CHANGED:String = NAME + 'CURRENT_DESIGN_AREA_CHANGE';
		
		
		public function CompositionProxy()  
		{  
			super( NAME, CompositionVO.getInstance());
		}
		
		
		///product color
		public function set productColor(pc:ProductColorVO):void 
		{
			
			currentProductVO.currentColor = pc;
			//vo.selectedColor = pc;
			sendNotification(PRODUCT_COLOR_CHANGED,pc,NAME);
		}
		public function get productColor():ProductColorVO {
			return currentProductVO.currentColor;
		}
		private function get currentProductVO():ProductVO
		{
			var productProxy:ProductProxy = facade.retrieveProxy(ProductProxy.NAME+productID) as ProductProxy;
			return productProxy.vo;
		}
		//---------------
		
		// product
		public function set productID(p:String):void 
		{
			vo.selectedProductID = p;
			configurationProxy.setParamSession("id_product",p);
			sendNotification(PRODUCT_CHANGED,productID,NAME);
		}
		public function get productID():String {
			return vo.selectedProductID;
		}
		//---------------
		
		// 
		public function setName(value:String):void 
		{
			vo.name = value;
			configurationProxy.setParamSession("name",value);
			sendNotification(NAME_CHANGED,vo.name,NAME);
		}
		public function getName():String {
			return vo.name;
		}
		public function setID(value:String):void 
		{
			vo.id = value;
			configurationProxy.setParamSession("id_composition",value);
			sendNotification(ID_CHANGED,vo.id,NAME);
		}
		public function getID():String {
			return vo.id;
		}
		//---------------
		private function get configurationProxy():ConfigurationProxy
		{
			return facade.retrieveProxy( ConfigurationProxy.NAME ) as ConfigurationProxy;
		}
		// current area
		public function get currentDesignArea():RegionVO
		{
			return vo.currentDesignArea;
		}
		
		public function set currentDesignArea(value:RegionVO):void
		{
			//vo.productOrder.currentDesignArea = value;
			//sendNotification(CURRENT_DESIGN_AREA_CHANGED,vo.productOrder.currentDesignArea,NAME);
			vo.currentDesignArea = value;
			sendNotification(CURRENT_DESIGN_AREA_CHANGED,vo.currentDesignArea,NAME);
		}
		// ------------
		
		public function get vo():CompositionVO {
			return data as CompositionVO;
		}
		
		public function get currentDesignProxy():DesignProxy
		{
			if(!currentDesignArea || !currentDesignArea.view.design)
				return null;
			
			return facade.retrieveProxy(currentDesignArea.view.design.uid) as DesignProxy;
		}
		
		public function addDesign():DesignVO
		{
			//create new vo
			var design:DesignVO = new DesignVO();
			
			//create and register proxy
			var designProxy:DesignProxy = new DesignProxy(design);
			facade.registerProxy(designProxy);
			
			//add to array collection
			vo.designs.addItem(design);
			
			return design;
		}
		public function getDesignIndex(design:DesignVO):int
		{
			return vo.designs.getItemIndex(design);
		}

		/*public function getDesignsToXML():Vector.<XML> {
			var vector:Vector.<XML> = new Vector.<XML>();
			for (var i:uint=0; i<vo.designs.length; i++) {
				var proxy:IXMLProxy = facade.retrieveProxy(vo.designs[i].uid) as IXMLProxy;
				vector.push(proxy.saveToXML());
			}
			return vector;
		}*/
		
		public function saveToXML():XML 
		{
			var elementXml:XML = <composition/>;
			elementXml.@id_product = vo.selectedProductID;
			elementXml.@id_composition = vo.id;
			elementXml.@id_product_color = currentProductVO.currentColor.id;
			elementXml.@name = vo.name;
			
			for (var i:uint=0; i<vo.designs.length; i++) {
				if(DesignVO(vo.designs[i]).elements.length>0)
				{
					var proxy:IXMLProxy = facade.retrieveProxy(vo.designs[i].uid) as IXMLProxy;
					elementXml.appendChild(proxy.saveToXML())
				}
			}
			return elementXml;
		}
		/*public function restoreSavedComposition(id_product:uint,id_product_color:uint, name:String, designs:Array):void 
		{
			setName(name);
			
			
			
			var productColorListProxy:ProductColorListProxy = facade.retrieveProxy(ProductColorListProxy.NAME) as productColorListProxy;
			productColor = productColorListProxy.getItemFromId(id_product_color);
			
			
			var designProxy:IXMLProxy;
			for(var i:uint=0; i< designs.length; i++)
			{
				var designXML:XML = new XML( designs[i] );
				var design:DesignVO;
				if(vo.designs.length>i)
				{
					design = vo.designs[i];
					
				}else
				{
					design = addDesign();
				}
				designProxy = facade.retrieveProxy(design.uid) as IXMLProxy;
				designProxy.loadFromXML(designXML);
			}
		}*/
		
		
	}  
}