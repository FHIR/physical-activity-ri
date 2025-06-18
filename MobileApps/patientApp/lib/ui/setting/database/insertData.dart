

import 'package:health/health.dart';

class HealthData{
  DateTime dateTime;
  String value= "0";
  String type = "";
  bool isWorkoutType = false;
  HealthWorkoutActivityType? healthWorkoutActivityType;

  HealthData(this.dateTime,this.value,this.type,this.healthWorkoutActivityType,this.isWorkoutType);
}