<?php 
class ModelPrintingMethodScreenprinting extends Model {

  	public function validatePrinting($studio_id) {

  		$return_array = array();

  		$this->load->model('opentshirts/price_quote');

      $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

  		$amount_products = $this->model_opentshirts_price_quote->countProductsInMatrix($studio_data['quantity_s_c']);

      $min_quantity = $this->getMinQuantity();

  		if (!isset($studio_data['views']) || !is_array($studio_data['views'])) {
  			$return_array['warning_code'] = 'error_printing_empty';
  		} elseif ($min_quantity === false || $this->getMaxColors()===false) {
  			$return_array['warning_code'] = 'error_printing_max_colors_error';
  		} elseif ($min_quantity > $amount_products) {
  			$return_array['warning_code'] = 'error_printing_min_quantity';
        $return_array['warning_code_params'] = array();
        $return_array['warning_code_params'][] = $min_quantity;
        $return_array['warning_code_params'][] = $amount_products;
  		} else {
            //add whitebase if needed
            $this->checkWhitebase($studio_id);
            $max_colors =  $this->getMaxColors();
            foreach($studio_data['views'] as $key=>$view) { 
              if (!empty($view['apply_white_base_array'])) {
                  $view['num_colors'] = ($view['num_colors']>0)?$view['num_colors']+1:0; //add 1 color for whitebase
              }
                if($view['num_colors']>$max_colors)
                {
                    $return_array['warning_code'] = 'error_printing_max_colors';
                    $return_array['warning_code_params'] = array();
                    $return_array['warning_code_params'][] = $max_colors;
                    $return_array['warning_code_params'][] = $view['num_colors'];
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

    //add white base to color counting if neccessary
    private function checkWhitebase($studio_id) {
        $this->load->model('opentshirts/product_color');

        $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

        $all_colors = $this->model_opentshirts_product_color->getColors();
        foreach($studio_data['views'] as $key=>&$view) { //view by reference becase we add apply_white_base_array to the view
            $view["apply_white_base_array"] = array();
            foreach($studio_data['quantity_s_c'] as $id_product_color=>$array_sizes) {
                foreach($array_sizes as $id_product_size=>$quantity) {
                    if($quantity) { //Only colors and sizes available for this product.
                        if($all_colors[$id_product_color]["need_white_base"]=='1') {
                            if($view["need_white_base"]=="true")///artwork needs white base
                            {
                                $view["apply_white_base_array"][] = $id_product_color;
                            }   
                        }
                    }
                }
            }
        }
        unset($view);
    }


  	public function getMaxColors()
    {
      $sql = "SELECT MAX(num_colors) as maximum FROM ".DB_PREFIX."screenprinting_quantity_price  ";
      $query = $this->db->query($sql);
      if($query->row["maximum"]=="")
      {
        return false;
      }else
      {
        return $query->row["maximum"];
      }

    }

    public function getMinQuantity()
    {
      $sql = "SELECT MIN(quantity) as minimum FROM ".DB_PREFIX."screenprinting_quantity  ";
      $query = $this->db->query($sql);
      if($query->row["minimum"]=="")
      {
        return false;
      }else
      {
        return $query->row["minimum"];
      }

    }
  	
  	/**
  	* return an array where key=number_of_colors, value=price
  	*/
  	public function getPrintingPricesFromQuantity($quantity)
  	{
  		$sql  = " SELECT quantity_index, screen_charge FROM ".DB_PREFIX."screenprinting_quantity  ";
  		$sql .= " WHERE quantity<=".(int)$quantity." ";
  		$sql .= " ORDER BY quantity DESC LIMIT 1 ";
  		
  		$query = $this->db->query($sql);
  		if($query->num_rows==0) {
  			return false;
  		} else {

  			$quantity_index = $query->row["quantity_index"]; //column to take prices from
            $screen_charge = $query->row["screen_charge"];
  			
  			$sql  = " SELECT price, num_colors FROM  ".DB_PREFIX."screenprinting_quantity_price "; 
  			$sql .= " WHERE quantity_index=".(int)$quantity_index." ";
  			$query = $this->db->query($sql);
  			
  			if($query->num_rows==0) {
  				return false;
  			} else {
  				$prices = array();
  				foreach ($query->rows as $result) {
  					$prices[$result["num_colors"]] = $result["price"];
  				}
                $return = array();
                $return['prices'] = $prices;
                $return['screen_charge'] = $screen_charge;

  				return $return;
  			}
  		}
  	}


  	public function getPrintingTotal($studio_id) {

        $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

		$this->load->model('opentshirts/price_quote');
  		$amount_products = $this->model_opentshirts_price_quote->countProductsInMatrix($studio_data['quantity_s_c']);

  		$printing_total = 0;
  		$printing_prices = $this->getPrintingPricesFromQuantity($amount_products);

  		foreach($studio_data['quantity_s_c'] as $id_product_color=>$array_sizes) {
  			foreach($array_sizes as $id_product_size=>$quantity) {
  				if($quantity) { //Only colors and sizes available for this product.
  					foreach($studio_data['views'] as $key=>$view) {
  						$num_colors = (int)$view["num_colors"];
                        
                        if (in_array($id_product_color, $view['apply_white_base_array'])) {
                            $num_colors = ($num_colors>0)?$num_colors+1:0; //add 1 color for whitebase
                            
                        }
  						//add printing price
  						if($num_colors > 0) {
  							$printing_total += $printing_prices['prices'][$num_colors] * $quantity;
  						}
  					}
  				}
  			}
  		}

        //add screen_charge
        foreach($studio_data['views'] as $key=>$view) {
            $num_colors = (int)$view["num_colors"];

            if (!empty($view['apply_white_base_array'])) {
              $num_colors = ($num_colors>0)?$num_colors+1:0; //add 1 color for whitebase
            }

            $printing_total += $printing_prices['screen_charge'] * $num_colors;
            
        }


  		return $printing_total;
  	}

    
}
?>