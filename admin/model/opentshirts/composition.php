<?php
class ModelOpentshirtsComposition extends Model {
	
	public function getComposition($id_composition) 
	{
		$query = $this->db->query('SELECT * FROM ' . DB_PREFIX . 'composition WHERE id_composition="' . $id_composition . '" ');
		$composition = array(
			'id_composition'	=> $query->row['id_composition'],
			'name'				=> $query->row['name'],
			'product_id'		=> $query->row['product_id'],
			'id_product_color'		=> $query->row['id_product_color'],
			'status'		=> $query->row['status'],
			'date_added'		=> $query->row['date_added']
		);
		return $composition;
	}

	public function editComposition($id_composition, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "composition SET ";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "' ";
		$sql .= " WHERE id_composition = '" . $id_composition . "' ";
		$this->db->query($sql);
		
		$sql  = "DELETE FROM " . DB_PREFIX . "composition_keyword WHERE id_composition = '" . $id_composition . "' ";
		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "composition_keyword SET ";
				$sql .= " id_composition = '" . $id_composition . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}		
		}
		
		$sql  = "DELETE FROM " . DB_PREFIX . "composition_composition_category WHERE id_composition = '" . $id_composition . "' ";
		$this->db->query($sql);
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "composition_composition_category SET ";
				$sql .= " id_composition = '" . $id_composition . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		
		return $id_composition;
		
	}
	
	public function getCompositions($data  = array()) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$compositions = array();
    		foreach ($query->rows as $result) {
			$compositions[$result['id_composition']] = array(
        			'id_composition' => $result['id_composition'],
        			'name' => $result['name'],
					'product_id'		=> $result['product_id'],
					'id_product_color'		=> $result['id_product_color'],
					'status'		=> $result['status'],
					'date_added'		=> $result['date_added']
      			);
    		}	
		return $compositions;
	}
	
	public function getTotalCompositions($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM ".DB_PREFIX."composition c  "; 
		$condition = " WHERE c.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", ".DB_PREFIX."composition_composition_category cxc ";
			$condition .= " AND cxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND c.id_composition=cxc.id_composition ";
		}

		///add id filter
		if(isset($data['filter_id_composition'])) {
			$condition .= " AND c.id_composition='".$this->db->escape($data['filter_id_composition'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND c.status='".$this->db->escape($data['filter_status'])."' ";
		}
		
		///add author filter
		if(isset($data['filter_id_author'])) {
			$condition .= " AND c.id_author='".$this->db->escape($data['filter_id_author'])."' ";
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
		$tables = "FROM ".DB_PREFIX."composition c  "; 
		$condition = " WHERE c.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", ".DB_PREFIX."composition_composition_category cxc ";
			$condition .= " AND cxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND c.id_composition=cxc.id_composition ";
		}

		///add id filter
		if(isset($data['filter_id_composition'])) {
			$condition .= " AND c.id_composition='".$this->db->escape($data['filter_id_composition'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND c.status='".$this->db->escape($data['filter_status'])."' ";
		}
		
		///add author filter
		if(isset($data['filter_id_author'])) {
			$condition .= " AND c.id_author='".$this->db->escape($data['filter_id_author'])."' ";
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
			'c.id_composition',
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
			$sql = "SELECT DISTINCT(id_composition) FROM ".DB_PREFIX."composition_keyword WHERE keyword LIKE '%".$this->db->escape($key)."%' ";
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$values[]="'".$result['id_composition']."'";	
			}
		}
		
		if ($values)
		{
			return ' OR c.id_composition IN ('.implode(',',$values).') ';		
		}	
	}
	
	public function getCompositionCategories($id_composition) 
	{
		$query = $this->db->query("SELECT id_category FROM ".DB_PREFIX."composition_composition_category WHERE id_composition = '".$id_composition."' ");
		
		$cats = array();
    	foreach ($query->rows as $result) {
			$cats[] = $result['id_category'];
    	}	
		return $cats;
	}

	public function getCompositionKeywords($id_composition) 
	{
		$query = $this->db->query("SELECT keyword FROM ".DB_PREFIX."composition_keyword WHERE id_composition = '".$id_composition."' ");
		
		$keywords = array();
    	foreach ($query->rows as $result) {
			$keywords[] = $result['keyword'];
    	}	
		return $keywords;
	}
	public function deleteComposition($id_composition)
	{
		$query = $this->db->query("UPDATE ".DB_PREFIX."composition SET deleted = '1' WHERE id_composition='".$id_composition."' LIMIT 1 ");
	}
	public function remove($id_composition)
	{		
		$this->db->query("DELETE FROM " . DB_PREFIX . "composition WHERE id_composition = '" . $id_composition . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "composition_keyword WHERE id_composition = '" . $id_composition . "' ");
		$this->db->query("DELETE FROM " . DB_PREFIX . "composition_composition_category WHERE id_composition = '" . $id_composition . "' ");
		
		$this->load->model('opentshirts/design');
		$result = $this->model_opentshirts_design->getDesigns(array('filter_id_composition' => $id_composition));
		foreach($result as $design) {
			$this->model_opentshirts_design->remove($design['id_design']);
		}
	}

}
?>