class Grid{
	float xOff;
	float yOff;
	float w;
	float h;

	int columns;
	int rows;
	float cellWidth;
	float cellHeight;
	
	Grid(float xOff, float yOff, float w, float h, int columns, int rows){
		this.xOff = xOff;
		this.yOff = yOff;
		this.w = w;
		this.h = h;

		this.columns = columns;
		this.rows = rows;
		this.cellWidth = w/float(columns);
		this.cellHeight = h/float(rows);
	}

	float cellXOffset(int i){
		return xOff + float(i)*cellWidth;
	}

	float cellYOffset(int j){
		return yOff + float(j)*cellHeight;
	}

	boolean rectangleContains(float x, float y){
		if(withinRange(x, xOff, xOff + w) &&
			 withinRange(y, yOff, yOff + h))
			return true;
		else
			return false;
	}

	int[] cellContaining(float x, float y){
		int[] output = new int[2];

		float xUnitCell = (x - xOff)/cellWidth;
		float yUnitCell = (y - yOff)/cellHeight;
		
		output[0] = int(floor(xUnitCell));
		output[1] = int(floor(yUnitCell));

		return output;
	}

}
