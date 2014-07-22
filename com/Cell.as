package com {
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import com.PlayerMC;
	
	public class Cell extends MovieClip 
	{
		private var passable:Boolean = true;
		private var leftCell:MovieClip = null;
		private var rightCell:MovieClip = null;
		private var topCell:MovieClip = null;
		private var bottomCell:MovieClip = null;
		private var inPath:Boolean = false;
		private var Selected:Boolean = false;
		private var cellIndex:Array = new Array(0,0);
		public static var instance:MovieClip;
		
		
		private var xPos:Number =0;
		private var yPos:Number = 0;
		private var G:Number = 0;
		private var F:Number = 0;
		private var H:Number = 0;
		private var parentCell:String = "none";
		
		private var counter:Number = 1;
		
		public function Cell(initX:Number, initY:Number, row:Number, col:Number) 
		{
			x = initX;
			y = initY;
			
			cellIndex[0] = row;
			cellIndex[1] = col;
			
			instance = this;
			
			addEventListener(Event.ENTER_FRAME, Update);
			addEventListener(MouseEvent.MOUSE_DOWN, onClick);
		}
		
		public function set_coords(I:Number, J:Number, ctr:Number)
		{
			var i = I;
			var j = J;
			counter = ctr;
		}
		
		public function get_G():Number
		{
			return G;
		}
		
		public function get_xPos():Number
		{
			return xPos;
		}
		
		public function get_yPos():Number
		{
			return yPos;
		}
		
		public function get_parent():String
		{
			return parentCell;
		}
		
		public function setCells(lc:MovieClip, rc:MovieClip, tc:MovieClip, bc:MovieClip):void
		{
			leftCell = lc;
			rightCell = rc;
			bottomCell = bc;
			topCell = tc;
			
			yPos = get_cellIndex()[0]
			xPos = get_cellIndex()[1];
		}
		
		public function set_passable(b:Boolean):void
		{
			passable = b;
		}
		
		public function get_passable():Boolean
		{
			return passable;
		}
		
		public function get_LCell():MovieClip
		{
			return leftCell;
		}
		
		public function get_RCell():MovieClip
		{
			return rightCell;
		}
		
		public function get_TCell():MovieClip
		{
			return topCell;
		}
		
		public function get_BCell():MovieClip
		{
			return bottomCell;
		}
		
		public function onClick(e:MouseEvent):void
		{
			if (masterGame.instance.InputStyle != 0) return;
			
			if (passable && PlayerMC.charState == "idle")
			{
				masterGame.instance.onScreenClick(this);
			}
		}
		
		public function get_cellIndex():Array
		{
			return cellIndex;
		}
		
		public function set_inPath(inP:Boolean)
		{
			inPath = inP;
		}
		
		public function get_inPath():Boolean
		{
			return inPath;
		}
		
		private function makeBrighter():void
		{
			// make cell brighter
		}
		
		private function resetBrightness():void
		{
			// reset cell's brightness
		}
		
		private function Update(e:Event):void
		{
			if (!inPath)
			{
			if (passable)
			{
				gotoAndStop("Empty");
			} else {
				gotoAndStop("Blocked");
			}
			} else {
				gotoAndStop(3);
			}
		}
	}
}
