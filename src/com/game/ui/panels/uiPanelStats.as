package com.game.ui.panels 
{
	import com.game.global.GlobalObjects;
	import com.game.ui.button.uiButtonText;
	import com.game.ui.button.uiRectangle;
	import com.game.ui.icons.stats;
	import com.zl.font.Fonts;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author ...
	 */
	public class uiPanelStats extends Sprite
	{
		private var _buttonAddCoins:uiButtonText;
		private var _buttonAddCash:uiButtonText;
		
		private var _bgCoins:uiRectangle;
		private var _bgCandy:uiRectangle;
		private var _bgEnergy:uiRectangle;
		private var _bgXP:uiRectangle;
		private var _bgCash:uiRectangle;
		
		private var _tfLevel:TextField;
		private var _statXP:uiStat;
		private var _statCoins:uiStat;
		private var _statCandy:uiStat;
		private var _statCash:uiStat;
		private var _statEnergy:uiStat;
		
		
		public function uiPanelStats() {
			GlobalObjects.uiStats = this;
			// BGs
			var bgFilters:Array = [new DropShadowFilter(2, 90, 0x000000, 0.25, 6, 6, 1, 3, false, false, false)];
			var bgObject:Object;
			var randomColor:int = 0xFFFFFF * Math.random();
			var statSpacing:int = 9;
			var setObject:Function = function ():void { //fillColor: 0xF7F1DF, fillColor2: 0xF0E3BF
				bgObject = {
					cornerRadius: 7, 
					borderAlpha: 1, 
					borderSize: 2, 
					borderColor: 0x785a3c,//0x5b3e28,//3d2a15,
					fillColor: 0xad8d60, 
					fillColor2: 0x9d7d50, 
					width: 150, 
					height: 36, 
					specColor: 0xFFFFFF, 
					specAlpha: 0.3, 
					specSize: 1.2, 
					shadeColor: 0xFFFFFF, 
					shadeAlpha: 0.5, 
					shadeSize: 1.5, 
					angle: 90 };
			}
			
			setObject();
			bgObject.width = 150-5 + 46;
			_bgCoins = new uiRectangle(bgObject);			
			_bgCoins.filters = bgFilters;
			_bgCoins.x = statSpacing;
			_bgCoins.y = statSpacing;
			_buttonAddCoins = new uiButtonText({
				text: 'Add', 
				textSize: 12, 
				fillColor: 0xFFCC00,
				fillColor2: 0xCC7700,
				fillBorderSize: 3,
				fillBorderColor:0x884400, 
				textBorderColor:0x884400, 
				paddingX: 8, 
				paddingY: 4.5
			});
			_buttonAddCoins.x = _bgCoins.x + _bgCoins.width - _buttonAddCoins.width-5;
			_buttonAddCoins.y = Math.round(_bgCoins.y + _bgCoins.height/2 - _buttonAddCoins.height/2);
			
			setObject();
			bgObject.width = 125-3-4;
			_bgCandy = new uiRectangle(bgObject);			
			_bgCandy.filters = bgFilters;
			_bgCandy.x = _bgCoins.x + _bgCoins.width + statSpacing;
			_bgCandy.y = statSpacing;
			
			setObject();
			bgObject.width = 180-4;
			_bgEnergy = new uiRectangle(bgObject);			
			_bgEnergy.filters = bgFilters;
			_bgEnergy.x = _bgCandy.x + _bgCandy.width + statSpacing;
			_bgEnergy.y = statSpacing;
			
			setObject();
			bgObject.width = 180-4;
			_bgXP = new uiRectangle(bgObject);			
			_bgXP.filters = bgFilters;
			_bgXP.x = _bgEnergy.x + _bgEnergy.width + statSpacing;
			_bgXP.y = statSpacing;
			
			setObject();
			bgObject.width = 110 + 50;
			//bgObject.height = 40;
			_bgCash = new uiRectangle(bgObject);			
			_bgCash.filters = bgFilters;
			_bgCash.x = statSpacing;
			_bgCash.y = _bgCoins.y + _bgCoins.height + statSpacing;
			_buttonAddCash = new uiButtonText( { 
				text: 'Add', 
				textSize: 12, 
				fillBorderSize: 3,
				fillColor: 0x99FF00,
				fillColor2: 0x449900, 
				fillBorderColor:0x226600, 
				textBorderColor:0x226600, 
				paddingX: 8, 
				paddingY: 4.5
			});
			_buttonAddCash.x = _bgCash.x + _bgCash.width - _buttonAddCash.width-5;
			_buttonAddCash.y = Math.round(_bgCash.y + _bgCash.height/2 - _buttonAddCash.height/2);
			
			
			// COINS ----------------------------------
			_statCoins = new uiStat( new stats.COINS as Sprite, {textBorderColor: 0x553300});
			_statCoins.x = _bgCoins.x;
			_statCoins.y = statSpacing + Math.round((_bgCoins.height - 0) / 2);
			_statCoins.number = 5000;
			
			// CANDY  ----------------------------------
			_statCandy = new uiStat( new stats.CANDY as Sprite, {textBorderColor: 0x550000, width: _bgCandy.width - 39});
			_statCandy.x = _bgCandy.x - 8;
			_statCandy.y = statSpacing + Math.round((_bgCandy.height - 0)/2);
			_statCandy.number = 2000;
			
			// ENERGY ----------------------------------
			_statEnergy = new uiStatGauge( new stats.BOLT as Sprite, { offset: 12,fillColor:  0x33AAFF,fillColor2: 0x0077FF,textBorderColor: 0x004477, width: _bgEnergy.width - 21});
			_statEnergy.x = _bgEnergy.x+2;
			_statEnergy.y = statSpacing + Math.round((_bgCoins.height - 0) / 2);
			_statEnergy.number = 30;
			
			// XP ----------------------------------
			_statXP = new uiStatGauge( new stats.STAR as Sprite, { offset: 12, fillColor:  0xFFCC33,fillColor2: 0xFF9900,textBorderColor: 0x774400, width: _bgXP.width - 34, logarithmic: true} );
			_statXP.x = _bgXP.x+3;
			_statXP.y = statSpacing + Math.round((_bgCoins.height - 0) / 2);
			_statXP.number = 102938;
			
			// Cash ----------------------------------
			_statCash = new uiStat( new stats.CASH as Sprite, {textBorderColor: 0x004400, width: _bgCash.width - 43-51});
			_statCash.x = _bgCoins.x+4;
			_statCash.y = _bgCash.y + (_bgCash.height) / 2;
			_statCash.number = 10;
			
			
			
			var _format:TextFormat = new TextFormat();
			_format.font =  new Fonts().Klaven();
			_format.align = TextFormatAlign.CENTER;
			_format.color = 0xFFFFFF;
			_format.size = 14;
			
			_tfLevel = new TextField();
			_tfLevel.embedFonts  = true;
			_tfLevel.autoSize = TextFieldAutoSize.LEFT;
			_tfLevel.antiAliasType = AntiAliasType.ADVANCED;
			_tfLevel.selectable = false;
			_tfLevel.sharpness = 50;
			_tfLevel.thickness = -200;
			_tfLevel.mouseEnabled = false;
			_tfLevel.defaultTextFormat = _format;
			_tfLevel.filters = [new DropShadowFilter(0, 0, 0x4F1600/*_textBorderColor*/, 1, 4, 4, 15)];
			
			addChild(_bgCoins);
			addChild(_bgCandy);
			addChild(_bgEnergy);
			addChild(_bgXP);
			addChild(_bgCash);
			
			addChild(_statCoins);
			addChild(_statCandy);
			addChild(_statEnergy);
			addChild(_statXP);
			addChild(_tfLevel);
			addChild(_statCash);
			
			addChild(_buttonAddCoins);
			addChild(_buttonAddCash);
		}
		
		public function set statLevel(val:uint):void {
			_tfLevel.text = val.toString();
			_tfLevel.x = _statXP.x + 19 - _tfLevel.width/2;
			_tfLevel.y = _statXP.y - _tfLevel.height/2 +2;
		}
		public function set statXP(val:uint):void 		{ _statXP.number = val; }
		public function set statCoins(val:uint):void 	{ _statCoins.number = val; }
		public function set statCandy(val:uint):void 	{ _statCandy.number = val; }
		public function set statCash(val:uint):void 	{ _statCash.number = val; }
		public function set statEnergy(val:uint):void 	{ _statEnergy.number = val; }
	}

}