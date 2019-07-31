package com.game.items 
{
	import com.game.containers.World;
	import com.game.global.GlobalObjects;
	import com.game.grid.ISortableItem;
	import com.game.grid.Map;
	import com.game.ui.panels.uiActionGauge;
	import com.game.uiTimer;
	import com.zl.utils.WebTrack;
	import flash.events.Event;
	import flash.events.MouseEvent
	import flash.geom.Point;
	public class MapItemTable extends MapItemDecor implements ISortableItem {
		
		private var _crop:MapItemCrop;
		private var _pendingStatus:int;
		private var _handsTimer:uiTimer;
		private var _callbackFinish:Function		
		private var _actionName:String = "Serving";
		
		public function MapItemTable(mcURL:String = "") {
			super(mcURL, DIREC_TYPE_1, 2, 2);
		}
		
		public function actionFinish(e:Event = null):void {
			if (_handsTimer){
				_handsTimer.removeEventListener(uiTimer.PROGRESS, actionProgress, false);
				_handsTimer.removeEventListener(uiTimer.DONE, actionFinish, false);
				_handsTimer.destroy();
				_handsTimer = null;
			}
			GlobalObjects.actionGauge.visible = false;
			WebTrack.getInstance().track('itemFinish');
			if (_callbackFinish != null) _callbackFinish();
			if (!_crop) return;
			if (_crop.status != _pendingStatus) {
				//throw Error('actionExecute: Crop Status changed');
				highlight(false);
				return
			}			
			removeChild(_crop);
			_crop.destroy();
			_crop = null;
			highlight(false);
		}
		
		private function actionProgress(e:Event = null):void {
			if (GlobalObjects.actionGauge) {
				GlobalObjects.actionGauge.followItemXY(x, y, _handsTimer.percent);
			}
			/*var actionGauge:uiActionGauge = GlobalObjects.actionGauge;
			var world:World = GlobalObjects.world;
			var map:Map = GlobalObjects.world.map;
			if (actionGauge) {
				actionGauge.visible = true;
				actionGauge.percent = _handsTimer.percent;
				var scale:Number = world.scaleX;
				actionGauge.x = Math.round((map.x + this.x) 		* scale + 380);
				actionGauge.y = Math.round((map.y + this.y - 75)	* scale + 310);
			}*/
		}
		
		public override function actionExecute(callback:Function = null):void {
			WebTrack.getInstance().track('itemExecute');
			_callbackFinish = callback;
			if (!_crop) return;
			if (_crop.status != _pendingStatus) {
				//throw Error('actionExecute: Crop Status changed');
				highlight(false);
				actionFinish();
				return
			}
			
			var actionGauge:uiActionGauge = GlobalObjects.actionGauge;
			var actionTime:Number;
			var actionName:String;
			if (_pendingStatus == MapItemCrop.STATUS_1_RIPE || _pendingStatus == MapItemCrop.STATUS_3_REVIVED) {
				actionTime = 2;
				actionName = 'Serving';
			}
			if (_pendingStatus == MapItemCrop.STATUS_2_WITHERED) {
				actionTime = 5;
				actionName = 'Trashing';
			}
			actionGauge.text = actionName;
			_handsTimer = new uiTimer(actionTime, 0, 1);
			_handsTimer.addEventListener(uiTimer.DONE, actionFinish, false, 0, true);
			_handsTimer.addEventListener(uiTimer.PROGRESS, actionProgress, false, 0, true);
			_handsTimer.start();
		}
		
		public function actionEnqueue():void {
			if (!_crop) {
				trace('MapItemTable: no crop');
				return;
			}
			if (_crop.status != _pendingStatus) {
				throw Error('actionEnqueue: Crop Status changed');
			}
			GlobalObjects.currentAvatar.actionQueueAdd(this);
			GlobalObjects.currentAvatar.walkItems();
		}
		
		public override function actionPrompt():void {
			_pendingStatus = _crop.status;
			if (_pendingStatus != MapItemCrop.STATUS_0_GROWING) {
				actionEnqueue();
			}
		}
		
		public override function actionCheck():Boolean {
			if (_crop.status != _pendingStatus) {
				highlight(false);
				return false;
			}
			return true;
		}
		
		public override function actable():Boolean {
			if (!_crop) return false;
			return _crop.actable();
		}
		public override function destroy():void {
			//trace('MapItemTable destroy');
			if (_crop) {
				_crop.removeEventListener(MouseEvent.CLICK,		mouseClickHandle, false);
				_crop.removeEventListener(MouseEvent.MOUSE_OVER,mouseOverHandle, false);
				_crop.removeEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandle, false);
				removeChild(_crop);
				_crop.destroy();
				_crop = null;
			}
			if (_handsTimer) {
				//_handsTimer.removeEventListener(uiTimer.DONE, timerDone, false);
				//_handsTimer.removeEventListener(uiTimer.PROGRESS, progress, false);
				_handsTimer.destroy();
				_handsTimer = null;
			}
			_callbackFinish = null;
			super.destroy();
		}
		
		override public function sellPrompt():void {
			if (_crop) {
				_crop.sellPrompt();
				_crop = null;
			}else {
				//trace('super.sell()');
				super.sellPrompt();
			}
		}
		override public function store():void {
			if (_crop) {
				return;
			}else {
				super.store();
			}
		}
		
		public function set crop(value:MapItemCrop):void {
			if (_crop) {
				removeChild(_crop);
				_crop.destroy();
			}
			_crop = value;
			if (_crop != null) {
				_crop.addEventListener(MouseEvent.CLICK,		mouseClickHandle, false, 0, true);
				_crop.addEventListener(MouseEvent.MOUSE_OVER,	mouseOverHandle, false, 0, true);
				_crop.addEventListener(MouseEvent.MOUSE_OUT,	mouseOutHandle, false, 0, true);
				addChild(_crop);			
			}
		}
		public function get crop():MapItemCrop {
			return _crop;
		}
	}

}