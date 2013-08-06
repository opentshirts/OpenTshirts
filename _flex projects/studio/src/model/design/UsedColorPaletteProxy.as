package model.design
{	  
	import model.design.vo.DesignColorVO;
	
	import mx.collections.ArrayCollection;
	
	import org.puremvc.as3.interfaces.IProxy;
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class UsedColorPaletteProxy extends Proxy implements IProxy
	{  
		public static const NAME:String = 'UsedColorsPaletteProxy';
		public static const PALETTE_CHANGE:String = NAME + 'PALETTE_CHANGE';  	  
		private var _uid:String;
		public function UsedColorPaletteProxy(uid:String)
		{  
			_uid = uid;
			super( NAME, new ArrayCollection());
		}
		override public function getProxyName():String
		{
			return NAME + _uid;
		}
		public function get designColors():ArrayCollection
		{
			return data as ArrayCollection;
		}
		public function setColors(colors:Vector.<DesignColorVO>):void
		{
			designColors.removeAll();
			
			for each (var color:DesignColorVO in colors)
			{
				addColor(color)
			}
			sendNotification(PALETTE_CHANGE, this, NAME);
		}
		public function addColor( color:DesignColorVO ):void
		{
			if(!idInArray(color.id) && color.id!=DesignColorVO.WHITEBASE && color.id!=DesignColorVO.PRODUCTCOLOR)
				designColors.addItem( color );
		}
		public function getNeedWhiteBase():Boolean
		{
			//if at least one ink need white base..return true
			for ( var i:int=0; i<designColors.length; i++ )
			{
				if ( DesignColorVO(designColors[i]).need_white_base ) {
					return true;
				}
			}
			return false;
		}
		private function idInArray(id:String):Boolean
		{
			if(getColorFromId(id)!=null)
				return true
			else
				return false;
		}
		public function getColorFromId(id:String):DesignColorVO
		{
			for ( var i:int=0; i<designColors.length; i++ )
			{
				if ( designColors[i].id == id ) {
					return designColors[i];
				}
			}
			return null;
		}

	}  
}