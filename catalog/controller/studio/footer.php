<?php  
class ControllerStudioFooter extends Controller {
	protected function index() {

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/footer.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/footer.tpl';
		} else {
			$this->template = 'default/template/studio/footer.tpl';
		}
		
		$this->render();
	}
}
?>