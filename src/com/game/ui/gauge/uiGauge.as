package com.game.ui.gauge 
{
	import away3d.core.utils.Init;
	import com.game.ui.button.uiRectangle;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author ...
	 */
	public class uiGauge extends Sprite{
		private var _back:uiRectangle;
		private var _fill:uiRectangle;
		private var _mask:uiRectangle;
		private var _width:Number 		= 100;
		private var _height:Number 		= 24;
		private var _percent:Number  	= 0.5;
		private var _logarithmic:Boolean  = false;
		private var _offset:Number  = 0;
		
		private var padding:Number 		= 2.0;
		private var cornerRadius:Number	= 5.0;
		private var glossAlpha:Number	= 0.15;
		private var fillColor:int	= 0xFFAA00;
		private var fillColor2:int	= 0xFF6600;
		private var backColor:int	= 0x444444;
		private var backColor2:int	= 0x777777;
		
		public function uiGauge(init:Object = null) {
			var ini:Init = Init.parse(init);
			_width			= ini.getNumber("width", 		_width);
			_height			= ini.getNumber("height", 		_height);
			_percent		= ini.getNumber("percent", 		_percent);
			_logarithmic	= ini.getBoolean("logarithmic", _logarithmic);
			cornerRadius	= ini.getNumber("cornerRadius",	cornerRadius);
			fillColor		= ini.getInt(	"fillColor", 	fillColor);
			fillColor2		= ini.getInt(	"fillColor2", 	fillColor2);
			backColor		= ini.getInt(	"backColor", 	backColor);
			backColor2		= ini.getInt(	"backColor2", 	backColor2);
			glossAlpha		= ini.getNumber("glossAlpha", 	glossAlpha);
			padding			= ini.getNumber("padding", 		padding);
			_offset			= ini.getNumber("offset", 		_offset);
					
			_back = new uiRectangle({width: _width,					height: _height, 				cornerRadius: cornerRadius, fillColor: backColor, fillColor2: backColor2, shadowAlpha: 0.5, shadowBlur: 10});
			_fill = new uiRectangle({width: _width - 2 * padding,	height: _height - 2 * padding,	cornerRadius: cornerRadius - padding, borderSize: 0, borderAlpha: 0, fillColor: fillColor, fillColor2: fillColor2, glossAlpha: 0.2});
			_mask = new uiRectangle({width: _width - 2 * padding,	height: _height - 2 * padding,	cornerRadius: cornerRadius - padding, borderSize: 0, borderAlpha: 0, fillAlpha: 0.5  } );
			
			_mask.visible = false;
			addChild(_back);
			addChild(_fill);
			addChild(_mask);
			redraw();
		}
		
		public override function get width():Number {return _width;}
		public override function get height():Number {return _height;}
		public override function set width(value:Number):void  {_width = value;}
		public override function set height(value:Number):void { _height = value; }
		
		public function redraw():void {
			if (_logarithmic) {
				var finalPercent:Number;
				var curvature:Number;
				var H:Number;
				var K:Number;
				var radius:Number;
				curvature = 0.77;
				H = 1 / curvature;
				K = 1 - H;
				radius = Math.sqrt(2 * H * H - 2 * H + 1);
				finalPercent = Math.sqrt(radius * radius - (_percent - H) * (_percent - H)) + K;
			}else {
				finalPercent = _percent;
			}
			
			var fillWidth:Number = (_width - 2 * padding - _offset) * finalPercent;
			var finalWidth:Number = fillWidth;
			var xOffset:Number = 0;
			if (fillWidth < 2 * cornerRadius) {
				finalWidth = 2 * cornerRadius;
				xOffset = finalWidth - fillWidth;
				_mask.x = Math.round(padding + _offset);
				_mask.y = padding;
				_mask.width = finalWidth
				_mask.height = _height - 2 * padding;
				_fill.mask = _mask
				_mask.redraw();
			}else {
				if (_fill.mask) {
					_fill.mask = null;
				}
			}
			_fill.x = Math.round(padding-xOffset + _offset);
			_fill.y = padding;
			
			_back.width = _width;
			_back.height =  _height;
			_back.redraw();
			
			_fill.width = Math.round(finalWidth);
			_fill.height = _height - 2 * padding;
			_fill.redraw();
		}
		
		public function get percent():Number {
			return _percent;
		}
		public function set percent(value:Number):void {
			_percent = value;
			redraw();
		}
		
	}

}