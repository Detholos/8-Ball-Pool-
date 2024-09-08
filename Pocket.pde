class Pocket {
	float r;
	float x;
	float y;
	float D;
	
	Pocket(float xCor, float yCor) {
		r = 13;
		x = xCor;
		y = yCor; 
		D = r * 2;
	}
	
	boolean fallsIn(Ball a) {
		float dx = x - a.x;
		float dy = y - a.y;
		float dist = sqrt(dx * dx + dy * dy);
		if(dist < r) 
			return true;		
		return false;
	}
	
}
