//FUNCS FOR A* ---------------------------------
//----------------------------------------------
//DESCRIPTION:
package com
{
	import com.Tile;
	import com.masterGame;
	
	public class _funcs_pathfinder
	{
		public function _funcs_pathfinder()
		{
			
		}
		
		public function pathFinder(xIni:Number, yIni:Number, xFin:Number, yFin:Number, level:Array)
		{
			var openList:Array = new Array();
			var closeList:Array = new Array();
			//afegim el primer node a la openlist
			var newTile = new Tile(xIni,yIni,0,0,0);
			newTile.parentTile = "none";
			openList.push(newTile);
			//executem per primera vegada la funcio bucle;
			var myLevel:Array = new Array();
			var tempRow:Array;
			for (var i:Number = 0; i < level.length; i++)
			{
				tempRow = new Array();
				for (var j:Number = 0; j < level[i].length;j++)
				{
					if (level[i][j].get_passable() == true)
					{
						tempRow.push(0);
					}
					else if (level[i][j].get_passable() == false)
					{
						tempRow.push(1);
					}
				}
				myLevel.push(tempRow);
				trace(myLevel[i]);
				tempRow.splice();
			}
			//var myLevel = level;
			var camino = searching(xFin,yFin,openList,closeList,myLevel);
			return camino;
		}
		//----------------------------------------------------------------
		public function searching(xFin:Number, yFin:Number, openList:Array, closeList:Array, level:Array)
		{
			if (openList.length == 0)
			{
				//lista buida no shi arriva
				return;
			}
			var tileMenorF = openList[0];
			var switchIndex = 0;
			//comprovem agafem el tile de menor F de la openList  
			for (var a:Number = 0; a<openList.length; a++)
			{
				if (openList[a].F < tileMenorF.F)
				{
					tileMenorF = openList[a];
					switchIndex = a;
				}
				//finalitzaem quan                      
				if (openList[a].xPos == xFin)
				{
					if (openList[a].yPos == yFin)
					{
						//trobem el tile final
						var camino = new Array();
						var tileAct = openList[a];
						camino.push(tileAct);
						while (tileAct.parentTile != "none")
						{
							camino.push(tileAct.parentTile);
							tileAct = tileAct.parentTile;
						}
						return camino;
					}
				}
			}
			//pasem el tile escollit a la closed list
			closeList.push(tileMenorF);
			openList.splice(switchIndex, 1);
			//;
			//unlock to paint tiles of closedList
			//_root.attachMovie("closedTile", "closedTile"+tileMenorF.yPos+"_"+tileMenorF.xPos, _root.getNextHighestDepth());
			//_root["closedTile"+tileMenorF.yPos+"_"+tileMenorF.xPos]._x = tileMenorF.xPos*30;
			//_root["closedTile"+tileMenorF.yPos+"_"+tileMenorF.xPos]._y = tileMenorF.yPos*30;
			//
			//comprovem els 8 tiles adjacents
			for (var i:Number = -1; i<2; i++)
			{
				for (var j:Number = -1; j<2; j++)
				{
					//comprovem ke no agafem el mateix tile [0,0]
					if ((i == 0 && j != 0) || (i != 0 && j == 0))
					//if  (i != 0 || j != 0)
					{
						var xTile:Number = tileMenorF.xPos + j;
						var yTile:Number = tileMenorF.yPos + i;
						//esta een la closed list
						var existCloseList:Boolean = false;
						for (var n:Number = 0; n<closeList.length; n++)
						{
							if (closeList[n].xPos == xTile && closeList[n].yPos == yTile)
							{
								existCloseList = true;
							}
						}
						//es caminable? 
						if (yTile < 0)
						{
							yTile=0;
						}
						if (xTile < 0)
						{
							xTile=0;
						}
						if (yTile > masterGame.instance.get_numRows()-1)
						{
							yTile = masterGame.instance.get_numRows()-1;
						}
						if (xTile > masterGame.instance.get_numCellsInRow())
						{
							xTile = masterGame.instance.get_numCellsInRow()-1;
						}
						//trace(yTile, xTile);
						if (level[yTile][xTile] == 0 && existCloseList == false)
						{
							//creamos el tile temporal para poder ver si existe en la lista abierta
							// G = 10 for tile horiz || vert & 14 for diagonal
							if (Math.abs(i) == 1 && Math.abs(j) == 1)
							{
								var G = tileMenorF.G + 14;
							}
							else
							{
								var G = tileMenorF.G + 10;
							}
							//H = 10*(abs(currentX-targetX) + abs(currentY-targetY)) 
							var H = 10*(Math.abs((xTile-xFin))+Math.abs(yTile-yFin));
							//F = G+H
							var F = G + H;
							var newTile = new Tile(xTile,yTile,G,H,F);
							newTile.parentTile = tileMenorF;
							//comprovem si el tile temporal (newTile) esta a la openList
							var exist:Boolean = false;
							var indexTemp = 0;
							for (var n:Number = 0; n<openList.length; n++)
							{
								if (openList[n].xPos == newTile.xPos && openList[n].yPos == newTile.yPos)
								{
									exist = true;
									indexTemp = n;
								}
							}
							//no esta a la openList (l'afegim)
							if (exist == false)
							{
								openList.push(newTile);
								/*
								//unlock to paint tiles of openList
								_root.attachMovie("tile", "tile"+newTile.yPos+"_"+newTile.xPos, _root.getNextHighestDepth());
								_root["tile"+newTile.yPos+"_"+newTile.xPos]._x = newTile.xPos*30;
								_root["tile"+newTile.yPos+"_"+newTile.xPos]._y = newTile.yPos*30;
								_root["tile"+newTile.yPos+"_"+newTile.xPos].g.text = newTile.G;
								_root["tile"+newTile.yPos+"_"+newTile.xPos].h.text = newTile.H;
								_root["tile"+newTile.yPos+"_"+newTile.xPos].f.text = newTile.F;
								var myArray = _root.returnParentDirection(newTile);
								_root["tile"+newTile.yPos+"_"+newTile.xPos].aguja._x += myArray[0];
								_root["tile"+newTile.yPos+"_"+newTile.xPos].aguja._y += myArray[1];
								*/
							}
							//si esta a la openList...        
							if (exist == true)
							{
								//compare his G
								if (openList[indexTemp].G < tileMenorF.G)
								{
									//recalculem
									if (Math.abs(i) == 1 && Math.abs(j) == 1)
									{
										openList[indexTemp].G = tileMenorF.G + 14;
									}
									else
									{
										openList[indexTemp].G = tileMenorF.G + 10;
									}
									//H = 10*(abs(currentX-targetX) + abs(currentY-targetY)) 
									openList[indexTemp].H = 10*(Math.abs((xTile-xFin))+Math.abs(yTile-yFin));
									//F = G+H
									openList[indexTemp].F = openList[indexTemp].G + openList[indexTemp].H;
									openList[indexTemp].parentTile = tileMenorF;
								}
							}
						}
					}
				}
			}
			//launch the functioin again as recursive
			return searching(xFin, yFin, openList, closeList, level);
		}
		//----------------------------------------------------------------
		//Descripction: returns an array with relative parent direction (x,y based) about tileObj
		public function returnParentDirection(tileObj)
		{
			var posArray:Array = [0,0];
			var xpos = tileObj.xPos - tileObj.parentTile.xPos;
			var ypos = tileObj.yPos - tileObj.parentTile.yPos;
			posArray[0] = xpos * -10;
			posArray[1] = ypos * -10;
			return posArray;
		}
	}
}