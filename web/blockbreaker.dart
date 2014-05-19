import 'dart:html';

import 'package:BlockBreaker/game.dart';
import 'package:BlockBreaker/InputManager.dart';

Game game;

void main() {
  game = new Game(querySelector("#gameCanvas"), new InputManager());
  
  window.animationFrame.then(run);
}

void run(num delta)
{
  game.act();
  window.animationFrame.then(run);
}