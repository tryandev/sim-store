package com.game.utils.astar {
	import com.game.grid.Map;
	import com.game.grid.Tile;
	import com.zl.utils.Sort;
	import flash.utils.Dictionary;
	
	/**
	 * This class is used to perform A* searches. Most commonly, the A* search is used for pathfinding through a tile-based map. A grid (map) to be searched using this class must implement ISearchable. The tiles on that grid must implement INode.
	 * <br><br>By default allowDiag is true, which means that diagonal paths are allowed. You can change that with the setAllowDiag method. By default, the max search time is 2000 ms. Thsi can be changed via the setMaxSearchTime method.
	 */
	public class Astar {
		private var _startNode:AStarNode;
		private var _goalNodes:Array;
		//private var closedArray:Object;
		//private var allowDiag:Boolean;
		private var _map:Map;
		//private var _maxSearchTime:Number;
		private var openArray:Array;
		private var closedArray:Object;
		
		/**
		 * Creates a new instance of the Astar class.
		 */
		public function Astar(inMap:Map){
			_map = inMap;
			//setAllowDiag(true);
			//_maxSearchTime = 2000;
		}
		public function destroy():void {
			//trace('AStar: destroy');
			for each (var temp:AStarNode in openArray) {
				temp.destroy();
			}
			openArray = null
			closedArray = null;
			_map = null;
			if (_startNode) {
				_startNode.destroy(); 
				_startNode  = null;
			}
			if (_goalNodes) {
				for each (var node:AStarNode in _goalNodes) {
					node.destroy();
				}
				_goalNodes  = null;
			}
		}
		/**
		 * Performs an A* search from one tile (INode) to another, using a grid (ISearchable).
		 * @param	The starting INode point on the grid.
		 * @param	The target INode point on the grid.
		 * @return SearchResults class instance. If the search yielded a path then SearchResults.getIsSuccess() method returns true, and SearchResults.getPath() returns a Path instance that defines the path.
		 */
		private static function nodeDistance(inNodeA:AStarNode, inNodeB:AStarNode):Number {
			var colDiff:Number = inNodeB.col - inNodeA.col;
			var rowDiff:Number = inNodeB.row - inNodeA.row;
			return Math.sqrt(colDiff * colDiff + rowDiff * rowDiff);
		}
		
		public static function nodeDistanceArray(inNode:AStarNode, inArray:Array):Number {
			var shortest:Number = Infinity;
			var tempDistance:Number = Infinity;
			for each (var node:AStarNode in inArray) {
				tempDistance = nodeDistance(inNode, node);
				if (tempDistance < shortest) {
					shortest = tempDistance;
					//trace(tempDistance);
				}
			}
			//if (shortest == Infinity) throw new Error();
			return shortest;
		}
		
		
		public function search(startNode:AStarNode, goalNodes:Array):AStarNode {
			
			openArray = new Array();
			closedArray = new Object();
			
			_startNode = startNode;
			_goalNodes = goalNodes;
			
			_startNode.parent = null;
			_startNode.g = 0;			
			_startNode.h = nodeDistanceArray(_startNode, _goalNodes);
			
			openArray.push(_startNode);	
			
			while (openArray.length > 0){
				openArray.sortOn("f", Array.DESCENDING | Array.NUMERIC);
				
				var o:AStarNode = openArray.pop();				
				
				if (nodeDistanceArray(o, _goalNodes) == 0) {
					return o;
				}
				
				closedArray["n" + o.col + "_" + o.row] = o;
				o.neighbors = getNodeNeighbors(o);
				for each (var n:AStarNode in o.neighbors) {
					if (closedArray["n" + n.col + "_" + n.row] != null) {
						continue;
					}
					var newScoreG:Number = o.g + nodeDistance(o, n);
					var newScoreBetter:Boolean;
					if (getNodeInArray(n.col, n.row, openArray) == null) {
						openArray.push(n);
						newScoreBetter = true;
					}else if (newScoreG < n.g) {
						newScoreBetter = true;
					}else {
						newScoreBetter = false;
					}
					if (newScoreBetter) {
						n.parent = o;
						n.g = newScoreG;
						n.h = nodeDistanceArray(n, _goalNodes);
						n.f = n.g + n.h;
					}
				}
			}
			return null;
		}
		
		public function compareNodeScore(inNodeA:AStarNode, inNodeB:AStarNode):Boolean {
			return inNodeA.f < inNodeB.f;
		}
		
		private function inObjectArray(inNode:AStarNode, inObject:Object):Boolean {
			return (inObject[inNode.col + "_" + inNode.row] != null);
		}
		
		private function getNodeInArray(inCol:int, inRow:int, inArray:Array):AStarNode {
			for each (var arrayNode:AStarNode in inArray){
				if (arrayNode.col == inCol && arrayNode.row == inRow) {
					//trace("getNodeInArray found");
					return arrayNode;
				}
			}
			return null;
		}
		
		private function getNodeNeighbors(inAStartNode:AStarNode):Array {
			var _neighbors:Array = new Array();
			var _theoreticalNeighbors:Array = new Array();
			var inCol:uint = inAStartNode.col;
			var inRow:uint = inAStartNode.row;
			_theoreticalNeighbors.push(_map.getTile(inCol - 0, inRow - 1));
			_theoreticalNeighbors.push(_map.getTile(inCol - 0, inRow + 1));
			_theoreticalNeighbors.push(_map.getTile(inCol - 1, inRow - 0));
			_theoreticalNeighbors.push(_map.getTile(inCol + 1, inRow - 0));
			if (!_map.tileOccupied(inCol + 0, inRow + 1) && !_map.tileOccupied(inCol - 1, inRow + 0)) _theoreticalNeighbors.push(_map.getTile(inCol - 1, inRow + 1));
			if (!_map.tileOccupied(inCol + 0, inRow + 1) && !_map.tileOccupied(inCol + 1, inRow + 0)) _theoreticalNeighbors.push(_map.getTile(inCol + 1, inRow + 1));
			if (!_map.tileOccupied(inCol + 0, inRow - 1) && !_map.tileOccupied(inCol - 1, inRow + 0)) _theoreticalNeighbors.push(_map.getTile(inCol - 1, inRow - 1));
			if (!_map.tileOccupied(inCol + 0, inRow - 1) && !_map.tileOccupied(inCol + 1, inRow + 0)) _theoreticalNeighbors.push(_map.getTile(inCol + 1, inRow - 1));
			for each (var tempTile:Tile in _theoreticalNeighbors){
				if (tempTile != null && tempTile.items.length < 1){
					var newNode:AStarNode;
					if (closedArray["n" + tempTile.col + "_" + tempTile.row] != null){
						newNode = closedArray["n" + tempTile.col + "_" + tempTile.row];
					} else {
						newNode = getNodeInArray(tempTile.col, tempTile.row, openArray);
						if (newNode == null){
							newNode = new AStarNode();
							newNode.col = tempTile.col
							newNode.row = tempTile.row
						}
					}
					//newNode.parent = inAStartNode;
					//trace(newNode);
					_neighbors.push(newNode);
				}
			}
			return _neighbors;
		}
		
	}
	
}
