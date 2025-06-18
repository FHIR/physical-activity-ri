import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/src/date_picker/date_picker_manager.dart';
import '../../../utils/constant.dart';
import '../../goalForm/datamodel/notesData.dart';
import '../../mixed/datamodel/exerciseData.dart';

class ExercisePrescriptionController extends GetxController {

  var selectedStatus = "";
  var selectedStatusFix = "";
  var selectedStatusHint = Constant.pleaseSelect;

  var selectedIntent = "";

  var selectedPriority = "";

  var selectedCodeType = "";
  var selectedCodeTypeHint = Constant.pleaseSelect;

  var textReasonCodeHint = "Please Enter";
  var htmlViewText = "";

  TextEditingController addReferralTypeController = TextEditingController();
  TextEditingController textReasonCode = TextEditingController();
  FocusNode addReferralTypeFocus = FocusNode();
  FocusNode textReasonCodeFocus = FocusNode();
  TextEditingController notesController = TextEditingController();
  FocusNode notesControllersFocus = FocusNode();

  var arguments = Get.arguments;
  List<NoteTableData> notesList = [];
  List<int> referralIdListData = [];
  String codeReferral = "";
  var normalStartDateStr = "Start date";
  DateTime? normalStartDate;
  TextEditingController periodStartDateStr = TextEditingController();
  TextEditingController periodEndDateStr = TextEditingController();

  // var periodStartDateStr = "Start date";
  DateTime? periodStartDate = DateTime.now();
  // var periodEndDateStr = "End date";
  DateTime? periodEndDate;

  ExerciseData exerciseEditedData = ExerciseData();
  var isEdited = false;

  List<String> performerLists = [];


  @override
  void onInit() {
    initValue();
    super.onInit();
  }

  onCancelTap(){
    Get.back();
  }

  onOkTap(){
    update();
    Get.back();
  }

  Future<void> initValue() async {
    if (arguments != null) {
      if (arguments[0] != null) {
        isEdited = true;
        exerciseEditedData = arguments[0];
        if(exerciseEditedData.status != null && exerciseEditedData.status != "") {
          selectedStatus = exerciseEditedData.status.toString();
          selectedStatusFix = exerciseEditedData.status.toString();
          selectedStatusHint = exerciseEditedData.status.toString();
        }

        if(exerciseEditedData.noteList.isNotEmpty){
          notesList = exerciseEditedData.noteList;
        }

        if(exerciseEditedData.textReasonCode != null && exerciseEditedData.textReasonCode != "") {
          textReasonCode.text = exerciseEditedData.textReasonCode.toString();
          selectedCodeType =  exerciseEditedData.textReasonCode ?? "";
        }

        if(exerciseEditedData.priority != null) {
          if( exerciseEditedData.priority != "Null"){
            selectedPriority = exerciseEditedData.priority.toString();
          }else{
            selectedPriority = Utils.priorityList[0];
          }
        }else{
          selectedPriority = Utils.priorityList[0];
        }

        if(exerciseEditedData.referralScope != null) {
          selectedCodeType = exerciseEditedData.referralScope.toString();
          selectedCodeTypeHint = exerciseEditedData.referralScope.toString();
          codeReferral = exerciseEditedData.referralCode ?? "" ;
        }

        if(exerciseEditedData.isPeriodDate){
          /// Found PeriodDate
          if(exerciseEditedData.startDate != null){
            periodStartDate = exerciseEditedData.startDate;
            periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodStartDate!);
          }

          if(exerciseEditedData.endDate != null){
            periodEndDate = exerciseEditedData.endDate;
            periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
          }

        }else{
          if(exerciseEditedData.startDate != null){
            normalStartDate = exerciseEditedData.startDate;
            normalStartDateStr = DateFormat(Constant.commonDateFormatDdMmYyyy).format(normalStartDate!);
          }
        }
        await Debug.printLog("Utils...codeList....${Utils.codeList}  $exerciseEditedData");
        update();
        exerciseEditedData.readonly = false;
      }
    }
  }
}

