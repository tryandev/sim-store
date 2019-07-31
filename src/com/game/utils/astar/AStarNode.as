package com.game.utils.astar {
	
	public class AStarNode {
		/*
		private var _f:Number;
		private var _g:Number;
		private var _h:Number;
		private var _neighbors:Array;
		private var _col:int;
		private var _row:int;
		private var _parent:AStarNode;*/
		
		public var f:Number;
		public var g:Number;
		public var h:Number;
		public var neighbors:Array;
		public var col:int;
		public var row:int;
		public var parent:AStarNode;
		
		//private var nodeType:String;
		//private var nodeId:String;
		public function AStarNode(){
		}
		
		public function destroy():void {
			//trace('AStarNode: destroy');
			neighbors = null;
			parent = null;
		}
		/*
		   public function set nodeId(nodeId:String):void {
		   this.nodeId = nodeId;
		   }
		   public function get nodeId():String {
		   return nodeId;
		   }
		
		   public function set nodeType(type:String):void {
		   nodeType = type;
		   }
		   public function get nodeType():String {
		   return nodeType;
		 }*/
		public function toString():String {
			return "[" + col + " " + row + "]" + " " + Math.round(f * 100) / 100 + "\t";
		}
		
		/*
		public function set col(num:int):void {
			_col = num;
			//trace("set col to " + _col);
		}
		
		public function get col():int {
			return _col;
		}
		
		public function set row(num:int):void {
			_row = num;
			//trace("set row to " + _row);
		}
		
		public function get row():int {
			return _row;
		}
		
		public function set neighbors(arr:Array):void {
			_neighbors = arr;
		}
		
		public function get neighbors():Array {
			return _neighbors;
		}
		
		//public function set f(inF:Number):void {
		//   _f = inF;
		// }
		public function get f():Number {
			return _g + _h;
		}
		
		public function set g(inG:Number):void {
			_g = inG;
		}
		
		public function get g():Number {
			return _g;
		}
		
		public function set h(inH:Number):void {
			_h = inH;
		}
		
		public function get h():Number {
			return _h;
		}
		
		public function set parent(inParent:AStarNode):void {
			_parent = inParent;
		}
		
		public function get parent():AStarNode {
			return _parent;
		}*/
	
	}

}
