<?php
class ModelProductColor extends Model {
	public function addColor($data) {


		if($this->config->get('product_color_option_id')) {
			$option_id = $this->config->get('product_color_option_id');
			$this->db->query("INSERT INTO " . DB_PREFIX . "option_value SET option_id = '" . (int)$option_id . "', image = '', sort_order = '0'");
			
			$option_value_id = $this->db->getLastId();

			global $languages;
			foreach($languages as $language) {
				$option_value['option_value_description'][$language['language_id']] = array('name'=>$data['name']);
			}		
			
			foreach ($option_value['option_value_description'] as $language_id => $option_value_description) {
				$this->db->query("INSERT INTO " . DB_PREFIX . "option_value_description SET option_value_id = '" . (int)$option_value_id . "', language_id = '" . (int)$language_id . "', option_id = '" . (int)$option_id . "', name = '" . $this->db->escape($option_value_description['name']) . "'");
			}
		} else {
			$option_value_id = 0;
		}


		$query = $this->db->query('SELECT UUID()');
		$id_product_color = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color SET ";
		$sql .= " id_product_color = '" . $id_product_color . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " num_colors = '" . $this->db->escape($data['num_colors']) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($data['need_white_base']) . "',";
		$sql .= " id_product_color_group = '" . $this->db->escape($data['id_product_color_group']) . "',";
		$sql .= " option_value_id = '" . $option_value_id . "'";

		$this->db->query($sql);
		
		$i = 0;
		foreach($data['hexa'] as $hexa_value)
		{
			$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color_flat_color SET ";
			$sql .= " id_product_color = '" . $id_product_color . "',";
			$sql .= " flat_color_index = '" . $i. "',";
			$sql .= " hexa = '" . $this->db->escape($hexa_value) . "' ";
			$this->db->query($sql);
			
			$i++;
		}	
	
		return $id_product_color;
		
	}
	public function editColor($id_product_color, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "printable_product_color SET ";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " num_colors = '" . $this->db->escape($data['num_colors']) . "',";
		$sql .= " need_white_base = '" . $this->db->escape($data['need_white_base']) . "',";
		$sql .= " id_product_color_group = '" . $this->db->escape($data['id_product_color_group']) . "' ";
		$sql .= " WHERE id_product_color = '" . $id_product_color . "' ";
		$this->db->query($sql);
		
		$sql  = "DELETE FROM " . DB_PREFIX . "printable_product_color_flat_color WHERE id_product_color = '" . $id_product_color . "' ";
		$this->db->query($sql);
		
		$i = 0;
		foreach($data['hexa'] as $hexa_value)
		{
			$sql  = "INSERT INTO " . DB_PREFIX . "printable_product_color_flat_color SET ";
			$sql .= " id_product_color = '" . $id_product_color . "',";
			$sql .= " flat_color_index = '" . $i. "',";
			$sql .= " hexa = '" . $this->db->escape($hexa_value) . "' ";
			$this->db->query($sql);
			
			$i++;
		}	
		
		return $id_product_color;
		
	}
	public function deleteColor($id_product_color)
	{
		/*
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_color WHERE id_product_color = '" . $id_product_color . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_color_flat_color WHERE id_product_color = '" . $id_product_color . "' ");
		*/
		$query = $this->db->query("UPDATE " . DB_PREFIX . "printable_product_color SET deleted = '1' WHERE id_product_color='".$id_product_color."' LIMIT 1 ");
		
		$this->db->query("DELETE FROM " . DB_PREFIX . "printable_product_product_color_product_size WHERE id_product_color = '" . $id_product_color . "' ");
	}
	
	public function getColor($id_product_color) {
		
		$sql = "SELECT * FROM " . DB_PREFIX . "printable_product_color pc, " . DB_PREFIX . "printable_product_color_flat_color fc WHERE fc.id_product_color=pc.id_product_color AND pc.id_product_color='". $id_product_color ."'  ";
		$query = $this->db->query($sql);
		
		$color = array();
		foreach ($query->rows as $result) {
			$color["id_product_color"] = $result["id_product_color"];
			$color["name"] = $result["name"];
			$color["num_colors"] = $result["num_colors"];
			$color["need_white_base"] = $result["need_white_base"];
			$color["id_product_color_group"] = $result["id_product_color_group"];
			$color["hexa"][] = $result["hexa"];
			$color["option_value_id"] = $result["option_value_id"];
		}
		
		return $color;	
	}
	
	public function getColors($data  = array()) {
		
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$color_data = array();
		
		foreach ($query->rows as $result) {
			$id_product_color = $result["id_product_color"];
			$color_data[$id_product_color]["id_product_color"] = $id_product_color;
			$color_data[$id_product_color]["name"] = $result["name"];
			$color_data[$id_product_color]["num_colors"] = $result["num_colors"];
			$color_data[$id_product_color]["need_white_base"] = $result["need_white_base"];
			$color_data[$id_product_color]["id_product_color_group"] = $result["id_product_color_group"];
			$color_data[$id_product_color]["hexa"][] = $result["hexa"];
			$color_data[$id_product_color]["option_value_id"] = $result["option_value_id"];
		}
		
		return $color_data;	
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "printable_product_color pc LEFT JOIN " . DB_PREFIX . "printable_product_color_flat_color fc ON (pc.id_product_color=fc.id_product_color) "; 
		$condition = " WHERE pc.deleted=0  ";

		///add id filter
		if(isset($data['filter_id_product_color'])) {
			$condition .= " AND pc.id_product_color='".$this->db->escape($data['filter_id_product_color'])."' ";
		}

		///add num_colors filter
		if(isset($data['filter_num_colors'])) {
			$condition .= " AND pc.num_colors='".$this->db->escape($data['filter_num_colors'])."' ";
		}
		
		///add id_product_color_group filter
		if(isset($data['filter_id_product_color_group'])) {
			$condition .= " AND pc.id_product_color_group='".$this->db->escape($data['filter_id_product_color_group'])."' ";
		}

		
		$sql .= $tables.$condition;
		
		$sort_data = array(
			'pc.num_colors, pc.name',
			'pc.num_colors',
			'pc.name',
			'pc.id_product_color_group'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY pc.num_colors, pc.name";
		}
		
		if (isset($data['order']) && ($data['order'] == 'DESC')) {
			$sql .= " DESC, fc.flat_color_index ASC ";
		} else {
			$sql .= " ASC, fc.flat_color_index ASC ";
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
	
	public function getTotalColors($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM " . DB_PREFIX . "printable_product_color pc  "; 
		$condition = " WHERE pc.deleted=0 ";
		
		///add id filter
		if(isset($data['filter_id_product_color'])) {
			$condition .= " AND pc.id_product_color='".$this->db->escape($data['filter_id_product_color'])."' ";
		}

		///add num_colors filter
		if(isset($data['filter_num_colors'])) {
			$condition .= " AND pc.num_colors='".$this->db->escape($data['filter_num_colors'])."' ";
		}
		
		///add id_product_color_group filter
		if(isset($data['filter_id_product_color_group'])) {
			$condition .= " AND pc.id_product_color_group='".$this->db->escape($data['filter_id_product_color_group'])."' ";
		}

		
		$sql .= $tables.$condition;
		
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
	
	public function getColorGroups() {
		$color_group_data = array();
		
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "printable_product_color_group ");
	
		foreach ($query->rows as $result) {
			$color_group_data[$result['id_product_color_group']] = array(
				'id_product_color_group' => $result['id_product_color_group'],
				'description'        => $result['description'],
				'color'        => $result['color']
			);
		}	
			
		
		return $color_group_data;	
	}
}
?>