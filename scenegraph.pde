import java.util.Stack;
import java.awt.Color;

public static final float GLOBAL_SCALE = 0.3;
float globalTime;

class SceneGraph{
	Node root;

	SceneGraph(){
		
	}

	void addRoot(Node root){
		this.root = root;
	}

	abstract class Node{
		Node child;

		abstract boolean isLeaf();
		abstract RGroup evaluate();

		abstract void addChild(Node child);
		abstract void addPath(Node path);

		abstract void setEnvelopeMatrix(EnvelopeMatrix envelopeMatrix);
	}
	
	class ShapeNode extends Node{
		//always leaf: child is dummy field
		RGroup group;
		
		ShapeNode(RGroup group){
			this.group = group;
		}

		boolean isLeaf(){
			return true;
		}

		RGroup evaluate(){
			return group;
		}

		void addChild(Node child) {
			System.out.println("Attempted to add child to leaf.");
		}
		void addPath(Node path) {
			System.out.println("Attempted to add child to leaf.");
		}

		void setGroup(RGroup group){
			this.group = group;
		}

		void setEnvelopeMatrix(EnvelopeMatrix envelopeMatrix){}
	}

	class ShapeAlongPathNode extends Node{
		Node path;
		Spread spread;
		int spreadNumber;
		boolean mutate;
		EnvelopeMatrix envelopeMatrix;
			
		ShapeAlongPathNode(int spreadNumber, boolean mutate){
			this.mutate = mutate;
			this.spreadNumber = spreadNumber;
		}

		void setEnvelopeMatrix(EnvelopeMatrix envelopeMatrix){
			this.envelopeMatrix = envelopeMatrix;
		}
		
		void addChild(Node child){
			this.child = child;
		}
		
		void addPath(Node path){
			this.path = path;
		}
			
		boolean isLeaf(){
			if(child == null)
				return true;
			else
				return false;
		}

		RGroup evaluate(){
			SpreadParticle spreadParticle = new SpreadParticle(child.evaluate());
			this.spread = new Spread(spreadParticle, path.evaluate(), spreadNumber);
			
			spread.addSpreadParticles(envelopeMatrix);
			return spread.getSpread();
		}
	}

	/*
		//TODO: recursively copy all nodes
	SceneGraph copy(){

	}
	*/
}

void printRPoint(RPoint p){
	System.out.println("(" + p.x + ", " + p.y + ")");
}

RGroup createGrid(int iMax, int jMax, float a, float xOffset, float yOffset){
	RGroup output = new RGroup();
	
	for(int i = -iMax/2; i < iMax/2; i++){
		for(int j = -jMax/2; j < jMax/2; j++){
			float x = float(i)*a + xOffset;
			float y = float(j)*a + yOffset;
			output.addElement(RShape.createLine(x, y, x + a, y));
		}
	}

	return output;
}

RGroup shapeToGroup(RShape shape){
	RGroup output = new RGroup();
	output.addElement(shape);
	return output;
}

RShape createRegularPolygon(int sides, float radius){
	RShape output = new RShape();

	output.addMoveTo(0, 0);
	output.addMoveTo(radius, 0);
	
	for(int i = 1; i < sides; i++){
		float theta = (float(i)/float(sides))*2*PI;
		output.addLineTo(radius*cos(theta), radius*sin(theta));
	}

	return output;
}

RShape mergeRecursive(RGeomElem element, RShape outputShape){
	if(element.getType() == RGeomElem.GROUP){
		System.out.println("GROUP");
		RGroup group = (RGroup)element;
		for(int i = 0; i < group.countElements(); i++){
			outputShape = outputShape.union(mergeRecursive(group.elements[i],
																										 outputShape));
		}
		return outputShape;
	}
	else if(element.getType() == RGeomElem.SHAPE){
		System.out.println("SHAPE");
		RShape shape = (RShape)element;
		return outputShape.union(shape);
	}
	else{
		System.out.println("Type is neither GROUP nor SHAPE");
		return new RShape();
	}
}