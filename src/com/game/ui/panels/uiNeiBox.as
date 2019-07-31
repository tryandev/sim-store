package com.game.ui.panels 
{
	import com.game.ui.button.uiRectangle;
	import com.game.ui.icons.stats;
	import com.zl.font.Fonts;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.AntiAliasType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author ...
	 */
	public class uiNeiBox extends Sprite {
		private var _bg:uiRectangle;
		private var _pic:uiRectangle;
		private var _star:Sprite;
		private var _tfName:TextField;
		//private var _tfMask:uiRectangle;
		private var _tfLevel:TextField;
		private var _formatName:TextFormat;
		private var _formatLevel:TextFormat;
		
		public static const BOX_WIDTH:int = 62;
		public static const BOX_HEIGHT:int = 83;
		
		public function uiNeiBox() {
			_bg = new uiRectangle({ 
				width: BOX_WIDTH, 
				height: BOX_HEIGHT, 
				fillColor: 0x876E4B, 
				fillAlpha: 1 /**/,
				shadowAlpha: 0.15,
				shadowBlur: 6
			});
			
			_bg.y = 0
			
			
			_star = new stats.STAR;
			_star.scaleX = 0.7;
			_star.scaleY = 0.7;
			_star.x = BOX_WIDTH - _star.width
			_star.y = BOX_HEIGHT - _star.height
			_star.filters = [new DropShadowFilter(3,45,0x000000,0.5)];
			
			_formatName = new TextFormat();
			_formatName.font = new Fonts().Helvetica();
			_formatName.align = TextFieldAutoSize.CENTER;
			_formatName.size = 11;
			_formatName.color = 0xFFFFFF;
			
			_formatLevel = new TextFormat();
			_formatLevel.font = new Fonts().Klaven();
			_formatLevel.align = TextFieldAutoSize.LEFT;
			_formatLevel.size = 12;
			_formatLevel.color = 0xFFFFFF;
			
			_tfName = new TextField();
			_tfName.width = BOX_WIDTH;
			_tfName.height = 19;
			_tfName.y = -1;
			_tfName.embedFonts  = true;
			_tfName.defaultTextFormat = _formatName;
			_tfName.antiAliasType = AntiAliasType.ADVANCED;
			_tfName.thickness = -100;
			_tfName.selectable = false;
			_tfName.mouseEnabled = false;
			_tfName.filters = [new GlowFilter(0x000000,0.7,3,3,3)]
			text = 'Neighbor';
			
			_tfLevel = new TextField();
			_tfLevel.autoSize = TextFieldAutoSize.CENTER;
			_tfLevel.embedFonts  = true;
			_tfLevel.defaultTextFormat = _formatLevel;
			_tfLevel.antiAliasType = AntiAliasType.ADVANCED;
			_tfLevel.thickness = -500;
			_tfLevel.selectable = false;
			_tfLevel.mouseEnabled = false;
			_tfLevel.filters = [new GlowFilter(0x000000, 0.7, 3, 3, 8)]
			//_tfLevel.text = "∞";
			level = 23;
			
			_pic = new uiRectangle( { width: 50, height: 50, fillColor: 0xFFFFFF } );
			_pic.y = _tfName.y + _tfName.height-2;
			_pic.x = BOX_WIDTH / 2 - _pic.width / 2;
			
			//_tfMask = new uiRectangle({width:BOX_WIDTH, height: _tfName.height});
			//_tfMask.y = _tfName.y;
			//_tfName.mask = _tfMask;
			
			addChild(_bg);
			addChild(_pic);
			addChild(_star);
			addChild(_tfName);
			addChild(_tfLevel);
			//addChild(_tfMask);
			//_bg.filters = [ new DropShadowFilter(0,0,0x000000,0.5,5,5,1,3,true)]
		}		
		public function get text():String {
			return _tfName.text;
		}
		public function set text(val:*):void {
			_tfName.text = String(val);
			_tfName.x = Math.round(BOX_WIDTH / 2 - _tfName.width / 2);
			if (_tfName.x < 0) _tfName.x = 0;
		}
		public function get level():uint {
			return uint(_tfLevel.text);
		}
		public function set level(val:*):void {
			_tfLevel.text = String(val);
			_tfLevel.y = _star.y + _star.height / 2 - _tfLevel.height / 2 + 3;
			_tfLevel.x = _star.x + _star.width / 2 - _tfLevel.width / 2;
		}
		public override function get height():Number {
			return BOX_HEIGHT;
		}
	}
}