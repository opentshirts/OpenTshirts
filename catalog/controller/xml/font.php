<?php 
class ControllerXmlFont extends Controller { 
	public function index() {
		
		$this->load->language('xml/xml');
		
		$this->load->model('opentshirts/font');
		
		$filters = array('filter_status' => '1', 'sort' => 'f.name', 'order' => 'ASC');
		$fonts = $this->model_opentshirts_font->getFonts($filters);
		
		if(empty($fonts)) {
			$error_warning = $this->language->get('no_fonts');
		}
		
		$this->data['fonts'] = array();
    	foreach ($fonts as $font) {
			$this->data['fonts'][] = array(
        			'id_font' => $font['id_font'],
        			'name' => $font['name'],
					'swf_file' => utf8_encode(htmlspecialchars("image/data/fonts/".$font['swf_file'])),
					'preview' => utf8_encode(htmlspecialchars("index.php?route=studio/ttf2png&font_source=fonts/".$font['ttf_file']."&display_text=".strtoupper($font['name'])))
			);
		}	
		
		if(isset($error_warning)) {
			$this->data['error_warning'] = $error_warning;
		} else {
			$this->data['error_warning'] = '';
		}
	
		$this->template = 'default/template/xml/font.tpl';
		
		$this->response->addHeader("Content-type: text/xml");
		$this->response->setOutput($this->render());
  	}
}
?>