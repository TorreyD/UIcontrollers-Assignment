//Declaración de la clase
package com
{
	public class Tile
	{
		var xPos:Number = 0;
		var yPos:Number = 0;
		var G:Number = 0;
		var H:Number = 0;
		var F:Number = 0;
		var parentTile = "none";
		//---------------------------------------------------------
		public function Tile(myxpos, myypos, myG, myH, myF)
		{
			this.xPos = myxpos;
			this.yPos = myypos;
			this.G = myG;
			this.H = myH;
			this.F = myF;
		}
	}
}