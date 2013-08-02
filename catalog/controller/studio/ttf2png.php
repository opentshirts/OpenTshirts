<?php 
class ControllerStudioTtf2png extends Controller { 
	public function index() {
		
		$this->load->language('xml/xml');

		if (isset($this->request->get['font_source']) && isset($this->request->get['display_text'])) {
			
			$this->load->library('ttf2png');
			
			$info['text'] = $this->request->get['display_text'];
			$ttf = DIR_IMAGE . 'data/' . $this->request->get['font_source'];
			
			$ttf2png = new TTF2PNG($ttf, $info);
			
			$this->response->addHeader("Content-Type: image/png");
			$this->response->setOutput($ttf2png->getImage());
		}
  	}
}
?>