package com.game.containers 
{
	import com.game.global.GlobalFunctions;
	import com.game.global.GlobalObjects;
	import com.game.grid.Map;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import away3d.core.utils.Init;
	import flash.display.Stage;
	import com.zl.utils.WebTrack
	/**
	 * ...
	 * @author ...
	 */
	public class World extends Sprite
	{
		private const _dragThreshold:int = 12;
		private var _map:Map;
		private var _worldDragged:Boolean;
		private var _stopThreshold:Number;
		private var _worldDownX:Number;
		private var _worldDownY:Number;
		private var _zoomRatio:Number = 1.2;
		private var _zoomLevel:int = 0;
		private var _zoomLevelMax:int = 10;
		private var _zoomLevelMin:int = -3;
		
		
		public function World(init:Object = null) 
		{
			var ini:Init = Init.parse(init) as Init;
			_map = 	ini.getObject('map') as Map || new Map();
			this.graphics.beginFill(0xFF0000);
			this.graphics.moveTo( -1, -1);
			this.graphics.lineTo( 1, -1);
			this.graphics.lineTo( 1, 1);
			this.graphics.lineTo( -1, 1);
			this.graphics.endFill();
			this.addEventListener(Event.ADDED_TO_STAGE, worldListen, false, 0, true);
			addChild(_map);
		}
		
		public function zoom(val:int):void {
			_zoomLevel += val; 
			var preHeight:Number = _map.height;
			var postHeight:Number = _map.height;
			preHeight = _map.height;
			if (_zoomLevel > _zoomLevelMax) _zoomLevel = _zoomLevelMax;
			if (_zoomLevel < _zoomLevelMin) _zoomLevel = _zoomLevelMin;
			this.scaleX = Math.pow(_zoomRatio, _zoomLevel)
			this.scaleY = this.scaleX;
			//trace(_zoomLevel + ' ' + this.scaleX);
			postHeight = _map.height;
			WebTrack.getInstance().track('zoom_' + _zoomLevel);
		}
		
		private function worldMouseWheel(e:MouseEvent):void {
			if (e.delta > 0) {
				zoom(1);
			}else {
				zoom(-1);
			}
		}
		
		private function worldListen(e:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, 		worldListen, 	false);
			this.addEventListener(MouseEvent.MOUSE_DOWN, 	worldMouseDown,	true, 0, true); 
			this.addEventListener(MouseEvent.MOUSE_WHEEL, 	worldMouseWheel,true, 0, true); 
		}
		
		private function worldMouseDown(e:Event):void {
			//trace('MOUSE_DOWN');
			stage.addEventListener(MouseEvent.MOUSE_MOVE, 	worldMouseDrag, true, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, 	worldMouseUp,  	true, 0, true);
			this.addEventListener(MouseEvent.CLICK, 		worldMouseUp,  	true, 0, true);
			_worldDownX = stage.mouseX;
			_worldDownY = stage.mouseY;
			_worldDragged = false;
			GlobalFunctions.expandUtil_Collapse();
			GlobalFunctions.expandControls_Collapse();
		}
		
		private function worldMouseDrag(e:Event):void {
			//trace('MOUSE_DRAG');
			var dx:Number = stage.mouseX - _worldDownX;
			var dy:Number = stage.mouseY - _worldDownY;
			if (Math.sqrt(dx * dx + dy * dy) > _dragThreshold && !_worldDragged) {				
				_worldDragged = true;
				//trace('_worldDragged');
			}
			if (_worldDragged) {
				_worldDownX = stage.mouseX;
				_worldDownY = stage.mouseY;
				_map.x += dx/scaleX;
				_map.y += dy/scaleX;
				//_bg.x += dx/scaleX;
				//_bg.y += dy/scaleX;
			}
		}		
		
		private function worldMouseUp(e:MouseEvent):void {
			GlobalFunctions.expandUtil_Collapse();
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, 	worldMouseDrag, true);
			if (e.type == MouseEvent.MOUSE_UP)	stage.removeEventListener(MouseEvent.MOUSE_UP,	worldMouseUp,	true);
			if (e.type == MouseEvent.CLICK) 	this.removeEventListener(MouseEvent.CLICK,		worldMouseUp,	true);
			if (_worldDragged) {
				e.stopPropagation();
				e.stopImmediatePropagation();
			}
		}
		
		public function get map():Map {
			return _map;
		}
		
		public function destroy():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, 	worldMouseDown,	true); 
			this.removeEventListener(MouseEvent.MOUSE_WHEEL, 	worldMouseWheel,true); 
			stage.removeEventListener(MouseEvent.CLICK, 		worldMouseUp,  	true);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, 	worldMouseDrag, true);
			stage.removeEventListener(MouseEvent.MOUSE_UP, 		worldMouseUp, 	true);
			removeChild(_map);
			_map.destroy();
			_map = null;
			//_bg = null;
			if (parent) {
				parent.removeChild(this);
			}
		}
	}

}