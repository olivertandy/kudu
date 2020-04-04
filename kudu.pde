import geomerative.*;

int DETAIL = 40;

SceneGraph sg = new SceneGraph();
EnvelopeMatrix envelopeMatrix;
EnvelopeMatrix envelopeMatrix2;
ArrayList<Envelope> envelopes = new ArrayList<Envelope>();

/*
RGroup testShape1 = shapeToGroup(RShape.createRectangle(-100, -100,
 																											200, 200));
RGroup testShape2 = shapeToGroup(RShape.createRectangle(-100, -100, 200, 200));
*/
RGroup testShape1 = shapeToGroup(RShape.createRectangle(-50, -50,
                                                       200, 200));
RGroup testShape2 = shapeToGroup(RShape.createEllipse(0, 0, 200, 200));

void setup(){
	RG.init(this);
	size(1200, 800);
	background(0);

	//presets
	envelopes.add(createPresetEnvelope(new Constant(1), DETAIL));
	envelopes.add(createPresetEnvelope(new Constant(0.5), DETAIL));
	envelopes.add(createPresetEnvelope(new Constant(0), DETAIL));
	envelopes.add(createPresetEnvelope(new Unity(), DETAIL));
	
	envelopes.add(createPresetEnvelope(new SineSquared(1, 1), DETAIL));
	envelopes.add(createPresetEnvelope(new SineSquared(1, 2), DETAIL));
	envelopes.add(createPresetEnvelope(new SineSquared(1, 4), DETAIL));
	envelopes.add(createPresetEnvelope(new SineSquared(1, 8), DETAIL));
	
	envelopes.add(createPresetEnvelope(new CubicUnit(), DETAIL));
	envelopes.add(createPresetEnvelope(new RandomSmooth(3), DETAIL));
	envelopes.add(createPresetEnvelope(new SquareWaveOnSpread(20), DETAIL));
	
	envelopes.add(createPresetEnvelope(new ExponentialDecay(10, 0.0), DETAIL));
	envelopes.add(createPresetEnvelope(new ExponentialDecay(10, 0.25), DETAIL));
	envelopes.add(createPresetEnvelope(new ExponentialDecay(10, 0.5), DETAIL));
	envelopes.add(createPresetEnvelope(new ExponentialDecay(10, 0.75), DETAIL));

	envelopeMatrix = new EnvelopeMatrix(envelopes);
	envelopeMatrix2 = new EnvelopeMatrix(envelopes);

	sg.addRoot(sg.new ShapeAlongPathNode(10, false));

	envelopeMatrix.setContainingGrid(50, 50, 200, 500);
	sg.root.setEnvelopeMatrix(envelopeMatrix);
	sg.root.addChild(sg.new ShapeAlongPathNode(50, false));
	sg.root.addPath(sg.new ShapeNode(testShape2));

	envelopeMatrix2.setContainingGrid(width - 250, 50, 200, 500);
	sg.root.child.setEnvelopeMatrix(envelopeMatrix2);	
	sg.root.child.addChild(sg.new ShapeNode(testShape1));
	sg.root.child.addPath(sg.new ShapeNode(testShape2));

	globalTime = 0;
}

void draw(){
	background(0);
	
	pushMatrix();
	translate(width/2, height/2);
	scale(0.5);
	sg.root.evaluate().draw();
	popMatrix();

	noFill();
	stroke(255);
	envelopeMatrix.draw();
	envelopeMatrix2.draw();

	globalTime += 0.01;
	if(globalTime >= 1) globalTime = 0;

	//filter(DILATE);
}

void mouseClicked(){
	if(envelopeMatrix.containingGrid.rectangleContains(mouseX, mouseY)){
		int[] index = envelopeMatrix.containingGrid.cellContaining(mouseX, mouseY);
		if(mouseButton == LEFT)
			envelopeMatrix.nextEnvelope(index[0], index[1]);
		else
			envelopeMatrix.previousEnvelope(index[0], index[1]);
	}

	if(envelopeMatrix2.containingGrid.rectangleContains(mouseX, mouseY)){
		int[] index = envelopeMatrix2.containingGrid.cellContaining(mouseX, mouseY);
		if(mouseButton == LEFT)
			envelopeMatrix2.nextEnvelope(index[0], index[1]);
		else
			envelopeMatrix2.previousEnvelope(index[0], index[1]);
	}
	
	//sg.root.setEnvelopeMatrix(envelopeMatrix);
}

void mouseDragged(){

}

RGroup createBezierGroup(float x0, float y0,
												 float x1, float y1,
												 float x2, float y2,
												 float x3, float y3){
	RPoint p0 = new RPoint(x0, y0);
	RPoint p1 = new RPoint(x1, y1);
	RPoint p2 = new RPoint(x2, y2);
	RPoint p3 = new RPoint(x3, y3);
	
	RShape bezier = new RShape();
	bezier.addMoveTo(p0);
	bezier.addBezierTo(p1, p2, p3);

	RGroup output = shapeToGroup(bezier);
	return output;
}