package com.zl.utils {
	import away3d.cameras.SpringCam;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.system.System;
	import flash.text.TextFormat;
	
	/**
	 * This class is used to show an approximation of the current frame rate.
	 */
	public class Diagnostics extends Sprite {
		private var times:Array;
		private var mems:Array;
		private var lastFrameTime:Date;
		private var totalTimesInAverage:int;
		private var textField:TextField;
		private var textFormat:TextFormat;
		private var memGraph:Sprite;
		private var frameRate:int;
		private var _graphWidth:uint;
		/**
		 * Creates a new instance of the Diagnostics class.
		 */
		public function Diagnostics() {
			mouseEnabled = false;
			mouseChildren = false;
			_graphWidth = 200;
			textFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = 9;
			
			textField = new TextField();
			textField.selectable = false;
			textField.mouseEnabled = false;
			textField.autoSize = "left";
			addChild(textField);
			
			memGraph = new Sprite();
			memGraph.y = 20;
			memGraph.alpha = 0.5;
			addChild(memGraph);
			
			totalTimesInAverage = 15;
			times = new Array();
			mems = new Array();
			lastFrameTime = new Date();
			addEventListener(Event.ENTER_FRAME, run, false, 0, true);
		}
		
		public function destroy():void {
			removeEventListener(Event.ENTER_FRAME, run)
		}
		
		public function get graphWidth():uint {
			return _graphWidth;
		}
		public function set graphWidth(inNum:uint):void {
			_graphWidth = inNum;
		}
		
		/**
		 * Returns the latest frame rate average.
		 * @return The latest frame rate average.
		 */
		public function getFrameRate():int {
			return frameRate;
		}
		
		/**
		 * Does the frame-based logic.
		 * @param	Event.
		 * @private
		 */
		private function run(e:Event):void {
			var now:Date = new Date();
			var frameTime:Number = now.valueOf() - lastFrameTime.valueOf();
			lastFrameTime = now;
			//
			times.unshift(frameTime);
			if (times.length > totalTimesInAverage){
				times.pop();
			}
			//average
			var totalTime:Number = 0;
			for (var i:int = 0; i < times.length; ++i){
				totalTime += times[i];
			}
			var avg:Number = totalTime / times.length;
			var fps:int = Math.round(1000 / avg);
			frameRate = fps;
			
			mems.push(System.totalMemory);
			if (mems.length > _graphWidth){
				mems.shift();
			}
			
			memGraph.graphics.clear();
			var memSum:Number;
			memSum = 0;
			memGraph.graphics.beginFill(0x00FF00);
			memGraph.graphics.moveTo(mems.length-1,0);
			memGraph.graphics.lineTo(0, 0);
			for (var j:uint = 0; j < mems.length; j++) {
				memGraph.graphics.lineTo(j, mems[j] / (1048576*5));
				memSum += mems[j];
			}
			memGraph.graphics.endFill();
			
			var mem:String = Number(System.totalMemory / 1024 / 1024).toFixed(2) + " MB";
			
			textField.text = "FPS: " + fps + "\t" + "mem: " + mem + "\t" + "amem: " + Number(memSum / mems.length / 1024 / 1024).toFixed(2) + " MB";
			textField.setTextFormat(textFormat);
		}
	}
}
