<?php  
class ControllerPrintingMethodModules extends Controller {

	public function get_printing_methods() {

		$this->load->model('setting/extension');

		$this->load->language('printing_method/modules');
		
		$sort_order = array(); 
		
		$results = $this->model_setting_extension->getExtensions('printing_method');
		
		foreach ($results as $key => $value) {
			$sort_order[$key] = $this->config->get($value['code'] . '_sort_order');
		}
		
		array_multisort($sort_order, SORT_ASC, $results);
		$this->data["printing_methods"] = array();

		$this->data["popup_title"] = $this->language->get('popup_title');
		$this->data["popup_title_autoselect"] = $this->language->get('popup_title_autoselect');
		

		$this->load->model('tool/image');

		foreach ($results as $result) {
			if ($this->config->get($result['code'] . '_status')) {

				$this->load->language('printing_method/' . $result['code']);
				//$this->load->model('printing_method/' . $result['code']);

				//print($result['code']);

				$this->data["printing_methods"][] = array(
					'code' => $result['code'],
					'title' => $this->language->get('title'),
					'description' => $this->config->get($result['code'] . '_description'),
					'image' => $this->model_tool_image->resize('data/printing_methods/' . $result['code'] . '/button.png', 200, 200)
				);
			}
		}

		$this->data["autoselect"] = false;

		if($this->config->get('ot_enable_autoselect')) {
			$this->data["autoselect"] = true;
			$this->data["quantities"] = $this->config->get('ot_quantities');
			$this->data["descriptions"] = $this->config->get('ot_descriptions');
			$this->data["pm"] = $this->config->get('ot_pm');
			$this->data["popup_title_autoselect"] = $this->config->get('ot_title_text');
		}

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/printing_method/modules.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/printing_method/modules.tpl';
		} else {
			$this->template = 'default/template/printing_method/modules.tpl';
		}

		
		$this->response->setOutput($this->render());
	}
}
?>