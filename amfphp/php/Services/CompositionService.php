<?php
class CompositionService {

	private $db;
	private $session;
	
	public function __construct() {

		require_once(dirname(__FILE__)."/".'../../../config.php');

		require_once(DIR_SYSTEM.'library/session.php');
		$this->session = new Session();

		require_once(DIR_SYSTEM.'library/db.php');
		$this->db = new DB(DB_DRIVER, DB_HOSTNAME, DB_USERNAME, DB_PASSWORD, DB_DATABASE);
		
		require_once(dirname(__FILE__)."/DesignIdea.class.php");
		require_once(dirname(__FILE__)."/Design.class.php");
		require_once(dirname(__FILE__)."/DesignElement.class.php");
	}
	
	/**
	* 
	*/
	public function saveComposition($content, $product_array_streams, $studio_id, $design_array_streams = array(), $design_data = array())
	{
		try {



			$response = array();
			
			$xml = @simplexml_load_string($content);
			if (!is_object($xml))
			{
				return array("ERROR" => "Error reading XML");
			}
			else
			{
				if(isset($this->session->data["user_id"]) || isset($this->session->data["customer_id"])) {
					if(isset($this->session->data["user_id"])) {
						$id_author = 0;
					} else {
						$id_author = $this->session->data["customer_id"];
					}
					
					$idea = new DesignIdea($this->db);
					
					$data["product_id"] = $xml["id_product"];
					$data["id_product_color"] = $xml["id_product_color"];
					$data["name"] = utf8_encode($xml["name"]);
					$data["id_author"] = $id_author;
					
					if(!empty($xml["id_composition"]) && $idea->compositionExists($xml["id_composition"]))///update
					{
						$data["id_composition"] = (string)$xml["id_composition"];
					}
						
					$idea->setFieldsData($data);
					$i = 0;
					foreach ($xml->design as $design_node)
					{
						$designObj = new Design($this->db);
						$designObj->setXML(utf8_encode($design_node->asXML()));
						$designObj->setSnapshot($product_array_streams[$i]);
						if(isset($design_array_streams[$i])) {
							$designObj->setOnlyDesignSnapshot($design_array_streams[$i]);
						}
						if(isset($design_data[$i])) {
							$designObj->setNumColors($design_data[$i]->num_colors);
							$designObj->setNeedWhiteBase($design_data[$i]->need_white_base);
						}
						foreach ($design_node->design_element as $design_element_node)
						{
							$design_element = new DesignElement($this->db);
							$design_element->setDesignElement($design_element_node['id']);
							$design_element->setType($design_element_node['type']);
							$designObj->addDesignElement($design_element);
						}
						$idea->addDesign($designObj);
						$i++;
						
					}
					if($id_comp = $idea->save())
					{
						$this->session->data['studio_data'][$studio_id]['id_composition'] = $id_comp;
						return array("id_composition" => $id_comp); //everything ok!
					}else{
						return array("ERROR" => "error saving composition ".$idea->last_error);
					}
				}else
				{
					return array("ERROR" => "User not logged in ");
				}
			}
			
		} catch (Exception $e) {
			return array("ERROR" => (string)$e);
		}

	}
	public function loadComposition($id_composition, $studio_id)
	{		
		
		$sql = "SELECT * FROM ".DB_PREFIX."composition c, ".DB_PREFIX."design d WHERE d.id_composition=c.id_composition AND c.id_composition='".$id_composition."' ";
		$query = $this->db->query($sql);

		if($query->num_rows>0)
		{
			$response["composition"] =array();
			$response["designs"] = array();
    		foreach ($query->rows as $result) {
				$response["composition"]["id_composition"] =  $result["id_composition"];
				$response["composition"]["name"] = $result["name"];
				$response["composition"]["id_product"] =  $result["product_id"]; //flex will looks for id_product instead of product_id
				$response["composition"]["id_product_color"] = $result["id_product_color"];
				$response["designs"][] .= $result["xml"];
			}
			$this->session->data['studio_data'][$studio_id]['id_composition'] = $id_composition;
			return $response;
		}
		return false;
	}


	public function loadDesign($id_design)
	{		
		
		$sql = "SELECT * FROM ".DB_PREFIX."design d WHERE d.id_design='".$id_design."' ";
		$query = $this->db->query($sql);

		if($query->num_rows>0)
		{
			$response["design"] = $query->row["xml"];
			return $response;
		}
		return false;
	}
	/**
	* setPriceParameters
	*/
	public function setPriceParameters($studio_id, $views = array())
	{
		/*ob_start();
		print_r($studio_id);
		print_r($views);
		error_log(ob_get_contents());
		ob_flush();		*/
		if(empty($studio_id)) {
			return array("ERROR" => "Error: studioID empty! ");
		}

		if(!isset($this->session->data['studio_data'][$studio_id])) {
			return array("ERROR" => "Error: studio session data empty! ");
		}

		if(!empty($views)) {
			foreach ($views as $key => $view_obj) {
				foreach ($view_obj as $prop_name => $value) {
					$this->session->data['studio_data'][$studio_id]['views'][$key][$prop_name] = $value;
				}
			}
		}

		return array("message" => "OK!"); //everything ok!
		
	}
	public function setParameter($studio_id, $key, $value) {
		try {
			$this->session->data['studio_data'][$studio_id][$key] = $value;
			return array("message" => "OK!"); //everything ok!
		} catch (Exception $e) {
			return array("ERROR" => (string)$e);
		}
	}

}
?>
