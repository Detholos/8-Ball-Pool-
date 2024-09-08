import processing.core.PApplet;
import processing.core.PImage;
import java.util.ArrayList; 

ArrayList<Ball> deadBalls = new ArrayList<Ball>(); 
public Ball cueBall; //x
Ball savBall = null;
boolean cuePocketed = false;
boolean powSet = false;
boolean cueBallPotted = false;
boolean snappedBack = false;
boolean gameStarted = false;
boolean running = false;
public boolean cueBallMoveable = false;
boolean potted = false;
boolean ballPocketed = false;
private PImage img;
public static float w, h;
private int yValP = 100;
private int yValA = 94;
private int angle = 360;
private int power = 6;
private int cuePower = 0;
int cueX = 250;
int cueY = 293;
int currentPlayer = 0;
String oneType = "Undecided";
String twoType = "Undecided";
int oneBallsToPocket = 7;
int twoBallsToPocket = 7;
ArrayList <Ball> balls = new ArrayList<Ball>();
Pocket[] pockets;

public void setup() {
		size(1000, 600);
    background(152, 190, 100);
		img = loadImage("table_withname.png");
		w = width; 
    h = height;
	
	  float k = 0;
	  float y = 0;
	  float x = 7.1;
	
		for(int i = 0; i < 5; i++) { //triangle setup;
			x -= 20.3;
			y = 10.2 * i;
			for(int j = i; j < 5; j++) {
				if (k==7){balls.add(new Ball(800 + x, 260 + y, false, true, k+1));} // 8 Ball
				else	{
					if ((k-1)%2==0||k==4){balls.add(new Ball(800 + x, 260 + y, true, false, k+1));}
					else{balls.add(new Ball(800 + x, 260 + y, false, false, k+1));}
				}
				y += 20.3;
				k++;
			}
		}
	cueBall = new CBall(cueX, cueY, 0, 0); //
	balls.add(cueBall); //
	
	pockets = { new Pocket(917, 91), new Pocket(494, 81), new Pocket(72, 91), new Pocket(72, 507), new Pocket(494, 518), new Pocket(915, 505) };

}

	void mouseReleased(){ // Important! otherwise cursor stays as moving image
		cursor(ARROW);
		cueBallMoveable = false; // You lose ability to move cueBall once you let go of mouse
	}

  public void draw() {

		background(152, 190, 100);
		// Really helpful. dont delete just comment out.
		if (!gameStarted) {cueBallMoveable = true;} // before first shot is taken and cueball still at middle (starting game conditions)
		if (mousePressed){
			
			if (cueBallMoveable) {
			cueBall.drag(mouseX, mouseY);
			if(!gameStarted && cueBall.x > 400)
				cueBall.x = 400;
			}
		}
    fill(255);
		image(img, -50, -50,width+100,height+100);
		noFill();
		
		// Players Info
		textSize(25);
		color oneColor = #FFFFFF;
		color twoColor = #FFFFFF;
		if (currentPlayer == 0){oneColor = #FF0000; twoColor = #FFFFFF}
		if (currentPlayer == 1){oneColor = #FFFFFF; twoColor = #FF0000}
		fill(oneColor);
		text("Player 1", 40, 25);
		fill(twoColor);
		text("Player 2", 555, 25);
		fill(255);
		textSize(15);
		text("Ball Set: "+oneType, 160, 20);
		text("Ball Set: "+twoType, 680, 20);
			
		// Power Slider
		fill(255);
			rect(5,100,25,400);
			fill(#FF0000);
			rect(5,yValP,25,45);
		if (mousePressed && mouseX>=5 && mouseX<=30 && mouseY>=100 && mouseY<=455 && allStopped)
		{
			yValP = mouseY;
			power = yValP-100;
		}
		
		// Angle Slider
		fill(255);
			rect(970,94,25,399);
			fill(#FF0000);
			rect(970,yValA,25,45);
		if (mousePressed && mouseX>=970 && mouseX<=995 && mouseY>=94 && mouseY<=454 && allStopped)
		{
			yValA = mouseY;
			angle = -yValA + 94;
		}
		
		
		// Spin control
		
		if(!snappedBack)
				cuePower = power;
				
	  noStroke();
		fill(12, 145, 24); 
		for(int i = 0; i < balls.size(); i++) { //balls are shown and move
			balls.get(i).display();
			balls.get(i).move();
		}
		 
		if(keyPressed && key == 'f' && allStopped) { //here this initiates cue shooting.
			gameStarted = true;
			running = true;
			potted = false;
			powSet = true;
			ballPocketed = false;
			float modifiedPower = power / 9.0;
			cuePower = 0;
			snappedBack = true;
			yValP = 100;
			cueBallMoveable = false;
			cueBall.vx = cos(radians(angle)) * -modifiedPower * .5;
			cueBall.vy = sin(radians(angle)) * -modifiedPower * .5;
		}
		
		for(int i = 0; i < balls.size() - 1; i++) { //all balls collide
			for(int j = i + 1; j < balls.size(); j++) {
				balls.get(0).collide(balls.get(i), balls.get(j));
			} 
		}

			for(int i = 0; i < balls.size(); i++) { //checks if all balls stop moving
				if(balls.get(i).vx > .01 || balls.get(i).vy > .01 || balls.get(i).vx < -.01 || balls.get(i).vy < -.01) {
					allStopped = false;
					break;
				}
				else {
					allStopped = true;
				}
			}
		// :(
Iterator<Ball> iterator = balls.iterator();
while (iterator.hasNext()) {
  Ball ball = iterator.next();
  for(int j = 0; j < pockets.length; j++) {
    if(pockets[j].fallsIn(ball)) {
      if(ball.equals(cueBall)) {
      	ball.hide();  
        }
      deadBalls.add(ball);
      iterator.remove();
    }
  }
}
	
		


				
if(allStopped) {
		if(deadBalls.size() > 0) {
			for(int i = 0; i <= deadBalls.size() - 1; i++) {
				if(deadBalls.get(i).eBall) {
					if(currentPlayer == 0) {
						if(oneBallsToPocket > 0) {
							textSize(25);
							text("Player 1 loses", 300, 300);
							noLoop();
							return;
						}
						if(oneBallsToPocket == 0) {
							textSize(25);
							text("Player 1 wins", 300, 300);
							noLoop();
							return;
						}
					}
					if(currentPlayer == 1) {
						if(twoBallsToPocket > 0) {
							textSize(25);
							text("Player 2 loses", 300, 300);
							noLoop();
							return;
						}
						if(twoBallsToPocket == 0) {
							textSize(25);
							text("Player 2 wins", 300, 300);
							noLoop();
							return;
						}
					}
				}
	
				if(currentPlayer == 0 && oneType.equals("Undecided")) {
					if(deadBalls.get(i).solid) { 
						oneType = "Solids";
						twoType = "Stripes";
					}
					else if(!deadBalls.get(i).eBall && !deadBalls.get(i).equals(cueBall)) {
						oneType = "Stripes";
						twoType = "Solids";
					}
					ballPocketed = true;
					oneBallsToPocket--;
				}
				
				else if(currentPlayer == 0 && !deadBalls.get(i).equals(cueBall)) {
					
					if(oneType.equals("Solids")) {
						if(deadBalls.get(i).solid) {
							ballPocketed = true;
							oneBallsToPocket--;
						}
						else if(!deadBalls.get(i).eBall && !deadBalls.get(i).equals(cueBall))
							twoBallsToPocket--;
					}
					
					if(oneType.equals("Stripes")) {
						if(!deadBalls.get(i).eBall && !deadBalls.get(i).equals(cueBall) && !deadBalls.get(i).solid) {
							ballPocketed = true;
							oneBallsToPocket--;
						}
						else if(deadBalls.get(i).solid)
							twoBallsToPocket--;
					}
				
				}
				
				if(currentPlayer == 1 && twoType.equals("Undecided")) {
					if(deadBalls.get(i).solid) {
						twoType = "Solids";
						oneType = "Stripes";
					}
					else if(!deadBalls.get(i).eBall && !deadBalls.get(i).equals(cueBall)) {
						twoType = "Stripes";
						oneType = "Solids";
					}
					ballPocketed = true;
					twoBallsToPocket--;
				}
				
				else if(currentPlayer == 1 && !deadBalls.get(i).equals(cueBall)) {
					
					if(twoType.equals("Solids")) {
						if(deadBalls.get(i).solid) {
							ballPocketed = true;
							oneBallsToPocket--;
						}
						else if(!deadBalls.get(i).eBall && !deadBalls.get(i).equals(cueBall))
							twoBallsToPocket--;
					}
					
					if(twoType.equals("Stripes")) {
						if(!deadBalls.get(i).eBall && !deadBalls.get(i).equals(cueBall) && !deadBalls.get(i).solid) {
							ballPocketed = true;
							oneBallsToPocket--;
						}
						else if(deadBalls.get(i).solid)
							twoBallsToPocket--;
					}
				}
				
			
				if(deadBalls.get(i).equals(cueBall)) {//    (// - possible problematic code) also this code goes AFTER the undecideds
					resetCueBall();
					cueBall.display();
					ballPocketed = false;
					cueBallPocketed = true;
				}
			}
		}
		deadBalls.clear();
		if(!ballPocketed || cueBallPocketed) {
			currentPlayer = (currentPlayer + 1) % 2;
			if(!gameStarted)
				currentPlayer -= 1;
		}
	fill(222);
	cueX = cueBall.x;
	cueY = cueBall.y;
	pushMatrix();
	translate(cueX, cueY);
	rotate(radians(angle));
	translate(-cueX, -cueY);
	translate(cuePower,0);
	quad(cueX, cueY-5, cueX+400, cueY-10, cueX+400, cueY+10, cueX, cueY+5);
	popMatrix();
	if(powSet) {
		powSet = false;
		power = 0.3;
	}
		
	snappedBack = false;
	ballPocketed = true;
	cueBallPocketed = false;
	savBall = null;
}
	//print(oneBallsToPocket +" " + twoBallsToPocket);		
}

	void resetCueBall() {
		cueBallMoveable = true;
		cueBall.x = 250;
		cueBall.y = 293;
		balls.add(cueBall);
	}
