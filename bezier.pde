//bezier surface
public final int N = 4;

//factory method for arrays of controlPoints
ControlPoint[][] rectanglePatch(float xOffset, float yOffset,
																float width, float height){
	ControlPoint[][] outputPoints = new ControlPoint[N][N];
	for(int i = 0; i < N; i++){
		for(int j = 0; j < N; j++){
			float x = xOffset + float(i)*width/(N-1);
			float y = yOffset + float(j)*height/(N-1);
			outputPoints[i][j] = new ControlPoint(x, y);
		}
	}

	return outputPoints;
}

void lineVector(RPoint p0, RPoint p1){
	line(p0.x, p0.y, p1.x, p1.y);
}

RPoint lerpVector(RPoint a, RPoint b, float parameter){
	float x = lerp(a.x, b.x, parameter);
	float y = lerp(a.y, b.y, parameter);
	return new RPoint(x, y);
}

RPoint lerpPoint(RPoint a, RPoint b, float parameter){
	float x = lerp(a.x, b.x, parameter);
	float y = lerp(a.y, b.y, parameter);
	return new RPoint(x, y);
}

int factorial(int n){
	if(n == 0){
		return 1;
	}
	else return n*factorial(n - 1);
}

int binomial(int n, int r){
	return factorial(n)/(factorial(n - r)*factorial(r));
}

float bernsteinPolynomial(int m, int i, float u){
	return binomial(m, i)*pow(u, i)*pow(1-u, m-i);
}

//factory method
//BezierPatch newRandomSurface(){}

class BezierPatch{
	ControlPoint[][] controlPoints;

	BezierPatch(ControlPoint[][] controlPoints){
		this.controlPoints = controlPoints;
	}

	RPoint getPoint(float u, float v){
		PVector sum = new PVector(0, 0);
		
		for(int i = 0; i < N; i++){
			for(int j = 0; j < N; j++){
				float bernsteinU = bernsteinPolynomial(N - 1, i, u);
				float bernsteinV = bernsteinPolynomial(N - 1, j, v);
				PVector controlPoint = controlPoints[i][j].getPVector();
				sum.add(PVector.mult(controlPoint, bernsteinU*bernsteinV));
			}
		}

		return new RPoint(sum.x, sum.y);
	}

	RPoint getPoint(RPoint point){
		return getPoint(point.x, point.y);
	}

	//check constraints here?
	void setControlPoint(float x, float y, int i, int j){
		this.controlPoints[i][j].point = new RPoint(x, y);
	}

	RPoint getControlPoint(int i, int j){
		return controlPoints[i][j].point;
	}

	void drawControlPoints(){
		stroke(0, 255, 255);
		strokeWeight(3);

		for(int i = 0; i < N; i++){
			for(int j = 0; j < N; j++){
				point(controlPoints[i][j].getX(), controlPoints[i][j].getY());
			}
		}
	}

	

}

class BezierLine{
	RPoint[] vertices;

	RPoint p0;
	RPoint p1;
	int segments;

	float surfaceWidth;
	float surfaceHeight;

	BezierLine(int segments,
						 float x0, float y0,
						 float x1, float y1,
						 float surfaceWidth, float surfaceHeight){
		this.segments = segments;
		this.p0 = new RPoint(x0, y0);
		this.p1 = new RPoint(x1, y1);
		this.surfaceWidth = surfaceWidth;
		this.surfaceHeight = surfaceHeight;
		
		vertices = createVertices();
	}

	RPoint[] createVertices(){
		RPoint[] newVertices = new RPoint[segments + 1];
		
		for(int i = 0; i <= segments; i++){
			float parameter = float(i)/float(segments);
			newVertices[i] = lerpVector(p0, p1, parameter);
		}

		return newVertices;
	}

	RPoint[] createBezierVertices(BezierPatch bezierPatch){
		RPoint[] normalizedVertices = new RPoint[segments + 1];
		RPoint[] bezierVertices = new RPoint[segments + 1];
		
		for(int i = 0; i <= segments; i++){
			float normalizedX = vertices[i].x/surfaceWidth;
			float normalizedY = vertices[i].y/surfaceHeight;
			normalizedVertices[i] = new RPoint(normalizedX, normalizedY);

			bezierVertices[i] = bezierPatch.getPoint(normalizedVertices[i]);

		}

		return bezierVertices;
	}

	void draw(BezierPatch bezierPatch){
		RPoint[] bezierVertices = createBezierVertices(bezierPatch);
		
		for(int i = 0; i < segments; i++){
			lineVector(bezierVertices[i], bezierVertices[i + 1]);
		}
	}

}

/*
class BezierRectangle{
	BezierLine[] edges = new BezierLine[4];

	BezierRectangle(float xOffset, float yOffset, float width, float height){
		edges[0] = new BezierLine();
	}

	void draw(BezierPatch bezierPatch){
		for(int i = 0; i < 4; i++){
			edges.draw(bezierPatch);
		}
	}
}
*/


class XYConstraint{
	public final int X = 0;
	public final int Y = 1;
	public final int LESS_THAN = 0;
	public final int MORE_THAN = 1;
		
	int axis;
	int comparator;
	float value;

	XYConstraint(int axis, int comparator, float value){
		this.axis = axis;
		this.comparator = comparator;
		this.value = value;
	}
}

class ControlPoint{
	RPoint point;
	ArrayList<XYConstraint> constraints;

	ControlPoint(float x, float y){
		this.point = new RPoint(x, y);
	}

	void addConstraint(XYConstraint constraint){
		constraints.add(constraint);
	}

	float getX(){
		return point.x;
	}

	float getY(){
		return point.y;
	}

	void setPoint(float x, float y){
		this.point = new RPoint(x, y);
	}

	PVector getPVector(){
		return new PVector(point.x, point.y);
	}
}

class ConstraintConnection{

}
