class CBall extends Ball {
	CBall(float xCor, float yCor, float vvx, float vvy) {
		super(xCor, yCor, false, false, 0);
		vx = vvx;
		vy = vvy; 
		
	}
	
	void display() {
		fill(255, 255, 255);
		ellipse(x, y, D, D);
	}
	
	void hide() {
		
		fill(0, 0, 0, 0)
		vx = 0;
		vy = 0;
		x = 0;
		y = 0;
		
	}
	
	void drag(mouX, mouY)	{
		if (abs(mouX-x)<30 && abs(mouY-y)<30)	{
			cursor(MOVE);
			x = mouX;
			y = mouY;
		}
	}

}
