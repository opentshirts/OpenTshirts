package controller.designElements.text
{
	import appFacade.ApplicationConstants;
	
	import model.design.CompositionProxy;
	import model.design.DesignColorListProxy;
	import model.elements.DesignElementProxy;
	import model.elements.filters.OutlineProxy;
	import model.elements.filters.OutlineVO;
	import model.elements.filters.ShadowProxy;
	import model.elements.filters.ShadowVO;
	import model.elements.text.FontListProxy;
	import model.elements.text.TextProxy;
	import model.elements.text.envelope.NoEnvelopeVO;
	import model.elements.text.layout.NormalTextLayoutVO;
	import model.elements.text.vo.TextVO;
	
	import mx.resources.ResourceManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import org.puremvc.as3.utilities.undo.model.enum.UndoableCommandTypeEnum;

	//mapped with ApplicationFacade.CREATE_TEXT
	public class CreateTextCommand extends SimpleCommand
	{
		override public function execute(note:INotification):void
		{
			if(!compositionProxy.currentDesignProxy)
			{
				sendNotification(ApplicationConstants.SHOW_MSG, {msg:ResourceManager.getInstance().getString('languageResources','SELECT_PRODUCT_FIRST'), type:0});					
				return;
			}
			//instanciate new text
			var tx:TextVO = new TextVO();
			
			//create and register proxy
			var txProxy:TextProxy = tx.creator.createProxy() as TextProxy;
			
			txProxy.setColor(designColorListProxy.getDefaultColor());
			txProxy.setFont(fontListProxy.getDefaultFont());
			txProxy.setText("Edit Text");
			txProxy.setSpacing(0);
			
			var normalLayout:NormalTextLayoutVO = new NormalTextLayoutVO();
			facade.registerProxy(normalLayout.creator.createProxy());
			txProxy.setLayout(normalLayout);
			
			var noEnvelope:NoEnvelopeVO = new NoEnvelopeVO();
			facade.registerProxy(noEnvelope.creator.createProxy());
			txProxy.setEnvelope(noEnvelope);
			
			facade.registerProxy(txProxy);
			
			//add to current design
			sendNotification(ApplicationConstants.ADD_ELEMENT_TO_DESIGN, {element_uid:tx.uid, design_uid:compositionProxy.currentDesignProxy.vo.uid}, UndoableCommandTypeEnum.RECORDABLE_COMMAND);

			//var elementProxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+tx.uid) as DesignElementProxy;
			//elementProxy.setPosition(compositionProxy.currentDesignArea.x,compositionProxy.currentDesignArea.y);
			
			/**
			 * add some filters just for testing purposes
			 **/
			///outline1
			var outline1:OutlineVO = new OutlineVO();
			outline1.index = "1";
			var outline1Proxy:OutlineProxy = outline1.creator.createProxy() as OutlineProxy;
			///default values
			outline1Proxy.setThickness(5);
			facade.registerProxy(outline1Proxy);
			outline1Proxy.setColor(designColorListProxy.designColors[2]); //any color
			///outline2
			var outline2:OutlineVO = new OutlineVO();
			outline2.index = "2";
			var outline2Proxy:OutlineProxy = outline2.creator.createProxy() as OutlineProxy;
			outline2Proxy.setThickness(5);
			facade.registerProxy(outline2Proxy);
			outline2Proxy.setColor(designColorListProxy.getDefaultColor()); //any color
			///shadow1
			var shadow1:ShadowVO = new ShadowVO();
			var shadowProxy:ShadowProxy = shadow1.creator.createProxy() as ShadowProxy;
			shadowProxy.setColor(designColorListProxy.getDefaultColor());
			shadowProxy.setThickness(5);
			shadowProxy.setAngle(45);
			shadowProxy.setDistance(10);
			
			facade.registerProxy(shadowProxy);
			shadowProxy.setColor(designColorListProxy.designColors[3]); //any color
			///add to design element
			var deProxy:DesignElementProxy = facade.retrieveProxy(DesignElementProxy.NAME+tx.uid) as DesignElementProxy;
			deProxy.addFilter(outline1);
			deProxy.addFilter(outline2);
			deProxy.addFilter(shadow1);
			/**
			 * 
			 * */
			sendNotification(ApplicationConstants.SELECT_ELEMENT, {uid:tx.uid});
			
			
		}
		private function get compositionProxy():CompositionProxy
		{
			return facade.retrieveProxy( CompositionProxy.NAME ) as CompositionProxy;
		}
		private function get designColorListProxy():DesignColorListProxy
		{
			return facade.retrieveProxy(DesignColorListProxy.NAME) as DesignColorListProxy;
		}
		private function get fontListProxy():FontListProxy
		{
			return facade.retrieveProxy(FontListProxy.NAME) as FontListProxy;
		}
	}
}