package com
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.masterGame;
	import com.Cell;

	import flash.events.Event;

	public class PlayerMC extends MovieClip
	{
		public static var instance:MovieClip;
		private var destinationPath:Array = new Array();
		private var curCell:MovieClip;
		private var tempCell:MovieClip;
		private var destCell:MovieClip;

		public static var charState:String = "idle";
		private var faceDir:String = "down";
		private var _path:Array;

		private var nextCellIndex:Number = 1;
		private var nextCell:MovieClip;

		private var moveSpeed:Number = 5; // the higher this number, the slower the movement
		
		public var imgPrev:MovieClip;
		
		public function PlayerMC(Rows:Number, Cols:Number)
		{
			imgPrev = this.getChildByName("imgPrev") as MovieClip;
			
			curCell = masterGame.instance.get_cellGrid()[0][Math.ceil(Cols/2)];
			x = curCell.x;
			y = curCell.y;

			instance = this;
			
			addEventListener(Event.ENTER_FRAME, Update);
		}
		
		public function Update(e:Event):void
		{
			if (charState == "idle")
			{
				if (faceDir == "down")
				{
					gotoAndStop("downIdle");
				}
				else if (faceDir == "up")
				{
					gotoAndStop("upIdle");
				}
				else if (faceDir == "left")
				{
					gotoAndStop("leftIdle");
				}
				else if (faceDir == "right")
				{
					gotoAndStop("rightIdle");
				}
			}
			else if (charState == "moving")
			{
				if (faceDir == "down")
				{
					gotoAndStop("downWalk");
				}
				else if (faceDir == "up")
				{
					gotoAndStop("upWalk");
				}
				else if (faceDir == "left")
				{
					gotoAndStop("leftWalk");
				}
				else if (faceDir == "right")
				{
					gotoAndStop("rightWalk");
				}
			}
		}

		public function moveMe(e:Event):void
		{
			if (1 == 1)
			{
				if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0])
				{
					if (nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1] - 1)
					{
						addEventListener(Event.ENTER_FRAME, moveStraightLeft);
						removeEventListener(Event.ENTER_FRAME, moveMe);
					}
					else if (nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1]+1)
					{
						addEventListener(Event.ENTER_FRAME, moveStraightRight);
						removeEventListener(Event.ENTER_FRAME, moveMe);
					}
				}
				else if (nextCell.get_cellIndex()[0] < curCell.get_cellIndex()[0])
				{
					if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0]-1 &&
					nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1])
					{
						addEventListener(Event.ENTER_FRAME, moveStraightUp);
						removeEventListener(Event.ENTER_FRAME, moveMe);
					}
					else if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0]-1 &&
					nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1]-1)
					{
						if (curCell.get_TCell().get_passable() == true)
						{
							tempCell = curCell.get_TCell();
							addEventListener(Event.ENTER_FRAME, moveUpThenLeft);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
						else if (curCell.get_LCell().get_passable() == true)
						{
							tempCell = curCell.get_LCell();
							addEventListener(Event.ENTER_FRAME, moveLeftThenUp);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
					}
					else if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0]-1 &&
					nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1]+1)
					{
						if (curCell.get_TCell().get_passable() == true)
						{
							tempCell = curCell.get_TCell();
							addEventListener(Event.ENTER_FRAME, moveUpThenRight);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
						else if (curCell.get_RCell().get_passable() == true)
						{
							tempCell = curCell.get_RCell();
							addEventListener(Event.ENTER_FRAME, moveRightThenUp);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
					}
				}
				else if (nextCell.get_cellIndex()[0] > curCell.get_cellIndex()[0])
				{
					if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0]+1 &&
					nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1])
					{
						addEventListener(Event.ENTER_FRAME, moveStraightDown);
						removeEventListener(Event.ENTER_FRAME, moveMe);
					}
					else if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0]+1 &&
					nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1]-1)
					{
						if (curCell.get_BCell().get_passable() == true)
						{
							tempCell = curCell.get_BCell();
							addEventListener(Event.ENTER_FRAME, moveDownThenLeft);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
						else if (curCell.get_LCell().get_passable() == true)
						{
							tempCell = curCell.get_LCell();
							addEventListener(Event.ENTER_FRAME, moveLeftThenDown);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
					}
					else if (nextCell.get_cellIndex()[0] == curCell.get_cellIndex()[0]+1 &&
					nextCell.get_cellIndex()[1] == curCell.get_cellIndex()[1]+1)
					{
						if (curCell.get_BCell().get_passable() == true)
						{
							tempCell = curCell.get_BCell();
							addEventListener(Event.ENTER_FRAME, moveDownThenRight);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
						else if (curCell.get_RCell().get_passable() == true)
						{
							tempCell = curCell.get_RCell();
							addEventListener(Event.ENTER_FRAME, moveRightThenDown);
							removeEventListener(Event.ENTER_FRAME, moveMe);
						}
					}
				}
			}
			else
			{
				charState = "idle";
			}
		}

		public function beginMoving(myPath:Array)
		{
			_path = myPath.reverse();
			curCell = _path[0];
			nextCellIndex = 1;
			nextCell = _path[nextCellIndex];
			charState = "moving";
			addEventListener(Event.ENTER_FRAME, moveMe);
		}

		public function get_curCell():MovieClip
		{
			return curCell;
		}

		public function moveStraightUp(e:Event):void
		{
			charState = "moving";
			faceDir = "up";
			
			var dx = Math.abs(x - nextCell.x);
			var dy = Math.abs(y - nextCell.y);
			if (dx > 5)
			{
				x += (nextCell.x - x)/moveSpeed;
			}
			else
			{
				x = nextCell.x;
			}
			if (dy > 5)
			{
				y += (nextCell.y - y)/moveSpeed;
			}
			else
			{
				y = nextCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				nextCellIndex++;
				masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
				curCell = nextCell;
				if (nextCellIndex < _path.length)
				{
					nextCell = _path[nextCellIndex];
					addEventListener(Event.ENTER_FRAME, moveMe);
				}
				else
				{
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					nextCell = null;
					charState = "idle";
				}
				removeEventListener(Event.ENTER_FRAME, moveStraightUp);
			}
		}
		public function moveStraightDown(e:Event):void
		{
			charState = "moving";
			faceDir = "down";
			var dx = Math.abs(x - nextCell.x);
			var dy = Math.abs(y - nextCell.y);
			if (dx > 5)
			{
				x += (nextCell.x - x)/moveSpeed;
			}
			else
			{
				x = nextCell.x;
			}
			if (dy > 5)
			{
				y += (nextCell.y - y)/moveSpeed;
			}
			else
			{
				y = nextCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				nextCellIndex++;
				masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
				curCell = nextCell;
				if (nextCellIndex < _path.length)
				{
					nextCell = _path[nextCellIndex];
					addEventListener(Event.ENTER_FRAME, moveMe);
				}
				else
				{
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					nextCell = null;
					charState = "idle";
				}
				removeEventListener(Event.ENTER_FRAME, moveStraightDown);
			}
		}
		public function moveStraightLeft(e:Event):void
		{
			charState = "moving";
			faceDir = "left";
			
			var dx = Math.abs(x - nextCell.x);
			var dy = Math.abs(y - nextCell.y);
			if (dx > 5)
			{
				x += (nextCell.x - x)/moveSpeed;
			}
			else
			{
				x = nextCell.x;
			}
			if (dy > 5)
			{
				y += (nextCell.y - y)/moveSpeed;
			}
			else
			{
				y = nextCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				nextCellIndex++;
				masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
				curCell = nextCell;
				if (nextCellIndex < _path.length)
				{
					nextCell = _path[nextCellIndex];
					addEventListener(Event.ENTER_FRAME, moveMe);
				}
				else
				{
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					nextCell = null;
					charState = "idle";
				}
				removeEventListener(Event.ENTER_FRAME, moveStraightLeft);
			}
		}
		public function moveStraightRight(e:Event):void
		{
			charState = "moving";
			faceDir = "right";
			
			var dx = Math.abs(x - nextCell.x);
			var dy = Math.abs(y - nextCell.y);
			if (dx > 5)
			{
				x += (nextCell.x - x)/moveSpeed;
			}
			else
			{
				x = nextCell.x;
			}
			if (dy > 5)
			{
				y += (nextCell.y - y)/moveSpeed;
			}
			else
			{
				y = nextCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				nextCellIndex++;
				masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
				curCell = nextCell;
				if (nextCellIndex < _path.length)
				{
					nextCell = _path[nextCellIndex];
					addEventListener(Event.ENTER_FRAME, moveMe);
				}
				else
				{
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					nextCell = null;
					charState = "idle";
				}
				removeEventListener(Event.ENTER_FRAME, moveStraightRight);
			}
		}
		public function moveUpThenLeft(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "up";
			} else {
				faceDir = "left";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveUpThenLeft);
				}
			}
		}
		public function moveUpThenRight(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "up";
			} else {
				faceDir = "right";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveUpThenRight);
				}
			}
		}
		public function moveDownThenLeft(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "down";
			} else {
				faceDir = "left";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveDownThenLeft);
				}
			}
		}
		public function moveDownThenRight(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "down";
			} else {
				faceDir = "right";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveDownThenRight);
				}
			}
		}
		public function moveRightThenUp(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "right";
			} else {
				faceDir = "up";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveRightThenUp);
				}
			}
		}
		public function moveRightThenDown(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "right";
			} else {
				faceDir = "down";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveRightThenDown);
				}
			}
		}
		public function moveLeftThenUp(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "left";
			} else {
				faceDir = "up";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveLeftThenUp);
				}
			}
		}
		public function moveLeftThenDown(e:Event):void
		{
			charState = "moving";
			
			if (tempCell != nextCell)
			{
				faceDir = "left";
			} else {
				faceDir = "down";
			}
			
			var dx = Math.abs(x - tempCell.x);
			var dy = Math.abs(y - tempCell.y);
			if (dx > 5)
			{
				x += (tempCell.x - x)/moveSpeed;
			}
			else
			{
				x = tempCell.x;
			}
			if (dy > 5)
			{
				y += (tempCell.y - y)/moveSpeed;
			}
			else
			{
				y = tempCell.y;
			}

			if (dx <= 5 && dy <= 5)
			{
				if (tempCell != nextCell)
				{
					tempCell = nextCell;
				}
				else
				{
					nextCellIndex++;
					masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
					curCell = nextCell;
					if (nextCellIndex < _path.length)
					{
						nextCell = _path[nextCellIndex];
						addEventListener(Event.ENTER_FRAME, moveMe);
					}
					else
					{
						masterGame.instance.get_cellGrid()[curCell.get_cellIndex()[0]][curCell.get_cellIndex()[1]].set_inPath(false);
						nextCell = null;
						charState = "idle";
					}
					removeEventListener(Event.ENTER_FRAME, moveLeftThenDown);
				}
			}
		}
		
		
		// alternate movement functions for new input methods
		
		public function alt_MoveUp():void
		{
			if (charState == "moving") return;
			
			if (curCell.get_TCell() != null)
			{
				if (curCell.get_TCell().get_passable() == true)
				{
					addEventListener(Event.ENTER_FRAME, alt_moveStraightUp);
					removeEventListener(Event.ENTER_FRAME, moveMe);
				}
			}
		}
		
		public function alt_MoveDown():void
		{
			if (charState == "moving") return;
			
			if (curCell.get_BCell() != null)
			{
				if (curCell.get_BCell().get_passable() == true)
				{
					addEventListener(Event.ENTER_FRAME, alt_moveStraightDown);
					removeEventListener(Event.ENTER_FRAME, moveMe);
				}
			}
		}
		
		public function alt_MoveLeft():void
		{
			if (charState == "moving") return;
			
			if (curCell.get_LCell() != null)
			{
				if (curCell.get_LCell().get_passable() == true)
				{
					addEventListener(Event.ENTER_FRAME, alt_moveStraightLeft);
					removeEventListener(Event.ENTER_FRAME, moveMe);
				}
			}
		}
		
		public function alt_MoveRight():void
		{
			if (charState == "moving") return;
			
			if (curCell.get_RCell() != null)
			{
				if (curCell.get_RCell().get_passable() == true)
				{
					addEventListener(Event.ENTER_FRAME, alt_moveStraightRight);
					removeEventListener(Event.ENTER_FRAME, moveMe);
				}
			}
		}
		
		private function alt_moveStraightUp(e:Event):void
		{
			charState = "moving";
			faceDir = "up";
			
			var dx = Math.abs(x - curCell.get_TCell().x);
			var dy = Math.abs(y - curCell.get_TCell().y);
			if (dx > 5)
			{
				x += (curCell.get_TCell().x - x)/moveSpeed;
			}
			else
			{
				x = curCell.get_TCell().x;
			}
			if (dy > 5)
			{
				y += (curCell.get_TCell().y - y)/moveSpeed;
			}
			else
			{
				y = curCell.get_TCell().y;
			}

			if (dx <= 5 && dy <= 5)
			{
				curCell = curCell.get_TCell();
				charState = "idle";
				removeEventListener(Event.ENTER_FRAME, alt_moveStraightUp);
			}
		}
		
		private function alt_moveStraightDown(e:Event):void
		{
			charState = "moving";
			faceDir = "down";
			
			var dx = Math.abs(x - curCell.get_BCell().x);
			var dy = Math.abs(y - curCell.get_BCell().y);
			if (dx > 5)
			{
				x += (curCell.get_BCell().x - x)/moveSpeed;
			}
			else
			{
				x = curCell.get_BCell().x;
			}
			if (dy > 5)
			{
				y += (curCell.get_BCell().y - y)/moveSpeed;
			}
			else
			{
				y = curCell.get_BCell().y;
			}

			if (dx <= 5 && dy <= 5)
			{
				curCell = curCell.get_BCell();
				charState = "idle";
				removeEventListener(Event.ENTER_FRAME, alt_moveStraightDown);
			}
		}
		
		private function alt_moveStraightLeft(e:Event):void
		{
			charState = "moving";
			faceDir = "left";
			
			var dx = Math.abs(x - curCell.get_LCell().x);
			var dy = Math.abs(y - curCell.get_LCell().y);
			if (dx > 5)
			{
				x += (curCell.get_LCell().x - x)/moveSpeed;
			}
			else
			{
				x = curCell.get_LCell().x;
			}
			if (dy > 5)
			{
				y += (curCell.get_LCell().y - y)/moveSpeed;
			}
			else
			{
				y = curCell.get_LCell().y;
			}

			if (dx <= 5 && dy <= 5)
			{
				curCell = curCell.get_LCell();
				charState = "idle";
				removeEventListener(Event.ENTER_FRAME, alt_moveStraightLeft);
			}
		}
		
		private function alt_moveStraightRight(e:Event):void
		{
			charState = "moving";
			faceDir = "right";
			
			var dx = Math.abs(x - curCell.get_RCell().x);
			var dy = Math.abs(y - curCell.get_RCell().y);
			if (dx > 5)
			{
				x += (curCell.get_RCell().x - x)/moveSpeed;
			}
			else
			{
				x = curCell.get_RCell().x;
			}
			if (dy > 5)
			{
				y += (curCell.get_RCell().y - y)/moveSpeed;
			}
			else
			{
				y = curCell.get_RCell().y;
			}

			if (dx <= 5 && dy <= 5)
			{
				curCell = curCell.get_RCell();
				charState = "idle";
				removeEventListener(Event.ENTER_FRAME, alt_moveStraightRight);
			}
		}
	}
}