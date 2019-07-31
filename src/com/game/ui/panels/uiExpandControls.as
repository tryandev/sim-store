package com.game.ui.panels 
{
	import com.game.containers.GameMode;
	import com.game.global.GlobalObjects;
	import com.game.global.GlobalFunctions;
	import com.game.ui.button.uiButton;
	import com.game.ui.button.uiButtonSprite;
	import com.game.ui.button.uiRectangle;
	import com.game.ui.icons.stats;
	import com.zl.font.Fonts;
	import flash.display.Sprite;
	import com.game.ui.shapes.monoUtility;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.AntiAliasType;
	//import flash.filters.DropShadowFilter;
	//import flash.filters.GlowFilter;
	/**
	 * ...
	 * @author ...
	 */
	public class uiExpandControls extends Sprite {
		
		private var _bg: uiRectangle;
		
		private var _iconSell:Sprite;
		private var _iconStore:Sprite;
		private var _iconRotate:Sprite;
		private var _iconMove:Sprite;
		private var _iconAction:Sprite;
		
		private var _tfSell:TextField;
		private var _tfStore:TextField;
		private var _tfRotate:TextField;
		private var _tfMove:TextField;
		private var _tfAction:TextField;
		
		private var _format:TextFormat;
		
		private const GAP_ICON:Number = 25;
		private const GAP_TEXT:Number = 2;
		private const BG_MARGIN:Number = 10;
		private const SCALE_ICON:Number = 1.1;
		private const SCALE_ICON_OVER:Number = 1.2;
		private const BG_WIDTH:Number = 65;
		
		private var _filters:Array;
		
		public function uiExpandControls() {
			_filters = new Array();
			//_filters.push(new GlowFilter(0xFFFFFF, 1, 2, 2, 10));
			_filters.push(new GlowFilter(0x482a0c, 1, 4, 4, 12));
			_filters.push(new DropShadowFilter(4,45,0x000000, 0.3, 4, 4, 1));
			
			_iconSell = new stats.COINS as Sprite;
			_iconStore = new stats.STORE as Sprite;
			_iconRotate = new stats.ARROW_ROTATE as Sprite;
			_iconMove = new stats.ARROW_MOVE as Sprite;
			_iconAction = new stats.ARROW_DEFAULT as Sprite;
			
			_tfSell = new TextField();
			_tfStore = new TextField();
			_tfRotate = new TextField();
			_tfMove = new TextField();
			_tfAction = new TextField();
			
			_format = new TextFormat();
			_format.font = new Fonts().Klaven();
			_format.align = TextFieldAutoSize.CENTER;
			_format.size = 13.0;
			_format.color = 0x381a0c;
			
			_iconSell.scaleX = SCALE_ICON; 		_iconSell.scaleY = SCALE_ICON;
			_iconStore.scaleX = SCALE_ICON; 	_iconStore.scaleY = SCALE_ICON;
			_iconRotate.scaleX = SCALE_ICON; 	_iconRotate.scaleY = SCALE_ICON;
			_iconMove.scaleX = SCALE_ICON; 		_iconMove.scaleY = SCALE_ICON;
			_iconAction.scaleX = SCALE_ICON; 		_iconAction.scaleY = SCALE_ICON;
			
			_iconSell.y = BG_MARGIN;
			_iconStore.y = _iconSell.y + _iconSell.height + GAP_ICON;
			_iconRotate.y = _iconStore.y + _iconStore.height + GAP_ICON;
			_iconMove.y = _iconRotate.y + _iconRotate.height + GAP_ICON;
			_iconAction.y = _iconMove.y + _iconMove.height + GAP_ICON;
			
			_iconSell.x = BG_WIDTH / 2 - _iconSell.width / 2;
			_iconStore.x = BG_WIDTH / 2 - _iconStore.width / 2;
			_iconRotate.x = BG_WIDTH / 2 - _iconRotate.width / 2;
			_iconMove.x = BG_WIDTH / 2 - _iconMove.width / 2;
			_iconAction.x = BG_WIDTH / 2 - _iconAction.width / 2;
			
			fixTextField(_tfSell, _iconSell, 'Sell');
			fixTextField(_tfStore, _iconStore, 'Store');
			fixTextField(_tfRotate, _iconRotate, 'Rotate');
			fixTextField(_tfMove, _iconMove, 'Move');
			fixTextField(_tfAction, _iconAction, 'Action');
			
			var paramsBG:Object = {
				cornerRadius: 7, 
				borderAlpha: 1, 
				borderSize: 2, 
				borderColor: 0x785a3c,
				fillColor: 0xad8d60, 
				fillColor2: 0x9d7d50, 
				width: BG_WIDTH,
				height: _tfMove.y + _tfMove.height + BG_MARGIN,
				specColor: 0xFFFFFF, 
				specAlpha: 0.3, 
				specSize: 1.2, 
				shadeColor: 0xFFFFFF, 
				shadeAlpha: 0.5, 
				shadeSize: 1.5, 
				angle: 90 
			};
			
			_bg = new uiRectangle(paramsBG);
			
			addChild(_bg);
			
			addChild(_iconSell);
			addChild(_iconStore);
			addChild(_iconRotate);
			addChild(_iconMove);
			//addChild(_iconAction);
			
			addChild(_tfSell);
			addChild(_tfStore);
			addChild(_tfRotate);
			addChild(_tfMove);
			//addChild(_tfAction);
		}
		
		public override function get height():Number {
			return _bg.height;
		}
		
		private function fixTextField(tf:TextField, sp:Sprite, text:String):void {
			//tf.border = true;
			tf.autoSize = TextFieldAutoSize.CENTER;
			tf.embedFonts = true;
			tf.defaultTextFormat = _format;
			tf.selectable = false;
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.sharpness = 100;
			tf.thickness = -200;
			tf.x = Math.round(BG_WIDTH / 2 - tf.width / 2);
			tf.y = Math.round(sp.y + sp.height + GAP_TEXT);
			tf.text = text;
			sp.filters = _filters;
			//tf.filters = _filters;
			sp.addEventListener(MouseEvent.CLICK, iconMouseClick, false, 0, true);
			sp.addEventListener(MouseEvent.MOUSE_OVER, iconMouseOver, false, 0, true);
			sp.addEventListener(MouseEvent.MOUSE_OUT, iconMouseOut, false, 0, true);
			sp.buttonMode = true;
		}
		
		private function iconMouseOver(e:Event):void {
			var sp:Sprite = e.target as Sprite;
			var oldHeight:Number = sp.height;
			sp.scaleX = SCALE_ICON_OVER; sp.scaleY = SCALE_ICON_OVER; 
			var heightDiff:Number = sp.height - oldHeight;
			sp.x = BG_WIDTH / 2 - sp.width / 2;
			sp.y -= heightDiff / 2;
		}
		private function iconMouseOut(e:Event):void {
			var sp:Sprite = e.target as Sprite;
			var oldHeight:Number = sp.height;
			sp.scaleX = SCALE_ICON; sp.scaleY = SCALE_ICON; 
			var heightDiff:Number = sp.height - oldHeight;
			sp.x = BG_WIDTH / 2 - sp.width / 2;
			sp.y -= heightDiff / 2;
		}
		private function iconMouseClick(e:Event):void {
			var sp:Sprite = e.target as Sprite;
			switch (sp) {
				case _iconSell: 	GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_SELL);	break;
				case _iconStore: 	GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_STORE);	break;
				case _iconRotate: 	GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_ROTATE);	break;
				case _iconMove: 	GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_MOVE);	break;
				case _iconAction: 	GlobalObjects.world.map.setGameMode(GameMode.GAMEMODE_LIVE);	break;	
			}
			GlobalFunctions.expandControls_Collapse();
		}
	}

}