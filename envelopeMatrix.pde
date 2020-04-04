final int SPREAD = 0;
final int TIME = 1;
final int INDEX = 2;
final int TOTAL_PARAMETERS = 3;

class EnvelopeMatrix{
	ArrayList<Envelope> envelopes;
	//stores references to envelopes in list
	int[][] matrix;
	
	Grid containingGrid;

	//use to identify which parameter is receiving live signal
	//instead of envelope
	int[] liveAttributes;

	EnvelopeMatrix(ArrayList<Envelope> envelopes){
		float[] defaultConstants = {0, 0, 1, 1, 0, 1, 0, 1, 1};

		this.envelopes = envelopes;
		matrix = new int[TOTAL_PARAMETERS][TOTAL_ATTRIBUTES];

		for(int i = 0; i < TOTAL_PARAMETERS; i++){
			for(int j = 0; j < TOTAL_ATTRIBUTES; j++){
				//	envelopes[i][j] = createPresetFunction(new Constant(defaultConstants[i],
				//  10));
				matrix[i][j] = 0;
			}
		}
	}

	void setEnvelope(int i, int j, int envelopeIndex){
		if(envelopeIndex < envelopes.size())
			matrix[i][j] = envelopeIndex;
		else
			matrix[i][j] = 0;
	}

	void nextEnvelope(int i, int j){
		matrix[i][j]++;
		if(matrix[i][j] >= envelopes.size())
			matrix[i][j] = 0;
	}

	void previousEnvelope(int i, int j){
		matrix[i][j]--;
		if(matrix[i][j] < 0)
			matrix[i][j] = envelopes.size() - 1;
	}

	Envelope getEnvelope(int i, int j){
		return envelopes.get(matrix[i][j]);
	}

	float evaluate(int i, int j, float x){
		return envelopes.get(matrix[i][j]).evaluate(x);
	}

	void setContainingGrid(float xOff, float yOff, float w, float h){
		this.containingGrid = new Grid(xOff, yOff, w, h,
																	 TOTAL_PARAMETERS, TOTAL_ATTRIBUTES);
	}

	void draw(){
		String[] parameterLabels = {"SPREAD", "TIME", "INDEX"};
		String[] attributeLabels = {"X", "Y", "SCALE_X", "SCALE_Y",
																"ROTATE", "ALPHA", "HUE", "SAT",
																"BRIGHT", "PATH"};
		
		//write labels
		for(int i = 0; i < TOTAL_PARAMETERS; i++){
			float x = containingGrid.cellXOffset(i);
			float y = containingGrid.cellYOffset(0);
			fill(255);
			text(parameterLabels[i], x, y);
		}

		for(int j = 0; j < TOTAL_ATTRIBUTES; j++){
			float x = containingGrid.cellXOffset(0);
			float y = containingGrid.cellYOffset(j);
			fill(255);

			pushMatrix();
			translate(x, y);
			text(attributeLabels[j], -50, 20);
			popMatrix();
		}
		
		for(int i = 0; i < TOTAL_PARAMETERS; i++){
			for(int j = 0; j < TOTAL_ATTRIBUTES; j++){
				float xOff = containingGrid.cellXOffset(i);
				float yOff = containingGrid.cellYOffset(j);
				float cellWidth = containingGrid.cellWidth;
				float cellHeight = containingGrid.cellHeight;
				
				envelopes.get(matrix[i][j]).draw(xOff, yOff, cellWidth, cellHeight);

        if(matrix[i][j] == 0){
          pushMatrix();
          translate(xOff, yOff);
          text("1.0", 0, cellHeight);
          popMatrix();
        }

				if(matrix[i][j] == 1){
					pushMatrix();
					translate(xOff, yOff);
					text("0.5", 0, cellHeight);
					popMatrix();
				}

				if(matrix[i][j] == 2){
					pushMatrix();
					translate(xOff, yOff);
					text("ZERO", 0, cellHeight);
					popMatrix();
				}
			}
		}
	}

}