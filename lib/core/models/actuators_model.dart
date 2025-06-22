import 'package:flutter/material.dart';

abstract class Actuator {
  String get name;
  String get image;
  List<Stage> get stages;
  int get currentStage;
}

class SimpleActuator implements Actuator {
  @override
  final String name;

  @override
  final String image;
  @override
  List<Stage> stages;
  @override
  int currentStage = 0;

  SimpleActuator({
    required this.name,
    required this.image,
    required this.stages,
    this.currentStage = 0,
  });
  void selectStage(int index) {
    currentStage = index.clamp(0, stages.length - 1);
  }
}

class MultiStageActuator implements Actuator {
  @override
  final String name;
  @override
  final String image;
  @override
  final List<Stage> stages;
  @override
  int currentStage = 0;

  MultiStageActuator({
    required this.name,
    required this.image,
    required this.stages,
    this.currentStage = 0,
  });
  void selectStage(int index) {
    currentStage = index.clamp(0, stages.length - 1);
  }
}

class Stage {
  final String name;
  final String? description;

  Stage(this.name, [this.description]);
}
