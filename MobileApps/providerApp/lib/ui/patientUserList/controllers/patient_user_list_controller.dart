import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientUserListController extends GetxController {

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

  List<PatientDataModel> patientList = [];
  getPatientList() async {
    // showDialogForProgress(Get.context!);

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
    update();
    Debug.printLog("getPatientList....$patientList");
  }

  saveDetail(int index){
    Preference.shared.setString(Preference.patientId, patientList[index].patientId);
    Preference.shared.setString(Preference.patientFName, patientList[index].fName);
    Preference.shared.setString(Preference.patientLName, patientList[index].lName);
    Preference.shared.setString(Preference.patientDob, patientList[index].dob);
    Preference.shared.setString(Preference.patientGender, patientList[index].gender);
    Utils.getAllDbData();
    Get.back();
    update();
  }

  gotoSkipTab(){
    if(isNavigation){
      /*if (kIsWeb) {
        Get.toNamed(AppRoutes.configurationMain,);
      } else {
        Get.toNamed(AppRoutes.integrationScreen, arguments: [false]);
      }*/
      Get.toNamed(AppRoutes.providerIdSelection,arguments: [Constant.profileTypeInitProvider,false]);
    }else{
      Get.back();
    }
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


}
