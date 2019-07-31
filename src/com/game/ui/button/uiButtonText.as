package com.game.ui.button 
{
	import away3d.core.utils.Init;
	import away3d.events.BillboardEvent;
	import flash.display.ColorCorrection;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import com.game.ui.button.uiRectangle;
	import com.zl.font.Fonts;
	import flash.filters.GlowFilter;
	//import flash.ui.Mouse;
	import flash.events.Event;
	import flash.display.Stage;
	/**
	 * ...
	 * @author ...
	 */
	public class uiButtonText extends uiButton {
		
		protected var _tf:TextField;
		protected var _format:TextFormat;
		
		private var _text:String		= 'Add Neighbors';
		
		public var textSize:Number	= 15;
		public var textColor:int	= 0xFFFFFF;
		public var textBorderSize:Number	= 5;
		public var textBorderColor:int	= 0x004477;
		public var textBorderAlpha:Number	= 1;
		
		
		
		public function uiButtonText(init:Object = null) {
			var ini:Init = Init.parse(init);
			_text			= ini.getString("text", 		_text);
			textSize		= ini.getNumber("textSize", 	textSize);
			textColor		= ini.getInt(	"textColor", 	textColor);
			textBorderSize	= ini.getNumber("textBorderSize", 	textBorderSize);
			textBorderColor = ini.getInt(	"textBorderColor", 	textBorderColor);
			textBorderAlpha = ini.getInt(	"textBorderAlpha", 	textBorderAlpha);
			shadeAlpha 		= ini.getNumber("shadeAlpha", 	0);
	
			_format = new TextFormat();
			_format.font =  new Fonts().Klaven()
			
			_tf = new TextField();
			_tf.embedFonts  = true;
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.antiAliasType = AntiAliasType.ADVANCED;
			_tf.selectable = false;
			_tf.sharpness = 100;
			_tf.thickness = -200;
			_tf.mouseEnabled = false;
			addChild(_tf);
			super(init);
		}
		
		public override function redraw():void {
			_format.color = 0xFFFFFF;
			_format.size = textSize;
			_tf.defaultTextFormat = _format;
			_tf.text = _text;
			_tf.x = paddingX;
			_tf.y = paddingY+1;
			_tf.filters = [new GlowFilter(textBorderColor, textBorderAlpha, textBorderSize, textBorderSize, 16)];
			_fill.width = Math.round(_tf.width + 2 * paddingX);
			_fill.height = Math.round(_tf.height + 2 * paddingY);
			super.redraw();
		}
		
		public function set text(value:String):void {
			_text = value;
			redraw();
		}
	}
}