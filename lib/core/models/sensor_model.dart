import 'package:flutter/material.dart';
import 'package:greenovate/core/constants/app_assets.dart';

class SensorModel {
  SensorModel({
    required this.name,
    required this.image,
    required this.unit,
    required this.value,
    required this.path
  });
  String name;
  double value;
  String unit;
  String image;
  String path ;

  static List<SensorModel> Sensors = [
    SensorModel(
      name: "Temperature",
      image: AppAssets.temperatureIcon,
      unit: "°C",
      value: 25.0,
      path : "/opTemp",
    ),
    SensorModel(
      name: "Humidity",
      image: AppAssets.humidityIcon,
      unit: "%",
      value: 60.0,
       path : "/opHumidity",
    ),
    SensorModel(
      name: "Soil Moisture",
      image: AppAssets.soilIcon,
      unit: "%",
      value: 40.0,
       path : "/opMoisture",
    ),
    SensorModel(
      name: "Light Intensity",
      image: AppAssets.ldrIcon,
      unit: "%",
      value: 80.0,
       path : "/opLdr",
    ),
    SensorModel(
      name: "Ph Level",
      image: AppAssets.phIcon,
      unit: "",
      value: 6,
       path : "/opPh",
    ),
  ];
}
