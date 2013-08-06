package flex.utils.spark {
	import flash.events.Event;

	import mx.core.FlexGlobals;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleManager2;

	import spark.components.Label;
	import spark.components.SkinnableContainer;

	/**
	 *  Alpha level of the color defined by the <code>backgroundrColor</code> style.
	 *  Valid values range from 0.0 to 1.0.
	 *  @default 1.0
	 */
	[Style(name="backgroundAlpha", type="Number", inherit="no")]

	/**
	 *  Background color.
	 *  @default 0xFFFFFF
	 */
	[Style(name="backgroundColor", type="uint", format="Color", inherit="no")]

	/**
	 *  Determines if the background is visible or not.
	 *  If <code>false</code>, then no background is visible
	 *  @default true
	 */
	[Style(name="backgroundVisible", type="Boolean", inherit="no")]

	/**
	 *  Alpha level of the color defined by the <code>borderColor</code> style.
	 *  Valid values range from 0.0 to 1.0.
	 *  @default 1.0
	 */
	[Style(name="borderAlpha", type="Number", inherit="no")]

	/**
	 *  Color of the border.
	 *  @default 0x000000
	 */
	[Style(name="borderColor", type="uint", format="Color", inherit="no")]

	/**
	 *  Determines if the border is visible or not.
	 *  If <code>false</code>, then no border is visible
	 *  except a border set by using the <code>borderStroke</code> property.
	 *  @default true
	 */
	[Style(name="borderVisible", type="Boolean", inherit="no")]

	/**
	 *  The stroke weight for the border.
	 *  @default 1
	 */
	[Style(name="borderWeight", type="Number", format="Length", inherit="no")]

	/**
	 *  Radius of the curved corners of the border.
	 *  @default 0
	 */
	[Style(name="cornerRadius", type="Number", format="Length", inherit="no")]

	/**
	 *  If <code>true</code>, the container has a visible drop shadow.
	 *  @default false
	 */
	[Style(name="dropShadowVisible", type="Boolean", inherit="no")]

	// Layout styles:
	/** Left side padding */
	[Style(name="paddingLeft", type="Number")]
	/** Right side padding */
	[Style(name="paddingRight", type="Number")]
	/** Padding at the top */
	[Style(name="paddingTop", type="Number")]
	/** Padding at the bottom */
	[Style(name="paddingBottom", type="Number")]

	/** Horizontal or vertical gap (VerticalLayout and HorizontalLayout only) */
	[Style(name="gap", type="Number")]
	/** Horizontal gap between columns (TileLayout and HorizontalLayout only) */
	[Style(name="horizontalGap", type="Number")]
	/** Vertical gap between rows (TileLayout and VerticalLayout only) */
	[Style(name="verticalGap", type="Number")]
	/** Layout horizontal alignment (TileLayout, HorizontalLayout and VerticalLayout only) */
	[Style(name="horizontalAlign", type="String", enumeration="left,center,right,justify")]
	/** Layout vertical alignment (TileLayout, HorizontalLayout and VerticalLayout only) */
	[Style(name="verticalAlign", type="String", enumeration="top,middle,bottom,justify")]
	/** Width of the columns (TileLayout only) */
	[Style(name="columnWidth", type="Number")]
	/** Height of the rows (TileLayout only) */
	[Style(name="rowHeight", type="Number")]

	/**
	 *  Style declaration name for the text in the title border.
	 *  The default value is <code>"windowStyles"</code>,
	 *  which causes the title to have boldface text.
	 *  @default "windowStyles"
	 */
	[Style(name="titleStyleName", type="String", inherit="no")]


	//--------------------------------------
	//  Other metadata
	//--------------------------------------

	[IconFile("TitledBorderBox.png")]

	/**
	 * The TitledBorderBox class is similar to the BorderContainer class.
	 * It renders a border and a background, both which can customized.
	 * But it also has a title Label that appears in the top left corner of the box.
	 * It also supports rounded corners and exposes many of the layout styles as all.
	 * The titleLabel can be styled by setting the <b>titleStyleName</b> style.
	 *
	 *  @mxml
	 *
	 *  <p>The <code>&lt;ui:TitledBorderBox&gt;</code> tag inherits all the tag attributes
	 *  of its superclass, and adds the following tag attributes:</p>
	 *
	 *  <pre>
	 *  &lt;ui:TitledBorderBox
	 *    <b>Properties</b>
	 *    title="null"
	 *
	 *    <b>Styles</b>
	 *    backgroundAlpha="1.0"
	 *    backgroundColor="0xFFFFFF"
	 *    backgroundVisible="true"
	 *    borderAlpha="1.0"
	 *    borderColor="0xB7BABC"
	 *    borderVisible="true"
	 *    borderWeight="1"
	 *    cornerRadius="0"
	 *    dropShadowVisible="false"
	 *    paddingLeft="[layout default]"
	 *    paddingTop="[layout default]"
	 *    paddingRight="[layout default]"
	 *    paddingBottom="[layout default]"
	 *    gap="[layout default]"
	 *    horizontalGap="[layout default]"
	 *    verticalGap="[layout default]"
	 *    horizontalAlign="[layout default]"
	 *    verticalAlign="[layout default]"
	 *    columnWidth="[layout default]"
	 *    rowHeight="[layout default]"
	 *    titleStyleName="windowStyles"
	 *  /&gt;
	 *  </pre>
	 *
	 * @see flex.utils.spark.TitledBorderBoxSkin
	 * @author Chris Callendar
	 * @date June 1st, 2010
	 */
	public class TitledBorderBox extends SkinnableContainer {


		private static var classConstructed:Boolean = classConstruct();

		private static function classConstruct():Boolean {
			var styleManager:IStyleManager2 = FlexGlobals.topLevelApplication.styleManager;
			var style:CSSStyleDeclaration = styleManager.getStyleDeclaration("flex.utils.spark.TitledBorderBox");
			if (!style) {
				style = new CSSStyleDeclaration();
			}
			style.defaultFactory = function():void {
				this.backgroundAlpha = 0;
				this.backgroundColor = 0xffffff;
				this.backgroundVisible = true;
				this.borderAlpha = 1;
				this.borderColor = 0x0;
				this.borderWeight = 1;
				this.borderVisible = true;
				this.cornerRadius = 0;
				this.dropShadowVisible = false;
				this.titleStyleName = "windowStyles";
				this.skinClass = TitledBorderBoxSkin;
			};
			styleManager.setStyleDeclaration("flex.utils.spark.TitledBorderBox", style, true);
			return true;
		}

		[SkinPart(required="true")]
		[Inspectable(environment="none")]
		public var titleLabel:Label;

		private var _title:String;

		private var titleChanged:Boolean = false;

		/**
		 *  Constructor.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion Flex 4
		 */
		public function TitledBorderBox() {
			super();
		}

		[Bindable("titleChanged")]
		[Inspectable(category="General")]
		public function get title():String {
			return _title;
		}

		public function set title(value:String):void {
			if (_title != value) {
				_title = value;
				titleChanged = true;
				invalidateProperties();
				dispatchEvent(new Event("titleChanged"));
			}
		}

		override protected function partAdded(partName:String, instance:Object):void {
			super.partAdded(partName, instance);
			if (instance == titleLabel) {
				titleLabel.text = title;
			}
		}

		override protected function commitProperties():void {
			super.commitProperties();

			if (titleChanged) {
				titleChanged = false;
				if (titleLabel) {
					titleLabel.text = title;
				}
			}
		}

	}
}
