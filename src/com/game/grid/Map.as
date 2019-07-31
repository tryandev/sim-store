package com.game.grid {
	import com.game.animation.Avatar;
	import com.game.containers.GameMode;
	import com.game.global.GlobalFunctions;
	import com.game.items.MapItemDecor;
	import com.game.items.MapItemCrop;
	import com.game.items.MapItemTable;
	import com.game.utils.astar.Astar;
	import com.game.utils.astar.AStarNode;
	import com.game.utils.geom.Coordinate;
	import com.game.utils.Isometric;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.GlowFilter;
	import flash.utils.getQualifiedClassName;
	import com.zl.utils.Sort;
	import com.zl.utils.WebTrack
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author 
	 */
	public class Map extends Sprite {
		
		public static const TILE_SCREEN_WIDTH:int = 50;
		public static const TILE_SCREEN_HEIGHT:int = 25;
		
		private var _grid:Array;
		private var _iso:Isometric;
		private var _tileWidthOnScreen:int;
		private var _tileHeightOnScreen:int;
		private var _tileWidth:Number;
		private var _tileHeight:Number;
		
		private var _gameMode:GameMode;
		
		private var _cols:int;
		private var _rows:int;
		
		private var _tileHolder:MovieClip;
		private var _itemHolder:MovieClip;
		private var _bg:Sprite;
		
		private var _itemsAll:Array = [];
		
		private var _size:uint = 16;
		
		private var _sortPending:Boolean;
		private var _sortFrequency:uint = 0 ;
		private var _sortCounter:uint;
		
		
		
		public function Map(){
			initialize();
			//getTile(8, 3).rotation = 90;
			//getTile(8, 3).alpha = 0.5;
		}
		
		public function setGameMode(value:int):void {
			_gameMode.setGameMode(value);
		}
		private function initialize():void {
			_bg = new Sprite();
			var bgSize:Number = 65536*2*2*2*2*2*2*2;
			_bg.graphics.beginFill(0x000000,0.2);
			_bg.graphics.moveTo( -bgSize, -bgSize);
			_bg.graphics.lineTo( bgSize, -bgSize);
			_bg.graphics.lineTo( bgSize, bgSize);
			_bg.graphics.lineTo( -bgSize, bgSize);
			_bg.graphics.endFill();/**/
			
			_iso = new Isometric();
			_tileWidthOnScreen = Map.TILE_SCREEN_WIDTH; //when mapped to the screen the tile makes a diamond of these dimensions
			_tileHeightOnScreen = Map.TILE_SCREEN_HEIGHT;
			_tileWidth = _iso.mapToIsoWorld(_tileWidthOnScreen, 0).x; //figure out the width of the tile in 3D space
			_tileHeight = _tileWidth; //the tile is a square in 3D space so the height matches the width
			_cols = _size;
			_rows = _size;
			_tileHolder = new MovieClip();
			_itemHolder = new MovieClip();
			_itemHolder.mouseEnabled = false;
			
			addChild(_bg)
			addChild(_tileHolder);
			addChild(_itemHolder);
			buildTiles();
			addEventListener(Event.ENTER_FRAME, sortEnterFrame, false, 0, true);
			_gameMode = new GameMode(this,_itemHolder, _tileHolder);
		}
		
		
		public function itemMouseEvent(item:MapItemDecor, e:Event):void {
			_gameMode.itemMouseEvent(item, e);
		}
		
		public function addRandomItem(item:ISortableItem, noOccupy:Boolean = false):Boolean {
			/*
			var col:int = Math.floor(_cols * Math.random());
			var row:int = Math.floor(_rows * Math.random());
			var item:Item = new Item();
			item.type = Math.floor(3 * Math.random());
			item.mouseEnabled = false;
			if (itemTestPlace(item, col, row)){
				addItem(item, col, row);
				return true;
			} else {
				return false;
			}*/
			
			/*if (Math.random() > 0.0) {
				var table:MapItemTable = new MapItemTable('../src/assets/swf/items_table_1.swf');
				table.crop = new MapItemCrop('../src/assets/swf/items_crop_oj.swf', 30, 0.99);
				item = table;
			}else {
				item = new MapItemDecor('../src/assets/swf/items_table_2.swf', MapItemDecor.DIREC_TYPE_2, 1, 2);
			}*/

			//item.type = Math.floor(3 * Math.random());
			//item.mouseEnabled = false;
			var col:int;
			var row:int;
			while(!itemTestPlace(item, col, row)) {
				col = Math.floor(_cols * Math.random());
				row = Math.floor(_rows * Math.random());
			}  
			addItem(item, col, row, noOccupy);
			return true;
		}
		
		
		public function addItem(itm:*, col:Number, row:Number, noOccupy:Boolean = false):void {
			if (!noOccupy){
				for (var i:int = col; i < col + itm.cols; ++i){
					for (var j:int = row; j < row + itm.rows; ++j){
						var tile:Tile = getTile(i, j);
						if (tile != null){
							tile.addItem(itm);
						}
					}
				}
			}
			var tx:Number = _tileWidth * col + _tileWidth / 2;
			var tz:Number = -(_tileHeight * row + _tileHeight / 2);
			
			var coord:Coordinate = _iso.mapToScreen(tx, 0, tz);
			itm.x = coord.x;
			itm.y = coord.y;
			
			itm.col = col;
			itm.row = row;
			
 			itm.map = this;
			
			itm.mouseEnabled = false;
			_itemsAll.push(itm);
			//_itemsAll2.push(itm);
			sort();
		}
		
		public function removeItem(item:*):void {
			_itemHolder.removeChild(item);
			for (var i:uint = 0; i < _itemsAll.length; ++i){
				if (_itemsAll[i] == item){
					_itemsAll.splice(i, 1);
					break;
				}
			}
		}
		/*
		private function depthBehindTest(inItem1:*, inItem2:*):Boolean {
			var result:Boolean = (
				Math.round(inItem1.col) <= Math.round(inItem2.col) + Math.round(inItem2.cols) - 1 
				&& 
				Math.round(inItem1.row) <= Math.round(inItem2.row) + Math.round(inItem2.rows) - 1);
			//trace(result);
			return result;
		}
		public function updateMovedItemDepth(inItem:Sprite):void {
			_itemHolder.removeChild(inItem);
			insertItemSorted(inItem)
		}
		
		public function insertItemSorted(itm:*):void {
			var added:Boolean = false;
			if (_itemHolder.numChildren == 0){
				_itemHolder.addChild(itm);
			} else {
				for (var i:uint = 0; i < _itemHolder.numChildren; i++){
					if (itm == _itemHolder.getChildAt(i)){
						continue;
					}
					if (depthBehindTest(itm, _itemHolder.getChildAt(i))){
						_itemHolder.addChildAt(itm, i);
						added = true;
						break;
					}
				}
				if (!added){
					_itemHolder.addChildAt(itm, _itemHolder.numChildren);
				}
			}
		
		}*/
		
		public function sort():void {
			trace('sort()');
			_sortPending = true;
		}
		private function sortEnterFrame(e:Event):void {
			_sortCounter++;
			if (_sortCounter >= _sortFrequency && _sortPending) {
				_sortCounter = 0;
				_sortPending = false;
				//trace('sort ' + Math.random())
				isoDepthSortAll2();
			}
		}
		
		private function isoDepthSort(A:ISortableItem, B:ISortableItem):int {
			if ( B.col < A.col + A.cols && B.row < A.row + A.rows ) {
				return 1;
			}else if (A.col < B.col + B.cols && A.row < B.row + B.rows){
				return -1;
			}
			return 0;
		}
		
		public function isoDepthSortAll2():void {
			//trace('isoDepthSortAll ' + Math.random());
			var children:Array = _itemsAll;
			var max:int = children.length;
			if (max < 2) {
				if (children.length == 1) {
					_itemHolder.addChild(children[0]);
				}
				return;
			}
			var visited:Dictionary = new Dictionary();
			var dependency:Dictionary = new Dictionary();
			for (var i:int = 0; i < max - 1; ++i) {
				var objA:ISortableItem = children[i];	
				if (dependency[objA] == null) dependency[objA] = [];
				for (var j:int = i + 1; j < max; ++j) {
					var objB:ISortableItem = children[j];
					if (dependency[objB] == null) dependency[objB] = [];
					var depthResult:int = isoDepthSort(objB, objA);
					if (depthResult == 1) {
						dependency[objA].push(objB);
					}else if (depthResult == -1) {
						dependency[objB].push(objA);
					}
				}
			}			
			for (var k:int = 0; k < max; ++k) {
				var obj:ISortableItem = children[k];
				if (visited[obj] !== true){
					isoDepthSortPlace(obj, dependency, visited);
				}
			}
			visited = null;
			dependency = null;
			children = null;
		}
		/*public function isoDepthSortAll():void {
			//trace('isoDepthSortAll ' + Math.random());
			var visited:Dictionary = new Dictionary();
			var dependency:Dictionary = new Dictionary();
			var children:Array = _itemsAll;
			var max:int = children.length;
			for (var i:int = 0; i < max; ++i) {
				var front:Array = [];
				var objA:ISortableItem = children[i];	
				for (var j:int = 0; j < max; ++j) {
					if (i !== j) {
						var objB:ISortableItem = children[j];
						if (isoDepthSort(objB, objA) == 1) {
							front.push(objB);
						}
					}
				}
				dependency[objA] = front;
			}			
			for (var k:int = 0; k < max; ++k) {
				var obj:ISortableItem = children[k];
				if (visited[obj] !== true){
					isoDepthSortPlace(obj, dependency, visited);
				}
			}
			visited = null;
			dependency = null;
			children = null;
			front = null;
		}*/
		
		private function isoDepthSortPlace(obj:ISortableItem, dependency:Dictionary, visited:Dictionary):void {
			visited[obj] = true;
			for each(var inner:ISortableItem in dependency[obj]){
				if(visited[inner] !== true){
					isoDepthSortPlace(inner, dependency, visited);
				}
			}
			_itemHolder.addChildAt(obj as DisplayObject, 0);
		};
		
		public function expand():void {
			var i:uint;
			var j:uint;
			_grid[cols] = [];
			for (i = 0; i < _cols; i++) {
				j = _rows;
				createNewTile(i, j);
			}
			for (j = 0; j < _rows; j++) {
				i = cols;
				createNewTile(i, j);
			}
			createNewTile(_cols, _rows);
			_cols++;
			_rows++;
		}
		
		private function buildTiles():void {
			_grid = [];
			for (var i:int = 0; i < _cols; ++i){
				_grid[i] = [];
				for (var j:int = 0; j < _rows; ++j){
					createNewTile(i, j);
				}
			}
		}
		
		private function createNewTile(i:uint, j:uint):Tile {
					var t:Tile;
					if (i / 2 != Math.round((i / 2)) || j / 2 != Math.round((j / 2)) ) {
						t = new Tile(0);
					}else {
						t = new Tile(1);
					}
					t.col = i;
					t.row = j;
					
					var tx:Number = i * _tileWidth;
					var tz:Number = -j * _tileHeight;
					
					var coord:Coordinate = _iso.mapToScreen(tx, 0, tz);
					
					t.x = coord.x;
					t.y = coord.y;
					
					_grid[i][j] = t;
					
					_tileHolder.addChildAt(t, (t.currentFrame == 1) ? 0: _tileHolder.numChildren);
					t.addEventListener(Tile.CLICK, tileClicked, false, 0, true);
					t.buttonMode = true;
					return t;
		}
		
		public function itemTestPlace(itm:ISortableItem, col:int, row:int):Boolean {
			var valid:Boolean = true;
			for (var i:int = col; i < col + itm.cols; ++i){
				for (var j:int = row; j < row + itm.rows; ++j){
					var tile:Tile = getTile(i, j);
					if (tile == null || tile.items.length > 0){
						valid = false;
						break;
					}
				}
			}
			return valid;
		}
		
		public function tileClicked(e:Event):void {
			//trace('path find');
			var myCoord:Coordinate = mapScreentoTile(this.mouseX, this.mouseY);
			//trace("myCoord.x: " + myCoord.x + "\t myCoord.y: " + myCoord.y);
			//return;
			var myTile:Tile = getTile(Math.floor(myCoord.x), Math.floor(myCoord.y));
			for each (var myChar:ISortableItem in _itemsAll) {
				if (getQualifiedClassName(myChar).split('::')[1] == "Avatar"){
					(myChar as Avatar).walkTile(myTile.getAStarNode());
					//trace('xxx');
				}
			}
			WebTrack.getInstance().track('tileClicked');
		}
		
		public function tileOccupied(col:int, row:int):Boolean {
			var myTile:Tile = getTile(col, row);
			if (myTile == null || myTile.items.length > 0){
				return true;
			} else {
				return false;
			}
		}
		
		public function getTile(col:int, row:int):Tile {
			var tile:Tile;
			if (col < _cols && row < _rows){
				try {
					tile = _grid[col][row];
				} catch (error:Error){
					return null;
				}
			}
			return tile;
		}
		
		public function pathFind(inStartNode:AStarNode, inEndNodes:Array):Array {
			var myAStar:Astar = new Astar(this);
			var resultNode:AStarNode = myAStar.search(inStartNode, inEndNodes);
			myAStar.destroy();
			var resultNodes:Array = new Array();
			while (resultNode != null){
				//trace(resultNode.col + ", " + resultNode.row);
				//getTile(resultNode.col, resultNode.row).alpha = .5;
				resultNodes.push(resultNode);
				resultNode = resultNode.parent;
			}
			return resultNodes;
		}
		
		public function mapTiletoScreen(col:Number, row:Number):Coordinate {
			var tx:Number = _tileWidth * col + _tileWidth / 2;
			var tz:Number = -(_tileHeight * row + _tileHeight / 2);
			var coord:Coordinate = _iso.mapToScreen(tx, 0, tz);
			return coord;
		}
		
		public function mapScreentoTile(screenX:Number, screenY:Number):Coordinate {
			var coord:Coordinate = _iso.mapToIsoWorld(screenX, screenY);
			var factor:Number = 42.985021228330226 * 0.823; //0.825
			//trace(coord);
			coord.x /= factor;
			coord.y = coord.z / (-factor);
			coord.z = 0;
			return coord;
		}
		
		public function get cols():int {
			return _cols;
		}
		
		public function get rows():int {
			return _rows;
		}
		
		public function destroy():void {
			trace('map: destroy');
			trace('_itemHolder.numChildren: ' + _itemHolder.numChildren);
			_gameMode.destroy();
			removeEventListener(Event.ENTER_FRAME, sortEnterFrame, false);
			//var tempClass:*
			while (_itemsAll.length) {
				//tempClass = 
				_itemsAll.pop().destroy();
				//tempClass.destroy()
			}
			_itemsAll = null;
			while(_tileHolder.numChildren) {_tileHolder.removeChildAt(0);}
			while(_itemHolder.numChildren) {_itemHolder.removeChildAt(0);}
			removeChild(_tileHolder);
			removeChild(_itemHolder);
			_tileHolder = null;
			_itemHolder = null;
		}
	}

}