//'lambda function' interface
//eventually make this a single binary function tree class

interface Lambda{
	float evaluate(float t);
}

class Constant implements Lambda{
	float c;
	
	Constant(float c){
		this.c = c;
	}

	float evaluate(float t){
		return c;
	}
}

class Unity implements Lambda{
	Unity(){}

	float evaluate(float t){
		return t;
	}
}

//sin^2 function with integer periods (like standing wave)
class SineSquared implements Lambda{
	float amplitude;
	int periods;
	
	SineSquared(float amplitude, int periods){
		this.amplitude = amplitude;
		this.periods = periods;
	}
	
	float evaluate(float t){
		return pow(sin(periods*PI*t), 2);
	}
}

class SquareWaveOnSpread implements Lambda{
	float halfPeriod;
	
	SquareWaveOnSpread(int spreadNumber){
		this.halfPeriod = 1.0f/float(spreadNumber);
	}

	float evaluate(float t){
		int containingHalfPeriod = int(floor(t/halfPeriod));
		if(containingHalfPeriod%2 == 0)
			return 1;
		else
			return 0;
	}
}

class ExponentialDecay implements Lambda{
	float rate;
	float offset;
	
	ExponentialDecay(float rate, float offset){
		this.rate = rate;
		this.offset = offset;
	}

	float evaluate(float t){
		if(t < offset)
			return 0;
		else
			return exp(-rate*(t - offset));
	}
}

class RandomSmooth implements Lambda{
	int points;
	float[] xValues;
	float[] yValues;
	
	RandomSmooth(int points){
		this.points = points;
		xValues = spread(points + 1);
		yValues = new float[points + 1];

		for(int i = 0; i < points + 1; i++){
			yValues[i] = random(0, 1);
		}
	}

	float evaluate(float t){
		//find interval in which t lies
		float d = 1.0f/float(points);
		int index = int(floor(t/d));

		float x0 = xValues[index];
		float x1 = xValues[index + 1];
		float y0 = yValues[index];
		float y1 = yValues[index + 1];

		return cubicOverInterval(t, x0, x1, y0, y1);
	}

	float[] spread(int spreadNumber){
		float d = 1.0f/float(spreadNumber);
		float[] values = new float[spreadNumber];

		for(int i = 0; i < spreadNumber; i++){
			values[i] = float(i)*d;
		}

		return values;
	}
}

float cubicOverInterval(float x, float x0, float x1, float y0, float y1){
	float argument = (x - x0)/(x1 - x0);
	return (y1 - y0)*cubicOverUnit(argument) + y0;
}

float cubicOverUnit(float x){
	// faster to just multiply?
	return 3*pow(x, 2) - 2*pow(x, 3);
}

class CubicUnit implements Lambda{
	CubicUnit(){}

	float evaluate(float t){
		return cubicOverUnit(t);
	}
} 

