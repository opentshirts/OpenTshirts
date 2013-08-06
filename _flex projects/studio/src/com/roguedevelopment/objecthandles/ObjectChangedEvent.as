package com.roguedevelopment.objecthandles
{
   import flash.events.Event;

   public class ObjectChangedEvent extends Event
   {

	   public static const OBJECT_REMOVED:String = "objectRemoved";
	   public static const OBJECT_MOVED:String = "objectMoved";
       public static const OBJECT_RESIZED:String = "objectResized";
       public static const OBJECT_ROTATED:String = "objectRotated";

	   public static const OBJECT_MOVING:String = "objectMoving";
	   public static const OBJECT_RESIZING:String = "objectResizing";
	   public static const OBJECT_ROTATING:String = "objectRotating";

       /**
       * An array of objects that were moved/resized or rotated.
       **/
       public var relatedObjects:Array;

       public function ObjectChangedEvent(relatedObjects:Array, type:String,bubbles:Boolean=false, cancelable:Boolean=false)
       {
           super(type, bubbles, cancelable);
           this.relatedObjects = relatedObjects;
       }
       
       public function set type(val:String):void
       {
       	 this.type = val;
       }

   }
}
