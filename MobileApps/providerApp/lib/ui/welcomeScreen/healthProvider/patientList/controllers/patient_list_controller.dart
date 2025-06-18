import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../../../../dataModel/patientDataModel.dart';
import '../../../../../db_helper/box/activity_data.dart';
import '../../../../../db_helper/box/monthly_log_data.dart';
import '../../../../../utils/constant.dart';
import '../../../../../utils/utils.dart';

class PatientListController extends GetxController {

  var isShowLoader = false;
  var argument = Get.arguments;
  bool isNavigation = false;
  BuildContext? context;

  @override
  void onInit() {
    if(argument != null){
      if(argument[0] != null){
        isNavigation = argument[0];
      }
    }
    getPatientList();
    super.onInit();
  }

  bool isShowProgress = false;
  List<PatientDataModel> patientList = [];

  onChangeProgress(bool value){
    isShowProgress = value;
    update();
  }
  getPatientList() async {
    // showDialogForProgress(Get.context!);

    onChangeProgress(true);
    var listData = await PaaProfiles.getPatientList();
    if (listData.resourceType == R4ResourceType.Bundle) {
      if (listData != null && listData.total != null) {
        for (int i = 0; i < listData.total.valueNumber.toInt(); i++) {
          var patientData = PatientDataModel();
          var data = listData.entry[i];
          var id;
          if (data.resource.id != null) {
            id = data.resource.id.toString();
          }
          var lName = data.resource.name[0].family.toString();
          var fName = data.resource.name[0].given[0].toString();
          var gender = data.resource.gender.toString();
          var dob = data.resource.birthDate.toString();

          patientData.patientId = id;
          patientData.fName = fName;
          patientData.lName = lName;
          patientData.dob = dob;
          patientData.gender = gender;
          patientList.add(patientData);
          Debug.printLog("patient info....$fName  $lName  $gender  $dob  $id");
        }
      }
    }
    // Get.back();
    onChangeProgress(false);
    // update();
    Debug.printLog("getPatientList....$patientList");
  }


  gotoSkipTab(){
    // if(Preference.shared.getString(Preference.patientId)!.isNotEmpty){
    //   Get.toNamed(AppRoutes.configurationMain,);
    // }
    if (kIsWeb) {
      Get.toNamed(AppRoutes.configurationMain,);
    } else {
      Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
    }
    /*if(isNavigation){
      if (kIsWeb) {
        Get.toNamed(AppRoutes.configuration, arguments: [true]);
      } else {
        Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
      }
    }else{
      Get.back();
    }
*/
    update();
  }

  showDialogForProgress(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          backgroundColor: CColor.white,
          content: Container(
            padding: EdgeInsets.only(left: Sizes.width_3),
            height: Get.height * 0.1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // const CircularProgressIndicator(),
                Container(
                  margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                  child: Text(
                    "Please wait",
                    style: AppFontStyle.styleW700(CColor.black, FontSize.size_12),
                  ),
                ),
                Text("patient data is in progress...",
                    style:
                    AppFontStyle.styleW400(CColor.black, FontSize.size_10))

              ],
            ),
          ),
        );
      },
    );
  }

  saveDetail(int index) async {
    Preference.shared.setString(Preference.patientId, patientList[index].patientId);
    Preference.shared.setString(Preference.patientFName, patientList[index].fName);
    Preference.shared.setString(Preference.patientLName, patientList[index].lName);
    Preference.shared.setString(Preference.patientDob, patientList[index].dob);
    Preference.shared.setString(Preference.patientGender, patientList[index].gender);
    Utils.getAllDbData();
    update();
    var currentYear = DateTime.now().year;
    var list = Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList().where((element) => element.patientId == Utils.getPatientId()
        && element.year == currentYear).toList();

    var listActivity = Hive
        .box<ActivityTable>(Constant.tableActivity)
        .values
        .toList().where((element) => element.patientId == Utils.getPatientId()
        && ((element.dateTime == null)?DateTime.now().year : element.dateTime!.year) == currentYear).toList();

    // if(patientList[index].patientId != "" && (list.isEmpty || listActivity.isEmpty) &&
    // if(patientList[index].patientId != "" &&
    //     Utils.getAPIEndPoint() != "" && Utils.getPatientId() != "") {
    //   await Utils.getSetMonthActivityData(patientList[index].patientId.toString(),currentYear.toString());
    //   // await getMonthActivityList(patientList[index].patientId.toString(),currentYear.toString());
    // }
    // await Utils.setMonthlyAndActivityData(currentYear.toString(),isFromActivity: true,isFromMonth: true);
  }
}
