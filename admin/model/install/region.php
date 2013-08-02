<?php
class ModelInstallRegion extends Model {

	public function dump($product_id, $view_index)
	{		
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "product_view_region WHERE product_id='".$product_id."' AND view_index='".$view_index."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result;
				}	
			} else {
				throw new ErrorException("ERROR: View without regions");
			}
		}
		return $response;
	}	

}
?>