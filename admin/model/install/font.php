<?php
class ModelInstallFont extends Model {
	public function install($font_obj, $file, $overwrite = false)
	{
		
		if(isset($font_obj->font->id_font)) { //if already exists just return
			$query = $this->db->query("SELECT id_font FROM `" . DB_PREFIX . "font` WHERE id_font='".$font_obj->font->id_font."' ");
			if($query->num_rows>0)
			{
				if($overwrite) {
					$this->load->model('font/font');
					$this->model_font_font->remove($font_obj->font->id_font);
				} else {
					return false;
				}
			}
		}
		$ID = $font_obj->font->id_font;
		
		$fields = 'INSERT INTO `' . DB_PREFIX . 'font` (`id_font`,`name`,`status`,`swf_file`,`ttf_file`,`deleted`,`date_added`) ';
		$values = ' VALUES (\''.$ID.'\',\''.$font_obj->font->name.'\',\''.$font_obj->font->status.'\',\''.$font_obj->font->swf_file.'\',\''.$font_obj->font->ttf_file.'\',0,NOW()); '.PHP_EOL;
		$sql = $fields.$values;
		
		$query = $this->db->query($sql);
		
		$font_dir = DIR_IMAGE.'data/fonts';
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/fonts/'.$font_obj->font->swf_file,  $font_dir.'/'.$font_obj->font->swf_file);
		@copy('zip://'.$file.'#'.basename(DIR_IMAGE).'/data/fonts/'.$font_obj->font->ttf_file,  $font_dir.'/'.$font_obj->font->ttf_file);

		
		foreach($font_obj->categories as $id_category)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'font_font_category` ';
			$fields .= '(`id_font`,`id_category`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$id_category.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
			
			$query = $this->db->query($sql);
		}
	
		foreach($font_obj->keywords as $keyword)
		{
			$fields = 'INSERT INTO `' . DB_PREFIX . 'font_keyword` ';
			$fields .= '(`id_font`,`keyword`)';
			$values = ' VALUES (';
			$values .= '\''.$ID.'\',';
			$values .= '\''.$keyword.'\'';
			$values .= ');'.PHP_EOL;
			
			$sql = $fields.$values;
		
			$query = $this->db->query($sql);
		}
		
		return $ID;
	}
	
	public function get_files($id_font)
	{
		$files = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "font WHERE id_font='".$id_font."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				$files[] = array('source'=> DIR_IMAGE . 'data/fonts/'.$row['ttf_file'], 'dest'=>basename(DIR_IMAGE) . '/data/fonts/'.$row['ttf_file']);
				$files[] = array('source'=> DIR_IMAGE . 'data/fonts/'.$row['swf_file'], 'dest'=>basename(DIR_IMAGE) . '/data/fonts/'.$row['swf_file']);
			} else {
				throw new ErrorException("ERROR: font doesnt exists");
			}
		}
		return $files;
	}	

	
	public function dump($id_font)
	{
		$response = array();
		$response['font'] = $this->dump_font_fields($id_font);
		$response['categories'] = $this->dump_font_categories($id_font);
		$response['keywords'] = $this->dump_font_keywords($id_font);
		return $response;
	}
	
	private function dump_font_fields($id_font)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "font WHERE id_font='".$id_font."' "))
		{
			if($query->num_rows==1)
			{
				$row = $query->row;
				unset($row['deleted']);
				unset($row['date_added']);
				$response = $row;
			} else {
				throw new ErrorException("ERROR: font doesnt exists");
			}
		}
		return $response;
	}
	
	private function dump_font_categories($id_font)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "font_font_category WHERE id_font='".$id_font."' "))
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
	
	private function dump_font_keywords($id_font)
	{
		$response = array();
		if($query = $this->db->query( "SELECT * FROM " . DB_PREFIX . "font_keyword WHERE id_font='".$id_font."' "))
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