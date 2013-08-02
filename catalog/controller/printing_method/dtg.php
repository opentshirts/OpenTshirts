<?php  
class ControllerPrintingMethodDtg extends Controller {

	public function index() {

		if (isset($this->request->post['studio_id']) && isset($this->session->data['studio_data'][$this->request->post['studio_id']])) {
			$this->session->data['studio_data'][$this->request->post['studio_id']]['printing_method'] = 'dtg';
		}

		$js_array_colors = json_encode($this->config->get('dtg_colors'));

		$this->response->setOutput("


				<script type='text/javascript'>
				$(function() {

					var javascript_array = ". $js_array_colors . ";
					getMovie().filterColors(javascript_array);
					getMovie().hideUsedColors();
					$(document).trigger('onPrintingMethodChange', 'dtg');
				});
				</script>

			");

	}



	public function getHTML() {

		$this->language->load('printing_method/dtg');

		$this->load->model('printing_method/dtg');

		$this->load->model('opentshirts/product_color');
		
		$all_colors = $this->model_opentshirts_product_color->getColors();

		$studio_data = &$this->session->data['studio_data'][$this->request->post['price_studio_id']]; //make it short

		$printing_total = $this->{'model_printing_method_dtg'}->getPrintingTotal($this->request->post['price_studio_id']);
		$this->data['printing_total'] = $this->currency->format($printing_total);

		$colors_whitebase_1 = "";
		$colors_whitebase_2 = "";
		foreach ($studio_data['views'] as $view) {
			if(!empty($view["apply_white_base_1_array"])) {
				foreach ($view["apply_white_base_1_array"] as $id_product_color) {
					$colors_whitebase_1 .= "\n".$all_colors[$id_product_color]["name"];
				}
			}	
			if(!empty($view["apply_white_base_2_array"])) {
				foreach ($view["apply_white_base_2_array"] as $id_product_color) {
					$colors_whitebase_2 .= "\n".$all_colors[$id_product_color]["name"];
				}
			}			
		}

		$this->data["colors_text_1"] = $this->language->get('text_whitebase_1_colors').$colors_whitebase_1;
		$this->data["colors_text_2"] = $this->language->get('text_whitebase_2_colors').$colors_whitebase_2;
		
					
		if (isset($this->request->post['price_studio_id']) && isset($this->session->data['studio_data'][$this->request->post['price_studio_id']]['views'])) {
			$this->data['views'] = $this->session->data['studio_data'][$this->request->post['price_studio_id']]['views'];
		} else {
			$this->data['views'] = array();
		}

		$this->data['text_apply_whitebase_1'] = $this->language->get('text_apply_whitebase_1');
		$this->data['text_apply_whitebase_2'] = $this->language->get('text_apply_whitebase_2');
		$this->data['text_printing_price'] = $this->language->get('text_printing_price');
		$this->data['text_print_on'] = $this->language->get('text_print_on');

		

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/printing_method/dtg.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/printing_method/dtg.tpl';
		} else {
			$this->template = 'default/template/printing_method/dtg.tpl';
		}
		
		$this->response->setOutput($this->render());
	}
}
?>