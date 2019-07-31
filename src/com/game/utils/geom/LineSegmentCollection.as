package com.game.utils.geom {
	
	/**
	 * ...
	 * @author 
	 */
	public class LineSegmentCollection {
		
		private var _lineSegments:Array;
		
		public function LineSegmentCollection() {
			_lineSegments = [];
		}
		
		/**
		 * Adds a new line segment
		 */
		public function addLineSegment(ls:LineSegment):void {
			_lineSegments.push(ls);
		}
		
		public function get lineSegments():Array { return _lineSegments; }
		
	}
	
}