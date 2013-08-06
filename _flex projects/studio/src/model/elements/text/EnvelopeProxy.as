package model.elements.text
{	  
	import Interfaces.IXMLProxy;
	
	import model.elements.text.envelope.SimpleEnvelopeVO;
	
	import org.puremvc.as3.patterns.proxy.Proxy;
	
	public class EnvelopeProxy extends Proxy implements IXMLProxy
	{  
		public static const NAME:String = 'EnvelopeProxy';
		
		public function EnvelopeProxy(value_object:Object)  
		{  
			super( NAME, value_object  );  
			
		}
		override public function getProxyName():String
		{
			//return vo.uid;
		}
		override public function onRegister():void
		{
			super.onRegister();
		}

		/*public function setShape(type:uint=TextShapeEnum.NORMAL, amount:Number=0, envelopeEffect:uint=0):void
		{
			switch(type)
			{
				case TextShapeEnum.ENVELOPE:
					vo.shape = new EnvelopeTextVO(amount, envelopeEffect);
					break;
				case TextShapeEnum.ARC:
					vo.shape = new ArcTextVO(amount);
					break;
				default:
					vo.shape = null;
					break;
			}
			sendNotification(SHAPE_CHANGED, {uid:vo.uid, shape:vo.shape}, NAME);
		}*/
		/*public function saveToXML():XML {
			var elementXml:XML = <design_element/>;
			elementXml.@type = vo.type;
			elementXml.@text = vo.text;
			elementXml.@color = vo.color.id;
			elementXml.@font = vo.font;
			elementXml.@spacing = vo.spacing;
			elementXml.@shape = vo.shape;
			elementXml.appendChild(designElementProxy.saveToXML());
			return elementXml;
		}
		public function loadFromXML(xml:XML):void {
			vo.color = designColorListProxy.getColorFromId(int(xml.@color));
			vo.font = xml.@font;
			vo.spacing = Number(xml.@spacing);
			vo.text = xml.@text;
			designElementProxy.loadFromXML(xml.base[0]);
		}*/
		public function get vo():SimpleEnvelopeVO
		{
			return data as SimpleEnvelopeVO;
		}
		
	}  
}