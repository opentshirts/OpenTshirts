package view.components.text {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.TriangleCulling;
	import flash.events.Event;
	import flash.geom.Point;
	
	import model.elements.text.envelope.SimpleEnvelopeEffectEnum;


	public class EnvelopeComponent extends Sprite {
		
		private var pOriginalTL:Point;
		private var pOriginalTC:Point;
		private var pOriginalTR:Point;
		private var pOriginalCL:Point;
		private var pOriginalCC:Point;
		private var pOriginalCR:Point;
		private var pOriginalBL:Point;
		private var pOriginalBC:Point;
		private var pOriginalBR:Point;
		
		private var top_arr:Vector.<Point>;
		private var left_arr:Vector.<Point>;
		private var right_arr:Vector.<Point>;
		private var bottom_arr:Vector.<Point>;
		
		private var bitmap:Bitmap;
		private var indices : Vector.<int> = new Vector.<int>();
		private var _rows:uint;
		private var _cols:uint;
		private var holder:Sprite;
		private var _envelopeEffect:uint;
		private var _amount:Number;//range between -1 and 1
		private var _displayObject:DisplayObject;
		
		public function EnvelopeComponent() {
			_rows=17;//with some values dosn't work, i don't know why
			_cols=17*2;//with some values dosn't work, i don't know why
			
			holder=new Sprite();
			this.addChild(holder);
			
			prepTriangles();
		}
		
		
		/*private functions*/
		public function draw():void {
			var myBitmapData:BitmapData=new BitmapData(displayObject.width,displayObject.height,true,0x00FFFFFF);//transparent background
			myBitmapData.draw(displayObject,null,null,null,null,true); //smoothing true
			bitmap=new Bitmap(myBitmapData);
			pOriginalTL = new Point(bitmap.x, bitmap.y);
			pOriginalTC = new Point(bitmap.x+bitmap.width/2, bitmap.y);
			pOriginalTR = new Point(bitmap.x+bitmap.width, bitmap.y);
			
			pOriginalCL = new Point(bitmap.x, bitmap.y+bitmap.height/2);
			pOriginalCC = new Point(bitmap.x+bitmap.width/2, bitmap.y+bitmap.height/2);
			pOriginalCR = new Point(bitmap.x+bitmap.width, bitmap.y+bitmap.height/2);
			
			pOriginalBL = new Point(bitmap.x, bitmap.y+bitmap.height);
			pOriginalBC = new Point(bitmap.x+bitmap.width/2, bitmap.y+bitmap.height);
			pOriginalBR = new Point(bitmap.x+bitmap.width, bitmap.y+bitmap.height);
			
			update();
		}
		
		private function placeCPs():void {
			
			var pTL:Point = pOriginalTL.clone();
			var pTR:Point = pOriginalTR.clone();
			var pBL:Point = pOriginalBL.clone();
			var pBR:Point = pOriginalBR.clone();
			
			var p1:Point;
			
			switch (_envelopeEffect) {

				case SimpleEnvelopeEffectEnum.EFFECT1 :
					p1 = new Point();
					if(_amount>0)
					{
						p1.x = pOriginalTC.x;
						p1.y = pOriginalTC.y + pOriginalBC.y *_amount;
						top_arr=getPointsArray(pTL,pTR,_cols, p1); //parabolic segment
						
						p1.x = pOriginalBC.x;
						p1.y = pOriginalBC.y - pOriginalBC.y *_amount;
						bottom_arr=getPointsArray(pBL,pBR,_cols, p1); //parabolic segment
					}else
					{
						pTL.y = pOriginalTL.y + pOriginalCC.y *_amount * -1;
						pTR.y = pOriginalTR.y + pOriginalCC.y *_amount * -1;
						
						pBL.y = pOriginalBL.y - pOriginalCC.y *_amount * -1;
						pBR.y = pOriginalBR.y - pOriginalCC.y *_amount * -1;
						
						p1.x = pOriginalTC.x;
						p1.y = pOriginalTC.y - pOriginalCC.y *_amount * -1;
						top_arr=getPointsArray(pTL,pTR,_cols, p1); //parabolic segment
						
						p1.x = pOriginalBC.x;
						p1.y = pOriginalBC.y + pOriginalCC.y *_amount * -1;
						bottom_arr=getPointsArray(pBL,pBR,_cols, p1); //parabolic segment
						
					}

					left_arr=getPointsArray(pTL,pBL,_rows); //straight line
					right_arr=getPointsArray(pTR,pBR,_rows); //straight line
					
					break
				case SimpleEnvelopeEffectEnum.EFFECT2 :
					if(_amount>0)
					{
						pTR.y = pOriginalTR.y + pOriginalCC.y *_amount;
						pBR.y = pOriginalBR.y - pOriginalCC.y *_amount;
					}else
					{
						pTL.y = pOriginalTL.y + pOriginalCC.y *_amount * -1;
						pBL.y = pOriginalBL.y - pOriginalCC.y *_amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols); //straight line
					bottom_arr=getPointsArray(pBL,pBR,_cols); //straight line
					left_arr=getPointsArray(pTL,pBL,_rows); //straight line
					right_arr=getPointsArray(pTR,pBR,_rows); //straight line
					break;
				case SimpleEnvelopeEffectEnum.EFFECT3 :
					if(_amount>0)
					{
						pTL.x = pOriginalTL.x + pOriginalCC.x *_amount;
						pTR.x = pOriginalTR.x - pOriginalCC.x *_amount;
					}else
					{
						
						pBL.x = pOriginalBL.x + pOriginalCC.x *_amount * -1;
						pBR.x = pOriginalBR.x - pOriginalCC.x *_amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols); //straight line
					bottom_arr=getPointsArray(pBL,pBR,_cols); //straight line
					left_arr=getPointsArray(pTL,pBL,_rows); //straight line
					right_arr=getPointsArray(pTR,pBR,_rows); //straight line
					
					
					break;
				case SimpleEnvelopeEffectEnum.EFFECT4 :
					p1 = new Point();
					if(_amount>0)
					{
						pTL.y = pOriginalTL.y + pOriginalCC.y/2 *_amount;
						pTR.y = pOriginalTR.y + pOriginalCC.y/2 *_amount;
					}else
					{
						pBL.y = pOriginalBL.y - pOriginalCC.y/2 * _amount * -1;
						pBR.y = pOriginalBR.y - pOriginalCC.y/2 * _amount * -1;
					}
					
					p1.x = pOriginalTC.x;
					p1.y = pOriginalTC.y - pOriginalCC.y/2 * _amount;
					top_arr=getPointsArray(pTL,pTR,_cols, p1); //parabolic segment
					
					p1.x = pOriginalBC.x;
					p1.y = pOriginalBC.y - pOriginalCC.y/2 * _amount;
					bottom_arr=getPointsArray(pBL,pBR,_cols, p1); //parabolic segment
					
					left_arr=getPointsArray(pTL,pBL,_rows); //straight line
					right_arr=getPointsArray(pTR,pBR,_rows); //straight line
					
					break
				case SimpleEnvelopeEffectEnum.EFFECT5 :
					if(_amount>0)
					{
						pTR.x = pOriginalTR.x - pOriginalTR.x * _amount;
					}else
					{
						pBR.x = pOriginalBR.x - pOriginalBR.x * _amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols);
					bottom_arr=getPointsArray(pBL,pBR,_cols);
					left_arr=getPointsArray(pTL,pBL,_rows);
					right_arr=getPointsArray(pTR,pBR,_rows);
					break
				case SimpleEnvelopeEffectEnum.EFFECT6 :
					if(_amount>0)
					{
						pTL.x = pOriginalTL.x + pOriginalTR.x * _amount;
					}else
					{
						pBL.x = pOriginalBL.x + pOriginalBR.x * _amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols);
					bottom_arr=getPointsArray(pBL,pBR,_cols);
					left_arr=getPointsArray(pTL,pBL,_rows);
					right_arr=getPointsArray(pTR,pBR,_rows);
					break
				case SimpleEnvelopeEffectEnum.EFFECT7 :
					if(_amount>0)
					{
						pTR.y = pOriginalTR.y + pOriginalBR.y * _amount;
					}else
					{
						pTL.y = pOriginalTL.y + pOriginalBL.y * _amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols);
					bottom_arr=getPointsArray(pBL,pBR,_cols);
					left_arr=getPointsArray(pTL,pBL,_rows);
					right_arr=getPointsArray(pTR,pBR,_rows);
					break
				case SimpleEnvelopeEffectEnum.EFFECT8 :
					if(_amount>0)
					{
						pBR.y = pOriginalBR.y - pOriginalBR.y * _amount;
					}else
					{
						pBL.y = pOriginalBL.y - pOriginalBL.y * _amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols);
					bottom_arr=getPointsArray(pBL,pBR,_cols);
					left_arr=getPointsArray(pTL,pBL,_rows);
					right_arr=getPointsArray(pTR,pBR,_rows);
					break
				case SimpleEnvelopeEffectEnum.EFFECT9 :
					if(_amount>0)
					{
						pBR.y = pOriginalBR.y - pOriginalCR.y * _amount;
						pBL.y = pOriginalBL.y - pOriginalCL.y * _amount;
						p1 = new Point();
						p1.x = pOriginalBC.x;
						p1.y = pOriginalBC.y + pOriginalCC.y * _amount;
						
					}else
					{
						p1 = new Point();
						p1.x = pOriginalBC.x;
						p1.y = pOriginalBC.y - pOriginalBC.y * _amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols);
					bottom_arr=getPointsArray(pBL,pBR,_cols, p1);
					left_arr=getPointsArray(pTL,pBL,_rows);
					right_arr=getPointsArray(pTR,pBR,_rows);
					break
				case SimpleEnvelopeEffectEnum.EFFECT10 :
					if(_amount>0)
					{
						pTR.y = pOriginalTR.y + pOriginalCR.y * _amount;
						pTL.y = pOriginalTL.y + pOriginalCL.y * _amount;
						p1 = new Point();
						p1.x = pOriginalTC.x;
						p1.y = pOriginalTC.y - pOriginalCC.y * _amount;
						
					}else
					{
						p1 = new Point();
						p1.x = pOriginalTC.x;
						p1.y = pOriginalTC.y + pOriginalBC.y * _amount * -1;
					}
					
					top_arr=getPointsArray(pTL,pTR,_cols, p1);
					bottom_arr=getPointsArray(pBL,pBR,_cols);
					left_arr=getPointsArray(pTL,pBL,_rows);
					right_arr=getPointsArray(pTR,pBR,_rows);
					break
			}
		}

		
		private function update(event : Event = null):void {
			placeCPs();
			
			var uvts : Vector.<Number> = new Vector.<Number>();
			var vertices : Vector.<Number> = new Vector.<Number>();
			vertices.length=0;
			uvts.length=0;
			
			for (var i : uint = 0; i <= _rows; i++) {
				for (var j : uint = 0; j <= _cols; j++) {
					
					var p:Point=getPoint(j,i);
					vertices.push(p.x, p.y);
					uvts.push(j / _cols, i / _rows);
				}
			}
			
			//draw triangles
			/*graphics.lineStyle(1,0x00FF00);
			var verticesDraw : Vector.<Point> = new Vector.<Point>();
			for (i = 0; i < vertices.length; i+=2) {
			verticesDraw.push(new Point(vertices[i],vertices[i+1]));
			}
			for (i = 0; i < indices.length; i+=3) {
			graphics.moveTo(verticesDraw[indices[i]].x,verticesDraw[indices[i]].y);
			graphics.lineTo(verticesDraw[indices[i+1]].x,verticesDraw[indices[i+1]].y);
			graphics.lineTo(verticesDraw[indices[i+2]].x,verticesDraw[indices[i+2]].y);
			graphics.lineTo(verticesDraw[indices[i]].x,verticesDraw[indices[i]].y);
			}*/
			
			holder.graphics.clear();
			holder.graphics.beginBitmapFill(bitmap.bitmapData, null, false, true);
			holder.graphics.drawTriangles(vertices, indices, uvts, TriangleCulling.NONE);
			holder.graphics.endFill();
			
		}
		private function getPoint(col : int, row : int):Point {
			var p0:Point;
			var p1:Point;
			var p:Point;
			var u:Number;
			
			///get ypos 
			p0=top_arr[col];
			p1=bottom_arr[col];
			u = row / _rows ;
			p=Point.interpolate(p0,p1,1-u);
			var y:Number=p.y;
			
			///get xpos 
			p0=left_arr[row];
			p1=right_arr[row];
			u = col / _cols ;
			p=Point.interpolate(p0,p1,1-u);
			var x:Number=p.x;
			
			p=new Point(x,y);
			//graphics.lineStyle(1,0xFF0000);
			//graphics.drawCircle(p.x,p.y, 1);
			return p;
		}
		
		private function getPointsArray(p0 : Point, p2 : Point, steps : uint, p1 : Point=null):Vector.<Point> {
			var arr :Vector.<Point> = new Vector.<Point>();
			for (var u : Number = 0; u <= 1; u += 1 / steps) {
				var p:Point;
				if (p1) {
					p = getQuadraticBezierPoint(u, p0, p1,p2);
				} else {
					p = getLinearBezierPoint(u, p0, p2);
				}
				arr.push(p);
				//graphics.lineStyle(1,0x00FFFF);
				//graphics.drawCircle(p.x,p.y, 2);
			}
			return arr;
		}
		//read http://en.wikipedia.org/wiki/B%C3%A9zier_curve for more info
		private function getQuadraticBezierPoint(u:Number, p0:Point, p1:Point, p2:Point):Point {
			var xpos:Number = Math.pow((1-u), 2) * p0.x + 2 * (1-u) * u * p1.x + Math.pow(u, 2) * p2.x;
			var ypos:Number = Math.pow((1-u), 2) * p0.y + 2 * (1-u) * u * p1.y + Math.pow(u, 2) * p2.y;
			return new Point(xpos,ypos);
		}
		private function getLinearBezierPoint(u:Number, p0:Point, p1:Point):Point {
			var xpos:Number = p0.x+u*(p1.x-p0.x);
			var ypos:Number = p0.y+u*(p1.y-p0.y);
			return new Point(xpos,ypos);
		}
		/* for edges and index asociation
		if you don't understand read this -> :http://help.adobe.com/es_ES/ActionScript/3.0_ProgrammingAS3/WS84753F1C-5ABE-40b1-A2E4-07D7349976C4.html
		*/
		private function prepTriangles():void {
			for (var i : int = 0; i < _rows; i++) {
				for (var j : int = 0; j < _cols; j++) {
					indices.push(i * (_cols+1) + j, i * (_cols+1) + j + 1, (i + 1) * (_cols+1) + j);
					
					indices.push(i * (_cols+1) + j + 1, (i + 1) * (_cols+1) + j + 1, (i + 1) * (_cols+1) + j);
				}
			}
		}
		public function get amount():Number
		{
			return _amount;
		}

		public function set amount(value:Number):void
		{
			_amount = value;
		}

		public function get envelopeEffect():uint
		{
			return _envelopeEffect;
		}

		public function set envelopeEffect(value:uint):void
		{
			_envelopeEffect = value;
		}

		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}

		public function set displayObject(value:DisplayObject):void
		{
			_displayObject = value;
		}


	}
}