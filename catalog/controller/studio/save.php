<?php  
class ControllerStudioSave extends Controller {
	public function index() {
				
		$this->load->library('user');
		$this->user = new User($this->registry);

		$this->language->load('studio/save');

		if(!$this->customer->isLogged() && !$this->user->isLogged())
		{
			if(($this->config->get('config_use_ssl') || $this->config->get('config_secure')) && !isset($this->request->server['HTTPS'])) {
				$this->response->setOutput($this->language->get('text_ssl_log_in_first'));
				return;
			} else {
				
				$query_string = "1=1";

				if(isset($this->request->get['studio_id'])) {
					$query_string .= '&studio_id=' . $this->request->get['studio_id'];
				}
				
				if(isset($this->request->get['add'])) {
					$query_string .= '&add=' . $this->request->get['add'];
				}

				if (isset($this->request->server['HTTPS']) && (($this->request->server['HTTPS'] == 'on') || ($this->request->server['HTTPS'] == '1'))) {
					$this->session->data['redirect'] = $this->url->link('studio/save',$query_string,'SSL');
				} else {
					$this->session->data['redirect'] = $this->url->link('studio/save',$query_string);
				}

				$this->redirect($this->url->link('studio/login', '', 'SSL'));
			}
		}

		$this->data['entry_design_name'] = $this->language->get('entry_design_name');
		$this->data['text_save_design'] = $this->language->get('text_save_design');
		$this->data['text_saving_design'] = $this->language->get('text_saving_design');
		
		if($this->user->isLogged()) {
			$this->data['text_saved_successfully'] = $this->language->get('text_design_idea_saved_successfully');
		} else {
			$this->data['text_saved_successfully'] = $this->language->get('text_design_saved_successfully');
		}
		$this->data['text_saved_error'] = $this->language->get('text_saved_error');
		
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/image/loading.gif')) {
			$this->data['loading_image'] = 'catalog/view/theme/'.$this->config->get('config_template') . '/image/loading.gif';
		} else {
			$this->data['loading_image'] = 'image/loading.gif';
		}

		$this->data['design_name'] = $this->language->get('text_my_custom_design'); //default name
			
		if(isset($this->request->get['studio_id']) && isset($this->session->data['studio_data'][$this->request->get['studio_id']]['id_composition'])) {
			$idc = $this->session->data['studio_data'][$this->request->get['studio_id']]['id_composition'];
			$this->load->model('opentshirts/composition');
			$total = $this->model_opentshirts_composition->getTotalCompositions(array('filter_id_composition' => $idc));
			if($total) {
				$data = $this->model_opentshirts_composition->getComposition($idc);
				$this->data['design_name'] = $data['name'];
			}
		}
		
		if(isset($this->request->get['add'])) {
			$this->data['add_after_save'] = true;
		} else {
			$this->data['add_after_save'] = false;
		}
				
		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/save.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/save.tpl';
		} else {
			$this->template = 'default/template/studio/save.tpl';
		}
					
		$this->response->setOutput($this->render());
	}

	public function save_container() {

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/studio/save_container.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/studio/save_container.tpl';
		} else {
			$this->template = 'default/template/studio/save_container.tpl';
		}

		$this->response->setOutput($this->render());
		
	}
}
?>