<?php
class ModelBitmapCategory extends Model {
	public function addCategory($data) {
		$query = $this->db->query('SELECT UUID()');
		$id_category = $query->row['UUID()'];
		
		$sql  = "INSERT INTO " . DB_PREFIX . "bitmap_category SET ";
		$sql .= " id_category = '" . $id_category . "',";
		
		if(empty($data['parent_category'])) {
			$sql .= " parent_category = NULL,";
		} else {
			$sql .= " parent_category = '" . $this->db->escape($data['parent_category']) . "',";
		}
		
		$sql .= " description = '" . $this->db->escape($data['description']) . "' ";
		$this->db->query($sql);
	}
	
	public function editCategory($id_category, $data) {
		$sql  = "UPDATE " . DB_PREFIX . "bitmap_category SET ";
		
		if(empty($data['parent_category'])) {
			$sql .= " parent_category = NULL,";
		} else {
			$sql .= " parent_category = '" . $this->db->escape($data['parent_category']) . "',";
		}
		
		$sql .= " description = '" . $this->db->escape($data['description']) . "' ";
		$sql .= " WHERE id_category = '" . $id_category . "' ";
		$this->db->query($sql);
	}
	
	public function deleteCategory($id_category)
	{
		$childrens = $this->getCategoriesByParentId($id_category);
		
		foreach($childrens as $id_children_category=>$category) {
			$this->deleteCategory($id_children_category);
		}
		
		$this->db->query("DELETE FROM " . DB_PREFIX . "bitmap_category WHERE id_category = '" . $this->db->escape($id_category) . "'");
		$this->db->query("DELETE FROM " . DB_PREFIX . "bitmap_bitmap_category WHERE id_category = '" .  $this->db->escape($id_category) . "' ");

	}
	
	public function getCategoriesByParentId($parent=false) {
		if($parent) {
			$where = "WHERE parent_category='".$parent."' ";
		} else {
			$where = "WHERE parent_category IS NULL";
		}
		
		$sql = "SELECT id_category, description FROM " . DB_PREFIX . "clipart_category ".$where." ORDER BY description ASC";
		$query = $this->db->query($sql);
		
		$categories = array();
    		foreach ($query->rows as $result) {
			
			$categories[$result['id_category']] = array(
        			'id_category'	=> $result['id_category'],
        			'description'	=> "   ".$result['description'],
					'children'	=> $this->getCategoriesByParentId($result['id_category']),
        		);
    		}
		return $categories;
	}
	
	public function getCategory($id_category) {
		$sql = "SELECT * FROM " . DB_PREFIX . "clipart_category WHERE id_category='".$id_category."' ";
		$query = $this->db->query($sql);
		return $query->row;
	}
}
?>