lass Ball {
  float D;
	float x; 
  float y;
	float vx;
	float vy; //velocites in xe et ye pos.  
	public boolean solid;
	boolean eBall;
	public int nBall;
 	public static int colCounter;

	Ball(float xCor, float yCor, boolean isSolid, boolean eightBall, int num) {
		vx = 0;
		vy = 0;
		
		x = xCor;
		y = yCor;
		
		r = 10;
		D = 2.0 * r;
		
		solid = isSolid;
		eBall = eightBall;
		nBall = num;
	}
	
	
	void display() {
		int size = 10;
		color ballColor = #999999;
		if(nBall==1||nBall==2){ballColor = #FCFF00;}
		if(nBall==3||nBall==4){ballColor = #0024A8;}
		if(nBall==5||nBall==9){ballColor = #FF5733;}
		if(nBall==6||nBall==7){ballColor = #89008F;}
		if(nBall==10||nBall==11){ballColor = #FFAE3C;}
		if(nBall==12||nBall==13){ballColor = #008907;}
		if(nBall==14||nBall==15){ballColor = #900C3F;}
			
			
		if (nBall>=10) {size = 7;}
		if (solid) {
			fill(ballColor);
			ellipse(x, y, D, D);					
		}
		else {
			fill(255,255,255)
			ellipse(x, y, D, D);
			fill(ballColor);
			rect(x-9.5,y-5,19,10, 10);
		}
		if (eBall) {
			fill(0,0,0);
			ellipse(x, y, D, D);
		}
		fill(255,255,255);
		ellipse(x, y, 10, 10);
		fill(0,0,0);
		textSize(size);
		text(nBall,x-2.71,y+3.5);
	}
	
	void frict() {
		
		float mu = .09;
		float g = .12;
	
		phi = atan2(vy, vx);
		
		vx -= (mu * g * Math.cos(phi));
		vy -= (mu * g * Math.sin(phi));
		
		if(vx < .005 && vx > -.005 && vy < .005 && vy > -.005) {
			vx = 0;
		  vy = 0;
		}
	}	
		
	void move() {
		float w = width; 
		float h = height;
		if(vx != 0 && vy != 0)
			frict();
		
		x += vx;  // literally move both x and y values
		y += vy;
		
		if(x > 926 - r) { //wall collisions 
			x = 926 - r;
			vx = -vx * .9;
    }
		
		if(y > 520 - r) {
			y = 520 - r;
			vy = -vy * .9;
		}
		
		if(y < r + 80) {
			y = r + 80;
			vy = -vy * .9;
		}
			
		if(x < r + 60) {
			x = r + 60;
			vx = -vx * .9; 
		}
	}
	
  void collide(Ball b1, Ball b2) {
  float dx = b2.x - b1.x;
  float dy = b2.y - b1.y;
  float dist = sqrt(dx * dx + dy * dy);
  
  if(dist < D) { //lu variant
		colCounter++;
		if(cueBallMoveable) {
			cueBall.x = 250;
			cueBall.y = 293;
			return
		}
    float angle = atan2(dy , dx);
    float sin = Math.sin(angle); 
		float cos = Math.cos(angle);
    
    float x1 = 0;
		float y1 = 0;
    float x2 = dx * cos + dy * sin;
    float y2 = dy * cos - dx * sin;
    
    // rotate velocity
    float vx1 = b1.vx * cos + b1.vy * sin;
    float vy1 = b1.vy * cos - b1.vx * sin;
    float vx2 = b2.vx * cos + b2.vy * sin;
    float vy2 = b2.vy * cos - b2.vx * sin;
    
    // simple momentum conservation m1 = m2 in 1D case
    float vx1final = vx2;
    float vx2final = vx1;
    
    vx1 = vx1final;
    vx2 = vx2final;
    
    // fix glitch by moving  half of each ball overlap
    float absV = abs(vx1) + abs(vx2);
    float overlap = (D) - abs(x1-x2);
    x1 += vx1 / absV * overlap;
    x2 += vx2 / absV * overlap;

    // rotate the relative positions back
    float x1final = x1 * cos - y1 * sin;
    float y1final = y1 * cos + x1 * sin;
    float x2final = x2 * cos - y2 * sin;
    float y2final = y2 * cos + x2 * sin;
    
    
    // finally compute the new absolute positions
    b2.x = b1.x + x2final;
    b2.y = b1.y + y2final;
    
    b1.x = b1.x + x1final;
    b1.y = b1.y + y1final;
    
    //rotate v back
    b1.vx = vx1 * cos - vy1 * sin;
    b1.vy = vy1 * cos + vx1 * sin;
    b2.vx = vx2 * cos - vy2 * sin;
    b2.vy = vy2 * cos + vx2 * sin;
   

		
    }
 
}
}
