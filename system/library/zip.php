<?php
final class Zip { 

	public function create_zip($files = array(),$destination = '',$overwrite = false) {
		//if the zip file already exists and overwrite is false, return false
		if(file_exists($destination) && !$overwrite) { return false; }
		//vars
		$valid_files = array();
		//if files were passed in...
		if(is_array($files)) {
			//cycle through each file
			foreach($files as $file) {
				//make sure the file exists
				if(file_exists($file['source'])) {
					$valid_files[] = $file;
				}
			}
		}
		//if we have good files...
		if(count($valid_files)) {
			//create the archive
			$zip = new ZipArchive();
			if($zip->open($destination,$overwrite ? ZIPARCHIVE::OVERWRITE : ZIPARCHIVE::CREATE) !== true) {
				throw new ErrorException("ERROR: while open zip");
			}
			//add the files
			foreach($valid_files as $file) {
				if(!$zip->addFile($file['source'],$file['dest'])) {
					throw new ErrorException("ERROR: while adding to zip ".$file['source'].$file['dest']);
				} 
			}
			
			//close the zip -- done!
			if(!$zip->close()) {
				throw new ErrorException("ERROR: while close zip");
			}
			
			//check to make sure the file exists
			return file_exists($destination);
		}
		else
		{
			return false;
		}
	}
}
?>