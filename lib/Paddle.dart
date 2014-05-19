library brickbreaker.paddle;

import 'dart:html';

class Paddle
{
  int x, y;
  
  int get width => this.image.width;
  int get height => this.image.height;
  
  ImageElement image;
  
  Paddle(int x, int y)
  {
    this.x = x;
    this.y = y;
    
    this.image = new ImageElement(src: "resources/images/paddle.png");
  }
  
}