package com.game.ui.panels 
{
	import com.game.global.GlobalObjects;
	import com.game.ui.button.uiButton;
	import com.game.ui.button.uiButtonSprite;
	import com.game.ui.button.uiRectangle;
	import flash.display.Sprite;
	import com.game.ui.shapes.monoUtility;
	import flash.events.Event;
	import flash.events.FocusEvent;
	//import flash.filters.DropShadowFilter;
	//import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class uiExpandUtil extends Sprite {
		
		private var _bg: uiRectangle;
		private var _btnAudioOn:uiButtonSprite;
		private var _btnMusicOn:uiButtonSprite;
		private var _btnZoomIn:uiButtonSprite;
		private var _btnZoomOut:uiButtonSprite;
		private var _spriteAudioCross:Sprite;
		private var _spriteMusicCross:Sprite
		public function uiExpandUtil() {
			
			var btnWidth:Number = 27;
			var btnHeight:Number = 27;
			var btnMargin:Number = 3;
			var bgMargin:Number = 5;
			 
			_btnAudioOn = new uiButtonSprite( { sprite: new monoUtility.AUDIO_ON as Sprite, 	paddingX: btnWidth, paddingY: btnHeight, fillBorderSize: 1, specSize: 1, cornerRadius: 5 } ); 
			_btnMusicOn = new uiButtonSprite( { sprite: new monoUtility.MUSIC as Sprite, 		paddingX: btnWidth, paddingY: btnHeight, fillBorderSize: 1, specSize: 1, cornerRadius: 5 } ); 
			_btnZoomIn = new uiButtonSprite( { sprite: new monoUtility.ZOOM_IN as Sprite, 		paddingX: btnWidth, paddingY: btnHeight, fillBorderSize: 1, specSize: 1, cornerRadius: 5 } ); 
			_btnZoomOut = new uiButtonSprite( { sprite: new monoUtility.ZOOM_OUT as Sprite, 	paddingX: btnWidth, paddingY: btnHeight, fillBorderSize: 1, specSize: 1, cornerRadius: 5 } ); 
			
			_btnAudioOn.x = 	bgMargin; _btnAudioOn.y =	0 * (btnMargin + btnHeight) + bgMargin;
			_btnMusicOn.x = 	bgMargin; _btnMusicOn.y =	1 * (btnMargin + btnHeight) + bgMargin;
			_btnZoomIn.x = 		bgMargin; _btnZoomIn.y = 	2 * (btnMargin + btnHeight) + bgMargin;
			_btnZoomOut.x = 	bgMargin; _btnZoomOut.y = 	3 * (btnMargin + btnHeight) + bgMargin;
			
			var paramsBG:Object = {
				cornerRadius: 7, 
				borderAlpha: 1, 
				borderSize: 2, 
				borderColor: 0x785a3c,
				fillColor: 0xad8d60, 
				fillColor2: 0x9d7d50, 
				width: btnWidth + 2 * bgMargin,
				height: _btnZoomOut.y + _btnZoomOut.height + bgMargin,
				specColor: 0xFFFFFF, 
				specAlpha: 0.3, 
				specSize: 1.2, 
				shadeColor: 0xFFFFFF, 
				shadeAlpha: 0.5, 
				shadeSize: 1.5, 
				angle: 90 
			};
			_bg = new uiRectangle(paramsBG);
			
			//var crossOutline:DropShadowFilter = new DropShadowFilter(0,0,0x000000,1,3,3,4);
			_spriteAudioCross = new monoUtility.CROSS as Sprite;
			_spriteMusicCross = new monoUtility.CROSS as Sprite;
			_spriteAudioCross.x = Math.round(_btnAudioOn.x + _btnAudioOn.width * 0.33 	- _spriteAudioCross.width / 2);
			_spriteAudioCross.y = Math.round(_btnAudioOn.y + _btnAudioOn.height * 0.33	- _spriteAudioCross.height / 2);
			_spriteMusicCross.x = Math.round(_btnMusicOn.x + _btnMusicOn.width * 0.33 	- _spriteMusicCross.width / 2);
			_spriteMusicCross.y = Math.round(_btnMusicOn.y + _btnMusicOn.height * 0.33	- _spriteMusicCross.height / 2);
			_spriteAudioCross.mouseEnabled = false;
			_spriteMusicCross.mouseEnabled = false;
			//_spriteAudioCross.visible = false;
			//_spriteMusicCross.visible = false;
			//_spriteAudioCross.filters = [crossOutline];
			//_spriteMusicCross.filters = [crossOutline];
			
			addChild(_bg);
			addChild(_btnAudioOn); _btnAudioOn.addEventListener(uiButton.CLICK, clickHandler, false, 0, true);
			addChild(_btnMusicOn); _btnMusicOn.addEventListener(uiButton.CLICK, clickHandler, false, 0, true);
			addChild(_btnZoomIn);   _btnZoomIn.addEventListener(uiButton.CLICK, clickHandler, false, 0, true);
			addChild(_btnZoomOut); _btnZoomOut.addEventListener(uiButton.CLICK, clickHandler, false, 0, true);
			addChild(_spriteAudioCross);
			addChild(_spriteMusicCross);
			
		}
		
		private function clickHandler(e:Event): void {
			if (e.target == _btnAudioOn) {
				_spriteAudioCross.visible = !_spriteAudioCross.visible;
			}else if (e.target == _btnMusicOn) {
				_spriteMusicCross.visible = !_spriteMusicCross.visible;				
			}else if (e.target == _btnZoomIn) {
				GlobalObjects.world.zoom(1);
			}else if (e.target == _btnZoomOut) {
				GlobalObjects.world.zoom(-1);				
			}
		}
		
		public override function get height():Number {
			return _bg.height;
		}
	}

}