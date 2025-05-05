import 'package:flutter/material.dart';

abstract class Actuator {
  String get name;
  String get image;
  bool get isOn;

  void toggle();
  void setState(bool value);
  void reset();
}

class SimpleActuator implements Actuator {
  @override
  final String name;
  @override
  final String image;
  bool _isOn = false;

  SimpleActuator({
    required this.name,
    required this.image,
  });

  @override
  bool get isOn => _isOn;

  @override
  void toggle() => _isOn = !_isOn;

  @override
  void setState(bool value) => _isOn = value;

  @override
  void reset() => _isOn = false;
}

class MultiStageActuator implements Actuator {
  @override
  final String name;
  @override
  final String image;
  final List<Stage> stages;
  int _currentStage = 0;

  MultiStageActuator({
    required this.name,
    required this.image,
    required this.stages,
  });

  @override
  bool get isOn => _currentStage > 0;

  String get currentStageName => stages[_currentStage].name;
  int get currentStage => _currentStage;

  void selectStage(int index) {
    _currentStage = index.clamp(0, stages.length - 1);
  }

  @override
  void toggle() {}

  @override
  void setState(bool value) {
    if (value && _currentStage == 0) {
      _currentStage = 1;
    } else if (!value) {
      _currentStage = 0;
    }
  }

  @override
  void reset() => _currentStage = 0;
}

class Stage {
  final String name;
  final String? description;

  Stage(this.name, [this.description]);
}
