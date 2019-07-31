package com.game.ui.panels 
{
	import away3d.core.utils.Init;
	import com.game.ui.gauge.uiGauge;
	import flash.display.Sprite
	public class uiStatGauge extends uiStat
	{
		private var _offset:Number = 0;
		private var fillColor:int	= 0xFFAA00;
		private var fillColor2:int	= 0xFF6600;
		private var _logarithmic:Boolean  = false;
		
		
		public function uiStatGauge(inIcon:Sprite = null, init:Object = null) {
			var ini:Init = Init.parse(init);
			_offset			= ini.getNumber("offset", 		_offset);
			fillColor		= ini.getInt(	"fillColor", 	fillColor);
			fillColor2		= ini.getInt(	"fillColor2", 	fillColor2);
			_logarithmic	= ini.getBoolean("logarithmic", _logarithmic);
			super(inIcon, init);
			_width 			= ini.getNumber("width", _width);
		}
		
		protected override function buildBG():void {
			_bg = new uiGauge({
				borderSize: 0,
				fillAlpha: 0.15,
				fillColor:  fillColor,
				fillColor2: fillColor2,
				backColor:  0x444444,
				backColor2: 0x222222,
				width: _width, 
				height: 24,
				padding: 2,
				offset: _offset,
				logarithmic: _logarithmic
			});
		}
		
		public override function set number(inNumber:int):void {
			super.number = inNumber;
			_tf.x = _bg.x + (_bg.width / 2) - _tf.width / 2;
		}
	}
}