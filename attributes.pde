//class that stores attributes in array & limits for each
final int X = 0;
final int Y = 1;
final int SCALE_X = 2;
final int SCALE_Y = 3;
final int ROTATION = 4;
final int ALPHA = 5;
final int H = 6;
final int S = 7;
final int B = 8;
final int PATH_OFFSET = 9;
final int TOTAL_ATTRIBUTES = 10;

class Attributes{
	float[] attributes;
	float[] minima;
	float[] maxima;

	float[] mutationFactors;
	boolean lockXY;

	boolean[] active;
	
	Attributes(){
		this.attributes = new float[TOTAL_ATTRIBUTES];
		this.minima = new float[TOTAL_ATTRIBUTES];
		this.maxima = new float[TOTAL_ATTRIBUTES];
		this.mutationFactors = new float[TOTAL_ATTRIBUTES];

		this.lockXY = false;
		this.active = new boolean[TOTAL_ATTRIBUTES];
		for(boolean currentActive: active){
			currentActive = true;
		}
	}
	
	void setAttributes(float[] attributes){
		if(attributes.length == TOTAL_ATTRIBUTES){
			this.attributes = attributes;
		}
		else{
			System.out.println("Incorrect number of arguments given.");
		}
	}

	void setAttributesFromEnvelope(EnvelopeMatrix envelopeMatrix,
																 float spreadParameter,
																 float time,
																 int index){
		for(int i = 0; i < TOTAL_ATTRIBUTES; i++){
			float spreadEvaluate = envelopeMatrix.evaluate(SPREAD, i, spreadParameter);
			float timeEvaluate = envelopeMatrix.evaluate(TIME, i, time);
			//float indexEvaluate = envelopeMatrix.evaluate(INDEX, i, index);

			//combine parameters according to type
			//TODO add extra option to choose between multiply & add for given
			//parameter

			float combinedEvaluate;

			if(!(i == ROTATION || i == X || i == Y || i == H))
				combinedEvaluate = timeEvaluate*spreadEvaluate;
			else
				combinedEvaluate = timeEvaluate + spreadEvaluate;
				//spreadEvaluate*timeEvaluate*indexEvaluate;

			this.attributes[i] = minima[i] + (maxima[i] - minima[i])*combinedEvaluate;
		}
	}

	void setMinima(float[] minima){
		if(minima.length == TOTAL_ATTRIBUTES){
			this.minima = minima;
		}
		else{
			System.out.println("Incorrect number of arguments given.");
		}
	}

	void setMaxima(float[] maxima){
		if(maxima.length == TOTAL_ATTRIBUTES){
			this.maxima = maxima;
		}
		else{
			System.out.println("Incorrect number of arguments given.");
		}
	}

	void setMutationFactors(float[] mutationFactors){
		if(mutationFactors.length == TOTAL_ATTRIBUTES){
			this.mutationFactors = mutationFactors;
		}
		else{
			System.out.println("Incorrect number of arguments given.");
		}
	}

	void setActive(boolean[] newActive){
		for(int i = 0; i < TOTAL_ATTRIBUTES; i++){
			this.active[i] = newActive[i];
		}
	}

	float get(int i){
		return attributes[i];
	}

	//associate each attribute with an RMatrix to apply
	RMatrix getMatrix(int i){
		RMatrix output = new RMatrix();

		switch(i){
		case X:
			output.translate(this.get(X), 0);
			break;	
		case Y:
			output.translate(0, this.get(Y));
			break;
		case SCALE_X:
			output.scale(this.get(SCALE_X), 1);
			break;
		case SCALE_Y:
			output.scale(1, this.get(SCALE_Y));
			break;
		case ROTATION:
			output.rotate(this.get(ROTATION));
			break;
		}

		return output;
	}

	float getColorAttribute(int i){
		switch(i){
		case ALPHA:
			return this.get(ALPHA);
		case H:
			return this.get(H);
		case S:
			return this.get(S);
		case B:
			return this.get(B);
		default:
			System.out.println("Not a color attribute.");
			return 0;
		}
	}

	//randomize to new attributes within limits
	void randomize(){
		for(int i = 0; i < TOTAL_ATTRIBUTES; i++){
			attributes[i] = random(minima[i], maxima[i]);
		}
	}

	void mutate(){
		float XYMutation = 0;
		if(lockXY) XYMutation = round(random(-1, 1)) * mutationFactors[SCALE_X];
		
		for(int i = 0; i < TOTAL_ATTRIBUTES; i++){
			/*
			attributes[i] += random(-mutationFactors[i],
															mutationFactors[i]);
			*/

			//System.out.println("lockXY = " + lockXY);
			
			if(!lockXY){
				attributes[i] += round(random(-1, 1)) * mutationFactors[i];
			}
			else if(lockXY  &&
				 !(i == SCALE_X || i == SCALE_Y)){
				attributes[i] += round(random(-1, 1)) * mutationFactors[i];
			}
			else{
				attributes[i] += XYMutation;
				System.out.println("Attribute " + i + " = " + attributes[i]);
			}
			
			if(attributes[i] < minima[i]){
				attributes[i] = minima[i];
			}
			else if(attributes[i] > maxima[i]){
				attributes[i] = maxima[i];
			}
		}
	}

	void lockXY(){
		lockXY = true;
	}

	void unlockXY(){
		lockXY = false;
	}

	void print(){
		for(int i = 0; i < TOTAL_ATTRIBUTES; i++){
			System.out.println(i + ": value = " + attributes[i] +
												 ", minimum = " + minima[i] +
												 ", maximum = " + maxima[i]);
		}
	}

	/*
	Attributes lerp(Attributes a, Attributes b, float parameter){
		float lerpedAttributes = new float[TOTAL_ATTRIBUTES];
		for(int i = 0; i < TOTAL_ATTRIBUTES; i++){
			lerpedAttributes[i] = lerp(a.attributes[i], , parameter);
		}
	}
	*/
}
