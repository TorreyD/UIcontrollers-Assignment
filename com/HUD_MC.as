package com 
{	
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.events.TouchEvent;
	import flash.events.GestureEvent;
	import flash.events.TransformGestureEvent;
	
	import flash.desktop.NativeApplication;
	import flash.display.Loader;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.IOErrorEvent;
	import flash.events.MediaEvent;
	import flash.media.CameraUI;
	import flash.media.MediaPromise;
	import flash.media.MediaType;

	import com.masterGame;
	
	public class HUD_MC extends MovieClip 
	{
		public static var instance;
		
		public var dPad:MovieClip;
		public var uBTN:MovieClip, dBTN:MovieClip, lBTN:MovieClip, rBTN:MovieClip; 
		public var touchLayer:MovieClip;
		
		public var modMenu:MovieClip;
		public var playStyleBTN1:MovieClip;
		public var playStyleBTN2:MovieClip;
		public var playStyleBTN3:MovieClip;
		public var camBTN:MovieClip;
		public var closeModMenuBTN:MovieClip;
		
		// the camera
		private var deviceCam:CameraUI = new CameraUI();
		private var imgLoader:Loader;
		private var imgLoader2:Loader;
		public var imgPrev:MovieClip;
		
		public function HUD_MC() 
		{
			Multitouch.inputMode = MultitouchInputMode.GESTURE;
			
			x = 240;
			y = 400;
			instance = this;
			
			// the camera
			if (CameraUI.isSupported)
			{
				deviceCam.addEventListener(MediaEvent.COMPLETE, imageCaptured);
				deviceCam.addEventListener(Event.CANCEL, captureCanceled);
				deviceCam.addEventListener(ErrorEvent.ERROR, camError);
			}
			imgPrev = PlayerImage.instance;
			
			// set up dPad and buttons
			dPad = this.getChildByName("dPad") as MovieClip;
			uBTN = dPad.getChildByName("uBTN") as MovieClip;
			dBTN = dPad.getChildByName("dBTN") as MovieClip;
			lBTN = dPad.getChildByName("lBTN") as MovieClip;
			rBTN = dPad.getChildByName("rBTN") as MovieClip;
			
			// set up mod menu and buttons
			modMenu = this.getChildByName("modMenu") as MovieClip;
			playStyleBTN1 = modMenu.getChildByName("ps1_BTN") as MovieClip;
			playStyleBTN1.gotoAndStop(2); // point and click is the default
			playStyleBTN2 = modMenu.getChildByName("ps2_BTN") as MovieClip;
			playStyleBTN3 = modMenu.getChildByName("ps3_BTN") as MovieClip;
			camBTN = modMenu.getChildByName("camBTN") as MovieClip;
			closeModMenuBTN = modMenu.getChildByName("closeBTN") as MovieClip;
			
			// main buttons
			MovieClip(this.getChildByName("modBTN")).addEventListener(MouseEvent.MOUSE_DOWN, onModBTN_pressed);
			MovieClip(this.getChildByName("optBTN")).addEventListener(MouseEvent.MOUSE_DOWN, onOptBTN_pressed);
			MovieClip(this.getChildByName("credBTN")).addEventListener(MouseEvent.MOUSE_DOWN, onCredBTN_pressed);
			
			// mod menu
			playStyleBTN1.addEventListener(MouseEvent.MOUSE_DOWN, ps1BTN_pressed);
			playStyleBTN2.addEventListener(MouseEvent.MOUSE_DOWN, ps2BTN_pressed);
			playStyleBTN3.addEventListener(MouseEvent.MOUSE_DOWN, ps3BTN_pressed);
			camBTN.addEventListener(MouseEvent.MOUSE_DOWN, TakePicture);
			closeModMenuBTN.addEventListener(MouseEvent.MOUSE_DOWN, CloseModMenu);
			
			// dpad
			uBTN.addEventListener(MouseEvent.MOUSE_DOWN, pressUpBTN);
			uBTN.addEventListener(MouseEvent.MOUSE_OUT, releaseUpBTN);
			uBTN.addEventListener(MouseEvent.MOUSE_UP, releaseUpBTN);
			
			dBTN.addEventListener(MouseEvent.MOUSE_DOWN, pressDownBTN);
			dBTN.addEventListener(MouseEvent.MOUSE_OUT, releaseDownBTN);
			dBTN.addEventListener(MouseEvent.MOUSE_UP, releaseDownBTN);
			
			lBTN.addEventListener(MouseEvent.MOUSE_DOWN, pressLeftBTN);
			lBTN.addEventListener(MouseEvent.MOUSE_OUT, releaseLeftBTN);
			lBTN.addEventListener(MouseEvent.MOUSE_UP, releaseLeftBTN);
			
			rBTN.addEventListener(MouseEvent.MOUSE_DOWN, pressRightBTN);
			rBTN.addEventListener(MouseEvent.MOUSE_OUT, releaseRightBTN);
			rBTN.addEventListener(MouseEvent.MOUSE_UP, releaseRightBTN);
			
			// swiping
			touchLayer.addEventListener(TransformGestureEvent.GESTURE_SWIPE, SwipeHandler);
		}
		
		/////////////////////// buttons at the bottom of the screen //////////////////////////////////////////
		public function onModBTN_pressed(e:MouseEvent):void
		{
			modMenu.x = -239;
			modMenu.y = -324.8;
		}
		
		public function onOptBTN_pressed(e:MouseEvent):void
		{
			masterGame.instance.AddObstacles();
		}
		
		public function onCredBTN_pressed(e:MouseEvent):void
		{
			masterGame.instance.showCredits();
		}
		
		/////////////////////// Mod Menu Functions //////////////////////////////////////////
		private function CloseModMenu(e:MouseEvent):void
		{
			modMenu.x = 520;
		}
		
		private function ps1BTN_pressed(e:MouseEvent):void
		{
			SetInputStyle(0);
			playStyleBTN1.gotoAndStop(2);
			playStyleBTN2.gotoAndStop(1);
			playStyleBTN3.gotoAndStop(1);
		}
		
		private function ps2BTN_pressed(e:MouseEvent):void
		{
			SetInputStyle(1);
			playStyleBTN1.gotoAndStop(1);
			playStyleBTN2.gotoAndStop(2);
			playStyleBTN3.gotoAndStop(1);
		}
		
		private function ps3BTN_pressed(e:MouseEvent):void
		{
			SetInputStyle(2);
			playStyleBTN1.gotoAndStop(1);
			playStyleBTN2.gotoAndStop(1);
			playStyleBTN3.gotoAndStop(2);
		}
		
		private function TakePicture(e:MouseEvent):void
		{
			if (CameraUI.isSupported) deviceCam.launch(MediaType.IMAGE);
		}
		
		private function imageCaptured(e:MediaEvent):void
		{
			var imgPromise:MediaPromise = e.data;
			
			if (imgPromise.isAsync)
			{
				imgLoader = new Loader();
				imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, asyncImageLoaded);
				imgLoader.addEventListener(IOErrorEvent.IO_ERROR, camError);
				imgLoader.loadFilePromise(imgPromise);
				
				imgLoader2 = new Loader();
				imgLoader2.contentLoaderInfo.addEventListener(Event.COMPLETE, asyncImageLoaded);
				imgLoader2.addEventListener(IOErrorEvent.IO_ERROR, camError);
				imgLoader2.loadFilePromise(imgPromise);
			} else {
				imgLoader.loadFilePromise(imgPromise);
				imgLoader2.loadFilePromise(imgPromise);
				attachImage(MovieClip(modMenu.getChildByName("imgPrev")), imgLoader);
				attachImage(MovieClip(PlayerMC.instance.getChildByName("imgPrev")), imgLoader2);
			}
		}
		
		private function attachImage(target:MovieClip, L:Loader):void
		{
			L.width = target.width;
			L.height = target.height;
			target.addChild(L);
		}
		
		private function captureCanceled(e:Event):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function asyncImageLoaded(e:Event):void
		{
			attachImage(MovieClip(modMenu.getChildByName("imgPrev")), imgLoader);
			attachImage(MovieClip(PlayerMC.instance.getChildByName("imgPrev")), imgLoader2);
		}
		
		private function camError(err:ErrorEvent):void
		{
			NativeApplication.nativeApplication.exit();
		}
		
		private function SetInputStyle(val:int):void
		{
			masterGame.instance.InputStyle = val;
			
			if (masterGame.instance.InputStyle == 0)
			{
				dPad.y = 525;
				touchLayer.x = -744.15;
			}
			else if (masterGame.instance.InputStyle == 1)
			{
				dPad.y = 256.45;
				touchLayer.x = -744.15;
			}
			else if (masterGame.instance.InputStyle == 2)
			{
				dPad.y = 525;
				touchLayer.x = 0;
			}
		}
		
		/////////////////////// D-Pad Functions //////////////////////////////////////////
		private function pressUpBTN(e:MouseEvent):void
		{
			if (PlayerMC.charState == "moving") return;
			this.addEventListener(Event.ENTER_FRAME, autoMoveUp);
		}
		private function releaseUpBTN(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, autoMoveUp);
		}
		
		private function pressDownBTN(e:MouseEvent):void
		{
			if (PlayerMC.charState == "moving") return;
			this.addEventListener(Event.ENTER_FRAME, autoMoveDown);
		}
		private function releaseDownBTN(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, autoMoveDown);
		}
		
		private function pressLeftBTN(e:MouseEvent):void
		{
			if (PlayerMC.charState == "moving") return;
			this.addEventListener(Event.ENTER_FRAME, autoMoveLeft);
		}
		private function releaseLeftBTN(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, autoMoveLeft);
		}
		
		private function pressRightBTN(e:MouseEvent):void
		{
			if (PlayerMC.charState == "moving") return;
			this.addEventListener(Event.ENTER_FRAME, autoMoveRight);
		}
		private function releaseRightBTN(e:MouseEvent):void
		{
			this.removeEventListener(Event.ENTER_FRAME, autoMoveRight);
		}
		
		private function autoMoveUp(e:Event):void
		{
			if (PlayerMC.charState != "moving")
			{
				PlayerMC.instance.alt_MoveUp();
			}
		}
		private function autoMoveDown(e:Event):void
		{
			if (PlayerMC.charState != "moving")
			{
				PlayerMC.instance.alt_MoveDown();
			}
		}
		private function autoMoveLeft(e:Event):void
		{
			if (PlayerMC.charState != "moving")
			{
				PlayerMC.instance.alt_MoveLeft();
			}
		}
		private function autoMoveRight(e:Event):void
		{
			if (PlayerMC.charState != "moving")
			{
				PlayerMC.instance.alt_MoveRight();
			}
		}
		
		/////////////////////// Swiping //////////////////////////////////////////
		public function SwipeHandler(e:TransformGestureEvent)
		{
			if (masterGame.instance.InputStyle != 2) return;
			
			if (PlayerMC.charState == "idle")
			{
				if (e.offsetX == 0 && e.offsetY == -1) PlayerMC.instance.alt_MoveUp();
				else if (e.offsetX == 0 && e.offsetY == 1) PlayerMC.instance.alt_MoveDown();
				else if (e.offsetX == -1 && e.offsetY == 0) PlayerMC.instance.alt_MoveLeft();
				else if (e.offsetX == 1) PlayerMC.instance.alt_MoveRight();
				else if (e.offsetX == 0 && e.offsetY == 0) trace("stop");
			}
		}
	}
}
