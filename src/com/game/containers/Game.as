package com.game.containers {
	import com.game.animation.Avatar
	import com.game.animation.Cacher3D;
	import com.game.animation.Models;
	import com.game.animation.Textures
	import com.game.containers.World;
	import com.game.global.GlobalObjects;
	import com.game.global.GlobalStats;
	import com.game.grid.Map;
	import com.game.items.MapItemDecor;
	import com.game.items.MapItemCrop;
	import com.game.items.MapItemTable;
	import com.game.ui.panels.uiActionGauge;
	import com.game.ui.panels.uiStatGauge;
	import flash.utils.Timer;
	//import com.game.grid.Item;
	import com.game.grid.Tile;
	import com.game.ui.panels.uiPanelStats;
	import com.game.ui.panels.uiPanelBottom;
	import com.game.ui.shapes.monoUtility;
	import com.game.ui.gauge.*;
	import com.game.ui.button.*;
	import com.game.ui.shapes.*;
	import com.game.uiTimer;
	import com.game.utils.astar.AStarNode;
	import com.game.utils.geom.Coordinate;
	import com.game.utils.Isometric;
	import com.game.ui.Cursor;
	import com.zl.ui.KeyboardFull;
	import com.zl.utils.Sort;
	import com.zl.utils.Diagnostics;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.system.System;
	import com.greensock.TweenNano;
	import com.greensock.easing.Linear;
	import flash.utils.getTimer;
	import com.zl.utils.WebTrack;
	public class Game extends Sprite {
		
		private var _myGuys:Array = new Array();
		private var keystateUp:Boolean;
		private var keystateDown:Boolean;
		private var keystateLeft:Boolean;
		private var keystateRight:Boolean;
		
		private var _myDiagnostics:Diagnostics;
		
		private var _uiMissions:uiRectangle;
		private var _uiPanelStats:uiPanelStats;
		private var _uiPanelBottom:uiPanelBottom;
		private var _uiActionGauge:uiActionGauge;
		private var uiBorder:uiRectangle;
		
		private var _buttonsY:Number = 100;
		
		private var _uiTimer:uiTimer;

		public function Game() {
			this.addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
			//this.alpha = 0.5;
		}
		
		public function init(myEvent:Event):void {
			
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			stage.tabChildren = false;
			stage.align = StageAlign.TOP;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener(Event.RESIZE, positionUI, false, 0, true);
			
			
			newWorld();
			uiBorder = 		new uiRectangle({ fillAlpha: 0.0, borderAlpha: 0.5, fillColor: 0x000000, width: 760, height: 620, cornerRadius: 0 });
			_uiMissions = 	new uiRectangle( { fillAlpha: 0.5, borderAlpha: 0.0, fillColor: 0xFF0000, width: 50,  height: 300 } );
			_uiPanelStats = 	new uiPanelStats();
			_uiPanelBottom = 	new uiPanelBottom();
			
			GlobalObjects.cursor = new Cursor();
			
			
			_uiMissions.addEventListener(MouseEvent.CLICK, function():void { trace('xxx') }, false, 0, true);
			
			
			
			var temp_uiButtonSprite:uiButtonSprite;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyListenDown);
			_myDiagnostics = new Diagnostics()
			_myDiagnostics.y = 64;
			_myDiagnostics.x = 550;
			
			_uiActionGauge = new uiActionGauge()
			_uiActionGauge.x = 760 / 2;
			_uiActionGauge.y = 760 / 2;
			GlobalObjects.actionGauge = _uiActionGauge;
			
			
			addChild(_uiActionGauge);
			addChild(GlobalObjects.cursor);			
			//addChild(_uiMissions);
			addChild(_uiPanelStats);
			addChild(_uiPanelBottom);
			addChild(_myDiagnostics);
			
			addButton('Reset', 			debugReset);
			addButton('New Crop', 		debugAddCrop);
			addButton('New Decor', 		debugAddDecor);
			addButton('New Character',	debugAddAvat);
			addButton('Hair',			debugHair);
			addButton('Hair Color',		debugHairColor);
			addButton('Scalp',			debugScalp);
			addButton('Skin',			debugSkin);
			addButton('Shirt',			debugShirt);
			addButton('Expand', 		debugExpand);
			
			positionUI(null);
			
			populateMap()
		}
		
		private function addButton(text:String, func:Function):void {
			var tempButton:uiButtonText = new uiButtonText( { textSize: 11 } );
			tempButton.x = 9;
			tempButton.y = _buttonsY;
			tempButton.text = text;
			tempButton.addEventListener(uiButton.CLICK, func, false, 0, true);
			addChild(tempButton);
			_buttonsY += 30;
		}
		
		private function populateMap():void {
			//var door:MapItemDecor = new MapItemDecor('./swf/items_door_1.swf', MapItemDecor.DIREC_TYPE_2, 0, 3);
			//GlobalObjects.world.map.addItem(door,-0.5,4,true);
			//return;
			for (var i:int = 0; i < 10; ++i) {
				if (Math.random() > 0.5) {
					debugAddDecor();
				}else {
					debugAddCrop();
				}
			}
			WebTrack.getInstance().track('GameLoaded');
		}
		
		private function debugExpand(e:Event = null):void {
			GlobalObjects.world.map.expand();
			if (e) WebTrack.getInstance().track('debugExpand');
		}
		
		private function debugHair(e:Event = null):void {
			for (var i:int = 0; i < _myGuys.length; i++ ) {
				var myGuy:Avatar = _myGuys[i];
				myGuy.modelSet(Models.INDEX_HAIR, myGuy.modelGet(Models.INDEX_HAIR) + 1);
				
				if (myGuy.modelGet(Models.INDEX_HAIR) > Models.INDEX_HAIR_FLAT){
					myGuy.modelSet(Models.INDEX_HAIR, Models.INDEX_HAIR_NONE);
				}
				myGuy.updateModels();
			}
			if (e) WebTrack.getInstance().track('debugHair');
		}
		
		private function debugHairColor(e:Event = null):void {
			for (var i:int = 0; i < _myGuys.length; i++ ) {
				var myGuy:Avatar = _myGuys[i];
				myGuy.textureSet(Textures.INDEX_HAIRCOLOR, myGuy.textureGet(Textures.INDEX_HAIRCOLOR) + 1);
				myGuy.updateModels();
			}
			if (e) WebTrack.getInstance().track('debugHairColor');
		}
		
		private function debugScalp(e:Event = null):void {
			for (var i:int = 0; i < _myGuys.length; i++ ) {
				var myGuy:Avatar = _myGuys[i];
				myGuy.textureSet(Textures.INDEX_SCALP, myGuy.textureGet(Textures.INDEX_SCALP)+1);
				myGuy.updateModels();
			}
			if (e) WebTrack.getInstance().track('debugScalp');
		}
		
		private function debugSkin(e:Event = null):void {
			for (var i:int = 0; i < _myGuys.length; i++ ) {
				var myGuy:Avatar = _myGuys[i];
				myGuy.textureSet(Textures.INDEX_SKIN, myGuy.textureGet(Textures.INDEX_SKIN)+1);
				myGuy.updateModels();
			}
			if (e) WebTrack.getInstance().track('debugSkin');
		}
		
		private function debugShirt(e:Event = null):void {
			for (var i:int = 0; i < _myGuys.length; i++ ) {
				var myGuy:Avatar = _myGuys[i];
				myGuy.textureSet(Textures.INDEX_SHIRT, myGuy.textureGet(Textures.INDEX_SHIRT)+1);
				myGuy.updateModels();
			}
			if (e) WebTrack.getInstance().track('debugShirt');
		}
		
		private function debugReset(e:Event = null):void {
			GlobalObjects.world.destroy();
			_myGuys = [];
			newWorld();
			GlobalObjects.actionGauge.visible = false;
			if (e) WebTrack.getInstance().track('debugReset');
		}
		
		private function debugAddCrop(e:Event = null):void {
			var table:MapItemTable = new MapItemTable('./swf/items_table_1.swf');
			table.crop = new MapItemCrop('./swf/items_crop_oj.swf', 30, 0.99);
			GlobalObjects.world.map.addRandomItem(table);
			GlobalObjects.world.map.sort();
			if (e) WebTrack.getInstance().track('debugAddCrop');
		}
		
		private function debugAddDecor(e:Event = null):void {
			var decor:MapItemDecor = new MapItemDecor('./swf/items_table_2.swf', MapItemDecor.DIREC_TYPE_2, 1, 2);
			if (Math.random() > 0.5) decor.rotate++;
			GlobalObjects.world.map.addRandomItem(decor);
			GlobalObjects.world.map.sort();
			if (e) WebTrack.getInstance().track('debugAddDecor');
		}
		
		private function debugAddAvat(e:Event = null):void {
			var newGuy:Avatar = new Avatar();
			_myGuys.push(newGuy);
			GlobalObjects.world.map.addRandomItem(
				newGuy, 
				true
			);
			
			/**/newGuy.walkNodeGoalSet(
				[GlobalObjects.world.map.getTile(
					Math.floor(GlobalObjects.world.map.cols * Math.random()), 
					Math.floor(GlobalObjects.world.map.rows * Math.random())
				).getAStarNode()]
			);
			newGuy.addEventListener(Avatar.WALK_DONE, walkDoneHandler);
			if (e) WebTrack.getInstance().track('debugAddAvat');
		}
		
		public function newWorld():void {
			GlobalObjects.world = new World();
			GlobalObjects.world.x = 760 / 2;
			GlobalObjects.world.y = stage.stageHeight / 2;
			addChildAt(GlobalObjects.world,0);
			
			var myGuy:Avatar = new Avatar();
			GlobalObjects.currentAvatar = myGuy;
			_myGuys.push(myGuy);
			
			GlobalObjects.world.map.addItem(
				myGuy, 
				5,//-1, 
				5, 
				true
			);
			var guyPos:Coordinate = GlobalObjects.world.map.mapTiletoScreen(myGuy.col, myGuy.row);
			GlobalObjects.world.map.x -= guyPos.x;
			GlobalObjects.world.map.y -= guyPos.y;
			
			var square:Sprite = new Sprite();
			GlobalObjects.world.map.addChild(square);
			square.graphics.beginFill(0x0000FF);
			square.graphics.drawRect(0, 0, 2, 2);
			square.graphics.endFill();
			square.x = myGuy.x;
			square.y = myGuy.y;
			GlobalObjects.world.map.sort();
		}
		
		public function positionUI(myEvent:Event):void {
			_uiPanelStats.y = 0;
			_uiPanelStats.x = 0;
			_uiMissions.x = Math.ceil( -(stage.stageWidth - 760) / 2) + 9;
			_uiMissions.y = _uiPanelStats.y + _uiPanelStats.height + 3;
			_uiPanelBottom.y = stage.stageHeight - _uiPanelBottom.height;
			
			
			GlobalObjects.world.y = stage.stageHeight / 2;
		}
		
		public function walkDoneHandler(e:Event):void {
			var myGuy:Avatar = e.target as Avatar;
			var myCol:int = Math.floor(GlobalObjects.world.map.cols * Math.random());
			var myRow:int = Math.floor(GlobalObjects.world.map.rows * Math.random());
			var myTile:Tile = GlobalObjects.world.map.getTile(myCol, myRow);
			//myTile.alpha = 0;
			myGuy.walkNodeGoalSet(
				[myTile.getAStarNode()]
			);
		}
		
		public function guyWalk(inTile:Tile):void {
			/*var nodeArray:Array = map.pathFind(myGuy.getAStarNode(), inTile.getAStarNode());
			myGuy.walkNodeArray(nodeArray);*/
		}
		
		public function keyListenDown(myKeyEvent:KeyboardEvent):void {
			
			/*if (myKeyEvent.keyCode == KeyboardFull.SPACE){
				while (1){
					if (GlobalObjects.world.map.addRandomItem()){
						break;
					}
				}
				GlobalObjects.world.map.sort();
			}*/
			
			/*if (myKeyEvent.keyCode == KeyboardFull.M){
				while (1){
					if (GlobalObjects.world.map.addRandomItem()){
						break;
					}
				}
			}*/
			
			if (myKeyEvent.keyCode == KeyboardFull.S) {
				//var myGuy:Avatar = _myGuys[0] as Avatar;
				//var myNode:AStarNode = new AStarNode();
				//myNode.col = myGuy.col - 1;
				//myNode.row = myGuy.row;
				//myGuy.walkNodeGoalSet([myNode]);
				var i:int;
				
				
				var sortTime1:int = getTimer();
				GlobalObjects.world.map.isoDepthSortAll2();
				sortTime1 = getTimer() - sortTime1;
				
				var sortTime2:int = getTimer();
				GlobalObjects.world.map.isoDepthSortAll2();
				sortTime2 = getTimer() - sortTime2;
				
				trace(sortTime1 +", " + sortTime2);
			}
			/*if (myKeyEvent.keyCode == KeyboardFull.A) {
			}*/
			
			
			
			if (myKeyEvent.keyCode == KeyboardFull.G) {
				System.gc()
			}
			
			if (myKeyEvent.keyCode == KeyboardFull.N) {
				//for (var j:uint = 0; j < 10; j++){
					//myGuy.destroy();
					//myGuy = null;
					
					var newGuy:Avatar = new Avatar();
					_myGuys.push(newGuy);
					GlobalObjects.world.map.addItem(
						newGuy, 
						Math.floor(GlobalObjects.world.map.cols * Math.random()), 
						Math.floor(GlobalObjects.world.map.rows * Math.random()), 
						true
					);
					
					/**/newGuy.walkNodeGoalSet(
						[GlobalObjects.world.map.getTile(
							Math.floor(GlobalObjects.world.map.cols * Math.random()), 
							Math.floor(GlobalObjects.world.map.rows * Math.random())
						).getAStarNode()]
					);
					newGuy.addEventListener(Avatar.WALK_DONE, walkDoneHandler);
				//}
			}
			

		}
	}
}