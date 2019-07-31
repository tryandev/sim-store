package com.game.ui.button 
{
	import away3d.core.utils.Init;
	import flash.display.Sprite;
	import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class uiButtonSprite extends uiButton {
		
		private var _sprite:Sprite = null;
		public var spriteColor:int	= 0xFFFFFF;
		public var spriteBorderSize:Number	= 4;
		public var spriteBorderColor:int	= 0x004477;
		public var spriteBorderAlpha:Number	= 1;
		public var flipped:Boolean = false;
		
		public function uiButtonSprite(init:Object = null) {
			//this.cacheAsBitmap = true;
			var ini:Init = Init.parse(init);
			paddingX = 25;
			paddingY = 25;
			shadeAlpha = 0;
			_sprite				= ini.getObject("sprite") as Sprite;
			spriteColor			= ini.getInt(	"spriteColor", 			spriteColor);
			spriteBorderSize	= ini.getNumber("spriteBorderSize", 	spriteBorderSize);
			spriteBorderColor	= ini.getInt(	"spriteBorderColor", 	spriteBorderColor);
			spriteBorderAlpha	= ini.getInt(	"spriteBorderAlpha", 	spriteBorderAlpha);
			flipped				= ini.getBoolean("flipped", 			flipped);
			if (_sprite) addChild(_sprite);
			super(init);
		}
		
		public function set sprite(value:Sprite):void {
			removeChild(_sprite);
			_sprite = value;
			addChild(_sprite);
			redraw();
		}
		
		public override function redraw():void {
			var flipOffset:Number = 0;
			if (flipped) {
				_sprite.scaleX = -1;
				flipOffset = _sprite.width;
			}
			_sprite.x = Math.round(paddingX / 2 - _sprite.width / 2 + flipOffset);
			_sprite.y = Math.round(paddingY / 2 - _sprite.height / 2);
			_sprite.filters = [new GlowFilter(spriteBorderColor, spriteBorderAlpha, spriteBorderSize, spriteBorderSize, 16)];
			_fill.width = paddingX;
			_fill.height = paddingY;
			super.redraw();
		}		
	}
}