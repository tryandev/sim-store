package com.game.containers 
{
	import com.game.global.GlobalObjects;
	import com.game.grid.Map;
	import com.game.grid.Tile;
	import com.game.items.MapItemDecor;
	import com.game.ui.icons.stats;
	import com.game.utils.geom.Coordinate;
	import com.zl.utils.WebTrack;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author 
	 */
	public class GameMode {
		public static var GAMEMODE_LIVE:int 	= 0;
		public static var GAMEMODE_MOVE:int 	= 1;
		public static var GAMEMODE_ROTATE:int 	= 2;
		public static var GAMEMODE_SELL:int 	= 3;
		public static var GAMEMODE_STORE:int 	= 4;
		
		private var _tileHolder:Sprite;
		private var _itemHolder:Sprite;
		private var _itemPickUp:MapItemDecor;
		private var _map:Map;
		
		private var _cancelCol:int;
		private var _cancelRow:int;
		private var _cancelRotation:int;
		private var _mode:int;
		
		
		public function GameMode(map:Map, itemHolder:Sprite, tileHolder:Sprite){
			_map = map
			_itemHolder = itemHolder;
			_tileHolder = tileHolder;
		}
		
		public function destroy():void {
			_map.removeEventListener(MouseEvent.MOUSE_MOVE, itemPickUpMove, false);
			_map.removeEventListener(MouseEvent.CLICK, itemPickUpPlace, false);
			_tileHolder = null;
			_itemHolder = null;
			_itemPickUp = null;
			_map = null;
		}
		
		public function setGameMode(mode:int, skipTrace:Boolean = false):void {
			_mode = mode;
			if (mode == GAMEMODE_LIVE) {
				_tileHolder.mouseEnabled = true;
				_tileHolder.mouseChildren = true;
				_itemHolder.mouseEnabled = true;
				_itemHolder.mouseChildren = true;
				itemPickUpCancel();
				GlobalObjects.cursor.showDefault();
				if (!skipTrace) WebTrack.getInstance().track('gameModeLive');
			}
			if (mode == GAMEMODE_MOVE || mode == GAMEMODE_ROTATE) {
				_tileHolder.mouseEnabled = false;
				_tileHolder.mouseChildren = false;
				_itemHolder.mouseEnabled = true;
				_itemHolder.mouseChildren = true;
				itemPickUpCancel();
				if (mode == GAMEMODE_MOVE) {
					GlobalObjects.cursor.showMove();
					if (!skipTrace) WebTrack.getInstance().track('gameModeMove');
				}else {
					GlobalObjects.cursor.showRotate();				
					if (!skipTrace) WebTrack.getInstance().track('gameModeRotate');	
				}
				GlobalObjects.uiControls.showArrowCancel();
			}
			if (mode == GAMEMODE_SELL) {
				_tileHolder.mouseEnabled = false;
				_tileHolder.mouseChildren = false;
				_itemHolder.mouseEnabled = true;
				_itemHolder.mouseChildren = true;
				GlobalObjects.cursor.showSell();
				GlobalObjects.uiControls.showArrowCancel();
				if (!skipTrace) WebTrack.getInstance().track('gameModeSell');
			}
			if (mode == GAMEMODE_STORE) {
				_tileHolder.mouseEnabled = false;
				_tileHolder.mouseChildren = false;
				_itemHolder.mouseEnabled = true;
				_itemHolder.mouseChildren = true;
				GlobalObjects.cursor.showStore();
				GlobalObjects.uiControls.showArrowCancel();
				if (!skipTrace) WebTrack.getInstance().track('gameModeStore');
			}
		}
		private function actionQueueAdd(item:MapItemDecor):void {
		}
		
		private function actionQueueRemove(item:MapItemDecor):void {
			
		}
		
		public function itemMouseEvent(item:MapItemDecor, e:Event):void {
			if (e.type == MouseEvent.CLICK) {
				if (_mode == GAMEMODE_LIVE) {
					if (item.actable()) {
						item.actionPrompt();
						WebTrack.getInstance().track('itemQueue');
					}
				}else if (_mode == GAMEMODE_MOVE || _mode == GAMEMODE_ROTATE) {
					itemPickUp(item, e);
					if (_mode == GAMEMODE_MOVE) {
						WebTrack.getInstance().track('itemPickUp');
					}else {
						WebTrack.getInstance().track('itemPickUpRotate');
					}
				}else if (_mode == GAMEMODE_SELL) {
					item.sellPrompt();
					WebTrack.getInstance().track('itemSell');
				}else if (_mode == GAMEMODE_STORE) {
					item.store();
					WebTrack.getInstance().track('itemStore');
				}
			}
			
			if (e.type == MouseEvent.MOUSE_OVER) {
				item.filters = [new GlowFilter(0xFFAA00, 1, 4, 4, 8)];
				//trace(MapItem.ITEM_MOUSE_OVER);
			}
			if (e.type == MouseEvent.MOUSE_OUT) {
				item.filters = [];
				//trace(MapItem.ITEM_MOUSE_OUT);
			}
		}
		
		private function itemPickUp(item:MapItemDecor, e:Event):void {
			if (_itemPickUp == null) {
				_itemPickUp = item;
				_cancelCol = _itemPickUp.col;
				_cancelRow = _itemPickUp.row;
				_cancelRotation = _itemPickUp.rotate;
				for (var i:int = _itemPickUp.col; i < _itemPickUp.col + _itemPickUp.cols; ++i) {
					for (var j:int = _itemPickUp.row; j < _itemPickUp.row + _itemPickUp.rows; ++j) {
						var tile:Tile = _map.getTile(i, j);
						tile.removeItem(_itemPickUp);
					}
				}
				
				if (_mode == GAMEMODE_ROTATE) {
					//trace('pre  col row: ' + _itemPickUp.col + ", " + _itemPickUp.row);
					_itemPickUp.rotate++;
				}
				_itemHolder.mouseEnabled = false;
				_itemHolder.mouseChildren = false;
				_itemPickUp.tileGlowDraw(true);
				e.stopPropagation();
				_map.addEventListener(MouseEvent.MOUSE_MOVE, itemPickUpMove, false, 0, true);
				_map.addEventListener(MouseEvent.CLICK, itemPickUpPlace, false, 0, true);
			}
		}
		private function itemPickUpMove(e:Event):void {
			var isoCoord:Coordinate = _map.mapScreentoTile(_map.mouseX, _map.mouseY);
			isoCoord.x = Math.round(isoCoord.x);
			isoCoord.y = Math.round(isoCoord.y);
			if (isoCoord.x < 0 ) isoCoord.x = 0;
			if (isoCoord.y < 0 ) isoCoord.y = 0;
			if (isoCoord.x > _map.cols - _itemPickUp.cols) isoCoord.x = _map.cols - _itemPickUp.cols;
			if (isoCoord.y > _map.rows - _itemPickUp.rows) isoCoord.y = _map.rows - _itemPickUp.rows;
			
			if (_itemPickUp.col != isoCoord.x || _itemPickUp.row != isoCoord.y) {
				var scrCoord:Coordinate = _map.mapTiletoScreen(isoCoord.x, isoCoord.y);
				_itemPickUp.col = isoCoord.x;
				_itemPickUp.row = isoCoord.y;
				_itemPickUp.x = scrCoord.x;
				_itemPickUp.y = scrCoord.y;
				_itemPickUp.tileGlowDraw(_map.itemTestPlace(_itemPickUp, _itemPickUp.col, _itemPickUp.row));
				_map.sort();
				//trace('itemPickUpMove');
			}
		}
		private function itemPickUpCancel(e:Event = null):void {
			_map.removeEventListener(MouseEvent.MOUSE_MOVE, itemPickUpMove, false);
			_map.removeEventListener(MouseEvent.CLICK, itemPickUpPlace, false);
			if (_itemPickUp) {
				var scrCoord:Coordinate = _map.mapTiletoScreen(_cancelCol, _cancelRow);
				_itemPickUp.col = _cancelCol;
				_itemPickUp.row = _cancelRow;
				_itemPickUp.rotate = _cancelRotation;
				_itemPickUp.x = scrCoord.x;
				_itemPickUp.y = scrCoord.y;
				_itemPickUp.tileGlowClear();
				_map.sort();
				_itemPickUp = null;
				WebTrack.getInstance().track('itemPickUpCancel');
			}
		}
		
		private function itemPickUpPlace(e:Event):void {
			var scrCoord:Coordinate = _map.mapTiletoScreen(_itemPickUp.col, _itemPickUp.row);
			if (_map.itemTestPlace(_itemPickUp, _itemPickUp.col, _itemPickUp.row)) {
				for (var i:int = _itemPickUp.col; i < _itemPickUp.col + _itemPickUp.cols; ++i){
					for (var j:int = _itemPickUp.row; j < _itemPickUp.row + _itemPickUp.rows; ++j){
						var tile:Tile = _map.getTile(i, j);
						if (tile != null){
							tile.addItem(_itemPickUp);
						}
					}
				}
				_map.removeEventListener(MouseEvent.MOUSE_MOVE, itemPickUpMove, false);
				_map.removeEventListener(MouseEvent.CLICK, itemPickUpPlace, false);
				_itemPickUp.tileGlowClear();
				_itemPickUp.x = scrCoord.x;
				_itemPickUp.y = scrCoord.y;
				_itemPickUp = null;
				setGameMode(_mode, true);
			}
			WebTrack.getInstance().track('itemPickUpPlace');
		}
	}
}