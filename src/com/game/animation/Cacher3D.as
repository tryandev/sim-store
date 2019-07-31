package com.game.animation {
	import away3d.core.math.MatrixAway3D;
	import away3d.core.render.BitmapRenderSession;
	import away3d.core.render.Renderer;
	import away3d.materials.MovieMaterial;
	import com.game.utils.geom.Coordinate;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.system.System;
	import flash.utils.getQualifiedClassName;
	
	import away3d.animators.data.AnimationSequence;
	import away3d.cameras.HoverCamera3D;
	import away3d.cameras.lenses.OrthogonalLens;
	import away3d.containers.Scene3D;
	import away3d.containers.View3D;
	import away3d.core.clip.Clipping;
	import away3d.core.clip.FrustumClipping;
	import away3d.core.clip.RectangleClipping;
	import away3d.core.base.Object3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Cast;
	import away3d.core.utils.Init;
	import away3d.loaders.Md2;
	import away3d.materials.IMaterial;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	
	public class Cacher3D extends Sprite {
		
		public static const DIREC_TYPE_1:uint = 0;
		public static const DIREC_TYPE_2:uint = 1;
		public static const DIREC_TYPE_4:uint = 2;
		public static const DIREC_TYPE_8:uint = 3;
		
		public static const DIREC_S:uint = 0;
		public static const DIREC_SE:uint = 1;
		public static const DIREC_E:uint = 2;
		public static const DIREC_NE:uint = 3;
		public static const DIREC_N:uint = 4;
		public static const DIREC_NW:uint = 5;
		public static const DIREC_W:uint = 6;
		public static const DIREC_SW:uint = 7;
		public static const DIREC_NULL:uint = 8;
		
		public static const DRAW_WIDTH:Number = 75;
		public static const DRAW_HEIGHT:Number = 124;
		
		private var _view:View3D;
		private var _scene:Scene3D;
		private var _camera:HoverCamera3D;
		private var _stage3D:Sprite = new Sprite();
		
		private var _lastAddedSprite:Sprite = null;
		private var _labelCurrent:int = 0;;
		
		private var _cacheSequences:Array = new Array();
		private var _textureObject:DisplayObject;
		private var _models:Object = new Object();
		
		private var _drawOffsetY:Number = -25;
		private var _pivotOffsetY:Number;
		
		private var _enterFrameOnce:Boolean;
		private var _altFrames:Boolean;
		
		public function Cacher3D(... initarray:Array) {
			initObjects();
			var ini:Init;
			for each (var inItem:Object in initarray) {
				var tempClassName:String = getQualifiedClassName(inItem);
				var thisClassName:String = getQualifiedClassName(this);
				if (tempClassName.indexOf("Models_") == 0) {
					//trace(tempClassName + " is a model.");
					_models[tempClassName] = inItem;
					addModel(inItem);
				}
				if (inItem is Object) {
					ini = Init.parse(inItem);
					_pivotOffsetY = ini.getNumber("pivotOffsetY", 0);
					_drawOffsetY = ini.getNumber("drawOffsetY", _drawOffsetY);
					textureObject = ini.getObject("textureObject") as DisplayObject;
				}
			}
			//trace(_drawOffsetY);
		}
		
		private function initObjects():void {
			_view = new View3D();
			//_view.renderer = Renderer.CORRECT_Z_ORDER;
			//_view.screenClipping
			_scene = new Scene3D();
			var OrthoLens:OrthogonalLens = new OrthogonalLens();
			_camera = new HoverCamera3D({lens: OrthoLens});
			
			_camera.target = new Object3D( { x: 0, y: 0 } );
			_camera.tiltangle = 18; //30 // //39.077 from 3dsMax,
			_camera.targettiltangle = _camera.tiltangle;
			
			_view.camera = _camera;
			_view.scene = _scene;
			//_view.x = DRAW_WIDTH / 2;
			//_view.y = DRAW_HEIGHT / 2;
			
			_stage3D.addChild(_view);
			_stage3D.visible = false;
			addChild(_stage3D);
		}
		
		private function initTexture():void {
			var tempMaterial:IMaterial;
			if (_textureObject == null){
				tempMaterial = new ColorMaterial(0xFFFFFF);
			} else {
				var tempDisplayObject:DisplayObject = _textureObject;
				var texScale:Number = 0.25;
				var tempBitmapData:BitmapData = new BitmapData(
					tempDisplayObject.width*texScale,
					tempDisplayObject.height*texScale
				);
				var texTrans:Matrix = new Matrix();
				texTrans.createBox(texScale, texScale, 0, 0, 0);
				tempBitmapData.draw(tempDisplayObject, texTrans,null,null,null,true);
				//tempMaterial =  new MovieMaterial(tempDisplayObject as Sprite, { autoUpdate: true, smooth: true, precision: 80 } );
				tempMaterial = new BitmapMaterial(tempBitmapData, { smooth: true } );
			}
			for each (var tempMesh:Mesh in _scene.children) {
				tempMesh.material = tempMaterial;
			}
			resetCacheSequences();
		}
		
		public function enableAnimation():void {
			//trace("enableAnimation");
			var myAnimation:AnimationSequence = new AnimationSequence("ani", false, true, 1);
			for each (var tempMesh:Mesh in _scene.children) {
				tempMesh.play(myAnimation);
				tempMesh.gotoAndStop(0);
			}
			initTexture();
		}
		
		public function addModel(inModel:*):void {
			var tempMesh:Mesh = Md2.parse(Cast.bytearray(inModel));
			_scene.addChild(tempMesh);
			enableAnimation();
			initTexture();
			//tempMesh.z = -330;
			tempMesh.scaleX = -0.075;
			tempMesh.scaleY = 0.075;
			tempMesh.scaleZ = 0.075;
			tempMesh.rotationY = 180;
			tempMesh.bothsides = false;
		}
		
		public function createAnimation(inLabel:int, inDirectType:uint, inFrameArray:Array):void {
			_cacheSequences[inLabel] = new CacheSequence(this, _stage3D, inFrameArray, inDirectType);
		}
		public function getAnimation():int {
			return _labelCurrent;
		}
		public function playAnimation(inLabel:int, inDirection:uint = DIREC_NULL):void {
			//trace("play animation : " + inLabel + ", " + inDirection);
			_labelCurrent = inLabel;
			if (inDirection != DIREC_NULL)
				_cacheSequences[_labelCurrent].direction = inDirection;
			//trace("default direction: " + _cacheSequences[_labelCurrent].direction);
			if (_cacheSequences[_labelCurrent].frameCount < 2){
				removeEnterFrame();
				addEnterFrame(true);
			} else {
				removeEnterFrame();
				addEnterFrame();
			}
		}
		
		public function set orientation(inDirection:uint):void {
			_cacheSequences[_labelCurrent].direction = inDirection;
			onEnterFrameFnc();
		}
		
		public function get orientation():uint {
			return _cacheSequences[_labelCurrent].direction;
		}
		
		public function get textureObject():DisplayObject {
			return _textureObject;
		}
		
		public function set textureObject(inDisplayObject:DisplayObject):void {
			_textureObject = inDisplayObject;
			initTexture();
		}
		
		private function addEnterFrame(doOnce:Boolean = false):void {
			this.addEventListener(Event.ENTER_FRAME, onEnterFrameFnc, false, 0, true);
			_enterFrameOnce = doOnce;
		}
		
		private function removeEnterFrame():void {
			if (this.hasEventListener(Event.ENTER_FRAME)){
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrameFnc);
			}
		}
		
		private function onEnterFrameFnc(event:Event = null):void {
			//trace('onEnterFrameFnc');
			_altFrames = !_altFrames;
			if (_altFrames) return;
			if (_lastAddedSprite != null) {
				removeChild(_lastAddedSprite);
			}
			_lastAddedSprite = _cacheSequences[_labelCurrent].getSpriteNextFrame();
			//if (!_lastAddedSprite.cacheAsBitmap) _lastAddedSprite.cacheAsBitmap = true;
			addChild(_lastAddedSprite);
			_lastAddedSprite.y = -36;// _drawOffsetY;
			//trace(_lastAddedSprite.y);
			if (_enterFrameOnce)
				removeEnterFrame();
		}
		
		private function resetCacheSequences():void {
			for each (var tempCacheSequence:CacheSequence in _cacheSequences){
				//trace("a resetCacheSequence");
				tempCacheSequence.reset();
			}
		}
		
		public function destroy():void {
			/*
			private var _view:View3D;
			private var _scene:Scene3D;
			private var _camera:HoverCamera3D;
			private var _stage3D:Sprite = new Sprite();
			
			private var _lastAddedSprite:Sprite = null;
			private var _labelCurrent:int;
			
			private var _cacheSequences:Array = new Array();
			private var _textureObject:DisplayObject;
			private var _models:Object = new Object();
			
			private var _drawOffsetY:Number = -25;
			private var _pivotOffsetY:Number;
			
			private var _enterFrameOnce:Boolean;
			private var _altFrames:Boolean;
			*/
			removeEnterFrame();
			_models = null;
			_textureObject = null;
			if (_cacheSequences) {
				var max:int = _cacheSequences.length;
				for (var i:int = 0; i < max; i++) {
					_cacheSequences[i].destroy();
				}
				_cacheSequences[i] = null;
			}
			_lastAddedSprite = null;
			_camera = null;
			_scene = null;
			_view.destroy();
			_view = null;
			_stage3D = null;
		}
	}
}

//import away3d.core.light.PointLight;
import com.game.animation.Cacher3D;
import flash.display.Sprite;
import flash.display.Stage;
import away3d.containers.View3D;
import away3d.core.base.Mesh;
import away3d.cameras.HoverCamera3D;

class CacheSequence {
	
	//private var _frameStart:uint;
	//private var _frameEnd:uint;
	private var _frameArray:Array;
	private var _frameCurrent:uint;
	private var _frameCount:uint;
	private var _directionType:uint;
	private var _directionCurrent:uint;
	private var _directions:Array;
	private var _sequences:Array;
	private var _stage3D:Sprite;
	private var _view:View3D;
	private var _camera:HoverCamera3D;
	private var _parent:Sprite;
	
	public function CacheSequence(inObject:Sprite, inStage3D:Sprite, inFrameArray:Array, inDirectType:uint){
		_parent = inObject;
		//_frameStart = inFrameStart;
		//_frameEnd = inFrameEnd;
		_frameArray = inFrameArray
		_frameCount = _frameArray.length;
		_frameCurrent = _frameCount - 1;
		_directionType = inDirectType;
		_stage3D = inStage3D;
		_view = _stage3D.getChildAt(0) as View3D;
		_camera = _view.camera as HoverCamera3D;
		reset();
	}
	
	private function createDirectionsArray():void {
		switch (_directionType){
			case Cacher3D.DIREC_TYPE_8:
				_directions = new Array(Cacher3D.DIREC_S, Cacher3D.DIREC_SE, Cacher3D.DIREC_E, Cacher3D.DIREC_NE, Cacher3D.DIREC_N, Cacher3D.DIREC_NW, Cacher3D.DIREC_W, Cacher3D.DIREC_SW);
				break;
			case Cacher3D.DIREC_TYPE_4:
				_directions = new Array(Cacher3D.DIREC_SE, Cacher3D.DIREC_NE, Cacher3D.DIREC_NW, Cacher3D.DIREC_SW);
				break;
			case Cacher3D.DIREC_TYPE_2:
				_directions = new Array(Cacher3D.DIREC_SE, Cacher3D.DIREC_SW);
				break;
		}
		_directionCurrent = _directions[0];
		_sequences = new Array();
		for each (var i:uint in _directions){
			//_sequences[i] = new Array(_frameCount);
			_sequences[i] = new Array();
		}
	}
	
	public function getSpriteFrame(inDirection:uint, inFrameNumber:uint):Sprite {
		//if (inFrameNumber < 0 || inFrameNumber >= _frameCount){
		//	throw new Error(this + " - Invalid frame: " + inFrameNumber);
		//}
		if (_sequences[inDirection][inFrameNumber] == undefined){ // || true
			//trace("capture: " + inDirection + "_" + inFrameNumber);
			for each (var tempMesh:Mesh in _view.scene.children){
				tempMesh.gotoAndStop(inFrameNumber);
			}
			//trace(inFrameNumber);
			_camera.panangle = 45 * inDirection;
			_camera.targetpanangle = _camera.panangle;
			_camera.hover();
			var tempSprite:Sprite;
			tempSprite = new Sprite();
			_view.session.sessions[0].externalGraphics = tempSprite.graphics;
			_view.render();
			_sequences[inDirection][inFrameNumber] = tempSprite; //new Bitmap(tempBitmapData, "never", true);
		}
		//return tempSprite;
		return _sequences[inDirection][inFrameNumber];
	}
	
	public function getSpriteNextFrame():Sprite {
		frame += 1;
		return getSpriteFrame(_directionCurrent, _frameArray[frame]);
	}
	
	public function get frameCount():uint {
		return _frameCount;
	}
	
	public function get frame():uint {
		return _frameCurrent;
	}
	
	public function set frame(inFrameNum:uint):void {
		_frameCurrent = inFrameNum % _frameCount;
	}
	
	public function get direction():uint {
		return _directionCurrent;
	}
	
	public function set direction(inDirection:uint):void {
		//trace("set new direction: " + inDirection);
		if (inDirection != _directionCurrent){
			_directionCurrent = inDirection;
		}
	}
	
	public function reset():void {
		//trace("CacheSequence resetting");
		createDirectionsArray();
	}
	
	public function destroy():void {
	/*
	private var _sequences:Array;
	private var _frameArray:Array;
	private var _frameCurrent:uint;
	private var _frameCount:uint;
	private var _directionType:uint;
	private var _directionCurrent:uint;
	private var _directions:Array;
	private var _stage3D:Sprite;
	private var _view:View3D;
	private var _camera:HoverCamera3D;
	private var _parent:Sprite;*/
		if (_sequences) {
			for (var i:uint = 0; i < _sequences.length; i++) {
				var _sequencesDir:Array = _sequences[i];
				for (var j:uint = 0; j < _sequencesDir.length; j++) {
					var frameSprite:Sprite = _sequencesDir[j];
					if (frameSprite) {
						frameSprite.graphics.clear();
						_sequencesDir[j] = null;
					}
				}
				_sequences [i] = null;
				_sequencesDir = null;
			}
			_sequences = null;
		}
		_frameArray = null;
		_directions = null;
		_camera = null;
		_view = null;
		_stage3D = null;
		_parent = null;
		_directions = null;
	}
}