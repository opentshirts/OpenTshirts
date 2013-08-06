package controller.designElements.text
{
	import Interfaces.IEnvelope;
	
	import model.elements.text.TextProxy;
	import model.elements.text.envelope.EnvelopeTypeEnum;
	import model.elements.text.envelope.NoEnvelopeVO;
	import model.elements.text.envelope.SimpleEnvelopeVO;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_ENVELOPE
	public class ChangeEnvelopeUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("envelope") )
			{
				throw new Error("Could not execute " + this + ". uid and envelope expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeEnvelopeUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var envelope:Object = getNote().getBody().envelope;
			var envelopeType:String = envelope.type;
			var effectNumber:Number = (envelope.hasOwnProperty("effectNumber"))?envelope.effectNumber:0;
			
			var proxy:TextProxy = facade.retrieveProxy(uid) as TextProxy;
			var vo:TextVO = proxy.vo;
			
			var snapshot:Object = {uid:uid, envelope:vo.envelope};
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			if(envelope is IEnvelope)
			{
				proxy.setEnvelope(envelope as IEnvelope);
			}else
			{
				switch(envelopeType)
				{
					case EnvelopeTypeEnum.NONE:
					{
						var noEnvelope:NoEnvelopeVO = new NoEnvelopeVO();
						facade.registerProxy(noEnvelope.creator.createProxy());
						proxy.setEnvelope(noEnvelope);
						break;
					}
					case EnvelopeTypeEnum.SIMPLE:
					{
						var simpleEnvelope:SimpleEnvelopeVO = new SimpleEnvelopeVO(effectNumber);
						facade.registerProxy(simpleEnvelope.creator.createProxy());
						proxy.setEnvelope(simpleEnvelope);
						break;
					}
					default:
					{
						throw new Error("undefined envelopeType "+envelopeType);
						break;
					}
				}
			}
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeEnvelopeUndoableCommand";
		}
	}
}