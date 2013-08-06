package model.elements.text
{	  
	import Interfaces.IClonableProxy;
	import Interfaces.IDesignElement;
	import Interfaces.IDesignElementProxy;
	import Interfaces.IEnvelope;
	import Interfaces.ITextLayout;
	import Interfaces.ITintableElementProxy;
	import Interfaces.IXMLProxy;
	
	import model.design.DesignColorListProxy;
	import model.design.vo.DesignColorVO;
	import model.elements.DesignElementProxy;
	import model.elements.text.envelope.EnvelopeTypeEnum;
	import model.elements.text.envelope.NoEnvelopeVO;
	import model.elements.text.envelope.SimpleEnvelopeVO;
	import model.elements.text.layout.ArcTextLayoutVO;
	import model.elements.text.layout.NormalTextLayoutVO;
	import model.elements.text.layout.TextLayoutEnum;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class TextProxy extends Proxy implements IDesignElementProxy , ITintableElementProxy, IXMLProxy, IClonableProxy
	{  
		public static const NAME:String = 'TextProxy';
		public static const TEXT_CHANGED:String = NAME + 'TEXT_CHANGED';
		public static const FONT_CHANGED:String = NAME + 'FONT_CHANGED';
		public static const SPACING_CHANGED:String = NAME + 'SPACING_CHANGED';
		public static const COLOR_CHANGED:String = NAME + 'COLOR_CHANGED';
		public static const LAYOUT_CHANGED:String = NAME + 'LAYOUT_CHANGED';
		public static const ENVELOPE_CHANGED:String = NAME + 'ENVELOPE_CHANGED';
		
		private var designElementProxy:DesignElementProxy;
		
		public function TextProxy(value_object:Object)  
		{  
			super( NAME, value_object  ); 
			
			/*setColor(designColorListProxy.getDefaultColor());
			setFont(fontListProxy.getDefaultFont());
			setText("Edit Text");
			setSpacing(0);
			
			var normalLayout:NormalTextLayoutVO = new NormalTextLayoutVO();
			facade.registerProxy(normalLayout.creator.createProxy());
			setLayout(normalLayout);
			
			var noEnvelope:NoEnvelopeVO = new NoEnvelopeVO();
			facade.registerProxy(noEnvelope.creator.createProxy());
			setEnvelope(noEnvelope);*/
			
			designElementProxy = new DesignElementProxy(vo);
		}
		override public function getProxyName():String
		{
			return vo.uid;
		}
		override public function onRegister():void
		{
			super.onRegister();
			
			facade.registerProxy(designElementProxy);
		}
		override public function onRemove( ):void
		{
			facade.removeProxy(designElementProxy.getProxyName());
		}
		public function setText(value:String):void
		{
			vo.text = value;
			sendNotification(TEXT_CHANGED, {uid:vo.uid, text:vo.text}, NAME);
		}
		public function setFont(value:String):void
		{
			vo.font = value;
			if(fontListProxy.getFontByName(vo.font).id)
			{
				vo.id_font = fontListProxy.getFontByName(vo.font).id;
			}
			sendNotification(FONT_CHANGED, {uid:vo.uid, font:vo.font}, NAME);
		}
		public function setSpacing(value:Number):void
		{
			vo.spacing = value;
			sendNotification(SPACING_CHANGED, {uid:vo.uid, spacing:vo.spacing}, NAME);
		}
		public function setColor(value:DesignColorVO):void
		{
			vo.color = value;
			sendNotification(COLOR_CHANGED, {uid:vo.uid, color:vo.color}, NAME);
		}
		public function setLayout(layout:ITextLayout):void
		{
			vo.layout = layout;
			sendNotification(LAYOUT_CHANGED, {uid:vo.uid, layout:vo.layout}, NAME);
		}
		public function setEnvelope(envelope:IEnvelope):void
		{
			vo.envelope = envelope;
			sendNotification(ENVELOPE_CHANGED, {uid:vo.uid, envelope:vo.envelope}, NAME);
		}

		public function getColors():Vector.<DesignColorVO> {
			var colors:Vector.<DesignColorVO> = new Vector.<DesignColorVO>();
			colors.push(vo.color)
			colors = colors.concat(designElementProxy.getColors());
			return colors;
		}
		public function saveToXML():XML {
			var elementXml:XML = <design_element/>;
			elementXml.@type = vo.type;
			elementXml.@id = vo.id_font;
			elementXml.@text = vo.text;
			elementXml.@color = vo.color.id;
			elementXml.@font = vo.font;
			elementXml.@spacing = vo.spacing;
			//elementXml.@visible_colors = getColorsString();
			elementXml.appendChild(designElementProxy.saveToXML());
			elementXml.appendChild(IXMLProxy(facade.retrieveProxy(vo.envelope.uid)).saveToXML());
			elementXml.appendChild(IXMLProxy(facade.retrieveProxy(vo.layout.uid)).saveToXML());	
			return elementXml;
		}
		protected function getColorsString():String
		{
			var vector:Vector.<DesignColorVO> = this.getColors();
			var str:String = "";
			var separator:String = "";
			for each(var color:DesignColorVO in vector)
			{
				str += separator + color.id;
				separator = ",";
			}
			return str;
		}
		public function loadFromXML(xml:XML):void {
			vo.color = designColorListProxy.getColorFromId(String(xml.@color));
			vo.font = xml.@font;
			vo.id_font = xml.@id;
			vo.spacing = Number(xml.@spacing);
			vo.text = xml.@text;
			
			
			var xmlProxy:IXMLProxy;
			///envelope
			var envelopevo:IEnvelope;
			var envelopeXML:XML = xml.envelope[0];
			switch(String(envelopeXML.@type))
			{
				case EnvelopeTypeEnum.NONE:
					envelopevo = new NoEnvelopeVO();
					break;
				case EnvelopeTypeEnum.SIMPLE:
					envelopevo = new SimpleEnvelopeVO(envelopeXML.@effectNumber);
					break;
			}
			xmlProxy = envelopevo.creator.createProxy() as IXMLProxy;
			xmlProxy.loadFromXML(envelopeXML);
			facade.registerProxy(xmlProxy);
			vo.envelope = envelopevo;
			
			///text layout
			var layoutvo:ITextLayout;
			var layoutXML:XML = xml.text_layout[0];
			switch(String(layoutXML.@name))
			{
				case TextLayoutEnum.NORMAL:
					layoutvo = new NormalTextLayoutVO()
					break;
				case TextLayoutEnum.ARC:
					layoutvo = new ArcTextLayoutVO();
					break;
			}
			xmlProxy = layoutvo.creator.createProxy() as IXMLProxy;
			xmlProxy.loadFromXML(layoutXML);
			facade.registerProxy(xmlProxy);
			vo.layout = layoutvo;
			
			designElementProxy.loadFromXML(xml.base[0]);
		}
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy( DesignColorListProxy.NAME ) as DesignColorListProxy;
		}
		
		private function get fontListProxy():FontListProxy
		{
			return facade.retrieveProxy(FontListProxy.NAME) as FontListProxy;
		}
		public function get vo():TextVO
		{
			return data as TextVO;
		}
		public function get designElement():IDesignElement
		{
			return data as IDesignElement;
		}
		
		public function getCopy():Object
		{
			var obj:TextVO = new TextVO();
			
			obj.text  = vo.text;
			obj.color  = vo.color;
			obj.id_font  = vo.id_font;
			obj.font  = vo.font;
			obj.spacing  = vo.spacing;
			var envelopeProxy:IClonableProxy = facade.retrieveProxy(vo.envelope.uid) as IClonableProxy;
			var env_clone:IEnvelope = IEnvelope(envelopeProxy.getCopy());
			facade.registerProxy(env_clone.creator.createProxy());
			obj.envelope = env_clone;
			
			var layoutProxy:IClonableProxy = facade.retrieveProxy(vo.layout.uid) as IClonableProxy;
			var lay_clone:ITextLayout = ITextLayout(layoutProxy.getCopy());
			facade.registerProxy(lay_clone.creator.createProxy());
			obj.layout  = lay_clone;

			designElementProxy.copyProperties(obj);
			return obj;
		}
		
	}  
}