package com.game.utils.geom {
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author 
	 */
	public class IntersectionTestResult {
		
		private var _intersecting:Boolean = false;
		private var _point:Point;
		
		/**
		 * True if an instersection was found. The point property will be non-null as well.
		 */
		public function get intersecting():Boolean { return _intersecting; }
		
		public function set intersecting(value:Boolean):void {
			_intersecting = value;
		}
		/**
		 * If intersecting, this is the point of that intersection
		 */
		public function get point():Point { return _point; }
		
		public function set point(value:Point):void {
			_point = value;
		}
		
	}
	
}