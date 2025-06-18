import 'dart:convert';

import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/box/to_do_form_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:fhir/primitive_types/code.dart';
import 'package:fhir/primitive_types/date.dart';
import 'package:fhir/primitive_types/decimal.dart';
import 'package:fhir/primitive_types/fhir_date_time.dart';
import 'package:fhir/primitive_types/fhir_uri.dart';
import 'package:fhir/r4.dart';
import 'package:fhir/r4/general_types/general_types.dart';
import 'package:fhir/r4/resource/resource.dart';
import 'package:fhir/r4/resource_types/base/workflow/workflow.dart';
import 'package:fhir/r4/resource_types/clinical/care_provision/care_provision.dart';
import 'package:fhir/r4/resource_types/clinical/diagnostics/diagnostics.dart';
import 'package:fhir/r4/resource_types/clinical/summary/summary.dart';
import 'package:fhir/r4/resource_types/foundation/documents/documents.dart';
import 'package:fhir/r4/special_types/special_types.dart';
import 'package:fhir_at_rest/r4/fhir_request.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../fhir_auth/r4.dart';
import '../providers/api.dart';
import '../ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import '../ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import '../ui/home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../ui/referralForm/datamodel/referralDataModel.dart';
import '../ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import '../utils/color.dart';
import '../utils/font_style.dart';
import '../utils/sizer_utils.dart';
import '../utils/utils.dart';
import 'package:get/get.dart' as getX;

class PaaProfiles {
  String? getCurrentPatient() {
    // Utils.getPrimaryServerData()!.patientId;
    return Utils.getPrimaryServerData()!.patientId;
  }
  String? getCurrentPatientName() {
    return "${Utils.getPrimaryServerData()!.patientFName} ${Utils.getPrimaryServerData()!.patientLName}";
  }

  static Future<dynamic> getReferralDataList(ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData!.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['patient=${serverData.patientId}',];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  static Future<dynamic> getPatientListTestUse(R4ResourceType type,String? id,String? name, ServerModelJson? selectedUrlModel) async {
    var client = ProviderRequest.getClientUrlWise(selectedUrlModel!.url, selectedUrlModel.clientId,
        selectedUrlModel.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['name=$name','_id=$id'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: type,
        client: client,
        parameters: parameters,
      );
      try {
        final response = await request.request(headers: Utils.getHeader(selectedUrlModel.authToken));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  static Future<dynamic> getMonthActivityList(
      String patientId, String code, String year,String clientId, String url, String token,
      List<ServerModelJson> primaryServerData,bool isFromMonth,
      {String count = "",DateTime? startAfterDate,DateTime? beforeEndDate}) async {
    count = Constant.totalCountOfAPIData;
    String lastUpdatedData= "";
    /*String lastUpdatedData = Utils.getLastAPICalledDate();
    if(lastUpdatedData != "") {
      lastUpdatedData =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(
              DateTime.parse(lastUpdatedData));
    }*/
    Debug.printLog("lastUpdatedData...$lastUpdatedData");
    var client;
    List<ServerModelJson> serverData = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    if(serverData.isNotEmpty){
      client = ProviderRequest.getClientUrlWise(url, clientId, token);

    } else {
      var client_id = ProviderRequest.getClientId();
      if (client_id == "") {
        client = ProviderRequest.getClient();
      } else {
        client = ProviderRequest.getSecureClient();
      }
    }

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = [];
      if (count == "") {
        parameters = [
          'patient=$patientId',
          'code=$code',
          'date=$year',
          if (lastUpdatedData != "") '_lastUpdated=gt$lastUpdatedData',
        ];
      } else {
        if(startAfterDate != null && beforeEndDate != null){
          var saDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(startAfterDate);
          var ebDate = DateFormat(Constant.commonDateFormatDdMmYyyy).format(beforeEndDate.add(Duration(days: 1))) ;
          if(code == ""){
            parameters = [
              'patient=$patientId',
              'date=sa$saDate',
              'date=eb$ebDate',
              '_count=$count',
              // if (lastUpdatedData != "") '_lastUpdated=gt$lastUpdatedData',
            ];
          }else{
            parameters = [
              'patient=$patientId',
              'code=$code',
              'date=sa$saDate',
              'date=eb$ebDate',
              '_count=$count',
              // if (lastUpdatedData != "") '_lastUpdated=gt$lastUpdatedData',
            ];
          }

        }
        else {
          parameters = [
            'patient=$patientId',
            'code=$code',
            'date=$year',
            '_count=$count',
            if (lastUpdatedData != "") '_lastUpdated=gt$lastUpdatedData',
          ];
        }
      }

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Observation,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {
        /*if (primaryServerData.isNotEmpty) {
          var primaryData = primaryServerData[0];
          if (primaryData.isSecure &&
              Utils.isExpiredToken(
                  primaryData.lastLoggedTime, primaryData.expireTime)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showDialog(
                context: getX.Get.context!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const ,
                    content: Text("Your ${code} has expired. Please log in again. MinPerDay"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          getX.Get.back();
                          Utils.callSecureServerAPI(primaryData.url,
                              primaryData.clientId,
                              primaryData.title);
                        },
                        child: const Text("Log in"),
                      ),
                      TextButton(
                        onPressed: () {
                          getX.Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            });

            return;
          }
        }*/
        if (primaryServerData.isNotEmpty) {
          var primaryData = primaryServerData[0];
          if (primaryData.isSecure &&
              Utils.isExpiredToken(
                  primaryData.lastLoggedTime, primaryData.expireTime)) {
            // await Utils.checkTokenExpireTime(primaryData);
          }
        }
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getCarePlanActivityList(String patientId ,ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData!.url, serverData.clientId,
        serverData.authToken);
    if (client != null && client.fhirUri.value != null) {
      var parameters = ['patient=$patientId'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.CarePlan,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getConditionActivityList(String patientId ,ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData!.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['patient=$patientId'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Condition,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getTaskDataList(String patientId,bool isFromReferral,ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData!.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = [];
      if(isFromReferral){
        parameters = ['patient=$patientId'];
      }else{
        // parameters = ['owner=$patientId'];
        parameters = ['owner=$patientId','status=${Constant.toDoStatusInProgress.toLowerCase()},${Constant.toDoStatusReady.toLowerCase()}'];
        // parameters = ['owner=$patientId','status=${Constant.toDoStatusInProgress.toLowerCase()},${Constant.toDoStatusReady.toLowerCase()},${Constant.toDoStatusRequested.toLowerCase()}'];
    // ,${Constant.toDoStatusRequested.toLowerCase()}
      }
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Task,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getTaskHistoryTODoDataList(String patientId,ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData!.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = [];
      // parameters = ['owner=$patientId'];
      parameters = ['owner=$patientId','status:not=${Constant.toDoStatusInProgress.toLowerCase()},${Constant.toDoStatusReady.toLowerCase()},${Constant.toDoStatusDraft.toLowerCase()}'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Task,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getGoalDataList(ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData!.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      // 'lifecycle-status:not=Proposed'
      var parameters = ['patient=${serverData.patientId}',];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Goal,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  /// ********************************* Create/Update Referrals **********************************

  Future<String> processReferralMultiServer(ServiceRequest serviceRequest,ReferralData referralData) async {
    var client = ProviderRequest.getClientUrlWise(referralData.qrUrl ?? "", referralData.clientId,
        referralData.token ?? "");


    if (client != null && client.fhirUri.value != null) {
      var request;
      if (serviceRequest.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: serviceRequest,
          client: client,
        );
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: serviceRequest,
          client: client,
        );
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = referralData.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processReferral.toString(),Constant.serviceRequest,response.toJson().toString());
        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  // Create Referral from the mixed screen
  ServiceRequest createReferral(ReferralSyncDataModel serviceRequest) {
    if (serviceRequest.objectId != "") {
      return ServiceRequest(
        id: serviceRequest.objectId,
        status: Code(serviceRequest.status!.toLowerCase()),
        priority: Code(serviceRequest.priority!.toLowerCase()),
        intent: Code("original-order"),
        category: [
          CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                  code: Code('PhysicalActivity'))
            ],
          ),
        ],
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri('http://snomed.info/sct'),
            code: Code(serviceRequest.code), // make it dynamic as per selection
            display: serviceRequest.display,
          ),
        ], text: serviceRequest.text),
        authoredOn: FhirDateTime(DateTime.now()),
        performer: [
          Reference(reference: 'Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName)
        ],
        // requester: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
        occurrencePeriod: Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),
            end: FhirDateTime(serviceRequest.endDate)),
        subject: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
        note: serviceRequest.getNotes()
      );
    } else {
      return ServiceRequest(
        status: Code(serviceRequest.status!.toLowerCase()),
        priority: Code(serviceRequest.priority!.toLowerCase()),
        intent: Code("original-order"),
        category: [
          CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                  code: Code('PhysicalActivity'))
            ],
          ),
        ],
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri('http://snomed.info/sct'),
            code: Code(serviceRequest.code), // make it dynamic as per selection
            display: serviceRequest.display,
          ),
        ], text: serviceRequest.text),
        authoredOn: FhirDateTime(DateTime.now()),
        performer: [
          Reference(reference: 'Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName)
        ],
        // requester: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
        occurrencePeriod: Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),
            end: FhirDateTime(serviceRequest.endDate)),
        subject: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotes()
      );
    }
  }

  // Creation of Task for Referral created above.
  Task createTask(
      ReferralSyncDataModel serviceRequest, String serviceRequestId) {
    if (serviceRequest.taskId != "") {
      Debug.printLog("createTask update.... ${serviceRequest.taskId}");
      return Task(
          id: serviceRequest.taskId,
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/CodeSystem/task-code'),
               code: Code('fulfill'),
            ),
          ]),
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          authoredOn: FhirDateTime(DateTime.now()),
          lastModified: FhirDateTime(DateTime.now()),
          // requester: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
          owner: Reference(reference: 'Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName),
          note: serviceRequest.getNotes());
    } else {
      Debug.printLog("createTask create.... ${serviceRequest.taskId}");
      return Task(
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/CodeSystem/task-code'),
              code: Code('fulfill'),
            ),
          ]),
          status: Code(serviceRequest.status!.toLowerCase()),

          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          authoredOn: FhirDateTime(DateTime.now()),
          lastModified: FhirDateTime(DateTime.now()),
          // requester: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
          owner: Reference(reference: 'Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName),
          note: serviceRequest.getNotes());
    }
  }

  Future<String> processTaskMultiServer(Task task,ToDoTableData todoTaskData ) async {
    var client = ProviderRequest.getClientUrlWise(todoTaskData.qrUrl ?? "", todoTaskData.clientId,
        todoTaskData.token ?? "");

    if (client != null && client.fhirUri.value != null) {
      var request;
      if (task.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: task,
          client: client,
        );
        Debug.printLog("processTask update.... ${task.id}");
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: task,
          client: client,
        );
        Debug.printLog("processTask create....${task.id}");
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = todoTaskData.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processTask.toString(),Constant.task,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  Future<String> processTaskReferalMultiServer(Task task,ReferralData referralData) async {

    var client = ProviderRequest.getClientUrlWise(referralData.qrUrl ?? "", referralData.clientId,
        referralData.token ?? "");


    if (client != null && client.fhirUri.value != null) {
      var request;
      if (task.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: task,
          client: client,
        );
        Debug.printLog("processTask update.... ${task.id}");
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: task,
          client: client,
        );
        Debug.printLog("processTask create....${task.id}");
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = referralData.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processTask.toString(),Constant.task,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  Future<String> processTaskPatientMultiServer(Task task,String qrUrl,String clientId,String token) async {

   /* var client = ProviderRequest.getClientUrlWise(referralData.qrUrl ?? "", referralData.clientId,
        referralData.token ?? "");*/

    var client = ProviderRequest.getClientUrlWise(qrUrl, clientId, token );

    if (client != null && client.fhirUri.value != null) {
      var request;
      if (task.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: task,
          client: client,
        );
        Debug.printLog("processTask update.... ${task.id}");
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: task,
          client: client,
        );
        Debug.printLog("processTask create....${task.id}");
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      // var token = referralData.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processTask.toString(),Constant.task,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  // Creation of task for patient
  /*Task createPatientTask(TaskSyncDataModel task) {
    var url = "";
    if (task.code == "complete-questionnaire") {
      url = "http://hl7.org/fhir/uv/sdc/CodeSystem/temp";
    } else {
      url =
          "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";
    }
    if (task.objectId != "") {
      return Task(
          id: task.objectId,
        status: Code(task.status.toString().toLowerCase()),
        statusReason: CodeableConcept(
            text: task.statusReason
          ),
        lastModified: FhirDateTime(task.lastUpdatedDate),
        intent: Code("order"),
        businessStatus: CodeableConcept(
            text: task.businessStatusReason
        ),
          priority: Code(task.priority!.toLowerCase()),
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(url),
              code: Code(task.code), // make it dynamic as per selection
              display: task.display,
            ),
          ], text: task.text),
        reasonCode: CodeableConcept(text: task.tag),
        authoredOn: FhirDateTime(task.createdDate!),
        for_: task.forReference,
        requester: task.requesterReference,
        owner: task.ownerReference,
          note: task.getNotes()
      );
    } else {
      return Task(
        status: Code(task.status.toString().toLowerCase()),
        intent: Code("order"),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        businessStatus: CodeableConcept(
            text: task.businessStatusReason
        ),
        lastModified: FhirDateTime(task.lastUpdatedDate!),
        priority: Code(task.priority!.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code), // make it dynamic as per selection
            display: task.display,
          ),
        ], text: task.text),
        for_: Reference(reference: 'Patient/${task.patientId}',display: task.patientName),
        authoredOn: FhirDateTime(task.createdDate!),
        // requester: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
        owner: Reference(reference: 'Patient/${task.patientId}',display: task.patientName),
          note: task.getNotes()
      );
    }
  }*/

  Task createPatientTask(TaskSyncDataModel task) {
    var url = "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";
    if(task.code == Constant.toDoCodeGeneralInfo){
      /*return Task(
          id: task.objectId,
          status: Code(task.status.toString().toLowerCase()),
          statusReason: CodeableConcept(
              text: task.statusReason
          ),
          lastModified: FhirDateTime(task.lastUpdatedDate),
          intent: Code("order"),
          priority: (task.priority == null || task.priority == "Null" || task.priority == "null")?Code(Constant.priorityRoutine.toLowerCase()):Code(task.priority.toLowerCase()),
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(url),
              code: Code(task.code),
              display: task.display,
            ),
          ]),
          authoredOn: FhirDateTime(task.createdDate!),
          for_: task.forReference,
          requester: task.requesterReference,
          owner: task.ownerReference,
          output: [
            TaskOutput(
              type: CodeableConcept(
                coding: [
                  Coding(
                    system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                    code: Code("general-information-response"),
                    display: "General Information Response"
                  )
                ]
              ),
              valueMarkdown: Markdown(task.generalResponseText ?? ""),
            ),
          ],
          note: task.getNotes(),
      );*/
      return Task(
        id: task.objectId,
        status: Code(task.status.toString().toLowerCase()),
        statusReason: CodeableConcept(
            text: task.statusReason ?? ''
        ),
        lastModified: FhirDateTime(task.lastUpdatedDate),
        intent: Code("order"),
        priority: (task.priority == null || task.priority == "Null" || task.priority == "null")
            ? Code(Constant.priorityRoutine.toLowerCase())
            : Code(task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code),
            display: task.display,
          ),
        ]),
        authoredOn: FhirDateTime(task.createdDate!),
        for_: task.forReference,
        requester: task.requesterReference,
        owner: task.ownerReference,
        output: [
          TaskOutput(
            type: CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                      code: Code("general-information-response"),
                      display: "General Information Response"
                  )
                ]
            ),
            valueMarkdown: Markdown(task.generalResponseText ?? ""),
          ),
        ],
        note: task.getNotes(),
          input: (task.display == Constant.toDoCodeDisplayMakeContact) ? [
            TaskInput(
                type:  CodeableConcept(
                    coding: [
                      Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("contact-entity"), // make it dynamic as per selection
                        display: "Contact Entity",
                      ),
                    ]
                ),
                valueReference: Reference(
                    reference: "Practitioner/${task.performerId}",
                    display: task.performerName
                )
            )
          ]: null,
          description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
          contained: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?[
            DocumentReference(
              resourceType: R4ResourceType.DocumentReference,
              id: 'doc1',
              status: Code('current'),
              content: [
                DocumentReferenceContent(
                  attachment: Attachment(
                    url: FhirUrl(task.reviewMaterialURL),
                    title: task.reviewMaterialTitle,
                  ),
                ),
              ],
            )
          ]:null
      );
    }else if(task.code == Constant.toDoCodeMakeContact){
      return Task(
          id: task.objectId,
          status: Code(task.status.toString().toLowerCase()),
          statusReason: CodeableConcept(
              text: task.statusReason
          ),
          lastModified: FhirDateTime(task.lastUpdatedDate),
          intent: Code("order"),
          priority: (task.priority == null || task.priority == "Null" || task.priority == "null")?Code(Constant.priorityRoutine.toLowerCase()):Code(task.priority.toLowerCase()),
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(url),
              code: Code(task.code),
              display: task.display,
            ),
          ], text: task.text),
          authoredOn: FhirDateTime(task.createdDate!),
          for_: task.forReference,
          requester: task.requesterReference,
          owner: task.ownerReference,
          output: [
            TaskOutput(
              type: CodeableConcept(
                  coding: [
                    Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("chosen-contact"),
                        display: "Chosen Contact"
                    )
                  ]
              ),
              valueMarkdown: Markdown(task.chosenContactText ?? ""),
            ),
          ],
          note: task.getNotes(),
          input: (task.display == Constant.toDoCodeDisplayMakeContact) ? [
            TaskInput(
                type:  CodeableConcept(
                    coding: [
                      Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("contact-entity"), // make it dynamic as per selection
                        display: "Contact Entity",
                      ),
                    ]
                ),
                valueReference: Reference(
                    reference: "Practitioner/${task.performerId}",
                    display: task.performerName
                )
            )
          ]:null,
          description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
          contained: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?[
            DocumentReference(
              resourceType: R4ResourceType.DocumentReference,
              id: 'doc1',
              status: Code('current'),
              content: [
                DocumentReferenceContent(
                  attachment: Attachment(
                    url: FhirUrl(task.reviewMaterialURL),
                    title: task.reviewMaterialTitle,
                  ),
                ),
              ],
            )
          ]: null
      );
    }else{
      return Task(
          id: task.objectId,
          status: Code(task.status.toString().toLowerCase()),
          statusReason: CodeableConcept(
              text: task.statusReason
          ),
          lastModified: FhirDateTime(task.lastUpdatedDate),
          intent: Code("order"),
          priority: (task.priority == null || task.priority == "Null" || task.priority == "null")?Code(Constant.priorityRoutine.toLowerCase()):Code(task.priority.toLowerCase()),
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(url),
              code: Code(task.code),
              display: task.display,
            ),
          ], text: task.text),
          reasonCode: CodeableConcept(text: task.tag),
          authoredOn: FhirDateTime(task.createdDate!),
          for_: task.forReference,
          requester: task.requesterReference,
          owner: task.ownerReference,
          note: task.getNotes(),
          input: (task.display == Constant.toDoCodeDisplayMakeContact) ? [
            TaskInput(
                type:  CodeableConcept(
                    coding: [
                      Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("contact-entity"), // make it dynamic as per selection
                        display: "Contact Entity",
                      ),
                    ]
                ),
                valueReference: Reference(
                    reference: "Practitioner/${task.performerId}",
                    display: task.performerName
                )
            )
          ]: null,
          description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
          contained: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?[
            DocumentReference(
              resourceType: R4ResourceType.DocumentReference,
              id: 'doc1',
              status: Code('current'),
              content: [
                DocumentReferenceContent(
                  attachment: Attachment(
                    url: FhirUrl(task.reviewMaterialURL),
                    title: task.reviewMaterialTitle,
                  ),
                ),
              ],
            )
          ]: null
      );
    }
  }

  Task updateFocusPatientTask(
      TaskSyncDataModel task, String serviceRequestId) {

    var url = "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";
    if(task.code == Constant.toDoCodeGeneralInfo) {
      return Task(
        id: task.objectId,
        status: Code(task.status.toString().toLowerCase()),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        lastModified: FhirDateTime(task.lastUpdatedDate),
        intent: Code("order"),
        priority: (task.priority == null || task.priority == "Null" ||
            task.priority == "null") ? Code(
            Constant.priorityRoutine.toLowerCase()) : Code(
            task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code),
            display: task.display,
          ),
        ], text: task.text),
        authoredOn: FhirDateTime(task.createdDate),
        focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
        reasonCode: CodeableConcept(
            text: task.tag
        ),
        for_: task.forReference,
        requester: task.requesterReference,
        owner: task.ownerReference,
        output: [
          TaskOutput(
            type: CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                      code: Code("general-information-response"),
                      display: "General Information Response"
                  )
                ]
            ),
            valueMarkdown: Markdown(task.generalResponseText ?? ""),
          ),
        ],
        note: task.getNotes(),
          input: (task.display == Constant.toDoCodeDisplayMakeContact) ? [
            TaskInput(
                type:  CodeableConcept(
                    coding: [
                      Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("contact-entity"), // make it dynamic as per selection
                        display: "Contact Entity",
                      ),
                    ]
                ),
                valueReference: Reference(
                    reference: "Practitioner/${task.performerId}",
                    display: task.performerName
                )
            )
          ]: [],
          description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
          contained: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?[
            DocumentReference(
              resourceType: R4ResourceType.DocumentReference,
              id: 'doc1',
              status: Code('current'),
              content: [
                DocumentReferenceContent(
                  attachment: Attachment(
                    url: FhirUrl(task.reviewMaterialURL),
                    title: task.reviewMaterialTitle,
                  ),
                ),
              ],
            )
          ]: []
      );
    }else if(task.code == Constant.toDoCodeMakeContact){
      return Task(
        id: task.objectId,
        status: Code(task.status.toString().toLowerCase()),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        lastModified: FhirDateTime(task.lastUpdatedDate),
        intent: Code("order"),
        priority: (task.priority == null || task.priority == "Null" ||
            task.priority == "null") ? Code(
            Constant.priorityRoutine.toLowerCase()) : Code(
            task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code), // make it dynamic as per selection
            display: task.display,
          ),
        ], text: task.text),
        authoredOn: FhirDateTime(task.createdDate),
        focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
        reasonCode: CodeableConcept(
            text: task.tag
        ),
        for_: task.forReference,
        requester: task.requesterReference,
        owner: task.ownerReference,
        output: [
          TaskOutput(
            type: CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                      code: Code("chosen-contact"),
                      display: "Chosen Contact"
                  )
                ]
            ),
            valueMarkdown: Markdown(task.chosenContactText ?? ""),
          ),
        ],
        note: task.getNotes(),
          input: (task.display == Constant.toDoCodeDisplayMakeContact) ? [
            TaskInput(
                type:  CodeableConcept(
                    coding: [
                      Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("contact-entity"), // make it dynamic as per selection
                        display: "Contact Entity",
                      ),
                    ]
                ),
                valueReference: Reference(
                    reference: "Practitioner/${task.performerId}",
                    display: task.performerName
                )
            )
          ]: [],
          description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
          contained: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?[
            DocumentReference(
              resourceType: R4ResourceType.DocumentReference,
              id: 'doc1',
              status: Code('current'),
              content: [
                DocumentReferenceContent(
                  attachment: Attachment(
                    url: FhirUrl(task.reviewMaterialURL),
                    title: task.reviewMaterialTitle,
                  ),
                ),
              ],
            )
          ]: []
      );
    }else{
      return Task(
        id: task.objectId,
        status: Code(task.status.toString().toLowerCase()),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        lastModified: FhirDateTime(task.lastUpdatedDate),
        intent: Code("order"),
        priority: (task.priority == null || task.priority == "Null" ||
            task.priority == "null") ? Code(
            Constant.priorityRoutine.toLowerCase()) : Code(
            task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code), // make it dynamic as per selection
            display: task.display,
          ),
        ], text: task.text),
        authoredOn: FhirDateTime(task.createdDate),
        focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
        reasonCode: CodeableConcept(
            text: task.tag
        ),
        for_: task.forReference,
        requester: task.requesterReference,
        owner: task.ownerReference,
        note: task.getNotes(),
          input: (task.display == Constant.toDoCodeDisplayMakeContact) ? [
            TaskInput(
                type:  CodeableConcept(
                    coding: [
                      Coding(
                        system: FhirUri("http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("contact-entity"), // make it dynamic as per selection
                        display: "Contact Entity",
                      ),
                    ]
                ),
                valueReference: Reference(
                    reference: "Practitioner/${task.performerId}",
                    display: task.performerName
                )
            )
          ]: [],
          description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
          contained: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?[
            DocumentReference(
              resourceType: R4ResourceType.DocumentReference,
              id: 'doc1',
              status: Code('current'),
              content: [
                DocumentReferenceContent(
                  attachment: Attachment(
                    url: FhirUrl(task.reviewMaterialURL),
                    title: task.reviewMaterialTitle,
                  ),
                ),
              ],
            )
          ]: []
      );
    }

  }

  /// ********************************* Create/Update CarePlans **********************************
  CarePlan createCarePlan(CarePlanSyncDataModel careplan) {
    if (careplan.objectId != "") {
      return CarePlan(
          id: careplan.objectId,
          text: Narrative(
              status: NarrativeStatus.additional,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n<p> ${careplan.text.toString()}</p>\n</div>"),
          subject: Reference(reference: 'Patient/${careplan.patientId}',display: careplan.patientName),
          // author: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
          period: Period(
              start: FhirDateTime(
                careplan.startDate,
              ),
              end: FhirDateTime(
                careplan.endDate,
              )),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/core/CodeSystem/careplan-category'),
                    code: Code('assess-plan')),
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          intent: Code("plan"),
          status: Code(careplan.status!.toLowerCase()),
          goal: careplan.getGoals(),
          note: careplan.getNotes());
    } else {
      return CarePlan(
          text: Narrative(
              status: NarrativeStatus.additional,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n<p> ${careplan.text.toString()}</p>\n</div>"),
          subject: Reference(reference: 'Patient/${careplan.patientId}',display: careplan.patientName),
          // author: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
          period: Period(
              start: FhirDateTime(
                careplan.startDate,
              ),
              end: FhirDateTime(
                (careplan.endDate == null) ? DateTime.now() : careplan.endDate,
              )),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/core/CodeSystem/careplan-category'),
                    code: Code('assess-plan')),
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          intent: Code("plan"),
          status: Code(careplan.status!.toLowerCase()),
          goal: careplan.getGoals(),
          note: careplan.getNotes());
    }
  }

  Future<String> processCarePlanMultiServer(CarePlan carePlan ,CarePlanTableData  carePlanTableData ) async {

    var client = ProviderRequest.getClientUrlWise(carePlanTableData.qrUrl ?? "", carePlanTableData.clientId,
        carePlanTableData.token ?? "");


    if (client != null && client.fhirUri.value != null) {
      var request;
      if (carePlan.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: carePlan,
          client: client,
        );
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: carePlan,
          client: client,
        );
      }

      var token = carePlanTableData.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processCarePlan.toString(),Constant.carePlan,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  /// ********************************* Create/Update Conditions **********************************

  Condition createCondition(ConditionSyncDataModel condition) {
    if (condition.objectId != "") {
      return Condition(
        id: condition.objectId,
        subject: Reference(reference: 'Patient/${condition.patientId}',display:condition.patientId),
        onsetDateTime: FhirDateTime(condition.onset),
        abatementDateTime: FhirDateTime(condition.abatement),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri('http://hl7.org/fhir/sid/icd-10-cm'),
            code: Code('Z72.3'),
            display: 'Lack of physical exercise',
          ),
        ]),
        category: [
          CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://hl7.org/fhir/us/core/CodeSystem/condition-category'),
                  code: Code('health-concern'),
                  display: "Health Concern"),
              Coding(
                  system: FhirUri(
                      'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                  code: Code('PhysicalActivity'))
            ],
          ),
        ],
        verificationStatus: CodeableConcept(
          coding: [
            Coding(
                system: FhirUri(
                    'https://hl7.org/fhir/us/physical-activity/STU1/ValueSet-pa-condition-verification-status'),
                    // 'http://terminology.hl7.org/CodeSystem/condition-ver-status'),
                code: Code(condition.verificationStatus!.toLowerCase()))
          ],
        ),
        clinicalStatus: CodeableConcept(
          coding: [
            Coding(
                system: FhirUri(
                    'http://terminology.hl7.org/CodeSystem/condition-clinical'),
                code: Code("active"))
          ],
        ),
      );
    } else {
      return Condition(
        subject: Reference(reference: 'Patient/${condition.patientId}',display:condition.patientId),
        // asserter: Reference(reference: 'Practitioner/${getCareManagerId()}',display: getCareManagerName()),
        onsetDateTime: FhirDateTime(condition.onset),
        abatementDateTime: FhirDateTime(condition.abatement),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri('http://hl7.org/fhir/sid/icd-10-cm'),
            code: Code('Z72.3'),
            display: 'Lack of physical exercise',
          ),
        ]),
        category: [
          CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://hl7.org/fhir/us/core/CodeSystem/condition-category'),
                  code: Code('health-concern'),
                  display: "Health Concern"),
              Coding(
                  system: FhirUri(
                      'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                  code: Code('PhysicalActivity'))
            ],
          ),
        ],
        verificationStatus: CodeableConcept(
          coding: [
            Coding(
                system: FhirUri(
                    'https://hl7.org/fhir/us/physical-activity/STU1/ValueSet-pa-condition-verification-status'),
                    // 'http://terminology.hl7.org/CodeSystem/condition-ver-status'),
                code: Code(condition.verificationStatus!.toLowerCase()))
          ],
        ),
        clinicalStatus: CodeableConcept(
          coding: [
            Coding(
                system: FhirUri(
                    'http://terminology.hl7.org/CodeSystem/condition-clinical'),
                code: Code("active"))
          ],
        ),
      );
    }
  }

  Future<String> processConditionMultiServer(Condition condition,ConditionTableData conditionSyncDataModel) async {
    var client = ProviderRequest.getClientUrlWise(conditionSyncDataModel.qrUrl ?? "", conditionSyncDataModel.clientId,
        conditionSyncDataModel.token ?? "");

    if (client != null && client.fhirUri.value != null) {
      var request;
      if (condition.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: condition,
          client: client,
        );
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: condition,
          client: client,
        );
      }

      var token = conditionSyncDataModel.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processCondition.toString(),Constant.condition,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  /// ********************************* Create/update Goals **********************************

  Goal  createGoal(GoalSyncDataModel allSyncingData) {
    if (allSyncingData.objectId != "") {
      return Goal(
          id: allSyncingData.objectId,
          lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
          description: CodeableConcept(text: allSyncingData.description),
          expressedBy: Reference(reference: allSyncingData.expressedBy,display: allSyncingData.expressedByDisplay),
          subject: Reference(reference: 'Patient/${allSyncingData.patientId}',display: allSyncingData.patientName),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          achievementStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/goal-achievement'),
                  code: Code(allSyncingData.achievementStatus))
            ],
          ),
          target: [
            GoalTarget(
                measure: CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri('http://loinc.org'),
                    code: Code(allSyncingData.code),
                    display: allSyncingData.actualDescription)
              ],
            ),
              detailQuantity: Quantity(
                  value: Decimal(int.parse(allSyncingData.target.toString())),
                  system: FhirUri("http://unitsofmeasure.org"),
                  code: Code(allSyncingData.placeHolderValue)),
              dueDate: Date(allSyncingData.dueDate),
            ),
          ],
          note: allSyncingData.getNotes());
    } else {
      return Goal(
          lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
          description: CodeableConcept(text: allSyncingData.description),
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          expressedBy: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          achievementStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/goal-achievement'),
                  code: Code(allSyncingData.achievementStatus))
            ],
          ),
          target: [
            GoalTarget(
                measure: CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri('http://loinc.org'),
                    code: Code(allSyncingData.code),
                    display: allSyncingData.actualDescription)
              ],
            ),
              detailQuantity: Quantity(
                  value: Decimal(int.parse(allSyncingData.target.toString())),
                  system: FhirUri("http://unitsofmeasure.org"),
                  code: Code(allSyncingData.placeHolderValue)),
              dueDate: Date(allSyncingData.dueDate),
            ),
          ],
          note: allSyncingData.getNotes());
    }
  }

  // Future<String> processGoalMultiServer(Goal goal ,GoalTableData goalSyncData) async {
  Future<String> processGoalMultiServer(Goal goal ,GoalSyncDataModel goalSyncData) async {
    var client = ProviderRequest.getClientUrlWise(goalSyncData.qrUrl ?? "", goalSyncData.clientId,
          goalSyncData.token ?? "");
    if (client != null && client.fhirUri.value != null) {
      var request;
      if (goal.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: goal,
          client: client,
        );
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: goal,
          client: client,
        );
      }

      var token = goalSyncData.token;
      try {

        final response = await request.request(headers: Utils.getHeader(token ?? ""));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(Constant.processGoal.toString(),Constant.goal,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  static Future<dynamic> getPerformerList(ServerModelJson selectedUrlModel) async {
    var client = ProviderRequest.getClientUrlWise(selectedUrlModel!.url, selectedUrlModel.clientId,
        selectedUrlModel.authToken);


    if (client != null && client.fhirUri.value != null) {
      var parameters = ['name=test'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Practitioner,
        client: client,
        parameters: parameters,
      );
      var token = selectedUrlModel.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  /// ******************************** Create/Update Observation Monthly/Weekly creations *******************************

  Future<String> processResource(Observation oResource,String type, String url, String clientId, String token) async {
    var client;
    List<ServerModelJson> serverData = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    if(serverData.isNotEmpty){
      client = ProviderRequest.getClientUrlWise(url, clientId, token);
    } else {
      var clientId = ProviderRequest.getClientId();
      if (clientId == "") {
        client = ProviderRequest.getClient();
      } else {
        client = ProviderRequest.getSecureClient();
      }
    }


    if (client != null && client.fhirUri.value != null) {
      var request;
      if (oResource.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: oResource,
          client: client,
        );
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: oResource,
          client: client,
        );
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      // Debug.printLog(
          // 'Token from API......: $token');
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        await DataBaseHelper.shared.insertLogTableData(type.toString(),Constant.observation,response.toJson().toString());

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  //Text Box First
  Observation createObservationDaysPerWeeks(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('89555-7'),
                display:
                'How many days per week did you engage in moderate to strenuous physical activity in the last 30 days',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }else{
        return Observation(
            id: objectId,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('89555-7'),
                display:
                'How many days per week did you engage in moderate to strenuous physical activity in the last 30 days',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            identifier: identifierDataList,
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('89555-7'),
                display:
                'How many days per week did you engage in moderate to strenuous physical activity in the last 30 days',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }else {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('89555-7'),
                display:
                'How many days per week did you engage in moderate to strenuous physical activity in the last 30 days',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }
    }
  }

  //Text Box Second
  Observation createObservationMintuesPerDay(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('68516-4'),
                display:
                'On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/d")));
      }else{
        return Observation(
          /*id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],*/
            id: objectId,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('68516-4'),
                display:
                'On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/d")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            identifier: identifierDataList,
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('68516-4'),
                display:
                'On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/d")));
      }else {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('68516-4'),
                display:
                'On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/d")));
      }
    }
  }

  //Text Box Third
  Observation createObservationMintuesPerWeek(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82290-8'),
                display:
                'Frequency of moderate to vigorous aerobic physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/wk")));
      }else{
        return Observation(
            id: objectId,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82290-8'),
                display:
                'Frequency of moderate to vigorous aerobic physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/wk")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            identifier: identifierDataList,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82290-8'),
                display:
                'Frequency of moderate to vigorous aerobic physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/wk")));
      }else{
        return Observation(
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82290-8'),
                display:
                'Frequency of moderate to vigorous aerobic physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "minutes per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("min/wk")));
      }
    }
  }

  //Text Box Fourth
  Observation createObservationStrengthDaysPerWeek(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }else{
        return Observation(
            id: objectId,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            identifier: identifierDataList,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }else{
        return Observation(
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectivePeriod: Period(
                start: FhirDateTime(
                  currentObject.startDate,
                ),
                end: FhirDateTime(currentObject.endDate)),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }
    }
  }

  /* Day Level Profiles */
  Observation createObservationAverageRestingHeartRate(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,
      String patientId,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('40443-4'),
                display: 'Heart rate --resting',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }else{
        return Observation(
            id: objectId,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('40443-4'),
                display: 'Heart rate --resting',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }
    } else {
      if (identifierDataList!.isNotEmpty) {
        return Observation(
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            identifier: identifierDataList,
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('40443-4'),
                display: 'Heart rate --resting',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      } else {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('40443-4'),
                display: 'Heart rate --resting',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }
    }
  }

  Observation createObservationCaloriesPerDay(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{final List<Identifier>? identifierDataList,String isOverride = Constant.notOverride }) {
    String isOverrideValue = (isOverride == Constant.notOverride)? "false": "true";
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(reference: 'Patient/$patientId',display: patientName),
            performer: [Reference(reference: 'Patient/$patientId',display: patientName)],
            // valueBoolean:Boolean(isOverrideValue),
            bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41979-6'),
                display: 'Calories burned in 24 hour Calculated',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "kilokalories per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("kcal/d")));
      }else {
        return Observation(
            id: objectId,
            // valueBoolean:Boolean(isOverrideValue),
            bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),

            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41979-6'),
                display: 'Calories burned in 24 hour Calculated',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "kilokalories per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("kcal/d")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            identifier: identifierDataList,
                        // valueBoolean:Boolean(isOverrideValue),
            bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),

            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41979-6'),
                display: 'Calories burned in 24 hour Calculated',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "kilokalories per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("kcal/d")));
      }else {
        return Observation(
             // valueBoolean:Boolean(isOverrideValue),
            bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41979-6'),
                display: 'Calories burned in 24 hour Calculated',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "kilokalories per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("kcal/d")));
      }
    }
  }

  Observation createObservationDailyStepsPerDay(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41950-7'),
                display: 'Number of steps in 24 hour Measured',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "steps per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/d")));
      }else {
        return Observation(
            id: objectId,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41950-7'),
                display: 'Number of steps in 24 hour Measured',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "steps per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/d")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41950-7'),
                display: 'Number of steps in 24 hour Measured',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "steps per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/d")));
      }else {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('41950-7'),
                display: 'Number of steps in 24 hour Measured',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "steps per day",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/d")));
      }
    }
  }

  Observation createObservationDailyPeakHeartRatePerDay(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('8873-2'),
                display: 'Heart rate 24 hour maximum',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }
      else {
        return Observation(
            id: objectId,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('8873-2'),
                display: 'Heart rate 24 hour maximum',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('8873-2'),
                display: 'Heart rate 24 hour maximum',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }
      else {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('8873-2'),
                display: 'Heart rate 24 hour maximum',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "beats per minute",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("/min")));
      }
    }
  }

  Observation createObservationDailyExperiencePerDay(
      SyncMonthlyActivityData currentObject, String objectId,String patientName,String patientId,String experienceCode,String experienceDisplay
      ,{List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    Debug.printLog("createObservationDailyExperience....$experienceCode  $experienceDisplay");
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('Experience'),
                display: 'Experience of Activity',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]));
      }
      else {
        return Observation(
            id: objectId,
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('Experience'),
                display: 'Experience of Activity',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]));
      }
    } else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            identifier: identifierDataList,
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('Experience'),
                display: 'Experience of Activity',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]));
      }
      else {
        return Observation(
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('Experience'),
                display: 'Experience of Activity',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]));
      }
    }
  }

  Observation createObservationDailyTotalMinPerDay( SyncMonthlyActivityData currentObject,
      String objectId,String patientName,String patientId,String note,
      {final List<Identifier>? identifierDataList,String isOverride = Constant.notOverride}) {
    String isOverrideValue = (isOverride == Constant.notOverride)? "false": "true";

    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101691-4"),
              display: 'Duration of physical activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(currentObject.startDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,
        );
      }else {
        return Observation(
          id: objectId,
          bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101691-4"),
              display: 'Duration of physical activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(currentObject.startDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101691-4"),
              display: 'Duration of physical activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(currentObject.startDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,
        );
      }
      else {
        return Observation(
          status: Code('final'),
          bodySite: CodeableConcept(coding: [Coding(display: isOverrideValue)]),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101691-4"),
              display: 'Duration of physical activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(currentObject.startDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,
        );
      }
    }
  }

  Observation createObservationDailyModMinPerDay( SyncMonthlyActivityData currentObject,
      String objectId,String patientName,String patientId,
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101689-8"),
              display: 'Duration of moderate activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }else {
        return Observation(
          id: objectId,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101689-8"),
              display: 'Duration of moderate activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101689-8"),
              display: 'Duration of moderate activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }else {
        return Observation(
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101689-8"),
              display: 'Duration of moderate activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
  }

  Observation createObservationDailyVigMinPerDay( SyncMonthlyActivityData currentObject,
      String objectId,String patientName,String patientId,
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101690-6"),
              display: 'Duration of vigorous activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }else {
        return Observation(
          id: objectId,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101690-6"),
              display: 'Duration of vigorous activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101690-6"),
              display: 'Duration of vigorous activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }else {
        return Observation(
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("101690-6"),
              display: 'Duration of vigorous activity',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectiveDateTime: FhirDateTime(
            currentObject.startDate,
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(currentObject.value),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
  }

  Observation createObservationDailyStrengthBoxPerDay(
      SyncMonthlyActivityData currentObject,
      String objectId,
      String patientName,
      String patientId,
      {List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if (identifierDataList!.isNotEmpty) {
        return Observation(
            id: objectId,
            identifier: identifierDataList,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      } else {
        return Observation(
            id: objectId,
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }
    } else {
      if (identifierDataList!.isNotEmpty) {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            identifier: identifierDataList,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      } else {
        return Observation(
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            status: Code('final'),
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://loinc.org'),
                code: Code('82291-6'),
                display: 'Frequency of muscle-strengthening physical activity',
              ),
            ]),
            effectiveDateTime: FhirDateTime(
              currentObject.startDate,
            ),
            valueQuantity: Quantity(
                value: Decimal(currentObject.value),
                unit: "days per week",
                system: FhirUri("http://unitsofmeasure.org"),
                code: Code("d/wk")));
      }
    }
  }

  /// =========================  ConfigurationActivity =====================================
  DocumentReference? createUpdateConfigurationActivity(String data) {
    String formattedDate =
        DateFormat(Constant.commonDateFormatForActivityConfiguration)
            .format(DateTime.now());

    ServerModelJson? serverModel = Utils.getPrimaryServerData();
    String? idActivityConfiguration =
        Preference.shared.getString(Preference.idActivityConfiguration) ?? "";
    if (idActivityConfiguration != "" &&
        idActivityConfiguration != "null" &&
        serverModel!.patientId == Utils.getPatientId()) {
      return DocumentReference(
          id: idActivityConfiguration,
          resourceType: R4ResourceType.DocumentReference,
          status: Code("current"),
          subject: Reference(
              reference: "Patient/${Utils.getPatientId()}",
              display: serverModel.patientFName + serverModel.patientLName),
          date: Instant(formattedDate),
          content: [
            DocumentReferenceContent(
              attachment: Attachment(
                contentType: Code("application/json"),
                data: Base64Binary(data),
                title: "Configuration File",
              ),
            ),
          ]);
    } else {
      return DocumentReference(
          resourceType: R4ResourceType.DocumentReference,
          status: Code("current"),
          subject: Reference(reference: "Patient/${Utils.getPatientId()}"),
          date: Instant(formattedDate),
          content: [
            DocumentReferenceContent(
              attachment: Attachment(
                  contentType: Code("application/json"),
                  data: Base64Binary(data),
                  title: "Configuration File"),
            ),
          ]);
    }
  }

  Future<String> processConfigurationActivity(DocumentReference? documentReference) async {
    ServerModelJson? serverModel =  Utils.getPrimaryServerData();
    var client = ProviderRequest.getClientUrlWise(serverModel!.url ?? "", serverModel.clientId,
        serverModel.authToken ?? "");
    if (client != null && client.fhirUri.value != null) {
      var request;
      if (documentReference!.id != null) {
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: documentReference,
          client: client,
        );
        Debug.printLog("processTask update.... ${documentReference.id}");
      } else {
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: documentReference,
          client: client,
        );
        Debug.printLog("processTask create....${documentReference.id}");
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverModel.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        // final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        Preference.shared.setString(Preference.idActivityConfiguration, result);

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  static Future<dynamic> getConfigurationActivityData() async {

    ServerModelJson? serverModel =  Utils.getPrimaryServerData();
    if(serverModel == null){
      return;
    }

    var client = ProviderRequest.getClientUrlWise(serverModel!.url, serverModel.clientId,
        serverModel.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['patient=${serverModel.patientId}'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.DocumentReference,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverModel.authToken;
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }


  ///Push Activity into server
  Observation createParentActivityObservation(String objectId,String patientName,String patientId
      ,String activityName,DateTime activityStartDate,DateTime activityEndDate,List<Reference> hasMemberDataList
      ,{final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            identifier: identifierDataList,
            id: objectId,
            status: Code('final'),
            meta: (isAppleHealthData)?Meta(
              source: FhirUri(Constant.appleLink),
            ):null,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                code: Code('PAPanel'),
                display: 'Physical Activity Panel',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            // effectiveDateTime: FhirDateTime(
            //   activityStartDate,
            // ),
            effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            hasMember: hasMemberDataList
        );
      }
      else {
        return Observation(
            id: objectId,
           /* text: Narrative(
                status: NarrativeStatus.generated,
                div:
                "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
            */status: Code('final'),
            meta: (isAppleHealthData)?Meta(
              source: FhirUri(Constant.appleLink),
            ):null,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                code: Code('PAPanel'),
                display: 'Physical Activity Panel',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            effectivePeriod: Period(
                start: FhirDateTime(activityStartDate),
                end: FhirDateTime(activityEndDate)
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            hasMember: hasMemberDataList
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
          */status: Code('final'),
            meta: (isAppleHealthData)?Meta(
              source: FhirUri(Constant.appleLink),
            ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
              code: Code('PAPanel'),
              display: 'Physical Activity Panel',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
            effectivePeriod: Period(
                start: FhirDateTime(activityStartDate),
                end: FhirDateTime(activityEndDate)
            ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          hasMember: hasMemberDataList
        );
      }
      else {
        return Observation(
            /*text: Narrative(
                status: NarrativeStatus.generated,
                div:
                "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
            */status: Code('final'),
            meta: (isAppleHealthData)?Meta(
              source: FhirUri(Constant.appleLink),
            ):null,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                code: Code('PAPanel'),
                display: 'Physical Activity Panel',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
            effectivePeriod: Period(
                start: FhirDateTime(activityStartDate),
                end: FhirDateTime(activityEndDate)
            ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            hasMember: hasMemberDataList
        );
      }
    }
  }

  Observation createChildActivityNameObservation(String objectId,String patientName,String patientId,String loincCode
      ,String activityName,DateTime activityStartDate,DateTime activityEndDate
      ,{final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
              code: Code('PAPanel'),
              display: 'Physical Activity Panel',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri('http://loinc.org'),
                  code: Code(loincCode),
                  display: activityName,
                ),
              ]
          ),
        );
      }else {
        return Observation(
          id: objectId,
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
          */status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
              code: Code('PAPanel'),
              display: 'Physical Activity Panel',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri('http://loinc.org'),
                  code: Code(loincCode),
                  display: activityName,
                ),
              ]
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            identifier: identifierDataList,
            status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
            category: [
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://terminology.hl7.org/CodeSystem/observation-category'),
                      code: Code('activity'))
                ],
              ),
              CodeableConcept(
                coding: [
                  Coding(
                      system: FhirUri(
                          'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                      code: Code('PhysicalActivity'))
                ],
              ),
            ],
            code: CodeableConcept(coding: [
              Coding(
                system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                code: Code('PAPanel'),
                display: 'Physical Activity Panel',
              ),
            ]),
            subject: Reference(
                reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
            performer: [
              Reference(reference: 'Patient/$patientId', display: patientName)
            ],
            valueCodeableConcept: CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri('http://loinc.org'),
                  code: Code(loincCode),
                  display: activityName,
                ),
              ]
            ),
        );
      }else {
        return Observation(
         /* text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
         */ status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
              code: Code('PAPanel'),
              display: 'Physical Activity Panel',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(
              coding: [
                Coding(
                  system: FhirUri('http://loinc.org'),
                  code: Code(loincCode),
                  display: activityName,
                ),
              ]
          ),
        );
      }
    }
  }

  Observation createChildActivityTotalMinObservation(String objectId,String patientName,String patientId,
      DateTime activityStartDate,DateTime activityEndDate,double totalMin,String note,
      {final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55411-3"),
              display: 'Exercise duration',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(totalMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(activityStartDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,

        );
      }else {
        return Observation(
          id: objectId,
         status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55411-3"),
              display: 'Exercise duration',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(totalMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(activityStartDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,

        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55411-3"),
              display: 'Exercise duration',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(totalMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(activityStartDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,

        );
      }else {
        return Observation(
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55411-3"),
              display: 'Exercise duration',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
            value: Decimal(totalMin),
            unit: "minutes",
            system: FhirUri("http://unitsofmeasure.org"),
            code: Code("min")
          ),
          note:(note != "")?[Annotation(text: Markdown(note) , time: FhirDateTime(activityStartDate), authorReference: Reference(reference: 'Patient/$patientId'))]:null,

        );
      }
    }
  }

  Observation createChildActivityModerateMinObservation(String objectId,String patientName,String patientId,
      DateTime activityStartDate,DateTime activityEndDate,double modMin,
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          id: objectId,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77592-4"),
              display: 'Moderate physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(modMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }else {
        return Observation(
          id: objectId,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77592-4"),
              display: 'Moderate physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(modMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77592-4"),
              display: 'Moderate physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(modMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }else {
        return Observation(
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77592-4"),
              display: 'Moderate physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(modMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
  }

  Observation createChildActivityVigorousMinObservation(String objectId,String patientName,String patientId,
      DateTime activityStartDate,DateTime activityEndDate,double vigMin,
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          id: objectId,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77593-2"),
              display: 'Vigorous physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(vigMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
      else {
        return Observation(
          id: objectId,
         /* text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityVigorous\"> </a><a name=\"hcExampleActivityVigorous\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityVigorous&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Vigorous physical activity [IPAQ] <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#77593-2)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 35 minutes<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code min = 'min')</span></p></div>"),
         */ status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77593-2"),
              display: 'Vigorous physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(vigMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77593-2"),
              display: 'Vigorous physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(vigMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
      else {
        return Observation(
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("77593-2"),
              display: 'Vigorous physical activity [IPAQ]',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(vigMin),
              unit: "minutes",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("min")
          ),
        );
      }
    }
  }

  Observation createChildActivityPeakHeartRateObservation(String objectId,String patientName,
      String patientId,DateTime activityStartDate,DateTime activityEndDate,double peakHeartRate,
      {final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          identifier: identifierDataList,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55426-1"),
              display: 'Heart rate unspecified time maximum by Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(peakHeartRate),
              unit: "beats per minute",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/min")
          ),
        );
      }
      else {
        return Observation(
          id: objectId,
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55426-1"),
              display: 'Heart rate unspecified time maximum by Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(peakHeartRate),
              unit: "beats per minute",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/min")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
         status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          identifier: identifierDataList,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55426-1"),
              display: 'Heart rate unspecified time maximum by Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(peakHeartRate),
              unit: "beats per minute",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/min")
          ),
        );
      }
      else {
        return Observation(
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityPeakHR\"> </a><a name=\"hcExampleActivityPeakHR\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityPeakHR&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Heart rate unspecified time maximum by Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55426-1)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 178 beats per minute<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code /min = '/min')</span></p></div>"),
         */ status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55426-1"),
              display: 'Heart rate unspecified time maximum by Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(peakHeartRate),
              unit: "beats per minute",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/min")
          ),
        );
      }
    }
  }

  Observation createChildActivityCaloriesObservation(String objectId,String patientName,
      String patientId,DateTime activityStartDate,DateTime activityEndDate,double caloriesData,
      {final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55424-6"),
              display: 'Calories burned in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(caloriesData),
              unit: "kilocalories",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("kcal")
          ),
        );
      }
      else {
        return Observation(
          id: objectId,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55424-6"),
              display: 'Calories burned in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(caloriesData),
              unit: "kilocalories",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("kcal")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55424-6"),
              display: 'Calories burned in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(caloriesData),
              unit: "kilocalories",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("kcal")
          ),
        );
      }
      else {
        return Observation(
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55424-6"),
              display: 'Calories burned in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(caloriesData),
              unit: "kilocalories",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("kcal")
          ),
        );
      }
    }
  }

  Observation createChildActivityStepsObservation(String objectId,String patientName,
      String patientId,DateTime activityStartDate,DateTime activityEndDate,double stepsData,
      {final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55423-8"),
              display: 'Number of steps in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(stepsData),
              unit: "steps per day",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/d")
          ),
        );
      }
      else {
        return Observation(
          id: objectId,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55423-8"),
              display: 'Number of steps in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(stepsData),
              unit: "steps per day",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/d")
          ),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55423-8"),
              display: 'Number of steps in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(stepsData),
              unit: "steps per day",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/d")
          ),
        );
      }
      else {
        return Observation(
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("55423-8"),
              display: 'Number of steps in unspecified time Pedometer',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueQuantity: Quantity(
              value: Decimal(stepsData),
              unit: "steps per day",
              system: FhirUri("http://unitsofmeasure.org"),
              code: Code("/d")
          ),
        );
      }
    }
  }

  Observation createChildActivityExObservation(String objectId,String patientName,
      String patientId,DateTime activityStartDate,DateTime activityEndDate,String experienceCode,String experienceDisplay,
      {final List<Identifier>? identifierDataList,bool isAppleHealthData = false}) {
    Utils.setLastAPICalledDate();
    if (objectId != "" &&  objectId != "null") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          status: Code('final'),
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("67675-9"),
              display: 'Was this a good or bad experience',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]),
        );
      }
      else {
        return Observation(
          id: objectId,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("67675-9"),
              display: 'Was this a good or bad experience',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]),
        );
      }
    }
    else {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("67675-9"),
              display: 'Was this a good or bad experience',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]),
        );
      }
      else {
        return Observation(
          status: Code('final'),
          meta: (isAppleHealthData)?Meta(
            source: FhirUri(Constant.appleLink),
          ):null,
          category: [
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://terminology.hl7.org/CodeSystem/observation-category'),
                    code: Code('activity'))
              ],
            ),
            CodeableConcept(
              coding: [
                Coding(
                    system: FhirUri(
                        'http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes'),
                    code: Code('PhysicalActivity'))
              ],
            ),
          ],
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://loinc.org'),
              code: Code("67675-9"),
              display: 'Was this a good or bad experience',
            ),
          ]),
          subject: Reference(
              reference: 'Patient/$patientId', display: patientName),
          effectivePeriod: Period(
              start: FhirDateTime(activityStartDate),
              end: FhirDateTime(activityEndDate)
          ),
          performer: [
            Reference(reference: 'Patient/$patientId', display: patientName)
          ],
          valueCodeableConcept: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/physical-activity/CodeSystem/pa-temporary-codes"),
                  code: Code(experienceCode),
                  display: experienceDisplay)
            ]),
        );
      }
    }
  }

  static Future<dynamic> getPatientDetailIdWise(R4ResourceType type,String? id) async {
    var client = ProviderRequest.getClientUrlWise(Utils.getPrimaryServerData()!.url, Utils.getPrimaryServerData()!.clientId,
        Utils.getPrimaryServerData()!.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['_id=$id'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: type,
        client: client,
        parameters: parameters,
      );
      try {

        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
            && element.isSelected).toList();
        var primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        if (primaryServerData.isNotEmpty) {
          var primaryData = primaryServerData[0];
          if (primaryData.isSecure &&
              Utils.isExpiredToken(
                  primaryData.lastLoggedTime, primaryData.expireTime)) {
            // await Utils.checkTokenExpireTime(primaryData);
          }
        }
        final response = await request.request(headers: Utils.getHeader(Utils.getPrimaryServerData()!.authToken));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  static Future<dynamic> getExercisePrescriptionDataList(ServerModelJson serverData) async {

    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);
    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['performer=${serverData.patientId}','status:not=${Constant.statusDraft.toLowerCase()}'];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken;
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }


}
