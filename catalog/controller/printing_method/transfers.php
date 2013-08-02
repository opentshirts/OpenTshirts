<?php  
class ControllerPrintingMethodTransfers extends Controller {

	public function index() {

		if (isset($this->request->post['studio_id']) && isset($this->session->data['studio_data'][$this->request->post['studio_id']])) {
			$this->session->data['studio_data'][$this->request->post['studio_id']]['printing_method'] = 'transfers';
		}


		$js_array_colors = json_encode($this->config->get('transfers_colors'));

		$this->response->setOutput("


				<script type='text/javascript'>
				$(function() {

					var javascript_array = ". $js_array_colors . ";
					getMovie().filterColors(javascript_array);
					getMovie().hideUsedColors();
					$(document).trigger('onPrintingMethodChange', 'transfers');
				});
				</script>

			");

	}



	public function getHTML() {

		$this->language->load('printing_method/transfers');

		$this->load->model('printing_method/transfers');

		$studio_data = &$this->session->data['studio_data'][$this->request->post['price_studio_id']]; //make it short

		$printing_total = $this->{'model_printing_method_transfers'}->getPrintingTotal($this->request->post['price_studio_id']);
		$this->data['printing_total'] = $this->currency->format($printing_total);

		
		if (isset($this->request->post['price_studio_id']) && isset($this->session->data['studio_data'][$this->request->post['price_studio_id']]['views'])) {
			$this->data['views'] = $this->session->data['studio_data'][$this->request->post['price_studio_id']]['views'];
		} else {
			$this->data['views'] = array();
		}

		$this->data['text_printing_price'] = $this->language->get('text_printing_price');
		$this->data['text_print_on'] = $this->language->get('text_print_on');

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/printing_method/transfers.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/printing_method/transfers.tpl';
		} else {
			$this->template = 'default/template/printing_method/transfers.tpl';
		}
		
		$this->response->setOutput($this->render());
	}
}
?>