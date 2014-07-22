package com
{
	import flash.display.MovieClip;

	public class PathFinder
	{
		//types of map elements
		public static var MAP_WALL:String = "X";
		public static var MAP_OPEN_SPACE:String = "_";
		public static var MAP_START:String = "S";
		public static var MAP_FINISH:String = "0";

		public static var _map:Array, _queue:Array;

		public function PathFinder()
		{

		}

		public function DrawMap(_cellGrid:Array, Start:MovieClip, Finish:MovieClip):Array
		{
			var tempMap:Array = new Array();

			for (var i:int = 0; i < _cellGrid.length; i++)
			{
				var tempMapRow:Array = new Array();
				for (var j:int = 0; j < _cellGrid[0].length; j++)
				{
					if (_cellGrid[i][j] == Start)
					{
						tempMapRow.push("S");
					}
					else if (_cellGrid[i][j] == Finish)
					{
						tempMapRow.push("0");
					}
					else if (_cellGrid[i][j].get_passable() == true)
					{
						tempMapRow.push("_");
					}
					else if (_cellGrid[i][j].get_passable() == false)
					{
						tempMapRow.push("X");
					}
				}
				tempMap.push(tempMapRow);
				tempMapRow.splice();
			}

			return _map;
		}

		public static function findPath(newMap:Array, Start:MovieClip, Finish:MovieClip):Array
		{
			// draw a new map
			var tempMap:Array = new Array();

			for (var i:int = 0; i < newMap.length; i++)
			{
				var tempMapRow:Array = new Array();
				for (var j:int = 0; j < newMap[0].length; j++)
				{
					if (newMap[i][j] == Start)
					{
						tempMapRow.push("S");
					}
					else if (newMap[i][j] == Finish)
					{
						tempMapRow.push("0");
					}
					else if (newMap[i][j].get_passable() == true)
					{
						tempMapRow.push("_");
					}
					else if (newMap[i][j].get_passable() == false)
					{
						tempMapRow.push("X");
					}
				}
				tempMap.push(tempMapRow);
				tempMapRow.splice();
			}
			////////////////////////////////////////////////////
			var i:int,j:int;
			_queue = new Array();
			_map = tempMap;

			//first find the coordinate of finish which is a first object
			var finishObject:Object;
			var counter:int = 0;

			for (i = 0; i < _map.length; i++)
			{
				for (j = 0; j < _map[i].length; j++)
				{
					if (_map[i][j] == MAP_FINISH)
					{
						finishObject = {i:i,j:j,counter:0};
						break;
					}
				}
			}
			_queue.push(finishObject);

			//run recursive function to find the shortest path
			checkQueue(0, 1);

			trace(_queue);
			return _queue;
		}

		private static function checkQueue(startIndex:int, counter:int):void
		{
			var lastQueueLength:int = _queue.length;
			var i:int;

			//check neigbours of the _queue element
			for (i = startIndex; i < lastQueueLength; i++)
			{
				var coordinate:Object;
				//check top
				if (_queue[i].j != 0 && _map[_queue[i].i][_queue[i].j - 1] != MAP_WALL)
				{
					coordinate = {i:_queue[i].i,j:_queue[i].j - 1,counter:counter};
					//if this coordinate is the start finish algorothm as 
					//the shortest path was just found
					if (_map[coordinate.i][coordinate.j] == MAP_START)
					{
						return;
					}//if a coordinate already exists in the queue 
					//and has higher coordinate it won't be added
					//but if it has lower coordinate it will replace the one in the queue
					if (canBeAddedToQueue(coordinate))
					{
						_queue.push(coordinate);
					}
				}
				//check right
				if (_queue[i].i != _map.length - 1 && 
				                        _map[_queue[i].i + 1][_queue[i].j] != MAP_WALL)
				{
					coordinate = {i:_queue[i].i + 1,j:_queue[i].j,counter:counter};
					if (_map[coordinate.i][coordinate.j] == MAP_START)
					{
						return;
					}
					if (canBeAddedToQueue(coordinate))
					{
						_queue.push(coordinate);
					}
				}
				//check bottom
				if (_queue[i].j != _map[_queue[i].i].length - 1 && 
				                           _map[_queue[i].i][_queue[i].j + 1] != MAP_WALL)
				{
					coordinate = {i:_queue[i].i,j:_queue[i].j + 1,counter:counter};
					if (_map[coordinate.i][coordinate.j] == MAP_START)
					{
						return;
					}
					if (canBeAddedToQueue(coordinate))
					{
						_queue.push(coordinate);
					}
				}
				//check left
				if (_queue[i].i != 0 && _map[_queue[i].i - 1][_queue[i].j] != MAP_WALL)
				{
					coordinate = {i:_queue[i].i - 1,j:_queue[i].j,counter:counter};
					if (_map[coordinate.i][coordinate.j] == MAP_START)
					{
						return;
					}
					if (canBeAddedToQueue(coordinate))
					{
						_queue.push(coordinate);
					}
				}
			}

			checkQueue(lastQueueLength, counter + 1);
		}

		public static function canBeAddedToQueue(coordinate:Object):Boolean
		{
			for (var i:int = _queue.length - 1; i >= 0; i--)
			{
				if (coordinate.i == _queue[i].i && coordinate.j == _queue[i].j)
				{
					if (coordinate.counter >= _queue[i].counter)
					{
						return false;
					}
					else
					{
						_queue.splice(i, 1);
						return true;
					}
				}
			}
			return true;
		}
	}
}