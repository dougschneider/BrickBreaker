library blockbreaker.inputManager;

import 'dart:html';

import 'package:BlockBreaker/Observer.dart';
import 'package:BlockBreaker/Action.dart';

class InputManager
{
  Observer observer;
  
  InputManager()
  {
    window.onKeyDown.listen(handleKeyDown);
    window.onKeyUp.listen(handleKeyUp);
  }
  
  void handleKeyDown(Event event)
  {
    if(!(event is KeyboardEvent))
      return;
    
    KeyboardEvent kevent = event as KeyboardEvent;
    notifyKeyDown(kevent.keyCode);
  }
  
  void notifyKeyDown(int key)
  {
    switch(key)
    {
      case KeyCode.LEFT:
        observer.startAction(LEFT);
        break;
      case KeyCode.RIGHT:
        observer.startAction(RIGHT);
        break;
      case KeyCode.SPACE:
        observer.startAction(FIRE);
        break;
    }
  }
  
  void handleKeyUp(Event event)
  {
    if(!(event is KeyboardEvent))
      return;
    
    KeyboardEvent kevent = event as KeyboardEvent;
    notifyKeyUp(kevent.keyCode);
  }
  
  void notifyKeyUp(int key)
  {
    switch(key)
    {
      case KeyCode.LEFT:
        observer.stopAction(LEFT);
        break;
      case KeyCode.RIGHT:
        observer.stopAction(RIGHT);
        break;
      case KeyCode.SPACE:
        observer.stopAction(FIRE);
        break;
    }
  }
}