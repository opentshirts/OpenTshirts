package controller.designElements.text
{
	import Interfaces.ITextLayout;
	
	import model.elements.text.TextProxy;
	import model.elements.text.layout.ArcTextLayoutVO;
	import model.elements.text.layout.NormalTextLayoutVO;
	import model.elements.text.layout.TextLayoutEnum;
	import model.elements.text.vo.TextVO;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.utilities.undo.controller.UndoableCommandBase;

	//mapped with ApplicationConstants.CHANGE_TEXT_LAYOUT
	public class ChangeTextLayoutUndoableCommand extends UndoableCommandBase
	{
		override public function execute(note:INotification):void
		{
			if ( !note.getBody().hasOwnProperty("uid") || !note.getBody().hasOwnProperty("layout") )
			{
				throw new Error("Could not execute " + this + ". uid and layout expected as body of the note");
			}
			super.execute( note );
			registerUndoCommand( ChangeTextLayoutUndoableCommand );
		}
		
		override public function executeCommand():void
		{
			var uid:String = getNote().getBody().uid;
			var layout:Object = getNote().getBody().layout;
			var layoutName:String = layout.name;
			
			var proxy:TextProxy = facade.retrieveProxy(uid) as TextProxy;
			var vo:TextVO = proxy.vo;
			
			var snapshot:Object = {uid:uid, layout:vo.layout};
			
			getNote().setBody( snapshot ); //save previous value into the note, for undo
			
			if(layout is ITextLayout)
			{
				proxy.setLayout(layout as ITextLayout);
			}else
			{
				switch(layoutName)
				{
					case TextLayoutEnum.ARC:
					{
						var arcLayout:ArcTextLayoutVO = new ArcTextLayoutVO();
						facade.registerProxy(arcLayout.creator.createProxy());
						proxy.setLayout(arcLayout);
						break;
					}
					case TextLayoutEnum.NORMAL:
					{
						var normalLayout:NormalTextLayoutVO = new NormalTextLayoutVO();
						facade.registerProxy(normalLayout.creator.createProxy());
						proxy.setLayout(normalLayout);
						break;
					}
					default:
					{
						throw new Error("undefined layoutName "+layoutName);
						break;
					}
				}
			}
			
		}
		
		override public function getCommandName():String
		{
			return "ChangeTextLayoutUndoableCommand";
		}
	}
}