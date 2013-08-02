<?php  
class ControllerPrintingMethodScreenprinting extends Controller {

	public function index() {

		if (isset($this->request->post['studio_id']) && isset($this->session->data['studio_data'][$this->request->post['studio_id']])) {
			$this->session->data['studio_data'][$this->request->post['studio_id']]['printing_method'] = 'screenprinting';
		}

		$js_array_colors = json_encode($this->config->get('screenprinting_colors'));

		$this->response->setOutput("


				<script type='text/javascript'>
				$(function() {

					var javascript_array = ". $js_array_colors . ";
					getMovie().filterColors(javascript_array);
					//getMovie().hideUsedColors();
					$(document).trigger('onPrintingMethodChange', 'screenprinting');
				});
				</script>

			");

	}



	public function getHTML() {

		$this->language->load('printing_method/screenprinting');

		$this->load->model('printing_method/screenprinting');

		$this->load->model('opentshirts/product_color');
		
		$all_colors = $this->model_opentshirts_product_color->getColors();

		$studio_data = &$this->session->data['studio_data'][$this->request->post['price_studio_id']]; //make it short

		$printing_total = $this->{'model_printing_method_screenprinting'}->getPrintingTotal($this->request->post['price_studio_id']);
		$this->data['printing_total'] = $this->currency->format($printing_total);

		$colors = "";
		foreach ($studio_data['views'] as $view) {
			if(!empty($view["apply_white_base_array"])) {
				foreach ($view["apply_white_base_array"] as $id_product_color) {
					$colors .= "\n".$all_colors[$id_product_color]["name"];
				}
			}			
		}

		if($colors) {
			$this->data["colors_text"] = $this->language->get('text_whitebase_colors').$colors;
		}
					
		if (isset($this->request->post['price_studio_id']) && isset($this->session->data['studio_data'][$this->request->post['price_studio_id']]['views'])) {
			$this->data['views'] = $this->session->data['studio_data'][$this->request->post['price_studio_id']]['views'];
		} else {
			$this->data['views'] = array();
		}

		$this->data['text_apply_whitebase'] = $this->language->get('text_apply_whitebase');
		$this->data['text_printing_price'] = $this->language->get('text_printing_price');
		$this->data['text_colors_on'] = $this->language->get('text_colors_on');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/printing_method/screenprinting.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/printing_method/screenprinting.tpl';
		} else {
			$this->template = 'default/template/printing_method/screenprinting.tpl';
		}
		
		$this->response->setOutput($this->render());
	}
}
?>