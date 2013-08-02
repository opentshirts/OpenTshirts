<?php
class ModelInstallDesign extends Model {

	public function dump($id_composition)
	{
		$this->load->model('install/design_element');
		
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "design WHERE id_composition='".$id_composition."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$design['design'] = $result;
					$design['design_elements'] = $this->model_install_design_element->dump($result['id_design']);
					$response[] = $design;
				}	
			} else {
				throw new ErrorException("ERROR: Composition without designs");
			}
		}
		return $response;
	}
}
?>