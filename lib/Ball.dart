library brickbreaker.ball;

import 'dart:html';

class Ball
{
  int x, y;
  double xv, yv;
  
  bool attached;
  ImageElement image;
  
  int get width => this.image.width;
  int get height => this.image.height;
  
  Ball(int x, int y)
  {
    this.x = x;
    this.y = y;
    this.attached = true;
    
    this.image = new ImageElement(src: "resources/images/ball.png");
  }
}