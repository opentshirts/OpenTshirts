package view.components.text
{
	import Interfaces.IEnvelope;
	import Interfaces.ITextLayout;
	
	import flash.events.Event;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import model.design.vo.DesignColorVO;
	import model.elements.text.envelope.EnvelopeTypeEnum;
	import model.elements.text.envelope.SimpleEnvelopeVO;
	import model.elements.text.layout.ArcTextLayoutVO;
	import model.elements.text.layout.TextLayoutEnum;
	
	import view.components.designElement.DesignElementBase;

	public class TextComponent extends DesignElementBase
	{
		protected var _text:String;
		protected var textChanged:Boolean = false;
		
		protected var _font:String;
		protected var fontChanged:Boolean = false;
		
		protected var _color:DesignColorVO;
		protected var colorChanged:Boolean = false;
		
		protected var _spacing:Number;
		protected var spacingChanged:Boolean = false;
		
		protected var _layout:ITextLayout;
		protected var layoutChanged:Boolean = false;
		
		protected var _envelope:IEnvelope;
		protected var envelopeChanged:Boolean = false;
		
		protected var textFormat:TextFormat;
		
		//public static const UPDATED:String = "UPDATED";
		
		public function TextComponent()
		{
			super();
			textFormat = new TextFormat()
			textFormat.size = 255;
			
			
		}
		public function invalidateText():void
		{
			
			if(textChanged || fontChanged || colorChanged || spacingChanged || layoutChanged || envelopeChanged)
			{
				textFormat.font = _font;
				textFormat.color = _color.hexa;
				textFormat.letterSpacing = _spacing;
				container.alpha = _color.alpha;
				
				//clear container
				while (container.numChildren>0) container.removeChildAt(0);
				
				switch(_layout.name)
				{
					case TextLayoutEnum.ARC:
					{
						var arcTextComponent:ArcTextComponent = new ArcTextComponent();
						arcTextComponent.text = _text;
						arcTextComponent.textFormat = textFormat;
						arcTextComponent.radioPercent = ArcTextLayoutVO(_layout).radio*-1;
						arcTextComponent.draw();
						container.addChild(arcTextComponent);
						
						setUnscaledSize(arcTextComponent.width,arcTextComponent.height);
						
						break;
					}
					case TextLayoutEnum.NORMAL:
					{
						var textField:TextField = new TextField();
						textField.embedFonts = true;
						textField.autoSize=TextFieldAutoSize.LEFT;
						textField.antiAliasType = AntiAliasType.ADVANCED;
						textField.selectable = false;
						textField.text=_text;
						textField.wordWrap = false;
						textField.setTextFormat(textFormat);
						container.addChild(textField);
						setUnscaledSize(textField.textWidth,textField.textHeight);
						break;
					}
				}
				if(_envelope)
				{
					switch (_envelope.type)
					{
						case EnvelopeTypeEnum.SIMPLE:
						{
							var envelopeTextComponent:EnvelopeComponent = new EnvelopeComponent();
							//envelopeTextComponent.text = _text;
							//envelopeTextComponent.textFormat = textFormat;
							envelopeTextComponent.displayObject = container.getChildAt(0);
							envelopeTextComponent.envelopeEffect = SimpleEnvelopeVO(_envelope).effectNumber;
							envelopeTextComponent.amount = SimpleEnvelopeVO(_envelope).amount;
							envelopeTextComponent.draw();
							//patch
							while (container.numChildren>0) container.removeChildAt(0);
							container.addChild(envelopeTextComponent);
							
							setUnscaledSize(envelopeTextComponent.width,envelopeTextComponent.height);
							
							break;
							
							
						}
					}
				}
				
				
				
				textChanged = false;
				fontChanged = false;
				colorChanged = false;
				spacingChanged = false;
				layoutChanged = false;
				envelopeChanged = false;
				//this.dispatchEvent(new Event(UPDATED));
			}
			
		}
		override public function updateCanvasColor():void
		{
			colorChanged = true;
			invalidateText();
		}
		public function refreshFont():void
		{
			fontChanged = true;
			invalidateText();
		}
		public function get text():String
		{
			return _text;
		}
		public function set text(value:String):void
		{
			if(_text != value)
			{
				_text = value;
				textChanged = true;
			}
		}
		public function get font():String
		{
			return _font;
		}
		public function set font(value:String):void
		{
			if(_font != value) 
			{
				_font = value;
				fontChanged = true;
			}
		}
		public function get color():DesignColorVO
		{
			return _color;
		}
		public function set color(value:DesignColorVO):void
		{
			if(_color != value) 
			{
				_color = value;
				colorChanged = true;
			}
			
		}
		public function get spacing():Number
		{
			return _spacing;
		}
		public function set spacing(value:Number):void
		{
			if(_spacing != value) 
			{
				_spacing = value;
				spacingChanged = true;
			}
		}
		public function get envelope():IEnvelope
		{
			return _envelope;
		}
		public function set envelope(value:IEnvelope):void
		{
			_envelope = value;
			envelopeChanged = true;
		}
		public function get layout():ITextLayout
		{
			return _layout;
		}
		public function set layout(value:ITextLayout):void
		{
			_layout = value;
			layoutChanged = true;
		}
	}
}