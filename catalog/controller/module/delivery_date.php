<?php
class ControllerModuleDeliveryDate extends Controller {
	protected function index($setting) {
		$this->language->load('module/delivery_date');
 
      	$this->data['text_order_today'] = $this->language->get('text_order_today');

		$this->data['text_rush_shipping'] = html_entity_decode($this->config->get('delivery_date_rush_title'));
		$this->data['text_free_shipping'] = html_entity_decode($this->config->get('delivery_date_free_title'));


		//$this->data['rush_month'] = date("M", strtotime(" +".$setting['days_rush'] ." day"));
		$this->data['rush_month'] = date("M", $this->getNextBussinesDay(strtotime(" +".$setting['days_rush'] ." day")));
		$this->data['rush_day'] = date("d", $this->getNextBussinesDay(strtotime(" +".$setting['days_rush'] ." day")));
		$this->data['free_month'] = date("M", $this->getNextBussinesDay(strtotime(" +".$setting['days_free'] ." day")));
		$this->data['free_day'] = date("d", $this->getNextBussinesDay(strtotime(" +".$setting['days_free'] ." day")));
		$this->data['shipping_link'] = $setting['shipping_link'];

		

		if (file_exists(DIR_TEMPLATE . $this->config->get('config_template') . '/template/module/delivery_date.tpl')) {
			$this->template = $this->config->get('config_template') . '/template/module/delivery_date.tpl';
		} else {
			$this->template = 'default/template/module/delivery_date.tpl';
		}

		$this->render();
	}

	private function getNextBussinesDay($time_stamp) {

		if(!$this->validate($time_stamp)) {
			return $this->getNextBussinesDay(strtotime('+1 day', $time_stamp));
		} else {
			return $time_stamp;
		}
	}
	private function validate($time_stamp) {
		//validate day of week
		$day = date("D", $time_stamp);
		$skip_days = $this->config->get('delivery_date_skip');
		if(isset($skip_days[$day])) {
			return false;
		}

		//validate holidays day
		if($this->config->get('delivery_date_holidays')) {
			foreach ($this->config->get('delivery_date_holidays') as $holiday) {
				if(date("n-j", $time_stamp) == $holiday['month'].'-'.$holiday['day']) {
					return false;
				}
			}
		}
		
		return true;
	}
}
?>