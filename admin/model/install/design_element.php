<?php
class ModelInstallDesignElement extends Model {

	public function dump($id_design)
	{		
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "design_element WHERE id_design='".$id_design."' ORDER BY sorting ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result;
				}	
			} else {
				throw new ErrorException("ERROR: design without elements");
			}
		}
		return $response;
	}	

}
?>