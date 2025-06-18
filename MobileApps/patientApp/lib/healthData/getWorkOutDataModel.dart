import 'package:health/health.dart';

class WorkOutData{
  String workOutDataName = "";
  String workOutDataCode = "";
  String workOutDataImages = "";
  HealthWorkoutActivityType datatype;
  bool? isShow = true;

  WorkOutData({required this.workOutDataName,required this.workOutDataImages,required this.datatype,this.isShow,required this.workOutDataCode});
}