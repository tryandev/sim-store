package com.game.animation {
	import adobe.utils.CustomActions;
	import away3d.core.utils.Color;
	import com.game.grid.ISortableItem;
	import com.game.grid.Map;
	import com.game.grid.Map;
	import com.game.items.MapItemDecor;
	import com.game.utils.astar.Astar;
	import com.game.utils.astar.AStarNode;
	import com.greensock.TweenNano;
	import com.greensock.easing.Linear;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.ColorTransform;
	import com.game.animation.Cacher3D;
	import away3d.core.utils.Init;
	import away3d.core.utils.Init;
	import com.game.utils.geom.Coordinate;
	import com.game.utils.geom.Coordinate;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;
	
	public class Avatar extends Sprite implements ISortableItem {
		
		public static const WALK_DONE:String = 'walkDone';
		public static const ANIMATION_IDLE:int = 0;
		public static const ANIMATION_WALK:int = 1;
		public static const ANIMATION_HAND:int = 2;
		
		private var _col:Number;
		private var _row:Number;
		
		private var _map:Map;
		private var _displayObject:Cacher3D;
		private var _textureMovieClip:DisplayObject;
		
		private var _nodeChainArray:Array;
		private var _nodesGoalSetPending:Array;
		private var _textures:Array;
		
		private var _isWalking:Boolean = false;
		private var _lastWholeCol:uint = 0;
		private var _lastWholeRow:uint = 0;
		private var _lastOrientation:uint = Cacher3D.DIREC_SE;
		
		private var _modelIndexBody:uint = Models.INDEX_BODY_NORMAL;
		private var _modelIndexHair:uint = Models.INDEX_HAIR_COMBOVER;
		private var _modelIndexMisc:uint = Models.INDEX_MISC_PIVOT;
		
		private var _actionQueue:Array;
		
		
		private var _hairColors:Array = [
			colorFromRGB(0, 0, 0),
			//colorFromRGB(22, 13, 9),
			//colorFromRGB(44, 25, 18),
			//colorFromRGB(88, 66, 43),
			colorFromRGB(173, 132, 89),
			colorFromRGB(216, 183, 149),
			colorFromRGB(135, 135, 135),
			colorFromRGB(45, 19, 11),
			colorFromRGB(76, 32, 19),
			colorFromRGB(140, 60, 35),
			colorFromRGB(201, 118, 86), 
			colorFromRGB(228, 175, 152), 
			colorFromRGB(220, 220, 220), 
			colorFromRGB(34, 27, 23), 
			colorFromRGB(68, 61, 39), 
			colorFromRGB(156, 142, 85), 
			colorFromRGB(206, 193, 124), 
			colorFromRGB(239, 231, 172), 
			colorFromRGB(97, 67, 162), 
			colorFromRGB(169, 68, 153), 
			colorFromRGB(243, 141, 184), 
			colorFromRGB(93, 77, 64), 
			colorFromRGB(157, 133, 114), 
			colorFromRGB(202, 184, 170), 
			colorFromRGB(222, 65, 65), 
			colorFromRGB(230, 147, 67), 
			colorFromRGB(238, 238, 101), 
			colorFromRGB(49, 69, 157), 
			colorFromRGB(88, 139, 192), 
			colorFromRGB(126, 209, 227), 
			colorFromRGB(41, 137, 66), 
			colorFromRGB(108, 196, 72), 
			colorFromRGB(197, 249, 157)
		];
		
		
		
		private function colorFromRGB(inR:uint, inG:uint, inB:uint):uint {
			return inR << 16 | inG << 8 | inB;
		}
		
		public function Avatar(... initarray:Array){
			var ini:Init;
			for each (var inItem:Object in initarray){
				if (inItem is Object){
					ini = Init.parse(inItem);
					col = ini.getNumber("col", 0);
					row = ini.getNumber("row", 0);
				}
			}
			_lastWholeCol = col;
			_lastWholeRow = row;
			_textureMovieClip = Textures.textureAvatar();
			updateModels();
			_textures = [];
			_actionQueue = [];
		}
		
		public function modelGet(inItemIndex:uint):uint {
			switch (inItemIndex){
				case Models.INDEX_BODY:
					return _modelIndexBody;
				case Models.INDEX_HAIR:
					return _modelIndexHair;
				case Models.INDEX_MISC:
					return _modelIndexMisc;
			}
			return 0;
		}
		
		public function modelSet(inItemIndex:uint, inOptionIndex:uint):void {
			switch (inItemIndex){
				case Models.INDEX_BODY:
					_modelIndexBody = inOptionIndex;
				case Models.INDEX_HAIR:
					_modelIndexHair = inOptionIndex;
				case Models.INDEX_MISC:
					_modelIndexMisc = inOptionIndex;
			}
		}
		
		public function textureGet(inItemIndex:uint):uint {
			return _textures[inItemIndex];
		}
		
		public function textureSet(inItemIndex:uint, inOptionIndex:uint):void {
			var tempMC:MovieClip;
			tempMC = _textureMovieClip[Textures.MC_NAMES[inItemIndex]];
			if (inItemIndex == Textures.INDEX_HAIRCOLOR){
				_textures[inItemIndex] = inOptionIndex % _hairColors.length;
				var tempColorTransform:ColorTransform = new ColorTransform();
				tempColorTransform.color = _hairColors[_textures[inItemIndex]];
				tempMC.transform.colorTransform = tempColorTransform;
				_textureMovieClip[Textures.MC_NAMES[Textures.INDEX_SCALP]].transform.colorTransform = tempColorTransform;
				//_textureMovieClip[Textures.MC_NAMES[Textures.INDEX_BROWS]].transform.colorTransform = tempColorTransform;
				//_textureMovieClip[Textures.MC_NAMES[Textures.INDEX_FACIAL]].transform.colorTransform = tempColorTransform;
			} else {
				tempMC.gotoAndStop(((inOptionIndex) % tempMC.totalFrames) + 1);
				_textures[inItemIndex] = tempMC.currentFrame - 1;
			}
		}
		
		public function actionQueueAdd(item:MapItemDecor):void {
			if (!_actionQueue.length) walkNodeStop();
			_actionQueue.push(item);
			item.highlight(true);
			//trace(_actionQueue.length);
		}
		
		public function actionQueueClear():void {
			var item:MapItemDecor;
			while (_actionQueue.length) {
				item = _actionQueue.pop();
				item.transform.colorTransform = null;
				item.mouseEnabled = true;
				item.mouseChildren = true;
			}
		}
		
		public function updateModels():void {
			
			var _models:Array = [Models.modelFromIndex(Models.INDEX_BODY, _modelIndexBody), Models.modelFromIndex(Models.INDEX_HAIR, _modelIndexHair)/*, Models.modelFromIndex(Models.INDEX_MISC, _modelIndexMisc)*/];
			
			var currentAnimation:int
			try {currentAnimation = _displayObject.getAnimation();}catch (err:Error){ currentAnimation = ANIMATION_IDLE}
			setModels(_models);
			_displayObject.createAnimation(ANIMATION_IDLE, Cacher3D.DIREC_TYPE_8, [0]);
			_displayObject.createAnimation(ANIMATION_WALK, Cacher3D.DIREC_TYPE_8, [0,1,2,3,2,1,0,4,5,6,5,4]);
			_displayObject.createAnimation(ANIMATION_HAND, Cacher3D.DIREC_TYPE_8, [7,8,9,9,10,9,9,8,9,9,10,9,9,8,7]);			
			_displayObject.playAnimation(currentAnimation);
			this.addChild(_displayObject);
			orient(_lastOrientation);
			_displayObject.mouseEnabled = false;
		}
		
		public function destroy():void {
			//trace('avatar: destroy');
			
			for each(var _node:* in _nodeChainArray){
				if (_node) {
					_node.destroy();
					_node = null;
				}
			}
			_nodeChainArray = null;
			
			if (_nodesGoalSetPending) {
				_nodesGoalSetPending = null;
			}
			TweenNano.killTweensOf(this, false);
			if (parent) parent.removeChild(this);
			_displayObject.destroy();
			_displayObject = null;
		}
		
		public function getAStarNode():AStarNode {
			var avatarNode:AStarNode = new AStarNode();
			avatarNode.col = Math.round(_col);
			avatarNode.row = Math.round(_row);
			return avatarNode;
		}
		
		private function walkDirection(inDirection:uint):Boolean {
			//trace("walkDirection: " + inDirection);
			if (!map){
				return false;
			}
			
			var deltaCol:int;
			var deltaRow:int;
			var diagonalMultiplier:Number = 1;
			
			switch (inDirection){
				case Cacher3D.DIREC_S:
					deltaCol = 1;
					deltaRow = 1;
					break;
				case Cacher3D.DIREC_N:
					deltaCol = -1;
					deltaRow = -1;
					break;
				case Cacher3D.DIREC_W:
					deltaCol = -1;
					deltaRow = 1;
					break;
				case Cacher3D.DIREC_E:
					deltaCol = 1;
					deltaRow = -1;
					break;
				case Cacher3D.DIREC_SW:
					deltaCol = 0;
					deltaRow = 1;
					break;
				case Cacher3D.DIREC_NE:
					deltaCol = 0;
					deltaRow = -1;
					break;
				case Cacher3D.DIREC_NW:
					deltaCol = -1;
					deltaRow = 0;
					break;
				case Cacher3D.DIREC_SE:
					deltaCol = 1;
					deltaRow = 0;
					break;
			}
			/*
			   //TEST INBOUND
			   if (col + deltaCol > _map.cols - 1 || row + deltaRow > _map.rows - 1 || col + deltaCol < 0 || row + deltaRow < 0){
			   //_walking = false;
			   return false;
			   }
			   //TEST OCCUPATION
			   if (_map.tileOccupied(col + deltaCol, row + deltaRow)){
			   return false;
			   }
			 */
			//TEST DIAGONAL OCCUPATION
			if (Math.abs(deltaCol) + Math.abs(deltaRow) > 1){
				diagonalMultiplier = 1.4142;
				/*if (_map.tileOccupied(col + deltaCol, row) || _map.tileOccupied(col, row + deltaRow)){
				   return false;
				 }*/
			}
			//trace("diagonalMultiplier: " + diagonalMultiplier);
			orient(inDirection);
			_displayObject.playAnimation(ANIMATION_WALK, inDirection);
			TweenNano.killTweensOf(this, false);
			TweenNano.to(
				this, 
				diagonalMultiplier * 14, 
				{ 
					col: Math.round(this.col + deltaCol), 
					row: Math.round(this.row + deltaRow), 
					useFrames: true, 
					ease: Linear.easeNone, 
					onComplete: walkNodeNext,
					onUpdate: walkEnterFrame
				}
			);
			//TweenNano.to(this, diagonalMultiplier * 15, {  useFrames: true, ease: Linear.easeNone});
			//trace("walkTime: " + diagonalMultiplier * 0.5);
			return true;
		}
		
		private function walkEnterFrame():void {
					map.sort();
			//var update:Boolean = false;
			//if (_lastWholeCol != Math.floor(_col) || _lastWholeRow != Math.floor(_row)) update = true;
			//if (_col == Math.round(_col) && _row == Math.round(_row )) update = true;
			if (_lastWholeCol != Math.floor(_col) || _lastWholeRow != Math.floor(_row)) {
				_lastWholeCol = Math.floor(_col);
				_lastWholeRow = Math.floor(_row);
				if (map) {
					trace('udpate ' + Math.random());
				}
			}
		}
		
		public function walkTile(inAstarNode:AStarNode):void {
			if (_actionQueue.length) return;
			walkNodeStop();
			walkNodeGoalSet([inAstarNode]);
		}
		public function walkItems():void {
			if (!_actionQueue.length) {
				//trace('_actionQueue empty');
				return;
			}
			var item:MapItemDecor = _actionQueue[0];
			var goalNodes:Array;
			if (item.actionCheck()) {
				goalNodes = item.getBorderNodes();
			}else {
				goalNodes = [];
				_actionQueue.shift();
			}
			//trace('goalNodes: ' + goalNodes.length);
			walkNodeGoalSet(goalNodes);
		}
		
		public function walkNodeGoalSet(inNodes:Array):void {
			//trace('walkNodeGoalSet');
			if (map == null) {
				//trace('parent null');
				return;
			}
			_nodesGoalSetPending = inNodes;
			//trace('walkNodGoal: ' + _nodePending);
			if (_isWalking) {
				return;
			}else {
				//_nodeChainArray.pop();
			}
			_isWalking = true;
			walkNodeNext();
		}
		
		public function walkNodeStop():void {
			//trace("walking done");
			_nodeChainArray = null;
		}
		
		private function walkNodeNext():void {
			//trace("walkNodeNext");
			if (_nodeChainArray && _nodeChainArray.length > 0){
				var walkNode:AStarNode = _nodeChainArray.pop();
				//trace("walking to " + walkNode);
				var deltaCol:int = walkNode.col - this.col;
				var deltaRow:int = walkNode.row - this.row;
				walkNode.destroy();
				var nodeDirection:int;
				if (deltaCol == 1 && deltaRow == 1)
					nodeDirection = Cacher3D.DIREC_S;
				if (deltaCol == -1 && deltaRow == -1)
					nodeDirection = Cacher3D.DIREC_N;
				if (deltaCol == -1 && deltaRow == 1)
					nodeDirection = Cacher3D.DIREC_W;
				if (deltaCol == 1 && deltaRow == -1)
					nodeDirection = Cacher3D.DIREC_E;
				if (deltaCol == 0 && deltaRow == 1)
					nodeDirection = Cacher3D.DIREC_SW;
				if (deltaCol == 0 && deltaRow == -1)
					nodeDirection = Cacher3D.DIREC_NE;
				if (deltaCol == -1 && deltaRow == 0)
					nodeDirection = Cacher3D.DIREC_NW;
				if (deltaCol == 1 && deltaRow == 0)
					nodeDirection = Cacher3D.DIREC_SE;
				if (deltaCol == 0 && deltaRow == 0) {
					walkNodeNext();
					return;
				}
				_lastOrientation = nodeDirection;
				walkDirection(nodeDirection);
			} else {
				walkNodeDone();
			}
		}
		
		private function actionDone():void {
			//trace('Avatar: actionDone');
			_displayObject.playAnimation(ANIMATION_IDLE, _displayObject.orientation);
			_isWalking = false;
			walkItems();
		}
		
		private function walkNodeDone():void {
			//trace("walkNodeDone");
			//trace('colrow: ' +col + ', ' +row);
			_displayObject.playAnimation(ANIMATION_IDLE, _lastOrientation);
			col = Math.round(col);
			row = Math.round(row);
			if (_nodesGoalSetPending && map) {
				_nodeChainArray = map.pathFind(getAStarNode(), _nodesGoalSetPending);
				_nodesGoalSetPending = null;
				//trace('_nodeChainArray.length: ' + _nodeChainArray.length)
				walkNodeNext();
			}else if (_actionQueue.length) {
				//trace('_actionQueue check distance');
				var item:MapItemDecor = _actionQueue[0];
				if (Astar.nodeDistanceArray(getAStarNode(), item.getBorderNodes()) == 0) {
					//trace('_actionQueue distance reached');
					_actionQueue.shift();
					this.faceItem(item);
					_displayObject.playAnimation(ANIMATION_HAND, _displayObject.orientation);
					_lastOrientation = _displayObject.orientation;
					item.actionExecute(actionDone);
					//walkItems();
				}else {
					_actionQueue.shift();
					item.highlight(false);
					actionDone();
				}
			}else {
				//trace('walkNodeDone DONE');
				_isWalking = false;
				for each (var temp:AStarNode in _nodeChainArray) {
					_nodeChainArray.destroy();
				}
				_nodeChainArray = null;
				dispatchEvent(new Event(WALK_DONE));				
			}
		}
		private function faceItem(value:MapItemDecor):void {
			if (row - 1 == value.row + value.rows - 1)	{ orient(Cacher3D.DIREC_NE); return; }
			if (col - 1 == value.col + value.cols - 1)	{ orient(Cacher3D.DIREC_NW); return; }
			if (row + 1 == value.row)					{ orient(Cacher3D.DIREC_SW); return; }
			if (col + 1 == value.col)					{ orient(Cacher3D.DIREC_SE); return; }
		}
		public function get cols():int { return 1; }
		public function get rows():int { return 1; }
		public function get col():Number { return _col; }
		public function get row():Number { return _row; }
		public function set col(inUint:Number):void { _col = inUint; setTilePosition(); }
		public function set row(inUint:Number):void { _row = inUint; setTilePosition(); }
		
		private function setTilePosition():void {
			if (_map != null){
				var coordScreen:Coordinate = _map.mapTiletoScreen(_col, _row);
				this.x = coordScreen.x;
				this.y = coordScreen.y;
			}
		}
		
		public function set map(inMap:Map):void {
			_map = inMap;
		}
		
		public function get map():Map {
			return _map;
		}
		
		public function orient(inDirection:uint):void {
			_displayObject.orientation = inDirection;
		}
		
		private function setModels(inModels:Array):void {
			if (_displayObject) {
				removeChild(_displayObject);
				_displayObject.destroy();
				_displayObject = null;
			}
			//trace("destroy cacher3d");
			_displayObject = new Cacher3D( { textureObject: _textureMovieClip, drawOffsetY: 12, pivotOffsetY: -35 } );
			for each (var inModel:Object in inModels){
				if (inModel != null)
					_displayObject.addModel(inModel);
			}
		}
		
	}
}