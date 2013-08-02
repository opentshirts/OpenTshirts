<?php
class ModelInstallComposition extends Model {
	public function install($composition_obj, $file, $overwrite = false)
	{
		if(isset($composition_obj->composition->id_composition)) { //if already exists just return
			$query = $this->db->query("SELECT id_composition FROM `" . DB_PREFIX . "composition` WHERE id_composition='".$composition_obj->composition->id_composition."' ");
			if($query->num_rows>0)
			{
				if($overwrite) {
					$this->load->model('composition/composition');
					$this->model_composition_composition->remove($composition_obj->composition->id_composition);
				} else {
					return false;
				}
			}
		}
		
		$sql  = "INSERT INTO " . DB_PREFIX . "composition SET ";
		$sql .= " id_composition = '" . $composition_obj->composition->id_composition . "',";
		$sql .= " name = '" . $this->db->escape($composition_obj->composition->name) . "', ";
		$sql .= " id_author = '" . $this->db->escape($composition_obj->composition->id_author) . "', ";
		$sql .= " id_product_color = '" . $this->db->escape($composition_obj->composition->id_product_color) . "', ";
		$sql .= " product_id = '" . $this->db->escape($composition_obj->composition->id_product) . "', ";
		$sql .= " status = '" . $this->db->escape($composition_obj->composition->status) . "', ";
		$sql .= " deleted = 0, ";
		$sql .= " editable = '" . $this->db->escape($composition_obj->composition->editable) . "', ";
		$sql .= " date_added = NOW() ";
		
		$query = $this->db->query($sql);
		
		$ID = $composition_obj->composition->id_composition;
		
		foreach($composition_obj->categories as $id_category)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'composition_composition_category` ';
			$fields .= '(`id_composition`,`id_category`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$id_category.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
			
			$query = $this->db->query($sql);
		}
	
		foreach($composition_obj->keywords as $keyword)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'composition_keyword` ';
			$fields .= '(`id_composition`,`keyword`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$this->db->escape($keyword).'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}
		
		foreach($composition_obj->designs as $design_obj)
		{
			$sql  = "INSERT INTO " . DB_PREFIX . "design SET ";
			$sql .= " id_composition = '" . $ID . "',";
			$sql .= " id_design = '" . $this->db->escape($design_obj->design->id_design) . "', ";
			$sql .= " xml = '" . $this->db->escape($design_obj->design->xml) . "' ";
			
			$query = $this->db->query($sql);
			
			$id_design = $design_obj->design->id_design;

			$design_dir = DIR_IMAGE . 'data/designs/design_' . $id_design;
			if(!is_dir($design_dir)){
				if(!mkdir($design_dir)) {
					trigger_error ("error trying to create dir ".$design_dir, E_USER_ERROR);
				} else {
					if(!chmod($design_dir, 0777)) {
						trigger_error ("error trying to set permission 0777 dir ".$design_dir, E_USER_ERROR);
					}
				}
			}
			
			@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/designs/design_' . $design_obj->design->id_design . '/snapshot.png',  $design_dir . '/snapshot.png');
			@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/designs/design_' . $design_obj->design->id_design . '/design_image.png',  $design_dir . '/design_image.png');                   
                        
			foreach($design_obj->design_elements as $design_element_obj)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "design_element SET ";
				$sql .= " id_design = '" . $id_design . "',";
				$sql .= " sorting = '" . $design_element_obj->sorting . "', ";
				$sql .= " id_design_element = '" . $design_element_obj->id_design_element . "', ";
				$sql .= " type = '" . $design_element_obj->type . "' ";
				
				$query = $this->db->query($sql);

			}
			
		}
		
		
		return $ID;
	}
	
	public function get_files($id_composition)
	{
		$files = array();
		
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "design WHERE id_composition='".$id_composition."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result) {
					$files[] = array('source'=> DIR_IMAGE . 'data/designs/design_'.$result['id_design'].'/snapshot.png', 'dest'=> basename(DIR_IMAGE) . '/data/designs/design_'.$result['id_design'].'/snapshot.png');
                    $files[] = array('source'=> DIR_IMAGE . 'data/designs/design_'.$result['id_design'].'/design_image.png', 'dest'=> basename(DIR_IMAGE) . '/data/designs/design_'.$result['id_design'].'/design_image.png');
                }
			} else {
				throw new ErrorException("ERROR: composition without designs");
			}
		}
		return $files;
	}	

	
	public function dump($id_composition)
	{
		$this->load->model('install/design');
		
		$response = array();
		$response['composition'] = $this->dump_composition_fields($id_composition);
		$response['categories'] = $this->dump_composition_categories($id_composition);
		$response['keywords'] = $this->dump_composition_keywords($id_composition);
		$response['designs'] = $this->model_install_design->dump($id_composition);
		return $response;
	}
	
	private function dump_composition_fields($id_composition)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "composition WHERE id_composition='".$id_composition."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				unset($row['deleted']);
				unset($row['date_added']);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: composition doesnt exists");
			}
		}
		return $response;
	}
	
	private function dump_composition_categories($id_composition)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "composition_composition_category WHERE id_composition='".$id_composition."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result['id_category'];
				}	
			}
		}
		return $response;
	}
	
	private function dump_composition_keywords($id_composition)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "composition_keyword WHERE id_composition='".$id_composition."' "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					$response[] = $result['keyword'];
				}	
			}
		}
		return $response;
	}
}
?>