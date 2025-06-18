import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../../db_helper/box/care_plan_form_data.dart';
import '../../../utils/debug.dart';
import '../../goalForm/datamodel/notesData.dart';

class CarePlanController extends GetxController {
  var selectedStatus = "";
  var selectedStatusHint = Constant.pleaseSelect;
  TextEditingController onSetDateController = TextEditingController();
  TextEditingController abatementController = TextEditingController();
  TextEditingController textFirstController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  FocusNode textFirstFocus = FocusNode();
  FocusNode notesControllersFocus = FocusNode();
  // List<GoalTableData> createdGoals = [];
  // List<GoalSyncDataModel> createdGoals = [];
  List createdGoals = [];

  var selectedCarePlanGoalStatus = "";

  var selectedDateFormat = DateTime.now();
  // var periodStartDateStr = "";
  TextEditingController periodEndDateStr = TextEditingController();
  TextEditingController periodStartDateStr = TextEditingController();

  // var periodEndDateStr = "End Date";
  var selectTextFirst = "Enter Text";
  DateTime? periodStartDate = DateTime.now();
  DateTime? periodEndDate;

  var editedCarePlanData = CarePlanTableData();
  var arguments = Get.arguments;
  var isEdited = false;
  var isAdd = false;
  List<NotesData> notesList = [];
  List<NoteTableData> noteDatabaseList = [];

  @override
  void onInit() {
    super.onInit();
    if (arguments != null) {
      if (arguments[0] != null) {
        editedCarePlanData = arguments[0];
        if(arguments[1] != null){
          createdGoals = arguments[1];
          getGoalList();
        }
        isEdited = true;
        getNoteList(editedCarePlanData.notesData);
        if (editedCarePlanData.text != null) {
          textFirstController.text = editedCarePlanData.text ?? "";
          Debug.printLog("editedCarePlanData.text....${editedCarePlanData.text}");
        }

        if (editedCarePlanData.status != null) {
          selectedStatus = editedCarePlanData.status ?? "";
        }

        if (editedCarePlanData.startDate != null) {
          periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(editedCarePlanData.startDate!);
          periodStartDate = editedCarePlanData.startDate!;
        }

        if (editedCarePlanData.endDate != null) {
          periodEndDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
              .format(editedCarePlanData.endDate!);
          periodEndDate = editedCarePlanData.endDate!;
        }

        if (editedCarePlanData.goal == null) {
          selectedCarePlanGoalStatus = Utils.multipleGoalsListString[0];
        }
        if (editedCarePlanData.goal != null) {
          selectedCarePlanGoalStatus = editedCarePlanData.goal ?? "";
        }
        editedCarePlanData.readOnly = false;
      } else {
        selectedStatus = Utils.statusInFoList[0];
        selectedCarePlanGoalStatus = Utils.multipleGoalsListString[0];
        editedCarePlanData.readOnly = false;
        periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
            .format(periodStartDate!);
      }
      if (editedCarePlanData.goalObjectId != null) {
        if (editedCarePlanData.goalObjectId!.isNotEmpty) {
          for (int i = 0; i < editedCarePlanData.goalObjectId!.length; i++) {
            var objectId = editedCarePlanData.goalObjectId![i];
            var matchedIndex = createdGoals
                .indexWhere((element) => element.objectId == objectId)
                .toInt();
            if (matchedIndex != -1) {
              createdGoals[matchedIndex].isSelected = true;
            }
          }
        }
      }
    } else {
      periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(periodStartDate!);
      selectedStatus = Utils.statusInFoList[0];
      selectedCarePlanGoalStatus = Utils.multipleGoalsListString[0];
    }
  }

  getNoteList(List<NoteTableData> noteList) async {

    if (noteList.isNotEmpty) {
      for (int i = 0; i < noteList.length; i++) {
        var data = NotesData();
        data.notes = noteList[i].notes;
        data.author = noteList[i].author;
        data.readOnly = noteList[i].readOnly;
        data.isDelete = noteList[i].isDelete;
        data.date = noteList[i].date;
        data.noteId = noteList[i].key;
        notesList.add(data);
      }
    }
    update();
  }

  editNoteDataController(String value) {
    notesController.text = value;
    update();
  }

  /*Local Storage in add Data*/
  addNotesData(String text, bool isEditNote, int index) async {
    if (isEditNote) {
      notesList[index].notes = text;
    } else {
      notesList.add(NotesData(
          isDelete: false,
          author: Utils.getFullName(),
          notes: text,
          date: DateTime.now()));
    }
    notesController.clear();
    Get.back();
    update();
  }

  /*================================*/

  onChangePeriodDate(bool isStartDate,
      DateRangePickerSelectionChangedArgs dateRangePickerSelectionChangedArgs) {
    if (isStartDate) {
      periodStartDate = dateRangePickerSelectionChangedArgs.value;

      periodStartDateStr.text = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(periodStartDate!);
    } else {
      periodEndDate = dateRangePickerSelectionChangedArgs.value;
      periodEndDateStr.text =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(periodEndDate!);
    }
    update();
  }

  void onChangeStatus(String value) {
    selectedStatus = value;
    update();
  }

  void onChangeMultipleGoalStatus(value) {
    selectedCarePlanGoalStatus = value;
    update();
  }

  deleteNoteListData(int? noteId, int index) async {
    notesList.removeAt(index);

    if (noteId != null) {
      await DataBaseHelper.shared.deleteSingleNoteData(noteId);
    }
    update();
  }

  insertUpdateData() async {
    if (textFirstController.text.isNotEmpty) {
      var textValue = textFirstController.text;
      var status = selectedStatus;
      var goalStatus = selectedCarePlanGoalStatus;

      if (isEdited) {
        editedCarePlanData.text = textValue;
        editedCarePlanData.status = status;
        editedCarePlanData.startDate = periodStartDate;
        editedCarePlanData.endDate = periodEndDate;
        editedCarePlanData.goal = goalStatus;
        editedCarePlanData.readOnly = false;
        editedCarePlanData.isDelete = false;
        editedCarePlanData.isSync = false;

        var selectedGoalData =
            createdGoals.where((element) => element.isSelected).toList();
        List<String> goalObjectIdList = [];
        if (selectedGoalData.isNotEmpty) {
          for (int i = 0; i < selectedGoalData.length; i++) {
            goalObjectIdList.add(selectedGoalData[i].objectId.toString());
          }
        }
        editedCarePlanData.goalObjectId = goalObjectIdList;

        await DataBaseHelper.shared.updateCarePlanData(editedCarePlanData);
        var noteDataList =
            Hive.box<NoteTableData>(Constant.tableNoteData).values.toList();
        if (noteDataList.isNotEmpty && notesList.isNotEmpty) {
          for (int i = 0; i < notesList.length; i++) {
            if (notesList[i].carePlanId != null) {
              NoteTableData noteData = await DataBaseHelper.shared
                  .getNoteDataID(notesList[i].noteId!);
              noteData.notes = notesList[i].notes;
              noteData.author = notesList[i].author;
              noteData.readOnly = notesList[i].readOnly!;
              noteData.date = notesList[i].date;
              noteData.isDelete = true;
              noteData.carePlanId = editedCarePlanData.key;
              await DataBaseHelper.shared.updateNoteData(noteData);
            } else {
              var noteTableData = NoteTableData();

              noteTableData.notes = notesList[i].notes;
              noteTableData.author = notesList[i].author;
              noteTableData.readOnly = false;
              noteTableData.date = notesList[i].date;
              noteTableData.isDelete = true;
              noteTableData.carePlanId = editedCarePlanData.key;
              await DataBaseHelper.shared.insertNoteData(noteTableData);
            }
          }
        } else {
          for (int i = 0; i < notesList.length; i++) {
            var noteTableData = NoteTableData();

            noteTableData.notes = notesList[i].notes;
            noteTableData.author = notesList[i].author;
            noteTableData.readOnly = false;
            noteTableData.date = notesList[i].date;
            noteTableData.isDelete = true;
            noteTableData.carePlanId = editedCarePlanData.key;
            await DataBaseHelper.shared.insertNoteData(noteTableData);
          }
        }

        Utils.showToast(Get.context!, "Care plan update successfully");
      } else {
        var data = CarePlanTableData();

        data.text = textValue;
        data.status = status;
        data.startDate = periodStartDate;
        data.endDate = periodEndDate;
        data.goal = goalStatus;
        data.isSync = false;
        if (Utils.getPrimaryServerData() != null) {
          data.qrUrl = Utils.getPrimaryServerData()!.url;
          data.token = Utils.getPrimaryServerData()!.authToken;
          data.clientId = Utils.getPrimaryServerData()!.clientId;
          data.patientId = Utils.getPrimaryServerData()!.patientId;
          data.patientName =
              "${Utils.getPrimaryServerData()!.patientFName} ${Utils.getPrimaryServerData()!.patientLName}";
        }

        var selectedGoalData =
            createdGoals.where((element) => element.isSelected).toList();
        List<String> goalObjectIdList = [];
        if (selectedGoalData.isNotEmpty) {
          for (int i = 0; i < selectedGoalData.length; i++) {
            goalObjectIdList.add(selectedGoalData[i].objectId.toString());
          }
        }
        data.goalObjectId = goalObjectIdList;

        var insertId = await DataBaseHelper.shared.insertCarePlanData(data);
        for (int i = 0; i < notesList.length; i++) {
          var noteTableData = NoteTableData();

          var nowDate = DateTime.now();
          noteTableData.notes = notesList[i].notes;
          noteTableData.author = notesList[i].author;
          noteTableData.readOnly = false;
          noteTableData.date =
              DateTime(nowDate.year, nowDate.month, nowDate.day);
          noteTableData.isDelete = true;
          noteTableData.carePlanId = insertId;
          await DataBaseHelper.shared.insertNoteData(noteTableData);
        }

        Utils.showToast(Get.context!, "Care plan added successfully");
      }
      Get.back();
      // String? qrUrl = Preference.shared.getString(Preference.qrUrlData) ?? "";
      // if (qrUrl != "") {
      if (Utils.getServerListPreference().isNotEmpty) {
        ///Day per week
        await Syncing.carePlanSyncingData(true, []);
      }
    } else {
      Utils.showToast(Get.context!, "Please set write text");
    }
  }

  getGoalList() {
/*    createdGoals = Hive.box<GoalTableData>(Constant.tableGoal)
        .values
        .toList()
        .where((element) =>
            element.patientId == Utils.getPatientId() && element.objectId != "")
        .toList();*/

    for (int i = 0; i < createdGoals.length; i++) {
      createdGoals[i].isSelected = false;
    }
    update();
  }

  onCancelTap() {
    Get.back();
  }

  onOkTap() {
    update();
    Get.back();
  }

  // void onChangeGoalSelect(GoalTableData goalData, int index) {
  void onChangeGoalSelect(GoalSyncDataModel goalData, int index) {
    createdGoals[index].isSelected = !createdGoals[index].isSelected;
  }
}
