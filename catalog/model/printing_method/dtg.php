<?php 
class ModelPrintingMethodDtg extends Model {

  	public function validatePrinting($studio_id) {

  		$return_array = array();

  		$this->load->model('opentshirts/product_color');
  		$this->load->model('opentshirts/price_quote');

      $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

  		if (!isset($studio_data['views']) || !is_array($studio_data['views'])) {
  			$return_array['warning_code'] = 'error_printing_empty';
  		} else {
            //add whitebase if needed
            $this->checkWhitebase($studio_id);

            $all_colors = $this->model_opentshirts_product_color->getColors();
            $amount_products = $this->model_opentshirts_price_quote->countProductsInMatrix($studio_data['quantity_s_c']);

            foreach($studio_data['views'] as $key=>$view) {
                ///are prices saved for this amount of products and area size?
                if ($this->getPrintingPricesFromQuantityArea($amount_products, (float)($view['area_size_w'] * $view['area_size_h']), 1)===false) {
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

    //add white base to color counting if neccessary
    private function checkWhitebase($studio_id) {
        $this->load->model('opentshirts/product_color');

        $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

        $all_colors = $this->model_opentshirts_product_color->getColors();
        foreach($studio_data['views'] as $key=>&$view) { //view by reference becase we add apply_white_base_array to the view
            $view["apply_white_base_1_array"] = array();
            $view["apply_white_base_2_array"] = array();
            foreach($studio_data['quantity_s_c'] as $id_product_color=>$array_sizes) {
                foreach($array_sizes as $id_product_size=>$quantity) {
                    if($quantity) { //Only colors and sizes available for this product.
                        if($all_colors[$id_product_color]["need_white_base"]=='1') {
                            if($view["need_white_base"]=="true")///artwork needs white base
                            {
                                if($all_colors[$id_product_color]["id_product_color_group"]=="2") {//medium
                                    $view["apply_white_base_1_array"][] = $id_product_color;
                                } elseif ($all_colors[$id_product_color]["id_product_color_group"]=="3") {//dark
                                    $view["apply_white_base_2_array"][] = $id_product_color;
                                }
                            }   
                        }
                    }
                }
            }
        }
        unset($view);
        
    }

    public function getPrintingPricesFromQuantityArea($quantity, $area, $color_group = 1)
    {
      $sql  = " SELECT quantity_index FROM " . DB_PREFIX . "dtg_printing_quantity  ";
      $sql .= " WHERE quantity<=".(int)$quantity." ";
      $sql .= " ORDER BY quantity DESC LIMIT 1 ";
      
      $query = $this->db->query($sql);
      if($query->num_rows==0) {
        return false;
      } else {

        $quantity_index = $query->row["quantity_index"]; //column to take prices from
        
        $sql  = " SELECT * FROM  " . DB_PREFIX . "dtg_printing_quantity_price "; 
        $sql .= " WHERE quantity_index=".(int)$quantity_index." AND area<=".(float)$area." ";
        $sql .= " ORDER BY area DESC LIMIT 1 ";
        $query = $this->db->query($sql);
        
        if($query->num_rows==0) {
          return false;
        } else {
          switch ($color_group) {
            case 3:
              $price = $query->row["price_whitebase_2"];
              break;
            case 2:
              $price = $query->row["price_whitebase_1"];
              break;
            default:
              $price = $query->row["price"];
              break;
          }
          return $price;
        }
      }
    }

  	public function getPrintingTotal($studio_id) {

        $studio_data = &$this->session->data['studio_data'][$studio_id]; //make it short

  		$this->load->model('opentshirts/product_color');
  		$all_colors = $this->model_opentshirts_product_color->getColors();

  		$this->load->model('opentshirts/price_quote');
  		$amount_products = $this->model_opentshirts_price_quote->countProductsInMatrix($studio_data['quantity_s_c']);

        $printing_total = 0;
  		foreach($studio_data['quantity_s_c'] as $id_product_color=>$array_sizes) {
  			foreach($array_sizes as $id_product_size=>$quantity) {
  				if($quantity) { //Only colors and sizes available for this product.
  					foreach($studio_data['views'] as $key=>$view) {
                        
                        $whitebase_level = 1;

                        if (in_array($id_product_color, $view['apply_white_base_1_array']) || in_array($id_product_color, $view['apply_white_base_2_array'])) {
                            $whitebase_level = $all_colors[$id_product_color]["id_product_color_group"];
                        }

                        $num_elements = (int)$view["num_elements"];
                        if($num_elements>0) {
      						$printing_price = $this->getPrintingPricesFromQuantityArea($amount_products, (float)($view['area_size_w'] * $view['area_size_h']), $whitebase_level);
                            $printing_total += $printing_price * $quantity;
                        }
  					}
  				}
  			}
  		}
  		return $printing_total;
  	}
}
?>