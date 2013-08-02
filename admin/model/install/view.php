<?php
class ModelInstallView extends Model {

	public function dump($product_id)
	{
		$this->load->model('install/region');
		
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_view WHERE product_id='".$product_id."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$view_index = $result['view_index'];
					$view['view'] = $result;
					$view['regions'] = $this->model_install_region->dump($product_id, $view_index);
					$view['view_fill'] = $this->dump_fills($product_id, $view_index);
					$response[] = $view;
				}	
			} else {
				throw new ErrorException("ERROR: Product without views");
			}
		}
		return $response;
	}	
	private function dump_fills($product_id, $view_index)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_view_fill WHERE product_id='".$product_id."' AND view_index='".$view_index."' ORDER BY view_fill_index ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result;
				}
			} else {
				throw new ErrorException("ERROR: View without fills");
			}
		}
		return $response;
	}

}
?>