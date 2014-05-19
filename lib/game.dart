library blockbreaker.game;

import 'dart:html';

import 'package:BlockBreaker/InputManager.dart';
import 'package:BlockBreaker/GameScreen.dart';

class Game
{
  CanvasElement canvas;
  InputManager input;
  GameScreen gameScreen;
  
  Game(CanvasElement canvas, InputManager input)
  {
    this.canvas = canvas;
    this.input = input;
    
    this.gameScreen = new GameScreen(canvas.width, canvas.height);
    input.observer = this.gameScreen;
  }
  
  void act()
  {
    gameScreen.update(canvas);
  }
}