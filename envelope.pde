class Point{
	float x;
	float y;

	Point(float x, float y){
		this.x = x;
		this.y = y;
	}

	void clipX(float min, float max){
		if(x < min) x = min;
		if(x > max) x = max;
	}

	void clipY(float min, float max){
		if(y < min) y = min;
		if(y > max) y = max;
	}
	
	void print(){
		System.out.printf("(%.3f, %.3f)\n", x, y);
	}
}

Point lerpPoint(Point a, Point b, float parameter){
	float x = lerp(a.x, b.x, parameter);
	float y = lerp(a.y, b.y, parameter);

	return new Point(x, y);
}

class Envelope{
	ArrayList<Point> points = new ArrayList<Point>();

	float[] precalculatedValues;

	//create new envelope with points at x = 0 and x = 1
	//& linear function
	Envelope(){
		points.add(new Point(0, 0));
		points.add(new Point(1, 1));
	}

	void addPoint(Point newPoint){
		//must insert points in right order - ie new point goes
		//between points with closest x-values
		//point will not be added if x is same as any existing point

		//need to do this as arraylist size changes leading to
		//infinite loop
		int currentPointsSize = points.size() - 1;

		for(int i = 0; i < currentPointsSize; i++){
			if(withinRange(newPoint.x, points.get(i).x, points.get(i + 1).x)){
				newPoint.clipY(0.0f, 1.0f);
				points.add(i + 1, newPoint);
			}
		}
	}

	void movePointX(int index, float xNew){
		//limit x-movement of endpoints
		//disallow movement of endpoints
	}

	void movePointY(int i, float yNew){
		if(withinRange(yNew, 0, 1))
			points.get(i).y = yNew;
	}

	float evaluate(float globalParameter){
		if(!withinRange(globalParameter, 0.0f, 1.0f)){
			System.out.println("Parameter out of bounds.");
			return 0;
		}
		
		int segmentIndex = 0;

		for(int i = 0; i < points.size() - 1; i++){
			if(withinRange(globalParameter, points.get(i).x, points.get(i + 1).x))
				segmentIndex = i;
		}

		Point p0 = points.get(segmentIndex);
		Point p1 = points.get(segmentIndex + 1);
		float localParameter = (globalParameter - p0.x)/(p1.x - p0.x);

		Point lerpPoint = lerpPoint(p0, p1, localParameter);
		return lerpPoint.y;
	}

	float evaluateFraction(int numerator, int denominator){
		float fraction = float(numerator)/float(denominator);
		return this.evaluate(fraction);
	}

	void createValueArray(int numberOfValues){

	}

	/*
	float[] getValueArray(){

	}
	*/

	//TODO display/UI methods: drag points, etc.

	void print(){
		System.out.println("Points:");
		for(int i = 0; i < points.size(); i++){
			points.get(i).print();
		}
	}

	void draw(float xOff, float yOff, float w, float h){
		ArrayList<Point> scaledPoints = scalePointsToBox(xOff, yOff, w, h);

		noFill();
		rect(xOff, yOff, w, h);

		for(int i = 0; i < scaledPoints.size() - 1; i++){
			line(scaledPoints.get(i).x,	scaledPoints.get(i).y,
					 scaledPoints.get(i + 1).x, scaledPoints.get(i + 1).y);
		}
	}

	ArrayList<Point> scalePointsToBox(float xOff, float yOff, float w, float h){
		ArrayList<Point> output = new ArrayList<Point>();

		for(int i = 0; i < points.size(); i++){
			float xScaled = xOff + w * points.get(i).x;
			float yScaled = yOff + h * (1 - points.get(i).y);
			output.add(new Point(xScaled, yScaled));
		}
		
		return output;
	}
}

/*
class DiscreteEnvelope{
int numberOfVertices;

@Override
//override setting functions: round to integer values

}
*/

boolean withinRange(float value, float min, float max){
	if(value >= min && value <= max) return true;
	else return false;
}

Envelope createPresetEnvelope(Lambda lambda, int evaluationPoints){
	Envelope output = new Envelope();
	float[] x = spread(evaluationPoints);
		
	//change start & end values
	output.movePointY(0, lambda.evaluate(x[0]));
	output.movePointY(1, lambda.evaluate(x[evaluationPoints - 1]));

	System.out.println("");

	//fill in intermediate values
	for(int i = 1; i < evaluationPoints - 1; i++){
		output.addPoint(new Point(x[i], lambda.evaluate(x[i])));
	}

	return output;
}

float[] spread(int spreadNumber){
	float d = 1.0f/float(spreadNumber);
	float[] values = new float[spreadNumber];

	for(int i = 0; i < spreadNumber; i++){
		values[i] = float(i)*d;
	}

	return values;
}
