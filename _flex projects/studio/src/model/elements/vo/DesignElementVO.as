package model.elements.vo
{
	
	import Interfaces.IIdentifiable;
	
	import com.roguedevelopment.objecthandles.ILockable;
	import com.roguedevelopment.objecthandles.IMoveable;
	import com.roguedevelopment.objecthandles.IResizeable;
	
	import factory.ICreator;
	
	import flash.events.EventDispatcher;
	
	import mx.collections.ArrayCollection;
	import mx.utils.UIDUtil;
	
	/**
	 * Base class for objects that can be part of a design
	 * */
	//ABSTRACT CLASS
	public class DesignElementVO extends EventDispatcher implements IResizeable, IMoveable, ILockable, IIdentifiable
	{
		private var _width:Number = 0;
		private var _height:Number = 0;
		private var _unscaledWidth:Number=0;
		private var _unscaledHeight:Number=0;
		private var _x:Number = 0;
		private var _y:Number = 0;
		private var _depth:int = -1;
		private var _rotation:Number = 0;
		private var _isLocked:Boolean = false;
		private var _flipV:Boolean = false;
		private var _flipH:Boolean = false;
		private var _maintainProportions:Boolean = false;
		private var _filters:ArrayCollection = new ArrayCollection();
		
		protected var _creator:ICreator;
		
		private var _uid:String;
		
		public function DesignElementVO()
		{
			super();
			uid = UIDUtil.createUID();
		}
		public function get creator():ICreator
		{
			return _creator;
		}
		public function get uid():String
		{
			return _uid;
		}
		
		public function set uid(value:String):void
		{
			_uid = value;
		}

		public function get isLocked():Boolean
		{
			return _isLocked;
		}
		
		public function set isLocked(value:Boolean):void
		{
			_isLocked = value;
		}

		public function get rotation():Number
		{
			return _rotation;
		}

		public function set rotation(value:Number):void
		{
			_rotation = value;
		}

		public function get y():Number
		{
			return _y;
		}

		public function set y(value:Number):void
		{
			_y = value;
		}

		public function get x():Number
		{
			return _x;
		}

		public function set x(value:Number):void
		{
			_x = value;
		}

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;	
		}

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		public function get unscaledWidth():Number
		{
			return _unscaledWidth;
		}

		public function set unscaledWidth(value:Number):void
		{
			_unscaledWidth = value;
		}

		public function get unscaledHeight():Number
		{
			return _unscaledHeight;
		}

		public function set unscaledHeight(value:Number):void
		{
			_unscaledHeight = value;
		}

		public function get maintainProportions():Boolean
		{
			return _maintainProportions;
		}

		public function set maintainProportions(value:Boolean):void
		{
			_maintainProportions = value;
		}

		//[Bindable]
		public function get filters():ArrayCollection
		{
			return _filters;
		}

		public function set filters(value:ArrayCollection):void
		{
			_filters = value;
		}

		public function get depth():int
		{
			return _depth;
		}

		public function set depth(value:int):void
		{
			_depth = value;
		}

		public function get flipV():Boolean
		{
			return _flipV;
		}

		public function set flipV(value:Boolean):void
		{
			_flipV = value;
		}

		public function get flipH():Boolean
		{
			return _flipH;
		}

		public function set flipH(value:Boolean):void
		{
			_flipH = value;
		}

		
	}
}