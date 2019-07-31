package com.game.ui.panels 
{
	import away3d.core.draw.PrimitiveQuadrantTreeNode;
	import com.game.containers.GameMode;
	import com.game.global.GlobalFunctions;
	import com.game.global.GlobalObjects;
	import com.game.ui.button.uiButton;
	import com.game.ui.button.uiButtonSprite;
	import com.game.ui.button.uiRectangle;
	import com.game.ui.icons.stats;
	import com.greensock.TweenNano;
	import com.zl.utils.WebTrack;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import com.game.ui.shapes.monoUtility;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.FocusEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class uiPanelControls extends Sprite {
		private var _bg:uiRectangle;
		private var _bgUtil:uiRectangle;
		
		private var _btnFull:uiButtonSprite;
		private var _btnConfig:uiButtonSprite;
		
		private var _btnArrow:uiButtonSprite;
		private var _btnCancel:uiButtonSprite;
		
		private var _utilExpanded:Boolean = false;
		private var _utilExpanding:Boolean = false;
		
		private var _controlsExpanded:Boolean = false;
		private var _controlsExpanding:Boolean = false;
		
		private var _bgWidth:Number = 200;
		
		public var expandUtil:uiExpandUtil;
		public var expandControls:uiExpandControls;
		
		private	const MARGIN_BTN:Number = 3;
		private	const MARGIN_BG:Number = 8;
		
		public function uiPanelControls(inWidth:Number = 0) {
			if (inWidth != 0) _bgWidth = inWidth;
			
			var paramsBG:Object = getParamsBG();
			_bg = new uiRectangle( paramsBG );
			
			_btnConfig = 	new uiButtonSprite( { sprite: new monoUtility.WRENCH as Sprite, 	paddingX: 27, paddingY: 27, fillBorderSize: 1, specSize: 1, cornerRadius: 5 } ); 
			_btnConfig.x = _bg.width - _btnConfig.width - MARGIN_BG - MARGIN_BG; 
			_btnConfig.y = -_btnConfig.height - MARGIN_BG + _bg.borderSize;
			
			_btnFull = 		new uiButtonSprite( { sprite: new monoUtility.FULLSCREEN as Sprite,	paddingX: 27, paddingY: 27, fillBorderSize: 1, specSize: 1, cornerRadius: 5 } ); 
			_btnFull.x = _btnConfig.x - _btnFull.width - MARGIN_BTN; 
			_btnFull.y = _btnConfig.y;
			
			_btnArrow = 	new uiButtonSprite(getParamsArrow()); 
			_btnCancel = 	new uiButtonSprite(getParamsArrow()); 
			_btnCancel.spriteBorderColor = 0x583A27;// 0x462F20
			_btnCancel.sprite = new stats.ARROW_STOP as Sprite;
			
			_btnArrow.x = _bg.x + MARGIN_BG; 
			_btnArrow.y = _bg.y + MARGIN_BG;
			_btnCancel.x = _btnArrow.x; 
			_btnCancel.y = _btnArrow.x;
			_btnCancel.visible = false;
			
			paramsBG = getParamsBG();
			paramsBG.height = 50;
			paramsBG.width = _btnFull.width + MARGIN_BTN + _btnConfig.width + 2 * MARGIN_BG;
			
			_bgUtil = new uiRectangle( paramsBG );
			_bgUtil.x = _bg.width - _bgUtil.width - MARGIN_BG;
			_bgUtil.y = _btnConfig.y - MARGIN_BG;
			
			expandUtil = new uiExpandUtil();
			expandUtil.y = 0;
			expandUtil.x = _bg.width - expandUtil.width - MARGIN_BG;
			expandUtil.visible = false;
			
			expandControls = new uiExpandControls();
			expandControls.y = 0;
			expandControls.x = 0;
			expandControls.alpha = 0;
			expandControls.visible = false;
			
			addChild(expandUtil);
			addChild(expandControls);
			
			addChild(_bgUtil);
			addChild(_bg);
			
			addChild(_btnConfig); 
			addChild(_btnFull); 
			
			addChild(_btnArrow); 
			addChild(_btnCancel); 
			
			_btnConfig.addEventListener(uiButton.CLICK, toggleUtil, false, 0, true);
			_btnFull.addEventListener(uiButton.CLICK, toggleFull, false, 0, true);
			_btnArrow.addEventListener(uiButton.CLICK, arrowClick, false, 0, true);
			_btnCancel.addEventListener(uiButton.CLICK, cancelClick, false, 0, true);
			
			GlobalFunctions.expandUtil_Collapse = collapseUtil;
			GlobalFunctions.expandControls_Collapse = collapseControls;
			GlobalObjects.uiControls = this;
			
			var aMC1:MovieClip = new stats.ATTENTION as MovieClip
			var aMC2:MovieClip = new stats.ATTENTION as MovieClip
			aMC1.x = 30;
			aMC1.y = 10;
			aMC2.x = 130
			aMC2.y = -35
			aMC1.scaleX = 1.3;
			aMC1.scaleY = 1.3;
			aMC2.scaleX = 1.3;
			aMC2.scaleY = 1.3;
			
			addChild(aMC1);
			addChild(aMC2);
		}
		
		public override function get height():Number {
			return _bg.height;
		}
		private function cancelClick(e:Event):void {
			_btnArrow.visible = true;
			_btnCancel.visible = false;
			GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_LIVE);
		}
		private function collapseUtil():void {
			if (!_utilExpanding && _utilExpanded) {
				toggleUtil(null);
			}
		}
		
		public function showArrowCancel():void {
			_btnArrow.visible = false;
			_btnCancel.visible = true;
		}
		
		private function collapseControls():void {
			if (!_controlsExpanding && _controlsExpanded) {
				toggleControls(null);
			}
		}
		
		private function arrowClick(e:Event):void {
			toggleControls(e);
		}
		
		private function toggleControls(e:Event):void {
			//GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_LIVE);
			if (_controlsExpanding) return;
			_controlsExpanding = true;
			if (!_controlsExpanded) {
				collapseUtil();
				WebTrack.getInstance().track('controlsExpand');
				expandControls.visible = true;
				expandControls.alpha = 0;
				TweenNano.to(
					expandControls, 
					0.3, 
					{ 
						y: -expandControls.height - MARGIN_BG, 
						alpha: 1, 
						onComplete: function():void { 
							_controlsExpanding = false; 
							_controlsExpanded = true;
						}
					} 
				);
			}else {
				TweenNano.to(
					expandControls, 
					0.3, 
					{ 
						y: 0, 
						alpha: 0, 
						onComplete: function():void { 
							_controlsExpanding = false; 
							_controlsExpanded = false; 
							expandControls.visible = false;
						}
					} 
				);			
			}
			
		}
		
		private function toggleUtil(e:Event):void {
			if (_utilExpanding) return;
			_utilExpanding = true;
			if (!_utilExpanded) {
				WebTrack.getInstance().track('utilsExpand');
				collapseControls();
				expandUtil.visible = true;
				TweenNano.to(
					expandUtil, 
					0.3, 
					{ 
						y: _bgUtil.y - expandUtil.height - MARGIN_BTN, 
						onComplete: function():void { 
							_utilExpanding = false; 
							_utilExpanded = true;
						}
					} 
				);
			}else {
				TweenNano.to(
					expandUtil, 
					0.3, 
					{ 
						y: 0, 
						onComplete: function():void { 
							_utilExpanding = false; 
							_utilExpanded = false; 
							expandUtil.visible = false;
						}
					} 
				);			
			}
		}
		
		private function toggleFull(e:Event):void {
			WebTrack.getInstance().track('fullscreen');
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState=StageDisplayState.FULL_SCREEN;
			} else {
				stage.displayState=StageDisplayState.NORMAL;
			}
		}
		private function getParamsBG():Object {	
			return {
				cornerRadius: 7, 
				borderAlpha: 1, 
				borderSize: 2, 
				borderColor: 0x785a3c,//0x5b3e28,//3d2a15,
				fillColor: 0xad8d60, 
				fillColor2: 0x9d7d50, 
				width: _bgWidth, 
				height: 115, 
				specColor: 0xFFFFFF, 
				specAlpha: 0.3, 
				specSize: 1.2, 
				shadeColor: 0xFFFFFF, 
				shadeAlpha: 0.5, 
				shadeSize: 1.5, 
				angle: 90 
			};
		}
		private function getParamsArrow():Object {
			return { 
				sprite: new stats.ARROW_DEFAULT as Sprite,	
				spriteBorderColor: 0x684a2c,
				paddingX: 56, 
				paddingY: 56, 
				fillBorderSize: 1, 
				fillBorderColor: 0x785a3c,//0x5b3e28,//3d2a15,
				fillColor: 0xcdad80, 
				fillColor2: 0x9d7d50, 
				specSize: 1.3, 
				
				specColor: 0xFFFFFF, 
				specAlpha: 0.3, 
				
				shadeColor: 0xFFFFFF, 
				shadeAlpha: 0.3, 
				
				bevelSize: 0,
				bevelAlpha: 0.4,
				
				hoverBrightness: 1.05,
				hoverShadowAlpha: 0.3,
				hoverShadowDistance: 2,
				hoverShadowBlur: 4,
				
				cornerRadius: 5,
				glossAlpha:0.0
			};
		}
	}

}