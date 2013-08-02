<?php
class ModelFontFont extends Model {	
	public function getSource($id_font)
	{
		$source = array();
		$query = $this->db->query("SELECT * FROM " . DB_PREFIX . "font WHERE id_font='".$id_font."' ");
		if($query->row) {
			$source1 = array(
					'link' => HTTP_CATALOG . 'image/data/fonts/'.$query->row['ttf_file'], 
					'description' => $query->row['ttf_file']
				);
		} else {
			$source1 = array(
						'link' => '#', 
						'description' => 'font deleted'
					);
		}
		$source[] = $source1;
		return $source;
	}
	
	public function addFont($data) {

		$query = $this->db->query('SELECT UUID()');
		$id_font = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "font SET ";
		$sql .= " id_font = '" . $id_font . "',";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " ttf_file = '" . $this->db->escape($data['ttf_file']) . "',";
		$sql .= " swf_file = '" . $this->db->escape($data['swf_file']) . "' ";

		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "font_keyword SET ";
				$sql .= " id_font = '" . $id_font . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}	
		}
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "font_font_category SET ";
				$sql .= " id_font = '" . $id_font . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		return $id_font;
		
	}
	public function editFont($id_font, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "font SET ";
		$sql .= " name = '" . $this->db->escape($data['name']) . "',";
		$sql .= " status = '" . $this->db->escape($data['status']) . "',";
		$sql .= " ttf_file = '" . $this->db->escape($data['ttf_file']) . "',";
		$sql .= " swf_file = '" . $this->db->escape($data['swf_file']) . "' ";
		$sql .= " WHERE id_font = '" . $id_font . "' ";
		$this->db->query($sql);
		
		$sql  = "DELETE FROM " . DB_PREFIX . "font_keyword WHERE id_font = '" . $id_font . "' ";
		$this->db->query($sql);
		
		if(!empty($data['keywords']))
		{
			$keywords = explode(",", $data['keywords']);
			foreach($keywords as $keyword)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "font_keyword SET ";
				$sql .= " id_font = '" . $id_font . "',";
				$sql .= " keyword = '" . $this->db->escape($keyword) . "' ";
				$this->db->query($sql);
			}		
		}
		
		$sql  = "DELETE FROM " . DB_PREFIX . "font_font_category WHERE id_font = '" . $id_font . "' ";
		$this->db->query($sql);
		
		if(isset($data['selected_categories']))
		{
			foreach($data['selected_categories'] as $id_category)
			{
				$sql  = "INSERT INTO " . DB_PREFIX . "font_font_category SET ";
				$sql .= " id_font = '" . $id_font . "',";
				$sql .= " id_category = '" . $id_category . "' ";
				$this->db->query($sql);
			}	
		}
		
		return $id_font;
		
	}
	public function getFont($id_font)
	{
		$query = $this->db->query('SELECT * FROM ' . DB_PREFIX . 'font WHERE id_font="'.$id_font.'" ');
		$font = array(
			'id_font'	=> $query->row['id_font'],
			'name'		=> $query->row['name'],
			'swf_file'		=> $query->row['swf_file'],
			'ttf_file'		=> $query->row['ttf_file'],
			'status'		=> $query->row['status'],
			'date_added'		=> $query->row['date_added']
		);
		return $font;
	}
	
	public function getFonts($data = array()) 
	{
		$query = $this->db->query($this->parseSQLByFilter($data));
		
		$fonts = array();
    	foreach ($query->rows as $result) {
			$fonts[$result['id_font']] = array(
				'id_font'	=> $result['id_font'],
				'name'		=> $result['name'],
				'ttf_file'		=> $result['ttf_file'],
				'status'		=> $result['status'],
				'date_added'		=> $result['date_added']
			);
    	}	
		return $fonts;
	}
	
	public function deleteFont($id_font)
	{
		$query = $this->db->query("UPDATE " . DB_PREFIX . "font SET deleted = '1' WHERE id_font='".$id_font."' LIMIT 1 ");
	}
	
	public function remove($id_font)
	{
		$result = $this->getFont($id_font);
		
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "font WHERE id_font='".$id_font."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "font_font_category WHERE id_font='".$id_font."' ");
		$query = $this->db->query("DELETE FROM " . DB_PREFIX . "font_keyword WHERE id_font='".$id_font."' ");
		
		$font_dir = DIR_IMAGE.'data/fonts';
		if($result['swf_file']) {
			@unlink( $font_dir.'/'.$result['swf_file']);
		}
		if($result['ttf_file']) {
			@unlink( $font_dir.'/'.$result['ttf_file']);
		}
	}
	
	public function getTotalFonts($data) 
	{
		$sql = "SELECT COUNT(*) AS total ";
		$tables = "FROM " . DB_PREFIX . "font f  "; 
		$condition = " WHERE f.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", " . DB_PREFIX . "font_font_category fxc ";
			$condition .= " AND fxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND f.id_font=fxc.id_font ";
		}

		///add id filter
		if(isset($data['filter_id_font'])) {
			$condition .= " AND f.id_font='".$this->db->escape($data['filter_id_font'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND f.status='".$this->db->escape($data['filter_status'])."' ";
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
				$condition .= " AND  ( f.name LIKE '%".$this->db->escape($data['filter_keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$order = 'score';
				$match = " , MATCH ( f.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( f.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$query = $this->db->query($sql);
		return $query->row['total'];
	}
	
	private function parseSQLByFilter($data) 
	{
		$sql = "SELECT * ";
		$tables = "FROM " . DB_PREFIX . "font f  "; 
		$condition = " WHERE f.deleted=0 ";
		
		///add category filter
		if(isset($data['filter_id_category'])) {
			$tables .= ", " . DB_PREFIX . "font_font_category fxc ";
			$condition .= " AND fxc.id_category='".$this->db->escape($data['filter_id_category'])."' AND f.id_font=fxc.id_font ";
		}

		///add id filter
		if(isset($data['filter_id_font'])) {
			$condition .= " AND f.id_font='".$this->db->escape($data['filter_id_font'])."' ";
		}

		///add status filter
		if(isset($data['filter_status'])) {
			$condition .= " AND f.status='".$this->db->escape($data['filter_status'])."' ";
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
				$condition .= " AND  ( f.name LIKE '%".$this->db->escape($data['filter_keyword'])."%' ".$ids_from_keyword." ) ";
			}
			else
			{
				$data['sort'] = 'score'; //force order by score
				$match = " , MATCH ( f.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) AS score ";
				$condition .= " AND (  MATCH ( f.name ) AGAINST ( '".$this->db->escape($data['filter_keyword'])."' ) ".$ids_from_keyword." )";
			}		
		}
		
		$sql .= $match.$tables.$condition;
		
		$sort_data = array(
			'RAND()',
			'f.date_added',
			'f.name',
			'f.status',
			'f.id_font',
			'score'
		);
		
		if (isset($data['sort']) && in_array($data['sort'], $sort_data)) {
			$sql .= " ORDER BY " . $data['sort'];
		} else {
			$sql .= " ORDER BY f.date_added";
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
			$sql = "SELECT DISTINCT(id_font) FROM " . DB_PREFIX . "font_keyword WHERE keyword LIKE '%".$this->db->escape($key)."%' ";
			$query = $this->db->query($sql);
			foreach ($query->rows as $result) {
				$values[]="'".$result['id_font']."'";	
			}
		}
		
		if ($values)
		{
			return ' OR f.id_font IN ('.implode(',',$values).') ';		
		}	
	}
	
	public function getFontCategories($id_font) 
	{
		$query = $this->db->query("SELECT id_category FROM " . DB_PREFIX . "font_font_category WHERE id_font = '".$id_font."' ");
		
		$cats = array();
    	foreach ($query->rows as $result) {
			$cats[] = $result['id_category'];
    	}	
		return $cats;
	}

	public function getFontKeywords($id_font) 
	{
		$query = $this->db->query("SELECT keyword FROM " . DB_PREFIX . "font_keyword WHERE id_font = '".$id_font."' ");
		
		$keywords = array();
    	foreach ($query->rows as $result) {
			$keywords[] = $result['keyword'];
    	}	
		return $keywords;
	}
	
	
}
?>