class Spread{
	RGroup spread;
	RGroup path;

	int spreadNumber;
	float[] spreadParameters;

	SpreadParticle spreadParticle;

	Spread(SpreadParticle spreadParticle, RGroup path, int spreadNumber){
		this.spreadParticle = spreadParticle;
		this.path = path;

		this.spreadNumber = spreadNumber;
		this.spreadParameters = spread(spreadNumber);
	}

	RGroup getSpread(){
		return spread;
	}

	void addSpreadParticles(EnvelopeMatrix envelopeMatrix){
		this.spread = new RGroup();
		int elements = path.countElements();
		
		for(int i = 0; i < elements; i++){
			RGroup spreadElement = new RGroup();
			RShape pathElement = path.elements[i].toShape();

			for(int j = 0; j < spreadNumber; j++){
				addSpreadParticle(spreadElement, pathElement,
													spreadParameters[j], j,
													envelopeMatrix);
			}

			spread.addElement(spreadElement);
		}		
	}

	void addSpreadParticle(RGroup spreadElement,
												 RShape pathElement,
												 float spreadParameter,
												 int particleIndex,
											   EnvelopeMatrix envelopeMatrix){
		//create local copy
		RShape localShape = new RShape(spreadParticle.particle.toShape());
		//could pre-apply in addSpreadParticles?
		localShape.scale(GLOBAL_SCALE);

		//Set attributes & transform
		spreadParticle.setAttributesFromEnvelope(envelopeMatrix,
																						 spreadParameter,
																						 globalTime,
																						 particleIndex);
		localShape.transform(attributesToMatrix(spreadParticle.attributes));
		//Adjust spread parameter using attributes
		spreadParameter += spreadParticle.getAttribute(PATH_OFFSET);
		//loop back around if parameter > 1
		if(spreadParameter >= 1.0f)
			spreadParameter = spreadParameter % 1.0f;

		int alpha = alphaToInteger(spreadParticle.getAttribute(ALPHA));
		int fill = HSBToInteger(spreadParticle.getAttributes());
			
		localShape.setStroke(false);
		localShape.setAlpha(alpha);
		localShape.setFill(fill);
			
		//transform along path
		RPoint currentPoint = pathElement.getPoint(spreadParameter);
		RPoint currentTangent = calculateTangent(pathElement,
																						 spreadParameter);
		RMatrix transformation =
			createTransformationMatrix(currentPoint, currentTangent);
		localShape.transform(transformation);

		spreadElement.addElement(localShape);
	}

	RMatrix createTransformationMatrix(RPoint point, RPoint tangent){
		RMatrix output = new RMatrix();

		RMatrix rotation = createRotationMatrix(tangent);
		RMatrix translation = createTranslationMatrix(point);

		output.apply(translation);
		output.apply(rotation);
			

		return output;
	}

	RPoint calculateTangent(RShape shape, float t){
		float d = 0.01;
		RPoint a = shape.getPoint(t);
		RPoint b = shape.getPoint((t + d*t)%1.0f); //assuming closed shape
		RPoint output = new RPoint(b.x - a.x, b.y - a.y);
		return output;
	}

	RMatrix createRotationMatrix(RPoint tangent){
		RMatrix output = new RMatrix();
		float theta = atan2(tangent.y, tangent.x);
		//System.out.println("Atan2 = " + theta);
		output.rotate(theta);
		return output;
	}

	RMatrix createTranslationMatrix(RPoint point){
		RMatrix output = new RMatrix();
		output.translate(point.x, point.y);
		return output;
	}

	int alphaToInteger(float alpha){
		return int(round(255*alpha));
	}

	int HSBToInteger(Attributes attributes){
		/*
			int hue = 255*int(round(attributes.get(H)));
			int sat = 255*int(round(attributes.get(S)));
			int bright = 255*int(round(attributes.get(B)));
		*/
			
		//int HSB = (hue << 16 | sat << 8 | bright);
			
		int RGB = Color.HSBtoRGB(attributes.get(H),
														 attributes.get(S),
														 attributes.get(B));
			
		return RGB;
	}

	float[] spread(int spreadNumber){
		float d = 1.0f/float(spreadNumber);
		float[] values = new float[spreadNumber];

		for(int i = 0; i < spreadNumber; i++){
			values[i] = float(i)*d;
		}

		return values;
	}

	float sumOf(float[] values){
		float sum = 0;
			
		for(int i = 0; i < values.length; i++){
			sum += values[i];
		}

		return sum;
	}

	//Local copy of function in scenegraph
	RMatrix attributesToMatrix(Attributes attributes){
		RMatrix output = new RMatrix();

		output.apply(attributes.getMatrix(ROTATION));
		output.apply(attributes.getMatrix(SCALE_X));
		output.apply(attributes.getMatrix(SCALE_Y));
		
		output.apply(attributes.getMatrix(X));
		output.apply(attributes.getMatrix(Y));

		return output;
	}
}

class SpreadParticle{
	Attributes attributes;
	RGroup particle;

	SpreadParticle(RGroup particle){
		this.particle = particle;
		this.attributes = createNewAttributes();
	}

	RGroup getParticle(){
		return particle;
	}

	RShape getShape(){
		return new RShape(particle.toShape());
	}

	Attributes getAttributes(){
		return attributes;
	}

	float getAttribute(int i){
		return attributes.get(i);
	}

	void setAttributesFromEnvelope(EnvelopeMatrix envelopeMatrix,
																 float spreadParameter,
																 float time,
																 int index){
		attributes.setAttributesFromEnvelope(envelopeMatrix,
																				 spreadParameter,
																				 time,
																				 index);
	}

	Attributes createNewAttributes(){
		float[] attributeArray = {0, 0, 1, 1, 0, 255, 255, 255, 255, 1};
		float[] maximaArray = {200, 200, 1, 1, 2*PI, 1, 1, 1, 1, 1};
		float[] minimaArray = {-200, -200, -1, -1, 0, 0, 0, 0, 0, 0};
		float[] mutationFactors = {200, 200, 1, 1, PI, 1, 1, 1, 1, 1};
		
		Attributes attributes = new Attributes();
		attributes.setAttributes(attributeArray);
		attributes.setMaxima(maximaArray);
		attributes.setMinima(minimaArray);
		attributes.setMutationFactors(mutationFactors);

		return attributes;
	}
}