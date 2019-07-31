package com.game.ui.panels 
{
	import away3d.core.utils.Init;
	import flash.display.Sprite;
	import com.game.ui.button.uiRectangle;
	import com.zl.font.Fonts;
	import flash.filters.GlowFilter;
	import flash.text.TextField
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class uiStat extends Sprite
	{
		
		protected var _bg:*;
		protected var _icon:Sprite;
		protected var _tf:TextField;
		protected var _format:TextFormat;
		protected var _number:int;
		protected var _textBorderColor:int = 0x000000;
		protected var _width:Number = 110;
		protected var _height:Number = 24;
			
		public function uiStat(inIcon:Sprite = null, init:Object = null) {
			var ini:Init = Init.parse(init);
			_textBorderColor = ini.getNumber("textBorderColor", _textBorderColor);
			_width = ini.getNumber("width", _width);
			_height = ini.getNumber("height", _height);
			
			//trace('uiStat');
			buildBG();
			_bg.y = -_bg.height / 2;
			
			if(inIcon){
				_icon = inIcon;
				_icon.x = 0;
				_icon.y = -_icon.height / 2;//)
				_icon.filters = [new GlowFilter(_textBorderColor, 1, 2, 2, 19, 2), new DropShadowFilter(4, 90, 0x000000, 0.3, 0, 0)];
				_bg.x = Math.round(_icon.x + _icon.width - 15);
			}else {
				_bg.x = 0;				
			}
			
			_format = new TextFormat();
			_format.font =  new Fonts().Klaven();
			_format.align = TextFormatAlign.CENTER;
			_format.color = 0xFFFFFF;
			_format.size = 14;
			
			_tf = new TextField();
			_tf.embedFonts  = true;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.selectable = false;
			_tf.sharpness = 50;
			_tf.thickness = -200;
			_tf.mouseEnabled = false;
			_tf.defaultTextFormat = _format;
			_tf.filters = [new DropShadowFilter(0, 0, 0/*_textBorderColor*/, 1, 4, 4, 15)];
			addChild(_bg);
			addChild(_tf);
			if (_icon) addChild(_icon);
			number = 12345678;
		}
		
		protected function buildBG():void {
			_bg = new uiRectangle( {
				borderSize: 0,
				fillAlpha: 1,
				fillColor: 0x876E4B,
				width: _width, 
				height: _height,
				shadowAlpha: 0.15,
				shadowBlur: 6
			});
		}
		
		public function get number():int {
			return _number;
		}
		public function set number(inNumber:int):void {
			//trace('uiStat number set');
			_number = inNumber;
			var tempString:String = _number.toString();
			var result:String = '';
			while (tempString.length > 3){
					var chunk:String = tempString.substr( -3);
					tempString = tempString.substr(0, tempString.length - 3);
					result = ',' + chunk + result;
			}
			if (tempString.length > 0){
					result = tempString + result;
			}
			_tf.text = result;
			_tf.x = _bg.x + _bg.width/2 - _tf.width/2;
			_tf.y = -_tf.height / 2;
		}
	}
}