library blockbreaker.gameScreen;

import 'dart:html';
import 'dart:math';

import 'package:BlockBreaker/Observer.dart';
import 'package:BlockBreaker/Paddle.dart';
import 'package:BlockBreaker/Action.dart';
import 'package:BlockBreaker/Ball.dart';

class GameScreen extends Observer
{
  
  Paddle paddle;
  List<List<int>> bricks;
  Ball ball;
  int width, height;
  bool moveRight, moveLeft;
  Random rand;
  
  ImageElement brickImage;
  
  GameScreen(int width, int height)
  {
    this.width = width;
    this.height = height;
    this.rand = new Random();

    this.paddle = new Paddle((width/2 - 50).round(), height-50);
    this.ball = new Ball(this.paddle.x + 50 - 10, height - 50 - 20);
    this.moveLeft = this.moveRight = false;
    
    brickImage = new ImageElement(src: "resources/images/brick.png");
    
    this.initialize();
  }
  
  void initialize()
  {
    this.paddle.x = (width/2 - 50).round();
    this.paddle.y = height-50;
    this.ball.x = this.paddle.x + 50 - 10;
    this.ball.y = height - 50 - 20;
    this.ball.attached = true;
    
    this.bricks = new List<List<int>>();
    for(int col = 0; col < 20; ++col)
    {
      bricks.add(new List());
      for(int row = 0; row < 10; ++row)
        bricks[col].add(1);
    }
  }
  
  void startAction(int action)
  {
    switch(action)
    {
      case LEFT:
        this.moveLeft = true;
        break;
      case RIGHT:
        this.moveRight = true;
        break;
      case FIRE:
        this.fire();
        break;
    }
  }
  
  void stopAction(int action)
  {
    switch(action)
    {
      case LEFT:
        this.moveLeft = false;
        break;
      case RIGHT:
        this.moveRight = false;
        break;
    }
  }
  
  void fire()
  {
    if(!this.ball.attached)
      return;
    this.ball.attached = false;
    
    int speed = 5;
    num frac = this.rand.nextDouble()*.6 + 0.2; 
    num angle = frac * PI;
    print(angle);
    this.ball.xv = speed*cos(angle);
    this.ball.yv = speed*sin(angle);
  }
  
  void update(CanvasElement canvas)
  {
    updatePaddle();
    updateBall();
    draw(canvas);
  }
  
  void updatePaddle()
  {
    if(this.moveLeft)
      this.paddle.x -= 7;
    if(this.moveRight)
      this.paddle.x += 7;
    
    // prevent the paddle from going out of bounds
    if(this.paddle.x < 0)
      this.paddle.x = 0;
    else if((this.paddle.x + this.paddle.width) > this.width)
      this.paddle.x = this.width - this.paddle.width;
  }
  
  void updateBall()
  {
    if(this.ball.attached)
    {
      this.ball.x = this.paddle.x + (this.paddle.width/2).round() - (this.ball.width/2).round();
    }
    else
    {
      this.ball.x += this.ball.xv.round();
      this.ball.y += this.ball.yv.round();
    
      if(this.ball.x < 0)
      {
        this.ball.x = 0;
        this.ball.xv = -this.ball.xv;
      }
      else if((this.ball.x + this.ball.width) > this.width)
      {
        this.ball.x = this.width - this.ball.width;
        this.ball.xv = -this.ball.xv;
      }
      
      if(this.ball.y < 0)
      {
        this.ball.y = 0;
        this.ball.yv = - this.ball.yv;
      }
      else if(this.ball.y + this.ball.height - this.ball.yv.round() <= this.paddle.y &&
          this.ball.y + this.ball.height >= this.paddle.y &&
          this.ball.x + this.ball.width >= this.paddle.x &&
          this.ball.x <= this.paddle.x + this.paddle.width)
      {
        this.ball.yv = -this.ball.yv;
      }
      else if(this.ball.y >= height)
      {
        this.initialize();
      }
      
      int brickx = 0;
      int bricky = -20;
      // check for contact with each brick
      for(int col = 0; col < this.bricks.length; ++col)
      {
        for(int row = 0; row < this.bricks[0].length; ++row)
        {
          bricky += 20;
          // skip empty bricks
          if(this.bricks[col][row] == 0)
            continue;
          
          // if hit brick from bottom
          if(this.ball.y - this.ball.yv >= bricky + 20 &&
              this.ball.y <= bricky + 20 &&
              this.ball.x + this.ball.width >= brickx &&
              this.ball.x <= brickx + 40)
          {
            this.bricks[col][row] -= 1;
            this.ball.yv = -this.ball.yv;
            this.ball.y = bricky + 20;
          }
          // else if hit brick from top
          else if(this.ball.y + this.ball.height - this.ball.yv <= bricky &&
              this.ball.y + this.ball.height >= bricky &&
              this.ball.x + this.ball.width >= brickx &&
              this.ball.x <= brickx + 40)
          {
            this.bricks[col][row] -= 1;
            this.ball.yv = -this.ball.yv;
            this.ball.y = bricky - this.ball.height;
          }
          // or if hit from right
          else if(this.ball.x - this.ball.xv >= brickx + 40 &&
              this.ball.x <= brickx + 40 &&
              this.ball.y + this.ball.height >= bricky &&
              this.ball.y <= bricky + 40)
          {
            this.bricks[col][row] -= 1;
            this.ball.xv = -this.ball.xv;
            this.ball.x = brickx + 40;
          }
          // or if this from left
          else if(this.ball.x + this.ball.width - this.ball.xv <= brickx &&
              this.ball.x + this.ball.width >= brickx && 
              this.ball.y + this.ball.height >= bricky &&
              this.ball.y <= bricky + 40)
          {
            this.bricks[col][row] -= 1;
            this.ball.xv = -this.ball.xv;
            this.ball.x = brickx - this.ball.width;
          }
          
        }
        brickx += 40;
        bricky = -20;
      }
    }
  }
  
  void draw(CanvasElement canvas)
  {
    drawBackground(canvas);
    drawPaddle(canvas);
    drawBall(canvas);
    drawBricks(canvas);
  }
  
  void drawBackground(CanvasElement canvas)
  {
    canvas.context2D.setFillColorRgb(0xDD, 0xDD, 0xDD);
    canvas.context2D.fillRect(0, 0, canvas.width, canvas.height);
  }
  
  void drawPaddle(CanvasElement canvas)
  {
    canvas.context2D.drawImage(this.paddle.image, this.paddle.x, this.paddle.y);
  }
  
  void drawBall(CanvasElement canvas)
  {
    canvas.context2D.drawImage(this.ball.image, this.ball.x, this.ball.y);
  }
  
  void drawBricks(CanvasElement canvas)
  {
    int curx = 0;
    int cury = 0;
    
    for(int col = 0; col < this.bricks.length; ++col)
    {
      for(int row = 0; row < this.bricks[col].length; ++row)
      {
        if(bricks[col][row] > 0)
          canvas.context2D.drawImage(this.brickImage, curx, cury);
        cury += 20;
      }
      cury = 0;
      curx += 40;
    }
  }
}