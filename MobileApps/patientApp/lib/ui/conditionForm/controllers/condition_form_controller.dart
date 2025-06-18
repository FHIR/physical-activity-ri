import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ConditionController extends GetxController {
  var selectedConditionStatus = "";
  var selectedVerificationStatus = "";
  TextEditingController onSetDateController = TextEditingController();
  TextEditingController abatementController = TextEditingController();
  var selectedDateFormat = DateTime.now();
  var selectedDateFormatOnSet = DateTime.now();
  var selectedOnSetDateStr = "";
  var selectedAbatementDateStr = "";
  var editedConditionData = ConditionTableData();
  var arguments = Get.arguments;
  var isEdited = false;
  var isAdd = false;
  TextEditingController textDetalisController = TextEditingController();
  FocusNode textFirstFocus = FocusNode();
  var selectTextFirst = "Enter a Details";


  @override
  void onInit() {
    if (arguments != null) {
      if (arguments[0] != null) {
        editedConditionData = arguments[0];
        isEdited = true;
        if (editedConditionData.verificationStatus != null) {
          try {
            selectedConditionStatus =
                          editedConditionData.display ?? "";
          } catch (e) {
            selectedConditionStatus = "";
          }

          try {
            selectedVerificationStatus =
                editedConditionData.verificationStatus ?? "";
          } catch (e) {
            selectedVerificationStatus = "";
          }
          // selectedVerificationStatus =
          //     editedConditionData.verificationStatus ?? "";
        }
        if (editedConditionData.detalis != null && editedConditionData.detalis != "") {
          textDetalisController.text = editedConditionData.detalis.toString();
        }

        if (editedConditionData.onset != null) {
          selectedOnSetDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(editedConditionData.onset!);
          onSetDateController.text = selectedOnSetDateStr.toString();
          selectedDateFormat = editedConditionData.onset!;
        }

        if (editedConditionData.abatement != null) {
          selectedAbatementDateStr =
              DateFormat(Constant.commonDateFormatDdMmYyyy)
                  .format(editedConditionData.abatement!);
          abatementController.text = selectedAbatementDateStr.toString();
          selectedDateFormat = editedConditionData.abatement!;
        }

        editedConditionData.readOnly = false;
      } else {
        selectedVerificationStatus = Utils.verificationStatusList[0];
        editedConditionData.readOnly = false;
      }
    } else {
      selectedVerificationStatus = Utils.verificationStatusList[0];
      editedConditionData.readOnly = false;
    }

    super.onInit();
  }

  void onSelectionOnsetChangedDatePicker(
      DateRangePickerSelectionChangedArgs args) {
    selectedDateFormatOnSet = args.value;
    selectedOnSetDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(selectedDateFormatOnSet);
    onSetDateController.text = selectedOnSetDateStr;
    update();
  }

  void onSelectionAbatementChangedDatePicker(
      DateRangePickerSelectionChangedArgs args) {
    selectedDateFormat = args.value;
    selectedAbatementDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(selectedDateFormat);
    abatementController.text = selectedAbatementDateStr;
    update();
  }

  insertUpdateData() async {
    var verification = selectedVerificationStatus;
    DateTime onSetDate = selectedDateFormatOnSet;
    DateTime abatementOnDate = selectedDateFormat;

    if (isEdited) {
      editedConditionData.onset = onSetDate;
      editedConditionData.verificationStatus = verification;
      editedConditionData.abatement = abatementOnDate;
      editedConditionData.isSync = false;
      await DataBaseHelper.shared.updateConditionData(editedConditionData);
      Utils.showToast(Get.context!, "Condition update successfully");
    } else {
      var data = ConditionTableData();
      data.verificationStatus = verification;
      data.abatement = abatementOnDate;
      data.onset = onSetDate;
      if (Utils.getPrimaryServerData() != null) {
        data.qrUrl = Utils.getPrimaryServerData()!.url;
        data.token = Utils.getPrimaryServerData()!.authToken;
        data.clientId = Utils.getPrimaryServerData()!.clientId;
        data.patientId = Utils.getPrimaryServerData()!.patientId;
        data.patientName =
            "${Utils.getPrimaryServerData()!.patientFName} ${Utils.getPrimaryServerData()!.patientLName}";
      }
      data.isSync = false;
      await DataBaseHelper.shared.insertConditionData(data);
      Utils.showToast(Get.context!, "Condition added successfully");
    }
    Get.back();
    if (Utils.getAPIEndPoint() != "") {
      await Syncing.conditionSyncingData(true, []);
    }
  }

  void onChangeVerificationStatus(String value) {
    selectedVerificationStatus = value;
    update();
  }
}
