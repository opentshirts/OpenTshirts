package utils
{
	import flash.display.BitmapData;

	public class BitmapDataUtil
	{
		public static function convertToTransparent(bd:BitmapData):void
		{
			bd.lock();			
			for( var y:int = 0; y < bd.height; y++ )
			{
				for( var x:int = 0; x < bd.width; x++ )
				{
					var pixelValue:uint = bd.getPixel32(x, y);
					var alphaValue:uint = pixelValue >> 24 & 0xFF;
					var red:uint = pixelValue >> 16 & 0xFF;
					var green:uint = pixelValue >> 8 & 0xFF;
					var blue:uint = pixelValue & 0xFF;
					var newColor:uint =  red << 16 | green << 8 | blue | (((255 - (red + green + blue) / 3 ) * alphaValue/255)<<24);
					bd.setPixel32( x, y, newColor );
				}
			}
			
			bd.unlock();
		}
		
		public static function transparentPixel(bd:BitmapData, color:uint):BitmapData
		{
			var y:int;
			var x:int;
			var pixelValue:uint;
			var alpha:uint;
			var red:uint;
			var green:uint;
			var blue:uint;
			var newColor:uint;
			var color:uint;
			
			var newBD:BitmapData = new BitmapData(bd.width, bd.height, true);
			newBD.lock();
			
			for( y = 0; y < bd.height; y++ )
			{
				for( x = 0; x < bd.width; x++ )
				{
					if(bd.transparent) {//for transparent images (png)
						pixelValue = bd.getPixel32(x, y);
						alpha = pixelValue >> 24 & 0xFF;
					} else { //for non transparent images (jpg)	
						pixelValue = bd.getPixel(x, y);
						alpha = 255;
					}
					red = pixelValue >> 16 & 0xFF;
					green = pixelValue >> 8 & 0xFF;
					blue = pixelValue & 0xFF;
					
					if(color == (red << 16 | green << 8 | blue)) {
						newColor =  0 << 24 | red << 16 | green << 8 | blue;
						newBD.setPixel32( x, y, newColor );
					} else {
						newColor =  alpha << 24 | red << 16 | green << 8 | blue;
						newBD.setPixel32( x, y, newColor );
					}
					
				}
			}
			
			newBD.unlock();
			return newBD;
		}
	}
}