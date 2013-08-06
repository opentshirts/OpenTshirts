package view
{
	
	import Interfaces.IDesignElementMediator;
	import Interfaces.IEnvelopeMediator;
	import Interfaces.ITextLayoutMediator;
	
	import flash.text.TextFormat;
	
	import model.elements.text.TextProxy;
	import model.elements.text.vo.TextVO;
	import model.elements.vo.DesignElementVO;
	
	import mx.core.FlexGlobals;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	
	import appFacade.ApplicationConstants;
	
	import view.components.designElement.DesignElementBase;
	import view.components.text.TextComponent;
	
	public class TextMediator extends Mediator implements IDesignElementMediator
	{  
		public static const NAME:String = 'TextMediator';
		 
		private var _vo:TextVO;
		
		public function TextMediator(vo:TextVO)  
		{  
			var viewComponent:Object = new TextComponent();
			
			super( NAME, viewComponent );
			
			_vo = vo;
			
		}
		override public function getMediatorName():String
		{
			return _vo.uid;
		}
		
		override public function onRegister():void
		{
			super.onRegister();
			
			registerDesignElementMediator();
			
			//invalidateComponent();
			
			textComponent.text =  _vo.text;
			textComponent.font =  _vo.font;
			textComponent.color = _vo.color;
			textComponent.spacing = _vo.spacing;
			
			//textComponent.layout = _vo.layout;
			//textComponent.envelope = _vo.envelope;
			
			ITextLayoutMediator(facade.retrieveMediator(_vo.layout.uid)).setTextComponent(textComponent);
			IEnvelopeMediator(facade.retrieveMediator(_vo.envelope.uid)).setTextComponent(textComponent);
			
			textComponent.invalidateText();
			
			///if font is not embedded try to load font
			if(!FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(new TextFormat(_vo.font)))
				sendNotification(ApplicationConstants.LOAD_FONT, _vo.font, NAME);
			
		}
		override public function onRemove():void
		{
			super.onRemove();
			
			removeDesignElementMediator();
			
			
		}
		
		override public function listNotificationInterests():Array  
		{
			return [
				TextProxy.TEXT_CHANGED,
				TextProxy.FONT_CHANGED,
				TextProxy.SPACING_CHANGED,
				TextProxy.COLOR_CHANGED,
				TextProxy.ENVELOPE_CHANGED,
				TextProxy.LAYOUT_CHANGED,
				
				ApplicationConstants.CHANGING_TEXT_SPACING,
				ApplicationConstants.FONT_LOADED
			];  
		}  
		
		override public function handleNotification(note:INotification):void
		{
			
			switch ( note.getName() )
			{
				case ApplicationConstants.CHANGING_TEXT_SPACING:
					if ( note.getBody().uid == _vo.uid )
					{						
						textComponent.spacing =  note.getBody().spacing;
						textComponent.invalidateText();
					}
					break;
				case ApplicationConstants.FONT_LOADED:
					var fontname:String = note.getBody() as String;
					if(_vo.font==fontname)
					{
						textComponent.refreshFont();
					}
					break;
				case TextProxy.TEXT_CHANGED:
					if (_vo.uid == String(note.getBody().uid) )
					{
						textComponent.text =  _vo.text;
						textComponent.invalidateText();
					}
					break;
				case TextProxy.FONT_CHANGED:
					if (_vo.uid == String(note.getBody().uid) )
					{
						textComponent.font =  _vo.font;
						textComponent.invalidateText();
						
						///if font is not embedded try to load font
						if(!FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(new TextFormat(_vo.font)))
							sendNotification(ApplicationConstants.LOAD_FONT, _vo.font, NAME);
					}
					break;
				case TextProxy.SPACING_CHANGED:
					if (_vo.uid == String(note.getBody().uid) )
					{
						textComponent.spacing = _vo.spacing;
						textComponent.invalidateText();
					}
					break;
				case TextProxy.COLOR_CHANGED:
					if (_vo.uid == String(note.getBody().uid) )
					{
						textComponent.color = _vo.color;
						textComponent.invalidateText();
					}
					break;
				case TextProxy.ENVELOPE_CHANGED:
					if (_vo.uid == String(note.getBody().uid) )
					{
						IEnvelopeMediator(facade.retrieveMediator(_vo.envelope.uid)).setTextComponent(textComponent);
					}
					break;
				case TextProxy.LAYOUT_CHANGED:
					if (_vo.uid == String(note.getBody().uid) )
					{
						ITextLayoutMediator(facade.retrieveMediator(_vo.layout.uid)).setTextComponent(textComponent);
					}
					break;

			}
		}

		/*tprivate function invalidateComponent():void
		{
			//invalidate visual element
			extComponent.text =  _vo.text;
			textComponent.font =  _vo.font;
			textComponent.color = _vo.color;
			textComponent.spacing = _vo.spacing;
			//textComponent.layout = _vo.layout;
			textComponent.envelope = _vo.envelope;
			
			textComponent.invalidateText();
			
			///if font is not embedded try to load font
			if(!FlexGlobals.topLevelApplication.systemManager.isFontFaceEmbedded(new TextFormat(_vo.font)))
				sendNotification(ApplicationConstants.LOAD_FONT, _vo.font, NAME);
			
		}*/
		private function get textComponent():TextComponent
		{
			return viewComponent as TextComponent;
		}

		
		/**
		 *  >> IDesignElementMediator
		 * */
		private function registerDesignElementMediator():void
		{
			facade.registerMediator(new DesignElementMediator(designElementBase, designElementVO));
		}
		private function removeDesignElementMediator():void
		{
			facade.removeMediator(DesignElementMediator.NAME+_vo.uid);
		}
		public function get designElementBase():DesignElementBase
		{
			return viewComponent as DesignElementBase;
		}
		public function get designElementVO():DesignElementVO
		{
			return _vo as DesignElementVO;
		}
		/**
		 *  << IDesignElementMediator
		 * */
	 }  
}