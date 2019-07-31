package com.game.grid {
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import com.game.utils.astar.AStarNode;
	
	/**
	 * ...
	 * @author 
	 */
	[Embed(source='../../../assets/swf/tiles.swf',symbol='Tile')]
	public class Tile extends MovieClip {
		public static var CLICK:String = "tileClick";
		
		private var _col:int;
		private var _row:int;
		private var _items:Array = [];
		
		public function Tile(tileIndex:uint = 1) {
			this.gotoAndStop(tileIndex+1);
			//trace(this.currentFrame);
			//cacheAsBitmap = true;
			addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
		}
		
		private function clickHandler(e:MouseEvent):void {
			trace("Tile.clicked()");
			dispatchEvent(new Event(CLICK));
		}
		
		public function destroy():void {
			removeEventListener(MouseEvent.CLICK, clickHandler,false);
			if (parent) parent.removeChild(this);
		}
		
		public function addItem(item:*):void {
			_items.push(item);
		}
		
		public function getAStarNode():AStarNode {
			var tileNode:AStarNode = new AStarNode();
			tileNode.col = _col;
			tileNode.row = _row;
			return tileNode;
		}
		
		public function removeItem(item:*):void {
			for (var i:int = 0; i < _items.length; ++i){
				if (_items[i] == item){
					_items.splice(i, 1);
					break;
				}
			}
		}
		
		public function get col():int {
			return _col;
		}
		
		public function set col(value:int):void {
			_col = value;
		}
		
		public function get row():int {
			return _row;
		}
		
		public function set row(value:int):void {
			_row = value;
		}
		
		public function get items():Array {
			return _items;
		}
	
	}

}