/********************************************
 title   : Reflection Manager
 version : 1.0
 author  : Wietse Veenstra
 website : http://www.wietseveenstra.nl
 date    : 2007-05-29
********************************************/
package com.fx {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	import mx.events.DragEvent;
	import mx.events.FlexEvent;
	import mx.events.MoveEvent;
	import mx.events.ResizeEvent;
	import mx.states.RemoveChild;
	
	public class ReflectionManager extends UIComponent {
		private static const _rPoint:Point = new Point(0, 0);
		private static const _rMatrix:Matrix = new Matrix();
				
		private var _bitmap:Bitmap = new Bitmap(new BitmapData(1, 1, true, 0));
		private var _targetBMData:BitmapData;
		private var _alphaGrBMData:BitmapData;
		private var _combinedBMData:BitmapData;
		private var _alphaGradient:Matrix = new Matrix();
		private var _blur:Number = 0;
		private var _blurFilter:BitmapFilter;
		private var _fadeFrom:Number = 0.3;
		private var _fadeTo:Number = 0;
		private var _matrix:Matrix;
		private var _point:Point;
		private var _rectangle:Rectangle;
		private var _shape:Shape;
		private var _target:UIComponent;
		
		public function ReflectionManager():void {
			this.addChild(this._bitmap);
			this.invalidateDisplayList();
		}
		
		public function get fadeFrom():Number {
			return this._fadeFrom;
		}
		
		public function set fadeFrom(value:Number):void {
			this._fadeFrom = value;
			this.invalidateDisplayList();
		}
		
		public function get fadeTo():Number {
			return this._fadeFrom;
		}
		
		public function set fadeTo(value:Number):void {
			this._fadeTo = value;
			this.invalidateDisplayList();
		}
		
		public function get blur():Number {
			return this._blur;
		}
		
		public function set blur(value:Number):void {
			this._blur = value;
			this.invalidateDisplayList();
		}
		
		public function set target(value:UIComponent):void {
			if (this._target != null) {
				this._target.removeEventListener(FlexEvent.UPDATE_COMPLETE, targetUpdateHandler, true);
				this._target.removeEventListener(Event.REMOVED_FROM_STAGE, targetRemovedHandler);
				this._target.removeEventListener(MouseEvent.MOUSE_DOWN, targetMouseDownHandler);
				this._target.removeEventListener(ResizeEvent.RESIZE, targetResizeHandler);
				this.clearBMData();
			}
			
			this._target = value;
			
			if (this._target) {
				this._target.addEventListener(FlexEvent.UPDATE_COMPLETE, targetUpdateHandler, true);
				this._target.addEventListener(Event.REMOVED_FROM_STAGE, targetRemovedHandler);
				this._target.addEventListener(MouseEvent.MOUSE_DOWN, targetMouseDownHandler);
				this._target.addEventListener(ResizeEvent.RESIZE, targetResizeHandler);
				this.invalidateDisplayList();
			}
		}
				
		public function targetUpdateHandler(event:FlexEvent):void {
			this.invalidateDisplayList();
		}
		
		private function targetMouseDownHandler(event:MouseEvent):void {
			this._target.addEventListener(MouseEvent.MOUSE_MOVE, targetMoveHandler);
		}
		
		private function targetMoveHandler(event:MouseEvent):void {
			this._bitmap.x = this._target.x;
			this._bitmap.y = this._target.y + this._target.height - 1;
		}
		
		private function targetResizeHandler(event:ResizeEvent):void {
			this.clearBMData();
			this.width = _target.width;
			if (this.parentDocument.hasOwnProperty('distance')) {
				this.height = (_target.height / 100) * this.parentDocument.distance.value;
			} else {
				this.height = (_target.height / 100) * 40;
			}
			this.invalidateDisplayList();
		}
		
		private function targetRemovedHandler(event:Event):void {
			this.parent.removeChild(this);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			if (_target != null) {
				this.drawReflection(_target);
				this._bitmap.bitmapData.dispose();
				this._bitmap.bitmapData = this._combinedBMData;
				this._bitmap.x = _target.x;
				this._bitmap.y = _target.y + _target.height - 1;
			} else {
				this.clearBMData();
			}
		}
		
		private function drawReflection(target:UIComponent):void { 
			if (this.width > 0 && this.height > 0) {
				this._matrix = new Matrix(1, 0, 0, -1, 0, target.height);
				this._point = this._matrix.transformPoint(new Point(0, target.height));
				this._matrix.tx = this._point.x * -1;
				this._matrix.ty = (this._point.y - target.height) * -1;
				
				this._targetBMData = new BitmapData(this.width, this.height, true, 0);
				this._targetBMData.draw(target, this._matrix);
				
				this._rectangle = new Rectangle(0, 0, this.width, this.height);
				
				if (this._blur > 0) {
					this._blurFilter = new BlurFilter(this._blur * 5, this._blur * 10, 1.0);
					this._targetBMData.applyFilter(this._targetBMData, this._rectangle, this._point, this._blurFilter);
				}
				
				if (this._alphaGrBMData == null) {
					this._alphaGradient.createGradientBox(this.width, this.height, Math.PI / 2);
					
					this._shape = new Shape();
					this._shape.graphics.beginGradientFill(GradientType.LINEAR, new Array(0, 0), new Array(this._fadeFrom, this._fadeTo), new Array(0, 0xFF), this._alphaGradient);
					this._shape.graphics.drawRect(0, 0, this.width, this.height);
					this._shape.graphics.endFill();
					
					this._alphaGrBMData = new BitmapData(this.width, this.height, true, 0);
					this._alphaGrBMData.draw(this._shape, _rMatrix);	
				}
				
				this._combinedBMData = new BitmapData(this.width, this.height, true, 0);
				this._combinedBMData.copyPixels(this._targetBMData, this._rectangle, _rPoint, this._alphaGrBMData);
			}
		}
		
		public function clearBMData():void {
			this._targetBMData = null;
			this._alphaGrBMData = null;
			this._combinedBMData = null;
		}
	}
}