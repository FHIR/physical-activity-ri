import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import 'package:banny_table/ui/home/home/controllers/home_controllers.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class ConditionController extends GetxController {
  var selectedVerificationStatusHint = Constant.pleaseSelect;
  var selectedVerificationStatus = "";
  var selectTextFirst = "Please enter";
  TextEditingController onSetDateController = TextEditingController();
  TextEditingController abatementController = TextEditingController();

  TextEditingController addContitionTypeController = TextEditingController();
  TextEditingController addContitionCodeController = TextEditingController();
  TextEditingController textDetalisController = TextEditingController();
  FocusNode addConditionTypeFocus = FocusNode();
  FocusNode addConditionCodeFocus = FocusNode();
  FocusNode textFirstFocus = FocusNode();
  // FocusNode notesControllersFocus = FocusNode();

  DateTime? selectedDateFormatAbs;
  DateTime? selectedDateFormatOnSet ;
  var selectedOnSetDateStr = "";
  var selectedAbatementDateStr = "";
  var selectedCodeTypeCondition = "";
  var selectedCodeTypeConditionHint = Constant.pleaseSelect;
  var selectedCodeCondition = "";
  var editedConditionData = ConditionSyncDataModel();
  var arguments = Get.arguments;
  var isEdited = false;
  var isAdd = false;

  @override
  void onInit() {
    if (arguments != null) {
      if (arguments[0] != null) {
        editedConditionData = arguments[0];
        isEdited = true;
        if (editedConditionData.verificationStatus != null && editedConditionData.verificationStatus != "") {
          selectedVerificationStatus = (editedConditionData.verificationStatus != "null") ? editedConditionData.verificationStatus ?? Utils.verificationStatusList[0]: Utils.verificationStatusList[0];
          selectedVerificationStatusHint = (editedConditionData.verificationStatus != "null") ? editedConditionData.verificationStatus ?? Constant.pleaseSelect: Constant.pleaseSelect;
        }else{
          selectedVerificationStatusHint =  Constant.pleaseSelect;
          selectedVerificationStatus = Utils.verificationStatusList[0];
        }


        if (editedConditionData.onset != null) {
          selectedOnSetDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(editedConditionData.onset!);
          onSetDateController.text = selectedOnSetDateStr.toString();
          selectedDateFormatAbs = editedConditionData.onset!;
        }
        if (editedConditionData.detalis != null) {
          textDetalisController.text = editedConditionData.detalis.toString();
        }

        if (editedConditionData.abatement != null) {
          selectedAbatementDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(editedConditionData.abatement!);
          abatementController.text = selectedAbatementDateStr.toString();
          selectedDateFormatOnSet = editedConditionData.abatement!;
        }
        /// Pending this Condition for Api in add...


        if(editedConditionData.code != null && editedConditionData.code != "") {
          selectedCodeCondition = editedConditionData.code.toString();
          selectedCodeTypeCondition = editedConditionData.display.toString();
          selectedCodeTypeConditionHint = editedConditionData.display.toString();
          if(Utils.conditionDropDown.where((element) => element.display.toLowerCase() == selectedCodeTypeCondition.toLowerCase() && element.code == selectedCodeCondition).toList().isEmpty){
            Utils.conditionDropDown.add(ConditionCodeDataModel(display: selectedCodeTypeCondition,code: selectedCodeCondition));
          }
          Utils.conditionDropDown = Utils.conditionDropDown.toSet().toList();
        }
        else{
          selectedCodeTypeConditionHint = Constant.pleaseSelect;
        }

        editedConditionData.readOnly = false;
      } else {
        editedConditionData.readOnly = false;

        selectedVerificationStatusHint =  Constant.verificationStatusConfirmed;
        selectedVerificationStatus = Constant.verificationStatusConfirmed;
      }
    } else {
      editedConditionData.readOnly = false;

      selectedVerificationStatusHint =  Constant.verificationStatusConfirmed;
      selectedVerificationStatus = Constant.verificationStatusConfirmed;
    }

    super.onInit();
  }

  void onSelectionOnsetChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    selectedDateFormatOnSet = args.value;
    selectedOnSetDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(selectedDateFormatOnSet!);
    onSetDateController.text = selectedOnSetDateStr;
    update();
  }

  void onSelectionAbatementChangedDatePicker(DateRangePickerSelectionChangedArgs args) {
    selectedDateFormatAbs = args.value;
    selectedAbatementDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(selectedDateFormatAbs!);
    abatementController.text = selectedAbatementDateStr;
    update();
  }

  insertUpdateData() async {

    String conditionId = "";
    var detalis = textDetalisController.text;
    var verification = selectedVerificationStatus;
    // DateTime onSetDate = selectedDateFormatOnSet!;
    String display = selectedCodeTypeCondition ;
    String code = selectedCodeCondition;

    if(selectedCodeTypeCondition != ""){
      if(selectedVerificationStatus != ""){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Utils.showDialogForProgress(
              Get.context!, Constant.txtPleaseWait, Constant.dataSyncingCondition);
        });
        if (isEdited) {
          if (selectedDateFormatOnSet != null) {
            editedConditionData.onset = selectedDateFormatOnSet!;
          }
          editedConditionData.verificationStatus = verification;
          if (selectedDateFormatAbs != null) {
            editedConditionData.abatement = selectedDateFormatAbs;
          }
          editedConditionData.isSync = false;
          editedConditionData.display = display;
          editedConditionData.detalis = detalis;
          editedConditionData.code = code;
          editedConditionData.text = display;
          editedConditionData.providerId = editedConditionData.providerId;
          editedConditionData.providerName = editedConditionData.providerName;
          // editedConditionData.patientId = Utils.getPatientId();
          // await DataBaseHelper.shared.updateConditionData(editedConditionData);
          List<ConditionSyncDataModel> allSyncingDataList = [editedConditionData];
          String conditionId = "";
          if(Utils.getPrimaryServerData()!.url != ""){
            conditionId = await Syncing.callApiForConditionSyncData(allSyncingDataList);
            // editedConditionData.objectId = conditionId;
            Debug.printLog("conditionId........$conditionId");
          }

          // var noteDataList = Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();

          Utils.showToast(Get.context!, "Condition update successfully");
        }
        else {
          var data = ConditionSyncDataModel();
          // data.patientId = Utils.getPatientId();
          data.verificationStatus = verification;
          if (selectedDateFormatAbs != null) {
            data.abatement = selectedDateFormatAbs;
          }
          if(selectedDateFormatOnSet != null){
            data.onset = selectedDateFormatOnSet;
          }
          data.isSync = false;
          data.display = display;
          data.code = code;
          data.detalis = detalis;
          data.text = display;
          if (Utils.getPrimaryServerData() != null) {
            data.qrUrl = Utils.getPrimaryServerData()!.url;
            data.token = Utils.getPrimaryServerData()!.authToken;
            data.clientId = Utils.getPrimaryServerData()!.clientId;
            data.patientId = Utils.getPrimaryServerData()!.patientId;
            data.providerId = Utils.getPrimaryServerData()!.providerId;
            data.providerName =
            "${Utils.getPrimaryServerData()!.providerFName}${Utils.getPrimaryServerData()!.providerLName}";
            data.patientName =
            "${Utils.getPrimaryServerData()!.patientFName}${Utils.getPrimaryServerData()!.patientLName}";
          }
          // await DataBaseHelper.shared.insertConditionData(data);
          if (Utils.getPrimaryServerData()!.url != "") {
            List<ConditionSyncDataModel> allSyncingDataList = [data];
            conditionId = await Syncing.callApiForConditionSyncData(allSyncingDataList);
            data.objectId = conditionId;
            if(conditionId != "null" && conditionId != "" && conditionId != "NULL" && conditionId != "Null") {
              HomeControllers homeControllers = Get.find();
              homeControllers.conditionDataListLocal.add(data);
              homeControllers.conditionDataList.add(data);
              homeControllers.updateMethod();
            }
          }
          if(conditionId != "null" && conditionId != "" && conditionId != "NULL" && conditionId != "Null") {
            Utils.showToast(Get.context!, "Condition created successfully");
          }
        }


        Get.back();
        if (isEdited) {
          Get.back(result: editedConditionData);
        }else{
          if(conditionId == "null" || conditionId == "" || conditionId == "NULL" || conditionId == "Null"){
            Utils.showErrorDialog(Get.context!,Constant.txtError,Constant.txtErrorConditionNotCreated);
          }else{
            Get.back();
          }
        }

      }else{
        Utils.showToast(Get.context!, "Please select a verification");
      }
    }else{
      Utils.showToast(Get.context!, "Please select a condition");
    }


  }

  void onChangeVerificationStatus(String value) {
    selectedVerificationStatus = value;
    update();
  }

  void addNewCodeDataIntoList(String codeType,String code) {
    if(codeType != ""){
      if(code != ""){
        Utils.conditionDropDown.add(ConditionCodeDataModel(display:codeType, code: code ), );
        Get.back();
        addContitionTypeController.clear();
        addContitionCodeController.clear();
      }else{
        Utils.showToast(Get.context!, "Please Enter a Condition Code");
      }
    }else{
      Utils.showToast(Get.context!, "Please Enter a Condition Type");
    }
    update();
  }

  void onChangeCode(int index) {
    selectedCodeTypeCondition = Utils.conditionDropDown[index].display ?? "";
    selectedCodeCondition = Utils.conditionDropDown[index].code ?? "";
    selectedCodeTypeConditionHint = Utils.conditionDropDown[index].display ?? "Please select";
    Get.back();
    update();
  }

  checkValidationForToken() async {
    await Utils.isExpireTokenAPICall(Constant.screenTypeHome,(value) async {
      if(!value){
        await insertUpdateData();
      }
    }).then((value) async {
      if(!value){
        await insertUpdateData();
      }
    });
  }
}
