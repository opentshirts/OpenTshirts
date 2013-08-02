<?php
class ModelInstallClipart extends Model {
	public function install($clipart_obj, $file, $overwrite = false)
	{
		
		if(isset($clipart_obj->clipart->id_clipart)) { //if already exists just return
			$query = $this->db->query("SELECT id_clipart FROM `" . DB_PREFIX . "clipart` WHERE id_clipart='".$clipart_obj->clipart->id_clipart."' ");
			if($query->num_rows>0)
			{
				if($overwrite) {
					$this->load->model('clipart/clipart');
					$this->model_clipart_clipart->remove($clipart_obj->clipart->id_clipart);
				} else {
					return false;
				}
			}
		}
		
		$ID = $clipart_obj->clipart->id_clipart;
		
		$fields = 'INSERT INTO `' . DB_PREFIX . 'clipart` (`id_clipart`,`name`,`status`,`swf_file`,`vector_file`,`vector_file_2`,`image_file`,`deleted`,`date_added`) ';
		$values = ' VALUES (\''.$ID.'\',\''.$clipart_obj->clipart->name.'\',\''.$clipart_obj->clipart->status.'\',\''.$clipart_obj->clipart->swf_file.'\',\''.$clipart_obj->clipart->vector_file.'\',\''.$clipart_obj->clipart->vector_file_2.'\',\''.$clipart_obj->clipart->image_file.'\',0,NOW()); '.PHP_EOL;
		$sql = $fields.$values;
		
		$query = $this->db->query($sql);
		
		$clipart_dir = DIR_IMAGE.'data/cliparts';
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/cliparts/'.$clipart_obj->clipart->swf_file,  $clipart_dir.'/'.$clipart_obj->clipart->swf_file);
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/cliparts/'.$clipart_obj->clipart->vector_file,  $clipart_dir.'/'.$clipart_obj->clipart->vector_file);
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/cliparts/'.$clipart_obj->clipart->vector_file_2,  $clipart_dir.'/'.$clipart_obj->clipart->vector_file_2);
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/cliparts/'.$clipart_obj->clipart->image_file,  $clipart_dir.'/'.$clipart_obj->clipart->image_file);
		
		foreach($clipart_obj->categories as $id_category)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'clipart_clipart_category` ';
			$fields .= '(`id_clipart`,`id_category`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$id_category.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
			
			$query = $this->db->query($sql);
		}
	
		foreach($clipart_obj->keywords as $keyword)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'clipart_keyword` ';
			$fields .= '(`id_clipart`,`keyword`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$keyword.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}
		
		foreach($clipart_obj->layers as $layer_obj)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'clipart_layers` (`id_clipart`,`sorting`,`name`,`id_design_color`) ';
			$values = ' VALUES (\''.$ID.'\',\''.$layer_obj->sorting.'\',\''.$layer_obj->name.'\',\''.$layer_obj->id_design_color.'\'); '.PHP_EOL;
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}
		
		return $ID;
	}
	
	public function get_files($id_clipart)
	{
		$files = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "clipart WHERE id_clipart='".$id_clipart."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				if($row['vector_file'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $row['vector_file'])) {
					$files[] = array('source'=>DIR_IMAGE . 'data/cliparts/' . $row['vector_file'], 'dest'=> basename(DIR_IMAGE) . '/data/cliparts/' . $row['vector_file']);
				} else {
					throw new ErrorException("ERROR: clipart file doesnt exists: id_clipart=".$id_clipart." | vector_file=".$row['vector_file']);
				}
				if($row['vector_file_2'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $row['vector_file_2'])) {
					$files[] = array('source'=>DIR_IMAGE . 'data/cliparts/' . $row['vector_file_2'], 'dest'=> basename(DIR_IMAGE) . '/data/cliparts/' . $row['vector_file_2']);
				} else {
					throw new ErrorException("ERROR: clipart file doesnt exists: id_clipart=".$id_clipart." | vector_file_2=".$row['vector_file_2']);
				}
				if($row['image_file'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $row['image_file'])) {
					$files[] = array('source'=>DIR_IMAGE . 'data/cliparts/' . $row['image_file'], 'dest'=> basename(DIR_IMAGE) . '/data/cliparts/' . $row['image_file']);
				} else {
					throw new ErrorException("ERROR: clipart file doesnt exists: id_clipart=".$id_clipart." | image_file=".$row['image_file']);
				}
				if($row['swf_file'] && file_exists(DIR_IMAGE . 'data/cliparts/' . $row['swf_file'])) {
					$files[] = array('source'=>DIR_IMAGE . 'data/cliparts/' . $row['swf_file'], 'dest'=> basename(DIR_IMAGE) . '/data/cliparts/' . $row['swf_file']);
				} else {
					throw new ErrorException("ERROR: clipart file doesnt exists: id_clipart=".$id_clipart." | swf_file=".$row['swf_file']);
				}
			} else {
				throw new ErrorException("ERROR: clipart doesnt exists: id_clipart=".$id_clipart);
			}
		}
		return $files;
	}	

	
	public function dump($id_clipart)
	{
		$response = array();
		$response['clipart'] = $this->dump_clipart_fields($id_clipart);
		$response['categories'] = $this->dump_clipart_categories($id_clipart);
		$response['keywords'] = $this->dump_clipart_keywords($id_clipart);
		$response['layers'] = $this->dump_clipart_layers($id_clipart);
		return $response;
	}
	
	private function dump_clipart_fields($id_clipart)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "clipart WHERE id_clipart='".$id_clipart."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				unset($row['deleted']);
				unset($row['date_added']);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: clipart doesnt exists: id_clipart=".$id_clipart);
			}
		}
		return $response;
	}
	
	private function dump_clipart_categories($id_clipart)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "clipart_clipart_category WHERE id_clipart='".$id_clipart."' "))
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
	
	private function dump_clipart_keywords($id_clipart)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "clipart_keyword WHERE id_clipart='".$id_clipart."' "))
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
	
	private function dump_clipart_layers($id_clipart)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "clipart_layers WHERE id_clipart='".$id_clipart."' ORDER BY sorting ASC "))
		{
			if($query->num_rows>0)
			{
				foreach ($query->rows as $result)
				{
					//unset($result['id_clipart']); //will be replacer for new id
					$response[] = $result;
				}	
			} else {
				throw new ErrorException("ERROR: Clipart without layers: id_clipart=".$id_clipart);
			}
		}
		return $response;
	}


}
?>