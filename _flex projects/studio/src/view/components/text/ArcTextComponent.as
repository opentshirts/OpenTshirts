package view.components.text {

	/**
	 * @author José Andriani <joseandriani@gmail.com>
	 */
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import utils.MathUtils;

	public class ArcTextComponent extends Sprite {
		private var _offset:Number = 0;
		private var _radioPercent:Number;
		private var _text:String;
		private var _maxAngle:Number=360;
		private var _totalTextWidth:Number;
		private var _arraySizes:Array;
		private var _textFormat:TextFormat;

		public function ArcTextComponent() {
			
		}
		public function draw():void {
			if(_text.length<1)
			{
				trace("empty text");
				return;
			}
			if (radioPercent==0) 
			{
				noArc();
				return;
			}
			
			//al angulo total barrido es la proporcion entre:
			//el ancho total de las letras menos la mitad del ancho de la primera y la ultima (porque el punto de registracion esta en el centro de la letra):
			// --> (totalTextWidth-(arraySizes[1]/2)-(arraySizes[arraySizes.length-1]/2))
			//y el perimetro total de la circunferencia: --> (2 * Math.PI * radio)
			
			updateLettersSizes(); //updates _arraySizes and _totalTextWidth
			
			var perimeter:Number = (2 * Math.PI * radioPercent);
			var firstLetterWidth:Number = _arraySizes[0];
			var lastLetterWidth:Number = _arraySizes[_arraySizes.length-1];
			
			var totalAngle:Number = (_totalTextWidth-(firstLetterWidth/2)-(lastLetterWidth/2)) * _maxAngle/ perimeter;
			var actualAngle:Number= -totalAngle/2+90+offset;//se inicia alineando el texto
			
			var lettersContainer:Sprite = new Sprite();
			
			for (var i:uint = 0; i<_text.length; i++) {
				var letter:Sprite = new Sprite();
				var txt:TextField = new TextField();
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.defaultTextFormat=_textFormat;
				txt.embedFonts=true;
				//txt.border=true;
				txt.text=_text.charAt(i);
				txt.selectable = false;
				txt.x= -txt.textWidth/2;
				txt.y= -txt.textHeight/2;
				letter.addChild(txt);

				var ang:Number=actualAngle;
				letter.rotation=ang-90;

				letter.rotation=letter.rotation*-1;//invert rotation
				
				letter.x=- Math.cos(MathUtils.toRadians(ang))*radioPercent;
				letter.y=radioPercent-Math.sin(MathUtils.toRadians(ang))*radioPercent;
				
				letter.y=letter.y*-1;//invert y
				
				lettersContainer.addChild(letter);

				///actualAngle dibuja la primer letra en 0 y va sumando la mitad de la letra que dibujo mas
				///la mitad de la letra que va a dibujar...es un quilombo pero sino no queda bien la separacion
				///para letras como la I
				if (i<_text.length-1) {//en el ultimo elemento arraySizes[i+1] arrojaria un error si se sigue sumando actualAngle
					actualAngle+=((_arraySizes[i]/2)+(_arraySizes[i+1]/2)) * _maxAngle/ perimeter;
				}
			}
			while (numChildren>0) removeChildAt(0);
			
			addChild(lettersContainer);
			lettersContainer.x = lettersContainer.width/2;
			lettersContainer.y = (radioPercent>0)?lettersContainer.height-(txt.height/2):(txt.height/2);
			
		}
		public function noArc():void {
			var txt:TextField = new TextField();
			txt.autoSize=TextFieldAutoSize.LEFT;
			txt.defaultTextFormat=_textFormat;
			txt.embedFonts=true;
			//txt.border=true;
			txt.text=_text;
			txt.selectable = false;
			while (numChildren>0) removeChildAt(0)
			addChild(txt);
		}
		
		/**
		 * Carga un arreglo donde en el index 0 guarda el ancho total, la suma de los anchos
		 * de cada letra individual, y en los restantes indices carga en ancho de cada letra
		*/
		private function updateLettersSizes():void {
			_arraySizes = new Array();
			var totalWidth:Number=0;
			
			for (var i:uint = 0; i<_text.length; i++) {
				var txt:TextField = new TextField();
				txt.autoSize=TextFieldAutoSize.LEFT;
				txt.defaultTextFormat=_textFormat;
				txt.embedFonts=true;
				txt.border=true;
				txt.text=_text.charAt(i);
				totalWidth+=txt.textWidth;
				_arraySizes[i]=txt.textWidth;
			}
			_totalTextWidth = totalWidth;
		}
		private function get minRadio():Number
		{
			return (_totalTextWidth)/ (2 * Math.PI);
		}
		public function get offset():Number
		{
			return _offset;
		}

		public function set offset(value:Number):void
		{
			_offset = value;
		}

		public function get radioPercent():Number
		{
			return (_radioPercent==0)?0:minRadio/_radioPercent;
		}

		public function set radioPercent(value:Number):void
		{
			_radioPercent = value;
		}

		public function get text():String
		{
			return _text;
		}

		public function set text(value:String):void
		{
			_text = value;
		}

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
		}


	}
}