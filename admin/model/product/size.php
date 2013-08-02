<?php
class ModelProductSize extends Model {
	
	public function addSize($data) {

		if($this->config->get('product_size_option_id')) {
			$option_id = $this->config->get('product_size_option_id');
			$this->db->query("INSERT INTO " . DB_PREFIX . "option_value SET option_id = '" . (int)$option_id . "', image = '', sort_order = '0'");
			
			$option_value_id = $this->db->getLastId();

			global $languages;
			foreach($languages as $language) {
				$option_value['option_value_description'][$language['language_id']] = array('name'=>$data['description']);
			}		
			
			foreach ($option_value['option_value_description'] as $language_id => $option_value_description) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "option_value_description SET option_value_id = '" . (int)$option_value_id . "', language_id = '" . (int)$language_id . "', option_id = '" . (int)$option_id . "', name = '" . $this->db->escape($option_value_description['name']) . "'");
			}
		} else {
			$option_value_id = 0;
		}

		$query = $this->db->query('SELECT UUID()');
		$id_product_size = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_size SET ";
		$sql .= " id_product_size = '" . $id_product_size . "',";
		$sql .= " description = '" . $this->db->escape($data['description']) . "',";
		$sql .= " initials = '" . $this->db->escape($data['initials']) . "',";
		$sql .= " apply_additional_cost = '" . $this->db->escape($data['apply_additional_cost']) . "' ";

		$this->db->query($sql);
			
		return $id_product_size;
		
	}
	public function editSize($id_product_size, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "printable_product_size SET ";
		$sql .= " description = '" . $this->db->escape($data['description']) . "',";
		$sql .= " initials = '" . $this->db->escape($data['initials']) . "',";
		$sql .= " apply_additional_cost = '" . $this->db->escape($data['apply_additional_cost']) . "' ";
		$sql .= " WHERE id_product_size = '" . $id_product_size . "' ";
		$this->db->query($sql);
				
		return $id_product_size;
		
	}
	public function deleteSize($id_product_size)
	{
		/*
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_size WHERE id_product_size = '" . $id_product_size . "' ");
		*/
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_size_upcharge WHERE id_product_size = '" . $id_product_size . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_product_color_product_size WHERE id_product_size = '" . $id_product_size . "' ");

		$query = $this->db->query("UPDATE " . DB_PREFIX . "printable_product_size SET deleted = '1' WHERE id_product_size='".$id_product_size."' LIMIT 1 ");
	}
	
	public function getSize($id_product_size) {
		
		$sql = "SELECT * FROM " . DB_PREFIX . "printable_product_size WHERE id_product_size='". $id_product_size ."'  ";
		$query = $this->db->query($sql);
		
		$size = array(
			'id_product_size'	=> $query->row['id_product_size'],
			'description'		=> $query->row['description'],
			'initials'		=> $query->row['initials'],
			'apply_additional_cost'		=> $query->row['apply_additional_cost'],
			'sort'		=> $query->row['sort'],
			'option_value_id'		=> $query->row['option_value_id']
		);
				
		return $size;	
	}
	
	public function getSizes($data  = array()) {
		
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$size_data = array();
		
		foreach ($query->rows as $result) {
			$size_data[$result['id_product_size']] = array(
				'id_product_size' => $result['id_product_size'],
				'description'        => $result['description'],
				'initials'        => $result['initials'],
				'apply_additional_cost'        => $result['apply_additional_cost'],
				'sort'        => $result['sort'],
				'option_value_id'		=> $result['option_value_id']
			);
		}
		
		return $size_data;	

	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "printable_product_size "; 
		$condition = " WHERE deleted=0   ";

		///add id filter
		if(isset($data['filter_id_product_size'])) {
			$condition .= " AND id_product_size='".$this->db->escape($data['filter_id_product_size'])."' ";
		}

		///add apply_additional_cost filter
		if(isset($data['filter_apply_additional_cost'])) {
			$condition .= " AND apply_additional_cost='".$this->db->escape($data['filter_apply_additional_cost'])."' ";
		}
		
		$sql .= $tables.$condition;
		
		$sort_data = array(
			'sort, description',
			'sort',
			'description',
			'apply_additional_cost',
			'initials'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY sort, description";
		}
		
		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC";
		} else {
			$sql .= " ASC";
		}

		if (isset($data['start']) || isset($data['limit'])) {
			if ($data['start'] < 0) {
				$data['start'] = 0;
			}

			if ($data['limit'] < 1) {
				$data['limit'] = 20;
			}

			$sql .= " LIMIT " . (int)$data['start'] . "," . (int)$data['limit'];
		}		
		
		return $sql;
	}
	
	public function getTotalSizes($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM " . DB_PREFIX . "printable_product_size "; 
		$condition = " WHERE deleted=0   ";

		///add id filter
		if(isset($data['filter_id_product_size'])) {
			$condition .= " AND id_product_size='".$this->db->escape($data['filter_id_product_size'])."' ";
		}

		///add apply_additional_cost filter
		if(isset($data['filter_apply_additional_cost'])) {
			$condition .= " AND apply_additional_cost='".$this->db->escape($data['filter_apply_additional_cost'])."' ";
		}
		
		$sql .= $tables.$condition;
		
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
	
	public function saveOrder($sizes) {
		foreach ($sizes as $sort => $id_product_size) {
			$query = $this->db->query("UPDATE " . DB_PREFIX . "printable_product_size SET sort = '".$sort."' WHERE id_product_size='".$id_product_size."' LIMIT 1 ");
		}
	}
}
?>