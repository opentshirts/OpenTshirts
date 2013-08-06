package flex.utils.spark.resize {
	import mx.core.UIComponent;

	import spark.components.Label;

	/**
	 * Extends Label to show a resize handle in the bottom right corner
	 * that when dragged resizes the label.
	 *
	 * @author Chris Callendar
	 * @date June 28th, 2010
	 */
	public class ResizableLabel extends Label {

		private var resizeManager:ResizeManager;

		private var _resizeHandle:UIComponent;

		private var createdChildren:Boolean;

		public function ResizableLabel() {
			super();
			mouseChildren = true; // required for the resizeHandle to accept mouse events
			minWidth = 13;
			minHeight = 13;
			resizeManager = new ResizeManager(this, null);
		}

		[Bindable]
		public function get resizeHandle():UIComponent {
			return _resizeHandle;
		}

		public function set resizeHandle(value:UIComponent):void {
			if (_resizeHandle) {
				removeChild(_resizeHandle);
			}
			_resizeHandle = value;
			if (createdChildren && _resizeHandle) {
				addChild(_resizeHandle);
				resizeManager.resizeHandle = _resizeHandle;
			}
		}

		override protected function createChildren():void {
			super.createChildren();
			createdChildren = true;
			if (!resizeHandle) {
				resizeHandle = createResizeHandle();
			} else {
				addChild(resizeHandle);
			}
		}

		protected function createResizeHandle():UIComponent {
			var handle:ResizeHandleLines = new ResizeHandleLines();
			return handle;
		}

		override protected function updateDisplayList(w:Number, h:Number):void {
			super.updateDisplayList(w, h);

			if (resizeHandle) {
				resizeHandle.x = w - resizeHandle.width - 1;
				resizeHandle.y = h - resizeHandle.height - 1;
			}
		}

	}
}