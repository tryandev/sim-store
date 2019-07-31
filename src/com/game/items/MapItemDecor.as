package com.game.items 
{
	import com.game.global.GlobalObjects;
	import com.game.global.MCLoader;
	import com.game.grid.ISortableItem;
	import com.game.grid.Map;
	import com.game.grid.Tile;
	import com.game.utils.astar.AStarNode;
	import com.stimuli.loading.BulkLoader;
	import com.stimuli.loading.BulkProgressEvent;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Loader
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.net.URLRequest;
	import flash.events.Event
	/**
	 * ...
	 * @author 
	 */
	public class MapItemDecor extends Sprite implements ISortableItem {
		
		private var _spriteURL:String

		private var _col:Number;
		private var _row:Number;
		private var _cols:int;
		private var _rows:int;
		private var _rotate:int;
		
		private var _direcType:int;
		
		private var _map:Map;
		private var _mc:MovieClip;
		private var _tileGlow:Sprite;
		private var _destroyed:Boolean;
		
		public var movable:Boolean = true;
		
		public static const DIREC_TYPE_1:uint = 0;
		public static const DIREC_TYPE_2:uint = 1;
		public static const DIREC_TYPE_4:uint = 2;
		
		public static const DIREC_SE:uint = 0;
		public static const DIREC_SW:uint = 1;
		public static const DIREC_NW:uint = 2;
		public static const DIREC_NE:uint = 3;
		
		public static const ITEM_MOUSE_CLICK:String = "itemMouseClick";
		public static const ITEM_MOUSE_OVER:String = "itemMouseOver";
		public static const ITEM_MOUSE_OUT:String = "itemMouseOut";
		
		public function MapItemDecor(spriteURL:String = "", directions:uint = DIREC_TYPE_1, cols:uint = 1, rows:uint = 1) {
			//trace('MapItemDecor()');
			_spriteURL = spriteURL;
			_direcType = directions;
			_cols = cols;
			_rows = rows;
			_tileGlow = new Sprite();
			addChild(_tileGlow);
			init();
		}
		
		public function destroy():void {
			//trace('MapItemDecor destroy');
			_destroyed = true;
			_map = null;
			if (_mc) {
				_mc.removeEventListener(MouseEvent.CLICK,		mouseClickHandle, false);
				_mc.removeEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandle, false);
				_mc.removeEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandle, false );
				removeChild(_mc);
				_mc = null;
			}
			if(_tileGlow){
				removeChild(_tileGlow);
				_tileGlow = null;
			}
		}
		
		public function highlight(value:Boolean):void {
			if (value) {
				this.transform.colorTransform = new ColorTransform(
					0.75,	0.75,	0.75,	1,
					0,		64,		64,		0
				);
				this.mouseEnabled = false;
				this.mouseChildren = false;		
			}else {
			
				this.transform.colorTransform = new ColorTransform();
				this.mouseChildren = true;
				this.mouseEnabled = true;				
			}
		}
		
		public function actionCheck():Boolean { return false; }
		public function actionPrompt():void { } 
		public function actionExecute(callback:Function = null):void { } 
		public function actable():Boolean { return false; }
		
		public function getBorderNodes():Array {
			var i:int
			var result:Array = []
			for (i = 0; i < cols; i++ ) {
				if (!_map.tileOccupied(col + i, row - 1))	result.push(_map.getTile(col + i, 	row - 1).getAStarNode());
				if (!_map.tileOccupied(col + i, row + rows))result.push(_map.getTile(col + i, 	row + rows).getAStarNode());
			}
			for (i = 0; i < rows; i++ ) {
				if (!_map.tileOccupied(col - 1, row + i)) 	result.push(_map.getTile(col - 1,		row + i).getAStarNode());
				if (!_map.tileOccupied(col + cols, row + i)) result.push(_map.getTile(col + cols,	row + i).getAStarNode());
			}
			
			return result;
		}
		
		private function init():void {
			//_tileGlow.buttonMode = true;
			//tileGlowDraw();
			MCLoader.getInstance().add(_spriteURL, spriteLoaded);
			MCLoader.getInstance().start();
			
			//return;
			/*GlobalLoader.getInstance().add(_spriteURL);
			GlobalLoader.getInstance().get(_spriteURL).addEventListener(BulkProgressEvent.COMPLETE, spriteLoaded);
			GlobalLoader.getInstance().get(_spriteURL).addEventListener(BulkLoader.ERROR, error);
			GlobalLoader.getInstance().start();*/
			
            //loader.contentLoaderInfo.addEventListener(Event.INIT, spriteLoaded, false, 0, true );
            //loader.load( new URLRequest( _spriteURL ) );
		}
		
		private function error():void {
			trace('error');
		}
		
		protected function mouseClickHandle(e:Event):void { 	/*dispatchEvent(new Event(ITEM_MOUSE_CLICK));*/	if (_map) { _map.itemMouseEvent(this, e); }}
		protected  function mouseOverHandle(e:Event):void { 	/*dispatchEvent(new Event(ITEM_MOUSE_OVER));*/	if (_map) { _map.itemMouseEvent(this, e); }}
		protected  function mouseOutHandle(e:Event):void { 	/*dispatchEvent(new Event(ITEM_MOUSE_OUT));*/	if (_map) { _map.itemMouseEvent(this, e); }}
		
		public function tileGlowDraw(enabled:Boolean = false):void {
			var tileWidth:int = Map.TILE_SCREEN_WIDTH;
			var tileHeight:int = Map.TILE_SCREEN_HEIGHT;
			var x0:int = 0;
			var x1:int =  tileWidth/ 2 * _cols;
			var x2:int = x1 - tileWidth / 2 * _rows;			
			var x3:int = -tileWidth / 2 * rows;
			var y0:int = -tileHeight / 2;
			var y1:int = y0 + tileHeight / 2 * _cols;
			var y2:int = y1 + tileHeight / 2 * _rows;			
			var y3:int = y0 + tileHeight / 2 * _rows;
			var graphics:Graphics = _tileGlow.graphics;
			graphics.clear();
			graphics.beginFill(enabled ? 0x00FF00: 0xFF0000, 0.5);
			graphics.lineStyle(3, enabled ? 0x00FF00: 0xFF0000, 1);
			graphics.moveTo(x0,y0);
			graphics.lineTo(x1,y1);
			graphics.lineTo(x2,y2);
			graphics.lineTo(x3,y3);
			graphics.lineTo(x0, y0);
			graphics.endFill();
		}
		
		public function sellPrompt():void {
			for (var i:int = this.col; i < this.col + this.cols; ++i) {
				for (var j:int = this.row; j < this.row + this.rows; ++j) {
					var tile:Tile = GlobalObjects.world.map.getTile(i, j);
					tile.removeItem(this);
				}
			}
			destroy();
		}
		
		public function store():void {
			for (var i:int = this.col; i < this.col + this.cols; ++i) {
				for (var j:int = this.row; j < this.row + this.rows; ++j) {
					var tile:Tile = GlobalObjects.world.map.getTile(i, j);
					tile.removeItem(this);
				}
			}
			destroy();
		}
		
		public function tileGlowClear():void {
			_tileGlow.graphics.clear();
		}
		
		private function spriteLoaded(e:Event = null):void {
			//trace("spriteLoaded " +_spriteURL);
			//_mc = GlobalLoader.getInstance().getMovieClip(_spriteURL);//e.target.content as MovieClip;
			if (_destroyed) return;
			_mc = MCLoader.getInstance().getMC(_spriteURL);
			var mcSub:MovieClip = _mc.getChildAt(0) as MovieClip;
			mcSub.gotoAndStop((_rotate % mcSub.totalFrames) + 1);
			mcSub.stop();
			addChildAt(_mc,1);
			_mc.addEventListener(MouseEvent.CLICK,		mouseClickHandle, false, 0, true);
			_mc.addEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandle, false, 0, true);
			_mc.addEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandle, false, 0, true);
		}
		private function swapColRow():void {
			var tempCols:int = _cols;
			_cols = _rows;
			_rows = tempCols;
		}
		public function get col():Number { return _col; }
		public function set col(value:Number):void { _col = value; }
		
		public function get row():Number { return _row; }
		public function set row(value:Number):void { _row = value; }
		
		public function get cols():int { return _cols; }
		public function set cols(value:int):void { _cols = value; }
		
		public function get rows():int { return _rows; }
		public function set rows(value:int):void { _rows = value; }
		
		public function get rotate():int { return _rotate; }
		public function set rotate(value:int):void {
			if (value == _rotate) return;
			
			var newRotate:int = value;
			var rowColChange:Boolean = false;
			if (_direcType == DIREC_TYPE_1){
				newRotate = 0;
			}else if (_direcType == DIREC_TYPE_2) {
				newRotate = value % 2;
			}else if (_direcType == DIREC_TYPE_4) {
				newRotate = value % 4;
			}
			if (Math.abs(newRotate-_rotate) % 2 == 1) {
				rowColChange = true;
			}
			_rotate = newRotate;
			if (_mc) {
				var mcSub:MovieClip = _mc.getChildAt(0) as MovieClip;
				mcSub.gotoAndStop((_rotate % mcSub.totalFrames) + 1);
			}
			if (rowColChange) {
				swapColRow();
			}
			//trace("_rotate: " + _rotate);
			//trace("swapColRow: " + rowColChange);
		}
		
		public function set map(inMap:Map):void {_map = inMap;}
		public function get map():Map {return _map;}
	}

}