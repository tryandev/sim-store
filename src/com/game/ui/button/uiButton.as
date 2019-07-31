package com.game.ui.button 
{
	import away3d.core.utils.Init;
	import away3d.events.BillboardEvent;
	import flash.display.ColorCorrection;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.BitmapFilter;
	import flash.filters.ColorMatrixFilter;
	import com.game.ui.button.uiRectangle;
	import com.zl.font.Fonts;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	//import flash.ui.Mouse;
	import flash.events.Event;
	import flash.display.Stage;
	/**
	 * ...
	 * @author ...
	 */
	public class uiButton extends Sprite {
		
		public static const CLICK:String = 'uiButtonClick';
		
		private var _enabled:Boolean = true;
		
		private const INDEX_FILTER_HOVER:uint = 0;
		private const INDEX_FILTER_HOVER2:uint = INDEX_FILTER_HOVER + 1;
		private const INDEX_FILTER_ENABLED:uint = INDEX_FILTER_HOVER + 1;
		private const INDEX_FILTER_BEVEL1:uint = INDEX_FILTER_ENABLED + 1;
		private const INDEX_FILTER_BEVEL2:uint = INDEX_FILTER_BEVEL1 + 1;
		private var _filters:Array = new Array(INDEX_FILTER_BEVEL2);
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _fill:uiRectangle;
		protected var _x:Number = 0;
		protected var _y:Number = 0;
		
		public var paddingX:Number 	= 15.0;
		public var paddingY:Number 	= 5.0;
		public var cornerRadius:Number	= 7.0;
		public var glossAlpha:Number	= 0.4;
		
		public var fillColor:int			= 0x00AAFF;
		public var fillColor2:int			= 0x0066FF;
		public var fillBorderSize:Number	= 3;
		public var fillBorderColor:int		= 0x004477;
		public var fillBorderAlpha:Number	= 1;
		
		public var bevelSize:Number = 0;
		public var bevelAlpha:Number = 0.5;
		
		public var specColor:int		= 0xFFFFFF;
		public var specAlpha:Number		= 0.5;
		public var specSize:Number		= 1.5;
	
		public var shadeColor:int		= 0x000000;
		public var shadeAlpha:Number	= 0.30;
		public var shadeSize:Number		= 1.0;
		
		public var shadowAlpha:Number	= 0;
		public var shadowBlur:Number	= 5;
		
		public var hoverBrightness:Number = 1.2;
		public var hoverShadowAlpha:Number = 0;
		public var hoverShadowDistance:Number = 4;
		public var hoverShadowBlur:Number = 0;
		
		
		public function uiButton(init:Object = null) {
			var ini:Init = Init.parse(init);
			
			paddingX		= ini.getNumber("paddingX", 	paddingX);
			paddingY		= ini.getNumber("paddingY", 	paddingY);
			cornerRadius	= ini.getNumber("cornerRadius",	cornerRadius);
			glossAlpha		= ini.getNumber("glossAlpha", 	glossAlpha);
			fillColor		= ini.getInt(	"fillColor", 	fillColor);
			fillColor2		= ini.getInt(	"fillColor2", 	fillColor2);
			fillBorderSize	= ini.getNumber("fillBorderSize", 	fillBorderSize);
			fillBorderColor = ini.getInt(	"fillBorderColor", 	fillBorderColor);
			fillBorderAlpha = ini.getNumber("fillBorderAlpha", 	fillBorderAlpha);
			
			specColor 		= ini.getNumber("specColor", 	specColor);
			specAlpha 		= ini.getNumber("specAlpha", 	specAlpha);
			specSize 		= ini.getNumber("specSize", 	specSize);
			
			shadeColor 		= ini.getNumber("shadeColor", 	shadeColor);
			shadeAlpha 		= ini.getNumber("shadeAlpha", 	shadeAlpha);
			shadeSize 		= ini.getNumber("shadeSize", 	shadeSize);
			
			bevelSize 		= ini.getNumber("bevelSize", 	bevelSize);
			bevelAlpha 		= ini.getNumber("bevelAlpha", 	bevelAlpha);
			
			shadowAlpha = 	ini.getNumber(	"shadowAlpha",	shadowAlpha);
			shadowBlur = 	ini.getNumber(	"shadowBlur", 	shadowBlur);
			
			hoverBrightness = 		ini.getNumber(	"hoverBrightness", 		hoverBrightness);
			hoverShadowAlpha = 		ini.getNumber(	"hoverShadowAlpha", 	hoverShadowAlpha);
			hoverShadowDistance = 	ini.getNumber(	"hoverShadowDistance", 	hoverShadowDistance);
			hoverShadowBlur = 		ini.getNumber(	"hoverShadowBlur", 		hoverShadowBlur);
			
			_fill = new uiRectangle({
				cornerRadius: cornerRadius, 
				glossAlpha: glossAlpha, 
				
				fillColor: fillColor, 
				fillColor2: fillColor2, 
				
				borderAlpha: fillBorderAlpha,
				borderColor: fillBorderColor,
				borderSize: fillBorderSize,
				
				specColor: specColor,
				specAlpha: specAlpha,
				specSize: specSize,
				
				shadeColor: shadeColor,
				shadeAlpha: shadeAlpha,
				shadeSize: shadeSize,
				
				shadowAlpha: shadowAlpha,
				shadowBlur: shadowBlur
			});
			
			addChildAt(_fill, 0);

			this.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OVER, mouseOverHandler, false, 0, true);
			this.addEventListener(MouseEvent.MOUSE_OUT, mouseOutHandler, false, 0, true);
			this.buttonMode = true;
			mouseOutHandler(null);
			redraw();
			//this.addEventListener(Event.ENTER_FRAME, mouseListener, false, 0, true);
		}
		private function mouseOverHandler(e:Event):void {
			if (hoverBrightness > 1){
				_filters[INDEX_FILTER_HOVER] = new ColorMatrixFilter(
					[
						hoverBrightness, 0, 0, 0, 0,
						0, hoverBrightness, 0, 0, 0,
						0, 0, hoverBrightness, 0, 0,
						0, 0, 0, 1, 0
					]
				);
			}
			_filters[INDEX_FILTER_HOVER2] = null;
			updateFilters();
			//this.filters = _filters;
		}
			
		private function mouseOutHandler(e:Event):void {
			if (_enabled) {
				//trace('clear filters');
				_filters[INDEX_FILTER_HOVER] = null;
				if (hoverShadowAlpha > 0){
					_filters[INDEX_FILTER_HOVER2] = new DropShadowFilter(hoverShadowDistance, 45, 0x000000, hoverShadowAlpha, hoverShadowBlur, hoverShadowBlur,1, 3);
				}
				updateFilters();
			}else {
				//trace('disabled no clear');				
			}
		}
		
		private function clickHandler(e:Event):void {
			dispatchEvent(new Event(CLICK));
		}
		
		/*public function mouseListener(myEvent:Event):void {
				_tf.sharpness = (stage.mouseX * (800 / stage.width)) - 400;
				_tf.thickness = (stage.mouseY * (400 / stage.height)) - 200;
				text = "sharpness=" + Math.round(_tf.sharpness) + ", thickness=" + Math.round(_tf.thickness);
				redraw();
		}*/
		
		public override function get width():Number {return _width;}
		//public override function set width(value:Number):void  {_width = value;}
		public override function get height():Number {return _height;}
		//public override function set height(value:Number):void { _height = value; }
		
		public function set ux(value:Number):void	{ _x = value; this.x = Math.round(_x); }
		public function set uy(value:Number):void	{ _y = value; this.x = Math.round(_x); }
		public function get uy():Number {return _x;}
		public function get ux():Number {return _y;}
		
		public function redraw():void {
			_fill.fillColor = fillColor;
			_fill.fillColor2 = fillColor2;
			_fill.borderColor = fillBorderColor;
			_width = _fill.width;
			_height = _fill.height;
			_fill.shadeAlpha = shadeAlpha;
			_fill.redraw();
			if (bevelAlpha > 0 && bevelSize > 0) {
				_filters[INDEX_FILTER_BEVEL1] = new DropShadowFilter( -bevelSize, 45, 0x000000, bevelAlpha/2, 0, 0, 1, 1);
				_filters[INDEX_FILTER_BEVEL2] = new DropShadowFilter(  bevelSize, 45, 0xFFFFFF, bevelAlpha, 0, 0, 1, 1);
				updateFilters();
			}
		}
		
		public function set enabled(val:Boolean):void {
			if (_enabled == val) return;
			_enabled = val;
			if (!val) {
				_filters[INDEX_FILTER_ENABLED] = new ColorMatrixFilter(
					[
						0.2225, 0.7169, 0.0606, 0, 0,
						0.2225, 0.7169, 0.0606, 0, 0,
						0.2225, 0.7169, 0.0606, 0, 0,
						0, 0, 0, 1, 0
					]
				);
				updateFilters();
				this.mouseChildren = false;
				this.mouseEnabled = false;
			}else {
				_filters[INDEX_FILTER_ENABLED] = null;
				updateFilters();
				this.filters = null;
				this.mouseChildren = true;
				this.mouseEnabled = true;
			}
		}
		public function get enabled():Boolean {
			return _enabled;
		}
		private function updateFilters():void {
			var nonNull:Array = new Array();
			for each (var _bitmapFilter:BitmapFilter in _filters) {
				if (_bitmapFilter != null) {
					nonNull.push(_bitmapFilter);
				}
			}
			this.filters = nonNull;
		}
	}

}