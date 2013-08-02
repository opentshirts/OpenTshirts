<?php
final class TTF2PNG {
    private $ttf;
    private $width;
    private $height;
	private $text;
	private $font_size;
	private $image;
		
	public function __construct($ttf, $info = array()) {
		if (file_exists($ttf)) {
			$this->ttf = $ttf;

			if(isset($info['width'])) {
				$this->width = $info['width'];
			}
        	
			if(isset($info['height'])) {
				$this->height = $info['height'];
			}
        	
			if(isset($info['font_size'])) {
				$this->font_size = $info['font_size'];
			} else {
				$this->font_size = 20;
			}
        	
			if(isset($info['text'])) {
				$this->text = $info['text'];
			} else {
				$this->text = "Sample";
			}
        	
        	$this->create();
			
    	} else {
      		exit('Error: Could not load ttf ' . $ttf . '!');
    	}
	}
		
	private function create() {
		// First we create our bounding box for the first text
		$bbox = imagettfbbox($this->font_size, 0, $this->ttf, $this->text);
		
		//$txtWidth = abs($bbox[4]);
		$txtWidth = $bbox[4] - $bbox[6]; // upper-right x minus upper-left x 
		//$txtHeight = abs($bbox[5]);
		$txtHeight = $bbox[3] - $bbox[5]; // lower-right y minus upper-right y
		//echo $txtHeight.$txtWidth;
		//var_dump($bbox);
		if (isset($this->width) && isset($this->height))
		{
			$im = imagecreatetruecolor($this->width, $this->height);
		}else{
			$im = imagecreatetruecolor($txtWidth, $txtHeight*1.5);//error margin
		}
		
		//set transparent background
		imagealphablending($im, false);
		imagesavealpha($im, true);
		$trans_colour = imagecolorallocatealpha($im, 0, 0, 0, 127);
		imagefill($im, 0, 0, $trans_colour);
		// Set the background to be white
		/*$white = imagecolorallocate($im, 255, 0, 255);
		$red = imagecolorallocate($im, 255, 0, 0);
		imagefilledrectangle($im, 0, 0, imagesx($im), imagesy($im), $red);*/
		
		// This is our cordinates for X and Y
		//$x = (imagesx($im)-$txtWidth) / 2 ;
		$x = 0 ;
		$y = (imagesy($im) - $txtHeight) / 2  + $this->font_size;
		// Write it
		$fontColor = imagecolorallocate($im, 0, 0, 0);
		imagettftext($im, $this->font_size, 0, $x, $y, $fontColor, $this->ttf, $this->text);
		
		$this->image = $im;
    }    
	
	public function getImage() {
		return imagepng($this->image);
	}
	public function save($file) {
       imagepng($this->image, $file, 0);
	   
	   imagedestroy($this->image);
	}
	
}
?>