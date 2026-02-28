enum PomodoroMode { pomodoro, shortBreak, longBreak }

class PomodoroStateMachine {
  ///The duration, in seconds, of one pomodoro.
  final int pomodoroDuration;
  ///The duration, in seconds, of one short break.
  final int shortBreakDuration;
  ///The duraction, in seconds, of one long break.
  final int longBreakDuration;
  
  PomodoroMode _currentMode = PomodoroMode.pomodoro;
  /// This tracks the sessions in one cycle.
  /// A classic Pomodoro cycle contains of 4 pomodoros, with a short break
  /// between each, but after the 4th pomodoro: a long break instead. 
  int _sessionCount = 0;
  
  ///Pomodoro durations are given in seconds
  PomodoroStateMachine({
    this.pomodoroDuration = 25 * 60,
    this.shortBreakDuration = 5 * 60,
    this.longBreakDuration = 15 * 60,
  });
  
  PomodoroMode get currentMode => _currentMode;
  int get currentDuration => _getCurrentDuration();

  bool setCurrentMode(String mode){
    if(mode.startsWith('long')){
      _currentMode = PomodoroMode.longBreak;
      _sessionCount = 0;
      return true;
    }
    if(mode.startsWith('short')){
      _currentMode = PomodoroMode.shortBreak;
      _sessionCount = 0;
      return true;
    }
    if(mode.startsWith('pomodoro')){
      _currentMode = PomodoroMode.pomodoro;
      _sessionCount = 0;
      return true;
    }
    return false;
  }
  
  ///Increase pomodoro count or reset after a long break
  void completeCycle() {
    if (_currentMode != PomodoroMode.longBreak) {
      _sessionCount++;
    } else {
      _sessionCount = 0;  // Reset after any break
    }
    _getNextMode();
  }
  
  PomodoroMode _getNextMode() {
    // Classic: 3 x (pomodoros → short) → 1 x (pomodoro → long break)
    if (_sessionCount % 7 == 0 && _sessionCount > 0) {
      _currentMode = PomodoroMode.longBreak;
    } else if (_sessionCount % 2 == 1) {
      _currentMode = PomodoroMode.shortBreak;
    } else {
      _currentMode = PomodoroMode.pomodoro;
    }
    
    print("--------------------------");
    print("_sessionCount is $_sessionCount - Mode is ${_currentMode.name}");
    print("--------------------------");

    return _currentMode;
  }
  
  int _getCurrentDuration() {
    switch (_currentMode) {
      case PomodoroMode.pomodoro: return pomodoroDuration;
      case PomodoroMode.shortBreak: return shortBreakDuration;
      case PomodoroMode.longBreak: return longBreakDuration;
    }
  }
}
