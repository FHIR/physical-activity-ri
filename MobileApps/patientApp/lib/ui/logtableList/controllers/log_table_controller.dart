
import 'package:banny_table/db_helper/box/log_table_data.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';


class LogTableController extends GetxController {

  List<LogTableData> logTable = [];

  @override
  void onInit() {
    getLogData();
    super.onInit();
  }

  getLogData(){
    logTable.clear();
    logTable = Hive.box<LogTableData>(Constant.tableLog).values.toList();
    logTable = logTable.reversed.toList();
    Debug.printLog("Length...........${logTable.length.toString()}");
    update();
  }
}

