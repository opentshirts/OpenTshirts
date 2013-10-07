<?php
class ScreenprintingCart {
	private $config;
	private $session;
	private $db;
	private $data;
	
  	public function __construct($config, $session, $db, &$data) {
		$this->config = $config;
		$this->session = $session;
		$this->db = $db;
		$this->data = &$data;
	}
	public function getPrintData($key) {

		$return = array(
			'flag_remove' => false,
			'option_price' => 0,
			'option_data' => array()
		);

		$composition = explode(':', $key);

		$id_composition = $composition[0];

		// Options
		if (isset($composition[1])) {
			$options = unserialize(base64_decode($composition[1]));
		} else {
			trigger_error("options for printable product not defined: ", E_USER_ERROR);
		} 

		$composition_query = $this->db->query("SELECT * FROM " . DB_PREFIX . "composition c LEFT JOIN " . DB_PREFIX . "design d ON (c.id_composition = d.id_composition) WHERE c.id_composition = '" . $id_composition . "' AND c.deleted = '0' AND c.editable = '1' ");

		$amount_products = 0;
		foreach ($this->session->data['cart'] as $key_2 => $quantity_2) {
			$product_2 = explode(':', $key_2);
			
			if ($product_2[0] == $id_composition) {
				$amount_products += $quantity_2;
			}
		}





		$printing_prices = array();
		$query_printing_quantity = $this->db->query("SELECT quantity_index, screen_charge FROM " . DB_PREFIX . "screenprinting_quantity WHERE quantity <= " . (int)$amount_products . " ORDER BY quantity DESC LIMIT 1 ");
		if($query_printing_quantity->num_rows==0) {
			$return['flag_remove'] = true;
		} else {

			$quantity_index = $query_printing_quantity->row["quantity_index"]; //column to take prices from
			$screen_charge = $query_printing_quantity->row["screen_charge"];
			$query_printing_quantity_price = $this->db->query("SELECT price, num_colors FROM " . DB_PREFIX . "screenprinting_quantity_price WHERE quantity_index = " . (int)$quantity_index . " ");
			
			if($query_printing_quantity_price->num_rows==0) {
				$return['flag_remove'] = true;
			} else {
				
				foreach ($query_printing_quantity_price->rows as $result) {
					$printing_prices[$result["num_colors"]] = $result["price"];
				}
			}
		}

		$return['option_data'][] = array(
			'product_option_id'       => '',
			'product_option_value_id' => '',
			'option_id'               => '',
			'option_value_id'         => '',
			'name'                    => 'Printing Method',
			'option_value'            => 'Screenprinting',
			'type'                    => '',
			'quantity'                => '',
			'subtract'                => '',
			'price'                   => '0',
			'price_prefix'            => '+',
			'points'                  => '0',
			'points_prefix'           => '+',								
			'weight'                  => '0',
			'weight_prefix'           => '+'
		);
		
		foreach ($options['views'] as $value) {

			$whitebase = (in_array($options['id_product_color'], $value['apply_white_base_array']))?" (+1 whitebase)":"";

			$printing_price = 0;
			$num_colors = $value['num_colors'];

			if(in_array($options['id_product_color'], $value['apply_white_base_array'])) {
				$num_colors = ($num_colors>0)?$num_colors+1:0; //add 1 color for whitebase
			}

			if($num_colors > 0) {
				$printing_price = $printing_prices[$num_colors];
				$return['option_price'] += $printing_prices[$num_colors];
			}

			$return['option_data'][] = array(
				'product_option_id'       => '',
				'product_option_value_id' => '',
				'option_id'               => '',
				'option_value_id'         => '',
				'name'                    => 'Colors to print on '.$value['name'],
				'option_value'            => $value['num_colors'].$whitebase,
				'type'                    => '',
				'quantity'                => '',
				'subtract'                => '',
				'price'                   => $printing_price,
				'price_prefix'            => '+',
				'points'                  => '0',
				'points_prefix'           => '+',								
				'weight'                  => '0',
				'weight_prefix'           => '+'
			);
		}

		//add screencharge only once for every composition
		$screen_charge_key = 'screens-'.$composition_query->row['id_composition'];

		if(!isset($this->data[$screen_charge_key])) {

			$total_screens = 0;

			foreach ($options['views'] as $value) {
				$num_colors = $value['num_colors'];

				if(!empty($value['apply_white_base_array'])) {
					$num_colors = ($num_colors>0)?$num_colors+1:0; //add 1 color for whitebase
				}

				if($num_colors > 0) {
					$total_screens += $num_colors;
				}


			}

			$recurring = false;
            $recurring_frequency = 0;
            $recurring_price = 0;
            $recurring_cycle = 0;
            $recurring_duration = 0;
            $recurring_trial_status = 0;
            $recurring_trial_price = 0;
            $recurring_trial_cycle = 0;
            $recurring_trial_duration = 0;
            $recurring_trial_frequency = 0;
            $profile_name = '';
            $profile_id = 0;

			$this->data[$screen_charge_key] = array(
				'key'             => $screen_charge_key,
				'id_composition'  => $composition_query->row['id_composition'] ,
				'product_id'      => 999,
				'name'            => 'Screen Charge for '.$composition_query->row['name'],
				'model'           => '',
				'shipping'        => 0,
				'image'           => 'data/printing_methods/screenprinting/screens.jpg',
				'option'          => array(),
				'download'        => array(),
				'quantity'        => $total_screens,
				'minimum'         => 1,
				'subtract'        => 0,
				'stock'           => true,
				'price'           => $screen_charge,
				'total'           => $screen_charge * $total_screens,
				'reward'          => 0,
				'points'          => 0,
				'tax_class_id'    => 0,
				'weight'          => 0,
				'weight_class_id' => $this->config->get('config_weight_class_id'),
				'length'          => 0,
				'width'           => 0,
				'height'          => 0,
				'length_class_id' => $this->config->get('config_length_class_id'),
				'profile_id'                => $profile_id,
                'profile_name'              => $profile_name,
                'recurring'                 => $recurring,
                'recurring_frequency'       => $recurring_frequency,
                'recurring_price'           => $recurring_price,
                'recurring_cycle'           => $recurring_cycle,
                'recurring_duration'        => $recurring_duration,
                'recurring_trial'           => $recurring_trial_status,
                'recurring_trial_frequency' => $recurring_trial_frequency,
                'recurring_trial_price'     => $recurring_trial_price,
                'recurring_trial_cycle'     => $recurring_trial_cycle,
                'recurring_trial_duration'  => $recurring_trial_duration		
			);
		}
		return $return;
	}
}
?>