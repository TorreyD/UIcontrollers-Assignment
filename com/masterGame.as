package com
{
	import pl.mateuszmackowiak.nativeANE.alert.NativeAlert;
	import pl.mateuszmackowiak.nativeANE.NativeDialogEvent;
	import pl.mateuszmackowiak.nativeANE.toast.Toast;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import com.Cell;
	import com.touchPad;
	import com.PlayerMC;
	import com._funcs_pathfinder;
	//import com.PathFinder;

	import flash.geom.Point;

	public class masterGame extends MovieClip
	{

		private var Cells:Array = new Array();

		private var numRows:Number = 0;
		private var numCellsInRow:Number = 0;
		private var pf;

		private var maxObstacles:Number = 20;
		private var minObstacles:Number = 10;

		public static var instance;
		
		private var inputStyle:int = 0; // 0 - Point and Click, 1 - Directional Input, 2 - Swipe to Move

		public function masterGame()
		{
			//MovieClip(MovieClip(this.getChildByName("optMenu")).getChildByName("optBTN")).addEventListener(MouseEvent.MOUSE_DOWN, onOptBTN_pressed);
			//MovieClip(MovieClip(this.getChildByName("optMenu")).getChildByName("credBTN")).addEventListener(MouseEvent.MOUSE_DOWN, onCredBTN_pressed);

			instance = this;
			pf = new _funcs_pathfinder();
			trace("Screen Width: " + stage.fullScreenWidth);
			trace("Screen Height: " + stage.fullScreenHeight);

			//numRows = Math.ceil((stage.fullScreenHeight-150) / 32);
			//numCellsInRow = Math.ceil(stage.fullScreenWidth / 32);
			
			numRows = Math.ceil((800-150) / 32);
			numCellsInRow = Math.ceil(480 / 32);

			trace("\nNumber of Rows: " + numRows);
			trace("Number of cells in each row: " + numCellsInRow);

			this.addEventListener(Event.ENTER_FRAME, initializeCells);
		}

		public function AddObstacles():void
		{
			addRandomObstacles();
		}

		public function showCredits():void
		{
			NativeAlert.show("Torrey Daniel, MGMS | UDD_O, 7/21/2014", "Made By");
		}

		public function onScreenClick(destCell:MovieClip):void
		{
			for (var i:Number = 0; i<numRows; i++)
			{
				for (var j:Number = 0; j<numCellsInRow; j++)
				{
					Cells[i][j].set_inPath(false);
				}
			}

			var _path:Array = pf.pathFinder(PlayerMC.instance.get_curCell().get_cellIndex()[1],
			   PlayerMC.instance.get_curCell().get_cellIndex()[0],
			   destCell.get_cellIndex()[1],
			   destCell.get_cellIndex()[0],
			   Cells);

			trace(_path);

			var charPath:Array = new Array();
			for (var k:int = 0; k < _path.length; k++)
			{
				Cells[_path[k].yPos][_path[k].xPos].set_inPath(true);
				charPath.push(Cells[_path[k].yPos][_path[k].xPos]);
			}

			MovieClip(this.getChildByName("player")).beginMoving(charPath);
		}

		public function get_cellGrid():Array
		{
			return Cells;
		}

		public function get_numRows():Number
		{
			return numRows;
		}

		public function get_numCellsInRow():Number
		{
			return numCellsInRow;
		}

		private function get_cellCoordinates(cell:MovieClip):Point
		{
			var pt:Point = new Point(cell.x,cell.y);
			return pt;
		}

		private function get_cellIndex(cell:MovieClip)
		{
			var cellIndex:Array = new Array(0,0);

			trace(cell.get_cellIndex());
		}

		private function addRandomObstacles():void
		{
			var numObstacles:Number =  Math.floor(Math.random() * (maxObstacles - minObstacles + minObstacles)) + minObstacles;
			resetCells();
			if (PlayerMC.charState == "idle")
			{
				for (var i:Number = 0; i < Math.ceil(numRows/2); i++)
				{
					for (var j:Number = 0; j < Math.ceil(numCellsInRow); j++)
					{
						if (i != Math.ceil((numRows / 2)) &&
							i != Math.ceil((numRows / 2))-1 &&
							i != Math.ceil((numRows / 2))+1)
						{
							if (numObstacles > 0)
							{
								var temp:Number = Math.floor(Math.random() * (100 - 1 + 1)) + 1;
								if (temp > 35 && temp < 41 && Cells[i][j].get_passable() == true && PlayerMC.instance.get_curCell() != Cells[i][j])
								{
									Cells[i][j].set_passable(false);
									numObstacles--;
									if (numObstacles <= 0)
									{
										return;
									}
								}
							} else {
								return;
							}
						}
					}
				}
				
				//
				for (var i:Number = numRows-1; i > Math.ceil(numRows/2); i--)
				{
					for (var j:Number = numCellsInRow-1; j > 0; j--)
					{
						if (i != Math.ceil((numRows / 2)) &&
							i != Math.ceil((numRows / 2))-1 &&
							i != Math.ceil((numRows / 2))+1)
						{
							if (numObstacles > 0)
							{
								var temp:Number = Math.floor(Math.random() * (100 - 1 + 1)) + 1;
								if (temp > 30 && temp < 41 && Cells[i][j].get_passable() == true && PlayerMC.instance.get_curCell() != Cells[i][j])
								{
									Cells[i][j].set_passable(false);
									numObstacles--;
									if (numObstacles <= 0)
									{
										return;
									}
								}
							} else {
								return;
							}
						}
					}
				}
			}
		}
		
		private function pickARandomCellRow(numRows):void
		{
			var cellRow:Number;
			
			var cellRow:Number = Math.floor(Math.random() * (numRows-1 - 0 + 0)) + 0;
			if (cellRow != Math.ceil((numRows / 2)) &&
				cellRow != Math.ceil((numRows / 2))-1 &&
				cellRow != Math.ceil((numRows / 2))+1)
			{
				//return cellRow;
			}
		}

		private function resetCells():void
		{
			if (PlayerMC.charState == "idle")
			{
				for (var i:Number = 0; i < numRows; i++)
				{
					for (var j:Number = 0; j < numCellsInRow; j++)
					{
						if (i != Math.ceil((numRows / 2)))
						{
							Cells[i][j].set_passable(true);
						}
					}
				}
			}
		}

		private function initializeCells(e:Event):void
		{
			// create the cells
			for (var i:Number = 0; i<numRows; i++)
			{
				var rowOfCells = new Array();
				for (var j:Number = 0; j<numCellsInRow; j++)
				{
					var cell:MovieClip = new Cell((32*j)+16, ((32*i)+16)+75, i, j);
					rowOfCells.push(cell);
				}
				Cells.push(rowOfCells);
				rowOfCells.splice();
			}

			// assign the "neighbors" to the cells
			for (var k:Number = 0; k<numRows; k++)
			{
				for (var l:Number = 0; l<numCellsInRow; l++)
				{
					if (k == 0)
					{
						if (l == 0)
						{
							// the first cell of the first row
							Cells[k][l].setCells(null, Cells[k][l+1], null, Cells[k+1][l]);
						}
						else if (l == (numCellsInRow-1))
						{
							// the last cell of the first row
							Cells[k][l].setCells(Cells[k][l-1], null, null, Cells[k+1][l]);
						}
						else
						{
							Cells[k][l].setCells(Cells[k][l-1], Cells[k][l+1], null, Cells[k+1][l]);
						}
					}
					else if (k == (numRows-1))
					{
						if (l == 0)
						{
							// the first cell of the last row
							Cells[k][l].setCells(null, Cells[k][l+1], Cells[k-1][l], null);
						}
						else if (l == (numCellsInRow-1))
						{
							// the last cell of the last row
							Cells[k][l].setCells(Cells[k][l-1], null, Cells[k-1][l], null);
						}
						else
						{
							Cells[k][l].setCells(Cells[k][l-1], Cells[k][l+1], Cells[k-1][l], null);
						}
					}
					else
					{
						Cells[k][l].setCells(Cells[k][l-1], Cells[k][l+1], Cells[k-1][l], Cells[k+1][l]);
					}
					this.addChild(Cells[k][l]);
				}
			}

			// make middle row of blocked cells
			for (var m:Number = 1; m < numCellsInRow-1; m++)
			{
				Cells[Math.ceil((numRows / 2))][m].set_passable(false);
			}

			var pl:MovieClip = new PlayerMC(numRows,numCellsInRow);
			pl.name = "player";
			this.addChild(pl);

			var hud:MovieClip = new HUD_MC();
			hud.name = "hud";
			//hud.x = stage.fullScreenWidth / 2;
			//hud.y = stage.fullScreenHeight / 2;
			this.addChild(hud);
			//var tp:MovieClip = new touchPad(stage.fullScreenWidth, stage.fullScreenHeight);
			//this.addChild(tp);

			this.removeEventListener(Event.ENTER_FRAME, initializeCells);
		}
		
		public function set InputStyle(val:int):void { inputStyle = val; }
		public function get InputStyle():int { return inputStyle; }
	}
}