package com.zl.utils {
	public class Sort {
		
		public function Sort() {
			
		}
		public static function merge(inArray:Array, inFunction:Function):Array {
			if (inArray.length <= 1)
				return inArray;
			var left:Array = new Array();
			var right:Array = new Array();
			var result:Array = new Array();
			var middle:uint = Math.floor(inArray.length / 2);
			var i:uint;
			if (inArray.length % 2 == 0){
				middle--;
			}
			left = inArray.slice(0, middle + 1);
			right = inArray.slice(middle + 1);			
			left = merge(left,inFunction);
			right = merge(right, inFunction);
			
			var mergeArray:Array = new Array();
			//if (left[left.length - 1] > right[0]) { //TEST
			if (inFunction(left[left.length - 1], right[0])) { //TEST
				while (left.length > 0 && right.length > 0){
					//if (left[0] > right[0]){ //TEST
					if (!inFunction(left[0], right[0])){ //TEST
						mergeArray.push(left[0]);
						left = left.slice(1);
					} else {
						mergeArray.push(right[0]);
						right = right.slice(1);
					}
				}
				if (left.length > 0){
					mergeArray = mergeArray.concat(left)
				} else {
					mergeArray = mergeArray.concat(right)
				}
				result = mergeArray;
			} else {
				result = left.concat(right);
			}
			return result;
		}
		
	}
}