package com.game.ui.panels 
{
	import away3d.events.VideoEvent;
	import com.game.ui.button.uiButton;
	import com.game.ui.button.uiButtonText;
	import com.game.ui.button.uiButtonSprite;
	import com.game.ui.button.uiRectangle;
	import com.game.ui.icons.stats;
	import com.game.ui.shapes.monoUtility;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class uiPanelBottom extends Sprite
	{
		private var _bg:uiRectangle;
		private var _mask:uiRectangle;
		private var _uiNeisGroup:uiNeisGroup;
		private var _uiPanelControls:uiPanelControls;
		
		private var _btnScrollNext1:uiButtonSprite;
		private var _btnScrollNext2:uiButtonSprite;
		private var _btnScrollNext3:uiButtonSprite;
		private var _btnScrollPrev1:uiButtonSprite;
		private var _btnScrollPrev2:uiButtonSprite;
		private var _btnScrollPrev3:uiButtonSprite;
		
		private	const GAP_BOX:uint = 6;
		private	const COUNT_BOX:uint = 7;
		private const MARGIN_BG:uint = 12;
		private const WIDTH_BTN:uint = 29;
		
		public function uiPanelBottom() {
			var paramsBG:Object = {
				cornerRadius: 7, 
				borderAlpha: 1, 
				borderSize: 2, 
				borderColor: 0x785a3c,//0x5b3e28,//3d2a15,
				fillColor: 0xad8d60, 
				fillColor2: 0x9d7d50, 
				width: 530, 
				height: 115, 
				specColor: 0xFFFFFF, 
				specAlpha: 0.3, 
				specSize: 1.2, 
				shadeColor: 0xFFFFFF, 
				shadeAlpha: 0.5, 
				shadeSize: 1.5, 
				angle: 90 };
			_bg = new uiRectangle( paramsBG );
			
			var paramsMask:Object = { width: 515, height: _bg.height, fillAlpha: 0.4 }
			_mask = new uiRectangle(paramsMask);
			_mask.x = MARGIN_BG + WIDTH_BTN + MARGIN_BG/2;
			
			_uiNeisGroup = new uiNeisGroup(GAP_BOX, COUNT_BOX);
			_uiNeisGroup.x = _mask.x + GAP_BOX / 2;
			
			
			_uiNeisGroup.y = _mask.y + _mask.height / 2 - _uiNeisGroup.height / 2;
			_uiNeisGroup.mask = _mask;
			
			_mask.width = (uiNeiBox.BOX_WIDTH + _uiNeisGroup.gap) * _uiNeisGroup.widthCount;
			_mask.redraw();
			
			
			var temp_uiButtonSprite:uiButtonSprite;
			_btnScrollPrev1 = new uiButtonSprite({ sprite: new monoUtility.NEXT_1 as Sprite, paddingX: 29, paddingY: 25, fillBorderSize: 1, specSize: 1, cornerRadius: 5, flipped: true });
			_btnScrollPrev2 = new uiButtonSprite({ sprite: new monoUtility.NEXT_2 as Sprite, paddingX: 29, paddingY: 25, fillBorderSize: 1, specSize: 1, cornerRadius: 5, flipped: true });
			_btnScrollPrev3 = new uiButtonSprite({ sprite: new monoUtility.NEXT_3 as Sprite, paddingX: 29, paddingY: 25, fillBorderSize: 1, specSize: 1, cornerRadius: 5, flipped: true });
			_btnScrollNext1 = new uiButtonSprite({ sprite: new monoUtility.NEXT_1 as Sprite, paddingX: 29, paddingY: 25, fillBorderSize: 1, specSize: 1, cornerRadius: 5 });
			_btnScrollNext2 = new uiButtonSprite({ sprite: new monoUtility.NEXT_2 as Sprite, paddingX: 29, paddingY: 25, fillBorderSize: 1, specSize: 1, cornerRadius: 5 });
			_btnScrollNext3 = new uiButtonSprite({ sprite: new monoUtility.NEXT_3 as Sprite, paddingX: 29, paddingY: 25, fillBorderSize: 1, specSize: 1, cornerRadius: 5 });

			_btnScrollPrev1.x = MARGIN_BG; _btnScrollPrev1.y = 12+5;
			_btnScrollPrev2.x = MARGIN_BG; _btnScrollPrev2.y = _btnScrollPrev1.y+28;
			_btnScrollPrev3.x = MARGIN_BG; _btnScrollPrev3.y = _btnScrollPrev2.y+28;
			_btnScrollNext1.x = _mask.x + _mask.width + MARGIN_BG/2; _btnScrollNext1.y = _btnScrollPrev1.y ;
			_btnScrollNext2.x = _mask.x + _mask.width + MARGIN_BG/2; _btnScrollNext2.y = _btnScrollPrev2.y;
			_btnScrollNext3.x = _mask.x + _mask.width + MARGIN_BG/2; _btnScrollNext3.y = _btnScrollPrev3.y;
			
			
			_bg.width = _btnScrollNext1.x + _btnScrollNext1.width + MARGIN_BG;
			_bg.redraw();
			
			_uiPanelControls =  new uiPanelControls(760-_bg.width -MARGIN_BG);
			_uiPanelControls.y = 0;
			_uiPanelControls.x = 760 - _uiPanelControls.width;
			
			addChild(_uiPanelControls);
			addChild(_bg);
			addChild(_mask);
			addChild(_uiNeisGroup);
			addChild(_btnScrollPrev1); 
			addChild(_btnScrollPrev2); 
			addChild(_btnScrollPrev3); 
			addChild(_btnScrollNext1); 
			addChild(_btnScrollNext2); 
			addChild(_btnScrollNext3); 
			
			_uiNeisGroup.hitEdge(disableButtons);
			_uiNeisGroup.setOffset();
			attachButtons();
		}
		
		public override function get height():Number {
			return _bg.height;
		}
		
		private function attachButtons():void {
			_btnScrollPrev1.addEventListener(uiButton.CLICK, scroll, false, 0, true);
			_btnScrollPrev2.addEventListener(uiButton.CLICK, scroll, false, 0, true);
			_btnScrollPrev3.addEventListener(uiButton.CLICK, scroll, false, 0, true);
			_btnScrollNext1.addEventListener(uiButton.CLICK, scroll, false, 0, true);
			_btnScrollNext2.addEventListener(uiButton.CLICK, scroll, false, 0, true);
			_btnScrollNext3.addEventListener(uiButton.CLICK, scroll, false, 0, true);
		}
		
		private function scroll(e:Event):void {
			if (e.target == _btnScrollNext1) _uiNeisGroup.scroll(1);
			if (e.target == _btnScrollNext2) _uiNeisGroup.scroll(COUNT_BOX);
			if (e.target == _btnScrollNext3) _uiNeisGroup.scroll(10000);
			if (e.target == _btnScrollPrev1) _uiNeisGroup.scroll(-1);
			if (e.target == _btnScrollPrev2) _uiNeisGroup.scroll(-COUNT_BOX);
			if (e.target == _btnScrollPrev3) _uiNeisGroup.scroll(-10000);
		}
		
		private function disableButtons(side:int):void {
			if (side == 0) {
				_btnScrollPrev1.enabled = false;
				_btnScrollPrev2.enabled = false;
				_btnScrollPrev3.enabled = false;
				_btnScrollNext1.enabled = true;
				_btnScrollNext2.enabled = true;
				_btnScrollNext3.enabled = true;
			}else if (side == 2) {
				_btnScrollPrev1.enabled = true;
				_btnScrollPrev2.enabled = true;
				_btnScrollPrev3.enabled = true;
				_btnScrollNext1.enabled = false;
				_btnScrollNext2.enabled = false;
				_btnScrollNext3.enabled = false;
			}else {
				_btnScrollPrev1.enabled = true;
				_btnScrollPrev2.enabled = true;
				_btnScrollPrev3.enabled = true;
				_btnScrollNext1.enabled = true;
				_btnScrollNext2.enabled = true;
				_btnScrollNext3.enabled = true;
			}
		}
	}
}