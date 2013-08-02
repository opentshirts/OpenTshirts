<?php  
class ControllerStudioZoom extends Controller {
	
	public function index() {
		
		$this->language->load('studio/zoom');
		
		$this->data['zoom_text_zoom_in'] = $this->language->get('zoom_text_zoom_in');
		$this->data['zoom_text_zoom_out'] = $this->language->get('zoom_text_zoom_out');
		$this->data['zoom_text_zoom_area'] = $this->language->get('zoom_text_zoom_area');
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/zoom.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/zoom.tpl';
		} else {
			$this->template = 'default/template/studio/zoom.tpl';
		}
		
		$this->render();
		//$this->response->setOutput($this->render());
	}
	

}
?>