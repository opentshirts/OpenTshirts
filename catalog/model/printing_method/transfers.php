<?php 
class ModelPrintingMethodTransfers extends Model {

  	public function validatePrinting($studio_id) {

  		$return_array = array();

  		$this->load->model('opentshirts/price_quote');

        $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

  		if (!isset($studio_data['views']) || !is_array($studio_data['views'])) {
  			$return_array['warning_code'] = 'error_printing_empty';
  		} else {
            $amount_products = $this->model_opentshirts_price_quote->countProductsInMatrix($studio_data['quantity_s_c']);

            foreach($studio_data['views'] as $key=>$view) {
                ///are prices saved for this amount of products and area size?
                if ($this->getPrintingPricesFromQuantityArea($amount_products, (float)($view['area_size_w'] * $view['area_size_h']))===false) {
                  $return_array['warning_code'] = $this->language->get('error_printing_price_array');
                  break;
                }
            }
  		}

  		$something_to_print = false;
  		if(isset($studio_data['views'])) {
  			foreach($studio_data['views'] as $key=>$view) {
  				$num_elements = (int)$view["num_elements"];
  				if($num_elements>0) {
  					$something_to_print = true;
  					break;
  				}
  			}
  		}
  		if(empty($studio_data['views']) || !$something_to_print) {
  			$return_array['warning_code'] = 'error_printing_empty';
  		}

  		if (!$return_array) {
  			return false;
  		} else {
  			return $return_array;
  		}	
  	}

    public function getPrintingPricesFromQuantityArea($quantity, $area)
    {
        $sql  = " SELECT quantity_index FROM " . DB_PREFIX . "transfers_printing_quantity  ";
        $sql .= " WHERE quantity<=".(int)$quantity." ";
        $sql .= " ORDER BY quantity DESC LIMIT 1 ";

        $query = $this->db->query($sql);
        if($query->num_rows==0) {
            return false;
        } else {

            $quantity_index = $query->row["quantity_index"]; //column to take prices from
            
            $sql  = " SELECT * FROM  " . DB_PREFIX . "transfers_printing_quantity_price "; 
            $sql .= " WHERE quantity_index=".(int)$quantity_index." AND area<=".(float)$area." ";
            $sql .= " ORDER BY area DESC LIMIT 1 ";
            $query = $this->db->query($sql);
            
            if($query->num_rows==0) {
              return false;
            } else {
              $price = $query->row["price"];
              return $price;
            }
        }
    }

  	public function getPrintingTotal($studio_id) {

        $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

  		$this->load->model('opentshirts/price_quote');
  		$amount_products = $this->model_opentshirts_price_quote->countProductsInMatrix($studio_data['quantity_s_c']);

        $printing_total = 0;
  		foreach($studio_data['views'] as $key=>$view) {
            $num_elements = (int)$view["num_elements"];
            if($num_elements>0) {
                $printing_price = $this->getPrintingPricesFromQuantityArea($amount_products, (float)($view['area_size_w'] * $view['area_size_h']));
                $printing_total += $printing_price * $amount_products;
            }
  		}
  		return $printing_total;
  	}
}
?>