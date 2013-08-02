<?php
class ModelOpentshirtsPriceQuote extends Model {

	public function countProductsInMatrix($matrix_color_size_quantity)
	{
		$total_number_products = 0;
		foreach($matrix_color_size_quantity as $id_product_color=>$sizes)
		{
			foreach($sizes as $id_product_size=>$quantity)
			{
				if(is_numeric($quantity) && (int)$quantity>0)
				{
					$total_number_products += (int)($quantity);
				}
			}
		}
		return $total_number_products;
	}
	
	/*
	* Check what sizes and colors are valid for this particular product 
	* and verifies that the values ​​of quantities received are valid numbers.
	*/
	public function cleanMatrix($matrix_color_size_quantity, $id_product)
	{
		$this->load->model('opentshirts/product');

		//product colors and sizes
		$distinct_product_colors = $this->model_opentshirts_product->getColors($id_product);
		$distinct_product_sizes = $this->model_opentshirts_product->getSizes($id_product);	
		$available_colors_sizes = $this->model_opentshirts_product->getColorsSizes($id_product);
		
		$validMatrix = array();
		foreach($distinct_product_colors as $id_product_color) {
			foreach($distinct_product_sizes as $id_product_size) {
				if(isset($available_colors_sizes[$id_product_color][$id_product_size])) { //Only colors and sizes available for this product.
					//validate quantities
					if(!empty($matrix_color_size_quantity[$id_product_color][$id_product_size]) && is_numeric($matrix_color_size_quantity[$id_product_color][$id_product_size]) && (int)$matrix_color_size_quantity[$id_product_color][$id_product_size]>0) {
						$quantity = (int)$matrix_color_size_quantity[$id_product_color][$id_product_size];
					} else {
						$quantity = 0;
					}
					///hold quantities for each product size/color available for this product
					$validMatrix[$id_product_color][$id_product_size] = $quantity;
				} else {
					$validMatrix[$id_product_color][$id_product_size] = false;
				}
			}
		}
		return $validMatrix;		
	}

}
?>