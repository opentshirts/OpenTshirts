package com.roguedevelopment.objecthandles
{
    import flash.events.Event;
    
    public class HandleClickedEvent extends Event
    {
        public static const HANDLE_CLICKED:String = "handleClicked";
        
        public var clickedHandle:IHandle;
        
        public function HandleClickedEvent(handle:IHandle)
        {
            super(HANDLE_CLICKED, false, false);
            this.clickedHandle = handle;
        }
        
        override public function clone() : Event
        {
            return new HandleClickedEvent(clickedHandle);
        }
    }
}