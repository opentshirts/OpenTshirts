<?php
class ModelClipartClipart extends Model {
	
	public function addClipart($data) {

		$query = $this->db->query('SELECT UUID()');
		$id_clipart = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "clipart SET ";
		$sql .= " id_clipart = '" . $id_clipart . "',";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " swf_file = '" . $this->db->escape($data['swf_file']) . "',";
		$sql .= " vector_file = '" . $this->db->escape($data['vector_file']) . "',";
		$sql .= " vector_file_2 = '" . $this->db->escape($data['vector_file_2']) . "',";
		$sql .= " image_file = '" . $this->db->escape($data['image_file']) . "' ";

		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "clipart_keyword SET ";
				$sql .= " id_clipart = '" . $id_clipart . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}	
		}
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "clipart_clipart_category SET ";
				$sql .= " id_clipart = '" . $id_clipart . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		
		if(isset($data['layer_name']))
		{
			foreach($data['layer_name'] as $key=>$name)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "clipart_layers SET ";
				$sql .= " id_clipart = '" . $id_clipart . "',";
				$sql .= " sorting = '" . $key . "', ";
				$sql .= " name = '" . $this->db->escape($name) . "', ";
				$sql .= " id_design_color = '" . $data['layer_id_design_color'][$key] . "' ";
				$this->db->query($sql);
			}	
		}
		return $id_clipart;
		
	}
	public function editClipart($id_clipart, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "clipart SET ";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " swf_file = '" . $this->db->escape($data['swf_file']) . "',";
		$sql .= " vector_file = '" . $this->db->escape($data['vector_file']) . "',";
		$sql .= " vector_file_2 = '" . $this->db->escape($data['vector_file_2']) . "',";
		$sql .= " image_file = '" . $this->db->escape($data['image_file']) . "' ";
		$sql .= " WHERE id_clipart = '" . $id_clipart . "' ";
		$this->db->query($sql);
		
		$sql  = "DELETE FROM " . DB_PREFIX . "clipart_keyword WHERE id_clipart = '" . $id_clipart . "' ";
		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "clipart_keyword SET ";
				$sql .= " id_clipart = '" . $id_clipart . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}	
		}
		
		$sql  = "DELETE FROM " . DB_PREFIX . "clipart_clipart_category WHERE id_clipart = '" . $id_clipart . "' ";
		$this->db->query($sql);
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "clipart_clipart_category SET ";
				$sql .= " id_clipart = '" . $id_clipart . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		$sql  = "DELETE FROM " . DB_PREFIX . "clipart_layers WHERE id_clipart = '" . $id_clipart . "' ";
		$this->db->query($sql);
		
		if(isset($data['layer_name']))
		{
			foreach($data['layer_name'] as $key=>$name)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "clipart_layers SET ";
				$sql .= " id_clipart = '" . $id_clipart . "',";
				$sql .= " sorting = '" . $key . "', ";
				$sql .= " name = '" . $this->db->escape($name) . "', ";
				$sql .= " id_design_color = '" . $data['layer_id_design_color'][$key] . "' ";
				$this->db->query($sql);
			}	
		}
		
		return $id_clipart;
		
	}

	public function deleteClipart($id_clipart)
	{
		$query = $this->db->query("UPDATE " . DB_PREFIX . "clipart SET deleted = '1' WHERE id_clipart='".$id_clipart."' LIMIT 1 ");
	}
	
	public function remove($id_clipart)
	{
		$result = $this->getClipart($id_clipart);
		
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "clipart WHERE id_clipart='".$id_clipart."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "clipart_clipart_category WHERE id_clipart='".$id_clipart."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "clipart_keyword WHERE id_clipart='".$id_clipart."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "clipart_layers WHERE id_clipart='".$id_clipart."' ");
		
		$clipart_dir = DIR_IMAGE.'data/cliparts';
		if($result['swf_file']) {
			@unlink( $clipart_dir.'/'.$result['swf_file']);
		}
		if($result['image_file']) {
			@unlink( $clipart_dir.'/'.$result['image_file']);
		}
		if($result['vector_file']) {
			@unlink( $clipart_dir.'/'.$result['vector_file']);
		}
		if($result['vector_file_2']) {
			@unlink( $clipart_dir.'/'.$result['vector_file_2']);
		}

	}
	
	public function getClipart($id_clipart)
	{
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "clipart WHERE id_clipart='".$id_clipart."' ");
		$result = $query->row;
		
		$clipart = array(
				'id_clipart' => $result['id_clipart'],
				'name' => $result['name'],
				'image_file' => $result['image_file'],
				'vector_file' => $result['vector_file'],
				'vector_file_2' => $result['vector_file_2'],
				'swf_file' => $result['swf_file'],
				'status'		=> $result['status'],
				'date_added'		=> $result['date_added']
			);
		return $clipart;
	}
	
	public function getSource($id_clipart)
	{
		$source = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "clipart WHERE id_clipart='".$id_clipart."' ");
		if($query->row) {
			$source[] = array(
						'link' => HTTP_CATALOG . 'image/data/cliparts/'.$query->row['vector_file'], 
						'description' => $query->row['vector_file']
					);
			if($query->row['vector_file_2']) {
				$source[] = array(
							'link' => HTTP_CATALOG . 'image/data/cliparts/'.$query->row['vector_file_2'], 
							'description' => $query->row['vector_file_2']
						);
			}
			$source[] = array(
						'link' => HTTP_CATALOG . 'image/data/cliparts/'.$query->row['swf_file'], 
						'description' => $query->row['swf_file']
					);
		} else {
			$source[] = array(
						'link' => '#', 
						'description' => 'clipart deleted'
					);
		}
		
		return $source;
	}
	
	public function getCliparts($data  = array()) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$cliparts = array();
    		foreach ($query->rows as $result) {
			$cliparts[$result['id_clipart']] = array(
        			'id_clipart' => $result['id_clipart'],
        			'name' => $result['name'],
					'image_file' => $result['image_file'],
					'status'		=> $result['status'],
					'date_added'		=> $result['date_added']
      			);
    		}	
		return $cliparts;
	}
	
	public function getTotalCliparts($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM " . DB_PREFIX . "clipart c  "; 
		$condition = " WHERE c.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", " . DB_PREFIX . "clipart_clipart_category cxc ";
			$condition .= " AND cxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND c.id_clipart=cxc.id_clipart ";
		}

		///add id filter
		if(isset($data['filter_id_clipart'])) {
			$condition .= " AND c.id_clipart='".$this->db->escape($data['filter_id_clipart'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND c.status='".$this->db->escape($data['filter_status'])."' ";
		}

		///add keyword filter
		$match = '';
		if (isset($data['filter_keyword']))
		{
			$array_keywords=explode(" ",$data['filter_keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['filter_keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( c.name LIKE '%".$this->db->escape($data['filter_keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( c.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( c.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "clipart c  "; 
		$condition = " WHERE c.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", " . DB_PREFIX . "clipart_clipart_category cxc ";
			$condition .= " AND cxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND c.id_clipart=cxc.id_clipart ";
		}

		///add id filter
		if(isset($data['filter_id_clipart'])) {
			$condition .= " AND c.id_clipart='".$this->db->escape($data['filter_id_clipart'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND c.status='".$this->db->escape($data['filter_status'])."' ";
		}

		///add keyword filter
		$match = '';
		if (isset($data['filter_keyword']))
		{
			$array_keywords=explode(" ",$data['filter_keyword']);
			$num_words=count($array_keywords);
			$ids_from_keyword=$this->getIdsFromKeywords($data['filter_keyword']);
			if ($num_words==1)
			{
				$condition .= " AND  ( c.name LIKE '%".$this->db->escape($data['filter_keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( c.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( c.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$sort_data = array(
			'RAND()',
			'c.date_added',
			'c.name',
			'c.status',
			'c.id_clipart',
			'score'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY c.date_added";
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
	
	private function getIdsFromKeywords($keyword)
	{
		$array_keywords=explode(" ",$keyword); ///split by words
		$values=array();
		
		foreach($array_keywords as $key) {
			$sql = "SELECT DISTINCT(id_clipart) FROM " . DB_PREFIX . "clipart_keyword WHERE keyword LIKE '%".$this->db->escape($key)."%' ";
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$values[]="'".$result['id_clipart']."'";	
			}
		}
		
		if ($values)
		{
			return ' OR c.id_clipart IN ('.implode(',',$values).') ';		
		}	
	}
	
	public function getClipartLayers($id_clipart) 
	{
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "clipart_layers WHERE id_clipart = '".$id_clipart."' ORDER BY sorting ASC ");
		
		$layers = array();
    	foreach ($query->rows as $result) {
			$layers[] = array(
        			'id_clipart' 		=> $result['id_clipart'],
        			'sorting' 			=> $result['sorting'],
					'name' 				=> $result['name'],
					'id_design_color'	=> $result['id_design_color']
      			);
    	}	
		return $layers;
	}

	public function getClipartCategories($id_clipart) 
	{
		$query = $this->db->query("SELECT id_category FROM " . DB_PREFIX . "clipart_clipart_category WHERE id_clipart = '".$id_clipart."' ");
		
		$cats = array();
    	foreach ($query->rows as $result) {
			$cats[] = $result['id_category'];
    	}	
		return $cats;
	}

	public function getClipartKeywords($id_clipart) 
	{
		$query = $this->db->query("SELECT keyword FROM " . DB_PREFIX . "clipart_keyword WHERE id_clipart = '".$id_clipart."' ");
		
		$keywords = array();
    	foreach ($query->rows as $result) {
			$keywords[] = $result['keyword'];
    	}	
		return $keywords;
	}
	


}
?>