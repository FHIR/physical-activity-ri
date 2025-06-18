import 'package:get/get.dart';
class ImportExportController extends GetxController {

  var isShowLoader = false;

  onChangeLoaderVisibility(bool value){
    isShowLoader = value;
    update();
  }
  // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  //
  // authentication() async {
  //   // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  //
  //   await Permission.activityRecognition.request();
  //   await Permission.location.request();
  //
  //   var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType).map((e) => HealthDataAccess.READ_WRITE).toList();
  //
  //   bool? hasPermissions =
  //       await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType, permissions: permissions);
  //
  //   var requested = false;
  //   try {
  //     await health.requestAuthorization((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType,permissions: permissions).then((value) => {
  //       requested = value,
  //       if(!requested){
  //         Utils.showSnackBar(Get.context!,"Auth Failed",false)
  //       },
  //       Debug.printLog("requestAuthorization....$value")
  //     });
  //   } catch (e) {
  //     Debug.printLog("Health permission....$e");
  //   }
  //
  // }
  //
  // importDataFromHealth() async {
  //   // onChangeLoaderVisibility(true);
  //   // Utils.showSnackBar(Get.context!,"Please wait...",true);
  //   // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  //   //
  //   // await Permission.activityRecognition.request();
  //   // await Permission.location.request();
  //   //
  //   // var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType).map((e) => HealthDataAccess.READ_WRITE).toList();
  //   //
  //   // bool? hasPermissions =
  //   // await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType, permissions: permissions);
  //   //
  //   // var requested = false;
  //   // try {
  //   //   await health.requestAuthorization((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType).then((value) => {
  //   //         requested = value,
  //   //         if(!requested){
  //   //           // onChangeLoaderVisibility(false)
  //   //           Utils.showSnackBar(Get.context!,"Failed",false)
  //   //         },
  //   //         Debug.printLog("requestAuthorization....$value")
  //   //       });
  //   // } catch (e) {
  //   //   Debug.printLog("Health permission....$e");
  //   // }
  //
  //   // if(requested) {
  //   // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  //   var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType).map((e) => HealthDataAccess.READ_WRITE).toList();
  //
  //   bool? hasPermissions =
  //   await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType, permissions: permissions);
  //
  //   // if(hasPermissions!) {
  //     _showDialogForProgress(Get.context!, true);
  //     var now = DateTime.now();
  //     var endDate = DateTime(now.year, now.month, now.day + 1);
  //     var startDate = DateTime(now.year - 1, now.month, now.day);
  //     List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
  //         startDate, endDate,
  //         (Platform.isAndroid) ? Utils.getAllHealthTypeAndroid : Utils
  //             .getAllHealthType);
  //
  //     var stepsListData = getStepDataFromHealth(
  //         healthData, Constant.titleSteps, HealthDataType.STEPS);
  //     for (int i = 0; i < stepsListData.length; i++) {
  //       insertUpdateHealthDay(stepsListData[i].dateTime, Constant.titleSteps,
  //           stepsListData[i].value);
  //     }
  //
  //     // if (Platform.isIOS) {
  //       var caloriesListData = getStepDataFromHealth(
  //           healthData, Constant.titleCalories,
  //           HealthDataType.ACTIVE_ENERGY_BURNED);
  //       for (int i = 0; i < caloriesListData.length; i++) {
  //         insertUpdateHealthDay(
  //             caloriesListData[i].dateTime, Constant.titleCalories,
  //             caloriesListData[i].value);
  //       }
  //    /* } else {
  //       var caloriesListData = getCaloriesData(
  //           healthData, Constant.titleCalories,
  //           HealthDataType.WORKOUT);
  //       for (int i = 0; i < caloriesListData.length; i++) {
  //         insertUpdateHealthDay(
  //             caloriesListData[i].dateTime, Constant.titleCalories,
  //             caloriesListData[i].value);
  //       }
  //     }*/
  //
  //     var heartRateListData = getStepDataFromHealth(
  //         healthData, Constant.titleHeartRatePeak, HealthDataType.HEART_RATE);
  //     for (int i = 0; i < heartRateListData.length; i++) {
  //       insertUpdateHealthDay(
  //           heartRateListData[i].dateTime, Constant.titleHeartRatePeak,
  //           heartRateListData[i].value);
  //     }
  //
  //     var heartRateRestingListData = getStepDataFromHealth(
  //         healthData, Constant.titleHeartRateRest,
  //         HealthDataType.RESTING_HEART_RATE);
  //     for (int i = 0; i < heartRateRestingListData.length; i++) {
  //       insertUpdateHealthDay(
  //           heartRateRestingListData[i].dateTime, Constant.titleHeartRateRest,
  //           heartRateRestingListData[i].value);
  //     }
  //     /*var now = DateTime.now();
  //     var endDate = DateTime(2023,10,31,23,59,59);
  //     var startDate = DateTime(2023,10,31,00,00,01);
  //     List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
  //         startDate, endDate, [HealthDataType.STEPS]);
  //     var totalCount = 0.0;
  //     for (int i = 0; i < healthData.length; i++) {
  //       Debug.printLog("healthData.... STEPS...${healthData[i].value}  ${healthData[i].dateFrom}");
  //       totalCount += double.parse(healthData[i].value.toString());
  //     }
  //     Debug.printLog("Total STEPS count...$totalCount  ${healthData.length}");*/
  //
  //     Get.back();
  //     Utils.showSnackBar(Get.context!, "Import data successfully", false);
  //   // }
  //   // else{
  //   //   Utils.showToast(Get.context!, "Not Authorized!!");
  //   // }
  //   // }
  // }
  //
  // List<HealthData> getStepDataFromHealth(List<HealthDataPoint> healthData,String type,HealthDataType healthDataType){
  //   List<HealthData> valueStepList = [];
  //
  //   var tempList =
  //       healthData.where((element) => element.type == healthDataType).toList();
  //   List<HealthDataPoint> stepWiseData = [];
  //
  //   if(Platform.isAndroid){
  //   for (int a = 0; a < tempList.length; a++) {
  //     if (stepWiseData.isEmpty) {
  //       stepWiseData.add(tempList[a]);
  //     } else {
  //       var checking = stepWiseData.where((element) =>
  //       element.value == tempList[a].value &&
  //           element.value == tempList[a].value &&
  //           element.unit == tempList[a].unit &&
  //           element.dateFrom == tempList[a].dateFrom &&
  //           element.dateTo == tempList[a].dateTo &&
  //           element.platform == tempList[a].platform &&
  //           element.deviceId == tempList[a].deviceId &&
  //           element.sourceId == tempList[a].sourceId
  //       ).toList();
  //       if (checking.isEmpty) {
  //         stepWiseData.add(tempList[a]);
  //       }
  //     }
  //   }
  //   }else if(Platform.isIOS){
  //     stepWiseData = tempList;
  //   }
  //
  //   if (stepWiseData.isNotEmpty) {
  //       DateTime? lastDate;
  //       for (int i = 0; i < stepWiseData.length; i++) {
  //         lastDate ??= Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
  //         if (lastDate == Utils.getDateFromFullDate(stepWiseData[i].dateFrom)) {
  //           if (valueStepList.isEmpty) {
  //             /*if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //                 "com.google.android.apps.fitness")) {
  //               valueStepList.add(HealthData(
  //                   Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                   stepWiseData[i].value.toString(),
  //                   type,null,false));
  //             } else if (Platform.isIOS) {
  //               valueStepList.add(HealthData(
  //                   Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                   stepWiseData[i].value.toString(),
  //                   type,null,false));
  //             }*/
  //             valueStepList.add(HealthData(
  //                 Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                 stepWiseData[i].value.toString(),
  //                 type,null,false));
  //           } else {
  //             var getData = valueStepList.indexWhere((element) =>
  //             element.dateTime == lastDate).toInt();
  //             if (getData != -1) {
  //               if (healthDataType == HealthDataType.HEART_RATE) {
  //                 /*if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //                     "com.google.android.apps.fitness")) {
  //                   if (double.parse(valueStepList[getData].value) <
  //                       double.parse(stepWiseData[i].value.toString())) {
  //                     valueStepList[getData].value =
  //                         double.parse(stepWiseData[i].value.toString())
  //                             .toString();
  //                   }
  //                 } else if (Platform.isIOS) {
  //                   if (double.parse(valueStepList[getData].value) <
  //                       double.parse(stepWiseData[i].value.toString())) {
  //                     valueStepList[getData].value =
  //                         double.parse(stepWiseData[i].value.toString())
  //                             .toString();
  //                   }
  //                 }*/
  //                 if (double.parse(valueStepList[getData].value) <
  //                     double.parse(stepWiseData[i].value.toString())) {
  //                   valueStepList[getData].value =
  //                       double.parse(stepWiseData[i].value.toString())
  //                           .toString();
  //                 }
  //               } else {
  //                 /*if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //                     "com.google.android.apps.fitness")) {
  //                   valueStepList[getData].value =
  //                       (double.parse(valueStepList[getData].value.toString()) +
  //                           double.parse(stepWiseData[i].value.toString()))
  //                           .toString();
  //                 } else if (Platform.isIOS) {
  //                   valueStepList[getData].value =
  //                       (double.parse(valueStepList[getData].value.toString()) +
  //                           double.parse(stepWiseData[i].value.toString()))
  //                           .toString();
  //                 }*/
  //                 valueStepList[getData].value =
  //                     (double.parse(valueStepList[getData].value.toString()) +
  //                         double.parse(stepWiseData[i].value.toString()))
  //                         .toString();
  //               }
  //             }
  //           }
  //         }
  //         else {
  //           /*if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //               "com.google.android.apps.fitness")) {
  //             lastDate = Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
  //             valueStepList.add(HealthData(
  //                 Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                 stepWiseData[i].value.toString(),
  //                 type,null,false));
  //           } else if (Platform.isIOS) {
  //             lastDate = Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
  //             valueStepList.add(HealthData(
  //                 Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                 stepWiseData[i].value.toString(),
  //                 type,null,false));
  //           }*/
  //           lastDate = Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
  //           valueStepList.add(HealthData(
  //               Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //               stepWiseData[i].value.toString(),
  //               type,null,false));
  //         }
  //       }
  //     }
  //
  //
  //   return valueStepList;
  // }
  //
  // List<HealthData> getCaloriesData(List<HealthDataPoint> healthData,String type,HealthDataType healthDataType){
  //   List<HealthData> valueStepList = [];
  //
  //   var stepWiseData = healthData.where((element) =>
  //   element.type == healthDataType).toList();
  //
  //   if (stepWiseData.isNotEmpty) {
  //     DateTime? lastDate;
  //     for (int i = 0; i < stepWiseData.length; i++) {
  //       lastDate ??= Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
  //       if (lastDate == Utils.getDateFromFullDate(stepWiseData[i].dateFrom)) {
  //         if (valueStepList.isEmpty) {
  //           if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //               "com.google.android.apps.fitness")) {
  //             // stepWiseData[i]].sourceName == "com.physical.activity.fitness1")){
  //             var value = stepWiseData[i].value.toJson()['totalEnergyBurned'];
  //             if(value != null || value != "0") {
  //               valueStepList.add(HealthData(
  //                   Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                   value.toString(),
  //                   type,Utils.getWorkoutActivityType(stepWiseData[i].value.toJson()["workoutActivityType"]),true));
  //                   // type,stepWiseData[i].value.toJson()["workoutActivityType"] as HealthWorkoutActivityType,true));
  //             }
  //           }
  //         } else {
  //           var getData = valueStepList.indexWhere((element) =>
  //           element.dateTime == lastDate).toInt();
  //           if (getData != -1) {
  //               if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //                   "com.google.android.apps.fitness")) {
  //                 // stepWiseData[i].sourceName == "com.physical.activity.fitness1")) {
  //                 var value = stepWiseData[i].value.toJson()['totalEnergyBurned'];
  //                 if(value != null || value != "0") {
  //                   valueStepList[getData].value =
  //                       (double.parse(valueStepList[getData].value.toString()) +
  //                           double.parse(value.toString()))
  //                           .toString();
  //                 }
  //               }
  //           }
  //         }
  //       }
  //       else {
  //         if (Platform.isAndroid && (stepWiseData[i].sourceName ==
  //             "com.google.android.apps.fitness")) {
  //           // stepWiseData[i].sourceName == "com.physical.activity.fitness1")) {
  //           lastDate = Utils.getDateFromFullDate(stepWiseData[i].dateFrom);
  //           var value = stepWiseData[i].value.toJson()['totalEnergyBurned'];
  //           if(value != null || value != "0") {
  //             valueStepList.add(HealthData(
  //                 Utils.getDateFromFullDate(stepWiseData[i].dateFrom),
  //                 value.toString(),
  //                 type,Utils.getWorkoutActivityType(stepWiseData[i].value.toJson()["workoutActivityType"]),true));
  //           }
  //         }
  //       }
  //     }
  //   }
  //
  //
  //   return valueStepList;
  // }
  //
  // insertUpdateHealthDay(DateTime dateTime,String titleName,String value) async {
  //   Debug.printLog("insertUpdateHealthDay...$dateTime  $titleName  $value");
  //   var allDataFromDB = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  //   var weekInsertedData = [];
  //
  //   String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
  //
  //   weekInsertedData = allDataFromDB.where((element) =>
  //   element.date == formattedDate &&
  //       element.type == Constant.typeDay && element.title == ((titleName == "")?null:titleName))
  //       .toList();
  //
  //   if(weekInsertedData.isEmpty) {
  //     var insertingData = ActivityTable();
  //     insertingData.title = ((titleName == "")?null:titleName);
  //
  //     insertingData.date =
  //         DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
  //     insertingData.dateTime = dateTime;
  //
  //
  //     insertingData.total = double.parse(value);
  //     insertingData.type = Constant.typeDay;
  //     insertingData.isSync = false;
  //     String formattedDateStart = "";
  //     String formattedDateEnd = "";
  //
  //
  //     formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
  //         .format(Utils.findFirstDateOfTheWeekImport(dateTime));
  //     formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
  //         .format(Utils.findLastDateOfTheWeekImport(dateTime));
  //
  //     insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
  //     insertingData.userId = Constant.defaultUserId;
  //     var id = await DataBaseHelper.shared.insertActivityData(insertingData);
  //   }
  //   else{
  //     String formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
  //
  //     var weekInsertedData = allDataFromDB
  //         .where((element) => element.date == formattedDate && element.title == ((titleName == "")?null:titleName) &&
  //         element.type == Constant.typeDay ).toList();
  //
  //     weekInsertedData[0].total = double.parse(value);
  //     weekInsertedData[0].isSync = false;
  //     await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
  //
  //   }
  //   insertUpdateHealthWeek(dateTime, titleName);
  //
  //
  // }
  //
  // String lastStartWeekDate = "";
  // String lastEndWeekDate = "";
  //
  // insertUpdateHealthWeek(DateTime dateTime, String titleName) async {
  //   Debug.printLog("weekly data insertUpdateHealthWeek......$dateTime  $titleName ");
  //   String formattedDateStart = "";
  //   String formattedDateEnd = "";
  //
  //   var allDataFromDB = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  //   var weekInsertedData = [];
  //
  //   formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
  //       .format(Utils.findFirstDateOfTheWeekImport(dateTime));
  //   formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
  //       .format(Utils.findLastDateOfTheWeekImport(dateTime));
  //
  //   weekInsertedData = allDataFromDB.where((element) =>
  //   element.weeksDate == "$formattedDateStart-$formattedDateEnd" &&
  //       element.type == Constant.typeWeek && element.title == titleName).toList();
  //
  //   if(weekInsertedData.isEmpty){
  //     var insertingData = ActivityTable();
  //     insertingData.title = titleName;
  //
  //
  //     insertingData.isSync = false;
  //     var weeklyCount = 0.0;
  //     var allDataFromDBDayWise = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  //     if(allDataFromDBDayWise.isNotEmpty){
  //       var dataList = allDataFromDBDayWise
  //           .where((element) =>
  //               element.type == Constant.typeDay &&
  //               element.weeksDate == "$formattedDateStart-$formattedDateEnd" && element.title == titleName)
  //           .toList();
  //       for (int i = 0; i < dataList.length; i++) {
  //         weeklyCount += dataList[i].total ?? 0.0;
  //       }
  //     }
  //     if(weeklyCount == 0.0){
  //       insertingData.total = null;
  //     }else{
  //       insertingData.total = weeklyCount;
  //     }
  //     insertingData.type = Constant.typeWeek;
  //     insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
  //     insertingData.userId = Constant.defaultUserId;
  //     var id = await DataBaseHelper.shared.insertActivityData(insertingData);
  //   }else{
  //
  //     var weekInsertedData = allDataFromDB
  //         .where((element) =>
  //     element.weeksDate == "$formattedDateStart-$formattedDateEnd"  && element.type == Constant.typeWeek
  //         && element.title == titleName)
  //         .toList()
  //         .single;
  //
  //     var weeklyCount = 0.0;
  //     var allDataFromDBDayWise = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  //     if(allDataFromDBDayWise.isNotEmpty){
  //       var dataList = allDataFromDBDayWise
  //           .where((element) =>
  //       element.type == Constant.typeDay &&
  //           element.weeksDate == "$formattedDateStart-$formattedDateEnd" && element.title == titleName)
  //           .toList();
  //       for (int i = 0; i < dataList.length; i++) {
  //         if(titleName == Constant.titleHeartRatePeak){
  //           if(dataList[i].total! > weeklyCount){
  //             weeklyCount = dataList[i].total!;
  //           }
  //         }else {
  //           weeklyCount += dataList[i].total ?? 0.0;
  //         }
  //       }
  //       if(weeklyCount == 0.0){
  //         weekInsertedData.total = null;
  //       }else {
  //         if(titleName == Constant.titleHeartRateRest){
  //           if(weeklyCount != 0.0 && dataList.isNotEmpty) {
  //             weekInsertedData.total = weeklyCount/dataList.length;
  //           }
  //         }else {
  //           weekInsertedData.total = weeklyCount;
  //         }
  //       }
  //     }
  //
  //
  //     weekInsertedData.isSync = false;
  //     await DataBaseHelper.shared.updateActivityData(weekInsertedData);
  //     var getData = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  //     // Debug.printLog("insertUpdateOtherTitleWeekData else......$getData");
  //   }
  // }
  //
  // exportDataFromHealth() async {
  //   // onChangeLoaderVisibility(true);
  //   // Utils.showSnackBar(Get.context!,"Please wait...",true);
  //
  //   // var permissions = [
  //   //   HealthDataAccess.READ_WRITE,
  //   //   HealthDataAccess.READ_WRITE,
  //   //   HealthDataAccess.READ_WRITE,
  //   //   if(Platform.isIOS)HealthDataAccess.READ_WRITE,
  //   // ];
  //   // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  //   //
  //   // await Permission.activityRecognition.request();
  //   // await Permission.location.request();
  //   //
  //   // var requested = false;
  //   // await health.requestAuthorization((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType, permissions: permissions).then((value) =>
  //   // {
  //   //   requested = value,
  //   //   if(!requested){
  //   //     Utils.showSnackBar(Get.context!,"Failed",false)
  //   //   },
  //   //   Debug.printLog("requestAuthorization read and write....$value")
  //   // });
  //
  //   // if(requested) {
  //   // HealthFactory health = HealthFactory(useHealthConnectIfAvailable: true);
  //   var permissions = ( (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType).map((e) => HealthDataAccess.READ_WRITE).toList();
  //
  //   bool? hasPermissions =
  //   await health.hasPermissions((Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType, permissions: permissions);
  //
  //   // if(hasPermissions!){
  //     _showDialogForProgress(Get.context!,false);
  //     var activityDataList = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  //     if(activityDataList.isNotEmpty) {
  //
  //       var nowRead = DateTime.now();
  //       var endDateRead = DateTime(nowRead.year, nowRead.month, nowRead.day+1);
  //       var startDateRead = DateTime(nowRead.year-1, nowRead.month, nowRead.day);
  //       List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
  //           startDateRead, endDateRead, (Platform.isAndroid)?Utils.getAllHealthTypeAndroid:Utils.getAllHealthType);
  //       /*
  //       await health.writeHealthData(100,HealthDataType.STEPS, DateTime(2023,12,02,09,00,00), DateTime(2023,12,02,10,00,00));*/
  //       var dailyData = activityDataList.where((element) => element.type == Constant.typeDay).toList();
  //       Debug.printLog("healthData.....${healthData.length}");
  //       if(healthData.isNotEmpty){
  //         for (int i = 0; i < dailyData.length; i++) {
  //           var dailyDataDateTime = dailyData[i].dateTime;
  //
  //           List<HealthData> stepsListData = [];
  //
  //           if(dailyData[i].title == Constant.titleSteps){
  //             stepsListData = getStepDataFromHealth(healthData,Constant.titleSteps,HealthDataType.STEPS);
  //           }
  //           else if(dailyData[i].title == Constant.titleCalories) {
  //             // if (Platform.isIOS) {
  //               stepsListData = getStepDataFromHealth(
  //                   healthData, Constant.titleCalories,
  //                   HealthDataType.ACTIVE_ENERGY_BURNED);
  //             /*}else if(Platform.isAndroid){
  //               stepsListData = getCaloriesData(
  //                   healthData, Constant.titleCalories,
  //                   HealthDataType.WORKOUT);
  //             }*/
  //           }
  //           else if(dailyData[i].title == Constant.titleHeartRatePeak){
  //             stepsListData = getStepDataFromHealth(healthData,Constant.titleHeartRatePeak,HealthDataType.HEART_RATE);
  //           }
  //           else if(dailyData[i].title == Constant.titleHeartRateRest){
  //             stepsListData = getStepDataFromHealth(healthData,Constant.titleHeartRateRest,HealthDataType.RESTING_HEART_RATE);
  //           }
  //           Debug.printLog("stepsListData.....${stepsListData.length}");
  //
  //           var foundedData = stepsListData
  //               .where((elementHealthData) => Utils.getDateFromFullDate(elementHealthData.dateTime) == dailyDataDateTime).toList();
  //           Debug.printLog("foundedData.....${foundedData.length}  ${dailyData[i].title}  ${dailyData[i].total}");
  //           if(foundedData.isNotEmpty){
  //             Debug.printLog("foundedData title wise... .....${foundedData[0].type}  ${foundedData[0].value}  ${dailyData[i].total}");
  //           }
  //
  //           if(foundedData.isNotEmpty && double.parse(foundedData[0].value.toString()) != (dailyData[i].total?.toInt() ?? 0)){
  //             var diff = dailyData[i].total!.toInt() - double.parse(foundedData[0].value) ;
  //             Debug.printLog("diff found.....$diff  ${dailyData[i].dateTime}  ${foundedData[0].dateTime} ${dailyData[i].title }");
  //
  //             // if (dailyData[i].title == Constant.titleSteps && (diff > 0 || 0 < -diff) ) {
  //             if (dailyData[i].title == Constant.titleSteps && (diff > 0) ) {
  //
  //               Utils.writeStepData(foundedData[0].dateTime, health, diff,i);
  //             }
  //             // else if (dailyData[i].title == Constant.titleCalories && (diff > 0 || 0 < -diff)) {
  //             else if (dailyData[i].title == Constant.titleCalories && (diff > 0)) {
  //               if (Platform.isIOS) {
  //                 Utils.writeCaloriesData(
  //                     foundedData[0].dateTime, health, diff,false,null);
  //               }else if(Platform.isAndroid){
  //                 Utils.writeCaloriesData(
  //                     foundedData[0].dateTime, health, diff,true,foundedData[0].healthWorkoutActivityType!);
  //               }
  //             }
  //             // else if (dailyData[i].title == Constant.titleHeartRatePeak && (diff > 0 || 0 < -diff)) {
  //             // else if (dailyData[i].title == Constant.titleHeartRatePeak && (diff > 0)) {
  //             else if (dailyData[i].title == Constant.titleHeartRatePeak) {
  //               Debug.printLog("Utils.writeHeartRateData...$diff  ${dailyData[i].dateTime}  ${foundedData[0].dateTime} ${dailyData[i].title } $i");
  //               // Utils.writeHeartRateData(foundedData[0].dateTime, health, diff);
  //               Utils.writeHeartRateData(foundedData[0].dateTime, health, dailyData[i].total!.toDouble());
  //             }
  //             // else if (dailyData[i].title == Constant.titleHeartRateRest && (diff > 0 || 0 < -diff)) {
  //             else if (dailyData[i].title == Constant.titleHeartRateRest && (diff > 0 )) {
  //               Debug.printLog("Utils.writeHeartRateRestData...$diff  ${dailyData[i].dateTime}  ${foundedData[0].dateTime} ${dailyData[i].title } $i");
  //               Utils.writeHeartRateRestData(foundedData[0].dateTime, health, diff);
  //             }
  //           }
  //           else if(foundedData.isEmpty){
  //             if(dailyData[i].total != 0 && dailyData[i].total != null){
  //               if(dailyData[i].title == Constant.titleSteps){
  //                 Utils.writeStepData(dailyData[i].dateTime!, health, dailyData[i].total,i);
  //               }else if(dailyData[i].title == Constant.titleCalories){
  //                 if (Platform.isIOS) {
  //                   Utils.writeCaloriesData(
  //                       dailyData[i].dateTime!, health, dailyData[i].total,false,null);
  //                 }else if(Platform.isAndroid){
  //                   Utils.writeCaloriesData(
  //                       dailyData[i].dateTime!, health, dailyData[i].total,true,HealthWorkoutActivityType.WALKING);
  //                 }
  //               }else if(dailyData[i].title == Constant.titleHeartRatePeak){
  //                 Utils.writeHeartRateData(dailyData[i].dateTime!, health, dailyData[i].total);
  //               }else if(dailyData[i].title == Constant.titleHeartRateRest){
  //                 Utils.writeHeartRateRestData(dailyData[i].dateTime!, health, dailyData[i].total);
  //               }
  //               Debug.printLog("extra data .. ${dailyData[i].total}  ${dailyData[i].dateTime} ${dailyData[i].title }");
  //             }
  //           }
  //         }
  //       }
  //       else{
  //         Debug.printLog("dailyData.....${dailyData.length}");
  //         if(dailyData.isNotEmpty){
  //           for (int i = 0; i < dailyData.length; i++) {
  //             if(dailyData[i].title == Constant.titleSteps){
  //               Utils.writeStepData(dailyData[i].dateTime!, health, dailyData[i].total,i);
  //             }else if(dailyData[i].title == Constant.titleCalories){
  //               if (Platform.isIOS) {
  //                 Utils.writeCaloriesData(
  //                     dailyData[i].dateTime!, health, dailyData[i].total,false,null);
  //               }else if(Platform.isAndroid){
  //                 Utils.writeCaloriesData(
  //                     dailyData[i].dateTime!, health, dailyData[i].total,true,HealthWorkoutActivityType.WALKING);
  //               }
  //             }else if(dailyData[i].title == Constant.titleHeartRatePeak){
  //               Utils.writeHeartRateData(dailyData[i].dateTime!, health, dailyData[i].total);
  //             }else if(dailyData[i].title == Constant.titleHeartRateRest){
  //               Utils.writeHeartRateRestData(dailyData[i].dateTime!, health, dailyData[i].total);
  //             }else if(dailyData[i].title == null){
  //               Utils.writeExerciseData(dailyData[i].dateTime!, health, dailyData[i].total);
  //             }
  //           }
  //         }
  //       }
  //     }
  //     Get.back();
  //     Utils.showSnackBar(Get.context!,"Export data successfully",false);
  //   // }else{
  //   //   Utils.showToast(Get.context!, "Not Authorized!!");
  //   // }
  //
  //   // }
  //   /*var rng = Random();
  //   for (var i = 0; i < 150; i++) {
  //     var str = rng.nextDouble() + rng.nextInt(10);
  //     var now = DateTime.now();
  //     Utils.writeCaloriesData(DateTime(now.year,now.month,now.day-2), health, str);
  //     Debug.printLog("Random......${rng.nextDouble() + rng.nextInt(10)}");
  //   }*/
  //
  //
  //
  // }
  //
  // _showDialogForProgress(BuildContext context, bool isImport) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         contentPadding: const EdgeInsets.all(0),
  //         shape: const RoundedRectangleBorder(
  //           borderRadius: BorderRadius.all(
  //             Radius.circular(5.0),
  //           ),
  //         ),
  //         backgroundColor: CColor.white,
  //         content: Container(
  //           padding: EdgeInsets.only(left: Sizes.width_3),
  //           height: Get.height * 0.1,
  //           child: Column(
  //             mainAxisAlignment: MainAxisAlignment.center,
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               // const CircularProgressIndicator(),
  //               Container(
  //                 margin: EdgeInsets.only(bottom: Sizes.height_0_5),
  //                 child: Text(
  //                   "Please wait",
  //                   style: AppFontStyle.styleW700(CColor.black, FontSize.size_12),
  //                 ),
  //               ),
  //               (isImport)
  //                   ? Text("Import data is in progress...",
  //                       style:
  //                           AppFontStyle.styleW400(CColor.black, FontSize.size_10))
  //                   : Text("Export data is in progress...",
  //                       style: AppFontStyle.styleW400(
  //                           CColor.black, FontSize.size_8)),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

}
