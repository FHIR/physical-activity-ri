import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/identifier_data.dart';
import 'package:banny_table/db_helper/box/log_table_data.dart';
import 'package:banny_table/db_helper/box/monthly_log_data.dart';
import 'package:banny_table/db_helper/box/notes_data.dart';
import 'package:banny_table/db_helper/box/routing_referral_data.dart';
import 'package:banny_table/db_helper/box/server_detail_data.dart';
import 'package:banny_table/db_helper/box/server_detail_data_mod_min.dart';
import 'package:banny_table/db_helper/box/server_detail_data_vig_min.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../utils/constant.dart';
import 'box/activity_data.dart';
import 'box/referral_data.dart';

class DataBaseHelper {

  static final DataBaseHelper _dataBaseHelper = DataBaseHelper._internal();

  factory DataBaseHelper() {
    return _dataBaseHelper;
  }

  DataBaseHelper._internal();

  static DataBaseHelper get shared => _dataBaseHelper;

  Future initialize() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ActivityTableAdapter());
    Hive.registerAdapter(MonthlyLogTableDataAdapter());
    Hive.registerAdapter(GoalTableDataAdapter());
    Hive.registerAdapter(ReferralDataAdapter());
    Hive.registerAdapter(NoteTableDataAdapter());
    Hive.registerAdapter(RoutingReferralDataAdapter());
    Hive.registerAdapter(ConditionTableDataAdapter());
    Hive.registerAdapter(CarePlanTableDataAdapter());
    Hive.registerAdapter(ToDoTableDataAdapter());
    Hive.registerAdapter(LogTableDataAdapter());
    Hive.registerAdapter(IdentifierTableAdapter());
    Hive.registerAdapter(ServerDetailDataTableAdapter());
    Hive.registerAdapter(ServerDetailDataModMinTableAdapter());
    Hive.registerAdapter(ServerDetailDataVigMinTableAdapter());

    await _openBoxes();
  }

  Box? dbQRCodeBox;
  Box? dbMonthlyLogCodeBox;
  Box? dbGoalCodeBox;
  Box? dbReferralCodeBox;
  Box? dbReferralRoutesCodeBox;
  Box? dbNoteDataCodeBox;
  Box? dbConditionDataCodeBox;
  Box? dbCarePlanCodeBox;
  Box? dbToDoCodeBox;
  Box? dbLogBox;


  Future _openBoxes() async {
    dbQRCodeBox = await Hive.openBox<ActivityTable>(Constant.tableActivity);
    dbMonthlyLogCodeBox = await Hive.openBox<MonthlyLogTableData>(Constant.tableMonthlyLog);
    dbGoalCodeBox = await Hive.openBox<GoalTableData>(Constant.tableGoal);
    dbReferralCodeBox = await Hive.openBox<ReferralData>(Constant.tableReferral);
    dbReferralRoutesCodeBox = await Hive.openBox<RoutingReferralData>(Constant.tableReferralRoute);
    dbNoteDataCodeBox = await Hive.openBox<NoteTableData>(Constant.tableNoteData);
    dbConditionDataCodeBox = await Hive.openBox<ConditionTableData>(Constant.tableCondition);
    dbCarePlanCodeBox = await Hive.openBox<CarePlanTableData>(Constant.tableCarePlan);
    dbToDoCodeBox = await Hive.openBox<ToDoTableData>(Constant.tableToDoList);
    dbLogBox = await Hive.openBox<LogTableData>(Constant.tableLog);
  }

  Future<int> insertActivityData(ActivityTable qrData) {
    qrData.patientId = Utils.getPatientId();
    return dbQRCodeBox!.add(qrData);
  }

  getActivityData(int id) {
    return dbQRCodeBox!.get(id);
  }

  updateActivityData(ActivityTable qrData) {
    qrData.patientId = Utils.getPatientId();
    dbQRCodeBox!.put(qrData.key, qrData);
  }

  updateActivityDataKeyWise(ActivityTable activityData,int id) {
    dbQRCodeBox!.put(id, activityData);
  }

  updateAllActivityData(Map map) {
    dbQRCodeBox!.putAll(map);
  }

  deleteSingleActivityData(int index) {
    dbQRCodeBox!.delete(index);
  }

  clearedAllDatabase() async {
    dbQRCodeBox!.clear();
    dbMonthlyLogCodeBox!.clear();
  }

  /*=====================================================================Monthly data========================================================================================================================*/
  Future<int> insertMonthlyData(MonthlyLogTableData qrData) {
    qrData.patientId = Utils.getPatientId();
    Debug.printLog("add Complete");
    return dbMonthlyLogCodeBox!.add(qrData);
  }

  getMonthlyData(int id) {
    return dbMonthlyLogCodeBox!.get(id);
  }

  updateMonthlyData(MonthlyLogTableData monthlyData) {
    monthlyData.patientId = Utils.getPatientId();
    Debug.printLog("updateMonthlyData.......${monthlyData.key}  ${monthlyData.dayPerWeekValue}  ${monthlyData.avgMinValue}  ${monthlyData.avgMInPerWeekValue}  ${monthlyData.strengthValue}");
    dbMonthlyLogCodeBox!.put(monthlyData.key, monthlyData);
  }

  updateMonthlyDataKeyWise(MonthlyLogTableData qrData,int key) {
    dbMonthlyLogCodeBox!.put(key, qrData);
  }

  updateAllMonthlyData(Map map) {
    dbMonthlyLogCodeBox!.putAll(map);
  }

  deleteSingleMonthlyData(int index) {
    dbMonthlyLogCodeBox!.delete(index);
  }

  /*=====================================================================Goal data========================================================================================================================*/
  Future<int> insertGoalData(GoalTableData qrData) {
    // qrData.patientId = Utils.getPatientId();
    return dbGoalCodeBox!.add(qrData);
  }

  getGoalData() {
    return dbGoalCodeBox!.get("");
  }

  getGoalDataById(int id) {
    return dbGoalCodeBox!.get(id);
  }

  updateGoalData(GoalTableData goalData) {
    // goalData.patientId = Utils.getPatientId();
    dbGoalCodeBox!.put(goalData.key, goalData);
  }

  updateGoalDataKeyWiseData(GoalTableData goalData,int key) {
    // goalData.patientId = Utils.getPatientId();
    dbGoalCodeBox!.put(key, goalData);
  }

  updateAllGoalData(Map map) {
    dbGoalCodeBox!.putAll(map);
  }

  deleteSingleGoalData(int index) {
    dbGoalCodeBox!.delete(index);
  }


/*============================================ routing referral =========================================================*/
  Future<int> insertReferralRouteData(RoutingReferralData qrData) {
    qrData.patientId = Utils.getPatientId();
    return dbReferralRoutesCodeBox!.add(qrData);
  }

  getReferralRouteData() {
    return dbReferralRoutesCodeBox!.get("");
  }

  updateReferralRouteData(RoutingReferralData routingReferral) {
    routingReferral.patientId = Utils.getPatientId();
    dbReferralRoutesCodeBox!.put(routingReferral.key, routingReferral);
  }

  updateAllReferralRouteData(Map map) {
    dbReferralRoutesCodeBox!.putAll(map);
  }

  deleteSingleReferralRouteData(int index) {
    dbReferralRoutesCodeBox!.delete(index);
  }
  deleteSingleReferralRouteDataIndex(int index) {
    dbReferralRoutesCodeBox!.deleteAt(index);
  }

  /*=====================================================================Referral data========================================================================================================================*/
  Future<int> insertReferralData(ReferralData qrData) {
    // qrData.patientId = Utils.getPatientId();
    return dbReferralCodeBox!.add(qrData);
  }

  getReferralData() {
    return dbReferralCodeBox!.get("");
  }

  getReferralDataIdWise(int id) {
    return dbReferralCodeBox!.get(id);
  }


  updateReferralData(ReferralData referralData) {
    // referralData.patientId = Utils.getPatientId();
    dbReferralCodeBox!.put(referralData.key, referralData);
  }

  updateReferralKeyWiseData(ReferralData referralData,int key) {
    // referralData.patientId = Utils.getPatientId();
    dbReferralCodeBox!.put(key, referralData);
  }

  updateAllReferralData(Map map) {
    dbReferralCodeBox!.putAll(map);
  }

  deleteSingleReferralData(int index) {
    dbReferralCodeBox!.deleteAt(index);
  }


 /* =========================================================== NoteData Goal ====================================================================*/
  Future<int> insertNoteData(NoteTableData qrData) {
    qrData.patientId = Utils.getPatientId();
    return dbNoteDataCodeBox!.add(qrData);
  }

  getNoteData() {
    return dbNoteDataCodeBox!.get("");
  }

  getNoteDataID(int id) {
    return dbNoteDataCodeBox!.get(id);
  }

  updateNoteData(NoteTableData noteData) {
    noteData.patientId = Utils.getPatientId();
    dbNoteDataCodeBox!.put(noteData.key, noteData);
  }
  updateKeyWiseNoteData(NoteTableData noteData,int notesKey) {
    noteData.patientId = Utils.getPatientId();
    dbNoteDataCodeBox!.put(notesKey, noteData);
  }

  updateAllNoteData(Map map) {
    dbNoteDataCodeBox!.putAll(map);
  }

  deleteSingleNoteData(int index) {
    dbNoteDataCodeBox!.delete(index);
  }

  /*============================================ Condition Data  =========================================================*/

  Future<int> insertConditionData(ConditionTableData qrData) {
    return dbConditionDataCodeBox!.add(qrData);
  }

  updateConditionDataKeyWiseData(ConditionTableData goalData,int key) {
    dbConditionDataCodeBox!.put(key, goalData);
  }


  getConditionData() {
    return dbConditionDataCodeBox!.get("");
  }

  getConditionDataID(int id) {
    return dbConditionDataCodeBox!.get(id);
  }

  updateConditionData(ConditionTableData conditionData) {
    dbConditionDataCodeBox!.put(conditionData.key, conditionData);
  }

  updateAllConditionData(Map map) {
    dbConditionDataCodeBox!.putAll(map);
  }

  deleteSingleConditionData(int index) {
    dbConditionDataCodeBox!.delete(index);
  }


  /*============================================ Care Plan DataTable =========================================================*/

  Future<int> insertCarePlanData(CarePlanTableData qrData) {
    return dbCarePlanCodeBox!.add(qrData);
  }

  getCarePlanData() {
    return dbCarePlanCodeBox!.get("");
  }

  getCarePlanDataID(int id) {
    return dbCarePlanCodeBox!.get(id);
  }

  updateCarePlanData(CarePlanTableData carePlanData) {
    dbCarePlanCodeBox!.put(carePlanData.key, carePlanData);
  }

  updateCarePlanDataKeyWise(CarePlanTableData goalData,int key) {
    dbCarePlanCodeBox!.put(key, goalData);
  }


  updateAllCarePlanData(Map map) {
    dbCarePlanCodeBox!.putAll(map);
  }

  deleteSingleCarePlanData(int index) {
    dbCarePlanCodeBox!.delete(index);
  }

  deleteCarePlanData() {
    dbCarePlanCodeBox!.clear();
  }


  /*============================================ To Do DataTable =========================================================*/

  Future<int> insertToDoData(ToDoTableData qrData) {
    return dbToDoCodeBox!.add(qrData);
  }

  getToDoData() {
    return dbToDoCodeBox!.get("");
  }

  getToDoDataID(int id) {
    return dbToDoCodeBox!.get(id);
  }

  updateToDoData(ToDoTableData toDoData) {
    dbToDoCodeBox!.put(toDoData.key, toDoData);
  }

  updateAllToDoData(Map map) {
    dbToDoCodeBox!.putAll(map);
  }

  deleteSingleToDoData(int index) {
    dbToDoCodeBox!.delete(index);
  }

  deleteToDoData() {
    dbToDoCodeBox!.clear();
  }

  /*============================================ LogTable DataTable =========================================================*/

  Future<int> insertLogTableData(String type,String resourceType,String response) {
    LogTableData data = LogTableData();
    data.type = type;
    data.resourceType = resourceType;
    data.response = response;
    data.patientId = Utils.getPatientId();
    return dbLogBox!.add(data);
  }

  getLogTableData() {
    return dbLogBox!.get("");
  }

  getLogTableDataID(int id) {
    return dbLogBox!.get(id);
  }
  updatelogTableKeyWiseData(LogTableData exerciseData,int key) {
    dbLogBox!.put(key, exerciseData);
  }
  updateLogTableData(LogTableData logTable) {
    dbLogBox!.put(logTable.key, logTable);
  }

  updateAllLogTableData(Map map) {
    dbLogBox!.putAll(map);
  }

  deleteSingleLogTableData(int index) {
    dbLogBox!.delete(index);
  }

  deleteLogTableData() {
    dbLogBox!.clear();
  }

}
