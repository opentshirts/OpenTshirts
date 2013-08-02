<?php 
class ControllerXmlLanguage extends Controller { 
	public function index() {
		
		$this->language->load('studio/studio');

		$this->data['code'] = $this->language->get('code');
		
		$this->data['language'] = array();
		$this->data['language']['CLIPART_PROPERTIES'] = $this->language->get('CLIPART_PROPERTIES');
		$this->data['language']['COLORS'] = $this->language->get('COLORS');
		$this->data['language']['COLOR'] = $this->language->get('COLOR');
		$this->data['language']['PRODUCTS'] = $this->language->get('PRODUCTS');
		$this->data['language']['CLIPART'] = $this->language->get('CLIPART');
		$this->data['language']['ADD_CLIPART'] = $this->language->get('CLIPART_PROPERTIES');
		$this->data['language']['ADD_TEXT'] = $this->language->get('CLIPART_PROPERTIES');
		$this->data['language']['SELECT_PRODUCT'] = $this->language->get('CLIPART_PROPERTIES');
		$this->data['language']['SEARCH'] = $this->language->get('CLIPART_PROPERTIES');
		$this->data['language']['VIEWS'] = $this->language->get('VIEWS');
		$this->data['language']['FULL_COLOR'] = $this->language->get('FULL_COLOR');
		$this->data['language']['DUO_COLOR'] = $this->language->get('DUO_COLOR');
		$this->data['language']['ONE_COLOR'] = $this->language->get('ONE_COLOR');
		$this->data['language']['INVERT'] = $this->language->get('INVERT');
		$this->data['language']['MOVE_TO_TOP'] = $this->language->get('MOVE_TO_TOP');
		$this->data['language']['MOVE_TO_BOTTOM'] = $this->language->get('MOVE_TO_BOTTOM');
		$this->data['language']['MOVE_FORWARD'] = $this->language->get('MOVE_FORWARD');
		$this->data['language']['MOVE_BACKWARD'] = $this->language->get('MOVE_BACKWARD');
		$this->data['language']['WIDTH'] = $this->language->get('WIDTH');
		$this->data['language']['HEIGHT'] = $this->language->get('HEIGHT');
		$this->data['language']['ROTATION'] = $this->language->get('ROTATION');
		$this->data['language']['X'] = $this->language->get('X');
		$this->data['language']['Y'] = $this->language->get('Y');
		$this->data['language']['LOCKED'] = $this->language->get('LOCKED');
		$this->data['language']['RESET_PROPORTIONS'] = $this->language->get('RESET_PROPORTIONS');
		$this->data['language']['TEXT'] = $this->language->get('TEXT');
		$this->data['language']['ENTER_TEXT'] = $this->language->get('ENTER_TEXT');
		$this->data['language']['FONT'] = $this->language->get('FONT');
		$this->data['language']['SPACING'] = $this->language->get('SPACING');
		$this->data['language']['TEXT_COLOR'] = $this->language->get('TEXT_COLOR');
		$this->data['language']['ALIGN_TO_BOTTOM'] = $this->language->get('ALIGN_TO_BOTTOM');
		$this->data['language']['ALIGN_TO_TOP'] = $this->language->get('ALIGN_TO_TOP');
		$this->data['language']['ALIGN_TO_LEFT'] = $this->language->get('ALIGN_TO_LEFT');
		$this->data['language']['ALIGN_TO_RIGHT'] = $this->language->get('ALIGN_TO_RIGHT');
		$this->data['language']['CENTER_VERTICAL'] = $this->language->get('CENTER_VERTICAL');
		$this->data['language']['CENTER_HORIZONTAL'] = $this->language->get('CENTER_HORIZONTAL');
		$this->data['language']['ARRANGE'] = $this->language->get('ARRANGE');
		$this->data['language']['ALIGN'] = $this->language->get('ALIGN');
		$this->data['language']['ZOOM_IN'] = $this->language->get('ZOOM_IN');
		$this->data['language']['ZOOM_TO_AREA'] = $this->language->get('ZOOM_TO_AREA');
		$this->data['language']['ZOOM_OUT'] = $this->language->get('ZOOM_OUT');
		$this->data['language']['FILTERS'] = $this->language->get('FILTERS');
		$this->data['language']['FILTER_COLOR'] = $this->language->get('FILTER_COLOR');
		$this->data['language']['SELECT_FILTER'] = $this->language->get('SELECT_FILTER');
		$this->data['language']['THICKNESS'] = $this->language->get('THICKNESS');
		$this->data['language']['DISTANCE'] = $this->language->get('DISTANCE');
		$this->data['language']['ANGLE'] = $this->language->get('ANGLE');
		$this->data['language']['OUTLINE'] = $this->language->get('OUTLINE');
		$this->data['language']['SHADOW'] = $this->language->get('SHADOW');
		$this->data['language']['VISIBLE'] = $this->language->get('VISIBLE');
		$this->data['language']['TEXT_EFFECT'] = $this->language->get('TEXT_EFFECT');
		$this->data['language']['ADJUST_EFFECTS'] = $this->language->get('ADJUST_EFFECTS');
		$this->data['language']['SELECT_FONT'] = $this->language->get('SELECT_FONT');
		$this->data['language']['SELECT_SHAPE'] = $this->language->get('SELECT_SHAPE');
		$this->data['language']['COLORS_USED'] = $this->language->get('COLORS_USED');
		$this->data['language']['SELECT_LAYERS_TO_TINT'] = $this->language->get('SELECT_LAYERS_TO_TINT');
		$this->data['language']['SAVE_DESIGN'] = $this->language->get('SAVE_DESIGN');
		$this->data['language']['SELECT_PRODUCT_FIRST'] = $this->language->get('SELECT_PRODUCT_FIRST');
		$this->data['language']['EXPORT_IMAGE'] = $this->language->get('EXPORT_IMAGE');
		$this->data['language']['PRODUCT_COLORS'] = $this->language->get('PRODUCT_COLORS');
		$this->data['language']['OBJECT_PROPERTIES'] = $this->language->get('OBJECT_PROPERTIES');
		$this->data['language']['CLIPART_PROPERTIES'] = $this->language->get('CLIPART_PROPERTIES');
		$this->data['language']['COLOR_PALETTE'] = $this->language->get('COLOR_PALETTE');
		$this->data['language']['SELECT_ALL'] = $this->language->get('SELECT_ALL');
		$this->data['language']['FIT_TO_AREA'] = $this->language->get('FIT_TO_AREA');
		$this->data['language']['FLIP_H'] = $this->language->get('FLIP_H');
		$this->data['language']['FLIP_V'] = $this->language->get('FLIP_V');
		$this->data['language']['PRODUCT_PROPERTIES_HELP1'] = $this->language->get('PRODUCT_PROPERTIES_HELP1');		
		$this->data['language']['PRODUCT_PROPERTIES_HELP2'] = $this->language->get('PRODUCT_PROPERTIES_HELP2');
		$this->data['language']['COLOR_USED_HELP'] = $this->language->get('COLOR_USED_HELP');
		$this->data['language']['UNDO'] = $this->language->get('UNDO');
		$this->data['language']['REDO'] = $this->language->get('REDO');
		$this->data['language']['DUPLICATE'] = $this->language->get('DUPLICATE');
		$this->data['language']['CLEAR_SELECTION'] = $this->language->get('CLEAR_SELECTION');
		$this->data['language']['TEXT_SHAPE'] = $this->language->get('TEXT_SHAPE');
		$this->data['language']['SELECT_TEXT_SHAPE'] = $this->language->get('SELECT_TEXT_SHAPE');
		$this->data['language']['SET_TEXT_OUTLINES'] = $this->language->get('SET_TEXT_OUTLINES');
		$this->data['language']['CLICK_ENABLE_OUTLINES'] = $this->language->get('CLICK_ENABLE_OUTLINES');
		$this->data['language']['PRODUCT_CATALOG_BUTTON'] = $this->language->get('PRODUCT_CATALOG_BUTTON');
		$this->data['language']['PRODUCT_INFORMATION'] = $this->language->get('PRODUCT_INFORMATION');
		$this->data['language']['PRINT_LOCATIONS'] = $this->language->get('PRINT_LOCATIONS');
		$this->data['language']['TEXT_HOVER_IMAGE'] = $this->language->get('TEXT_HOVER_IMAGE');
		$this->data['language']['AVAILABLE_PRINT_LOCATIONS'] = $this->language->get('AVAILABLE_PRINT_LOCATIONS');

		$this->template = 'default/template/xml/language.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>