import 'package:banny_table/db_helper/box/care_plan_form_data.dart';
import 'package:banny_table/db_helper/box/condition_form_data.dart';
import 'package:banny_table/db_helper/box/exercise_prescription_data.dart';
import 'package:banny_table/db_helper/box/goal_data.dart';
import 'package:banny_table/db_helper/box/referral_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/to_do_sync_data_model.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModelJson.dart';
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
import 'package:fhir/r4/resource_types/base/individuals/individuals.dart';
import 'package:fhir/r4/resource_types/base/workflow/workflow.dart';
import 'package:fhir/r4/resource_types/clinical/care_provision/care_provision.dart';
import 'package:fhir/r4/resource_types/clinical/diagnostics/diagnostics.dart';
import 'package:fhir/r4/resource_types/clinical/summary/summary.dart';
import 'package:fhir/r4/special_types/special_types.dart';
import 'package:fhir_at_rest/r4/fhir_request.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart' as getX;

import '../ui/ExercisePrescription/dataModel/exercisePrescriptionDataModel.dart';
import '../ui/carePlanForm/datamodel/carePlanSyncDataModel.dart';
import '../ui/conditionForm/datamodel/conditionSyncDataModel.dart';
import '../ui/createPatientForm/datamodel/createPatientDataModel.dart';
import '../ui/home/monthly/datamodel/syncMonthlyActivityData.dart';
import '../ui/referralForm/datamodel/referralDataModel.dart';
import '../utils/utils.dart';

class PaaProfiles {
  String? getCurrentPatient() {
    return Preference.shared.getString(Preference.patientId) ??
        Utils.getPatientId();
  }
  String? getCurrentPatientName() {
    return Preference.shared.getString(Preference.patientFName) ??
        "${Utils.getPatientFName()} ${Utils.getPatientLName()}";
  }

  String getProviderId() {
    return Preference.shared.getString(Preference.providerId) ??
        Utils.getProviderId();
  }

  String getProviderName() {
    // return "250195";
    return Preference.shared.getString(Preference.providerName) ??
        Utils.getProviderName();
  }

  static Future<dynamic> getReferralDataList() async {
    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['patient=${Utils.getPatientId()}',];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );
      var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

///Created
  static Future<dynamic> getReferralCreatedDataList(ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);
    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['requester=${serverData.providerId}&patient=${serverData.patientId}',];
    var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken ?? "";
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  ///Assigned
  static Future<dynamic> getReferralAssignedDataList(ServerModelJson serverData) async {

    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['performer=${serverData.providerId}&patient=${serverData.patientId}',];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken ?? "";
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  ///Get Id Wise Referral
  static Future<dynamic> getReferralIdWise(ServerModelJson serverData,String serviceRequestId) async {

    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['_id=$serviceRequestId',];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverData.authToken ?? "";
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  ///Exercise Prescription
  static Future<dynamic> getExercisePrescriptionDataList(String patientId ,ServerModelJson serverData) async {

    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);
    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['requester=${serverData.providerId}&performer=${serverData.patientId}',];

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

  static Future<dynamic> getPatient() async {
    //var request;
    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['given=Activity'];
      var request = FhirRequest.read(
        base: client.fhirUri.value!,
        type: R4ResourceType.Patient,
        id: Utils.getPatientId(),
      );
      var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {

        final response = await request.request();
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getCareManager() async {
    //var request;
    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['given=Activity'];
      var request = FhirRequest.read(
        base: client.fhirUri.value!,
        type: R4ResourceType.Practitioner,
        id: Utils.getProviderId(),
      );
      var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {

        final response = await request.request();
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getPatientList() async {
    //var request;
    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['given=raikot'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Patient,
        client: client,
        parameters: parameters,
      );
      var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {

        final response = await request.request();
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }


  static Future<dynamic> getPatientListTestUse(R4ResourceType type,String? id,String? name, ServerModelJson? selectedUrlModel) async {
    var client = ProviderRequest.getClientUrlWise(selectedUrlModel!.url, selectedUrlModel.clientId,
        selectedUrlModel.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parametersList;

      if(selectedUrlModel.isAdmin){
        if(name != "" || id != ""){
          parametersList =  ['name=$name','_id=$id'];
        }else{
          parametersList = [];
        }
      }else{
        if(type == R4ResourceType.Patient){
          // parametersList =  ['name=$name','_id=$id',"general-practitioner=${selectedUrlModel.providerId}"];
          parametersList =  ['name=$name',"general-practitioner=${selectedUrlModel.providerId}"];
        }else{
          parametersList =  ['name=$name','_id=$id'];
        }
      }


      var request;
      if (name != "" || id != "") {
        request = FhirRequest.search(
          base: client.fhirUri.value!,
          type: type,
          client: client,
          parameters: parametersList,
        );
      }else if(selectedUrlModel.isAdmin) {
        request = FhirRequest.search(
            base: client.fhirUri.value!,
            type: type,
            client: client,
        );
      }else {
        request = FhirRequest.search(
          base: client.fhirUri.value!,
          type: type,
          client: client,
          parameters: parametersList,
        );
      }

      try {
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.providerId != ""
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
        var data = Utils.getServerListPreference().where((element) => element.isSelected && element.providerId != ""
        && element.isPrimary).toList();
        if(data.isNotEmpty){
          selectedUrlModel = data[0];
        }
        final response = await request.request(headers: Utils.getHeader(selectedUrlModel.authToken));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }


  static Future<dynamic> getPractitionerListTestUse(R4ResourceType type,String? id,String? name) async {
    //var request;
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/

    var client = ProviderRequest.getClientUrlWise(Utils.getPrimaryServerData()!.url, Utils.getPrimaryServerData()!.clientId,
        Utils.getPrimaryServerData()!.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['given=$name','_id=$id'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: type,
        client: client,
        parameters: parameters,
      );
      var token = Utils.getPrimaryServerData()!.authToken ?? "";
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {
        // final response = await request.request(headers: {
        //   "Bearer": token,
        //   "Access-Control-Allow-Origin": "*",
        //   "Access-Control-Allow-Methods": "GET, POST",
        //   "Access-Control-Allow-Headers": "X-Requested-With",
        //   'Content-Type': 'application/json',
        //   'Accept': '*/*'
        // });
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.providerId != ""
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
        // Handle errors if the future fails
        return Resource();
      }
    }
  }

  static Future<dynamic> getMonthActivityList(
      String patientId, String code, String year,String clientId, String url, String token,
      List<ServerModelJson> primaryServerData,bool isFromMonth,
      {String count = "",DateTime? startAfterDate,DateTime? beforeEndDate}) async {
    String lastUpdatedData = Utils.getLastAPICalledDate();
    count = Constant.totalCountOfAPIData;
    if(lastUpdatedData != "") {
      lastUpdatedData =
          DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              DateTime.parse(lastUpdatedData));
    }
    Debug.printLog("lastUpdatedData...$lastUpdatedData");
    var client;
    List<ServerModelJson> serverData = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
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
                    title: const Text("Session Expired"),
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
    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
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


/*  static Future<dynamic> getConditionActivityList(String patientId) async {
    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['patient=$patientId'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Condition,
        client: client,
        parameters: parameters,
      );
      var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }*/

  static Future<dynamic> getConditionActivityList(String patientId ,ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
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


  static Future<dynamic> searchCondition(String text) async {
    var client = ProviderRequest.getClientUrlWise(Utils.getPrimaryServerData()!.url, Utils.getPrimaryServerData()!.clientId,
        Utils.getPrimaryServerData()!.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['code:text=$text',"_count=5"];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Condition,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = Utils.getPrimaryServerData()!.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        // Handle errors if the future fails
        return Resource();
      }
    }
  }


  static Future<dynamic> getToDoCreatedIndependentListApi(ServerModelJson selectedUrlModel) async {
    var client = ProviderRequest.getClientUrlWise(selectedUrlModel.url, selectedUrlModel.clientId,
        selectedUrlModel.authToken);

    var token = selectedUrlModel.authToken ?? "";
    Debug.printLog("Utils.getProviderId()....${Utils.getProviderId()}");
    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = [];
       // parameters = ['requester=${Utils.getProviderId()}','_count=${Constant.defaultCount}'];
      parameters = [
        'requester=${Utils.getProviderId()}',
        'status=${Constant.statusRejected.toLowerCase()},${Constant.statusCompleted.toLowerCase()},${Constant.toDoStatusFailed.toLowerCase()},${Constant.statusDraft.toLowerCase()}',
        '_count=${Constant.defaultCount}'
      ];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Task,
        client: client,
        parameters: parameters,
      );
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  static Future<dynamic> getToDoAssignedIndependentListApi(ServerModelJson selectedUrlModel) async {
    var client = ProviderRequest.getClientUrlWise(selectedUrlModel.url, selectedUrlModel.clientId,
        selectedUrlModel.authToken);

    var token = selectedUrlModel.authToken ?? "";

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = [];
      parameters = ["owner=${Utils.getProviderId()}","status=${Constant.toDoStatusRequested.toLowerCase()}",'_count=${Constant.defaultCount}'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Task,
        client: client,
        parameters: parameters,
      );
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  static Future<dynamic> getPatientTask(ServerModelJson serverData) async {
    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['requester=${serverData.providerId}','owner=${serverData.patientId}'];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Task,
        client: client,
        parameters: parameters,
      );
      var token = serverData.authToken ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }

  static Future<dynamic> getGoalDataList(ServerModelJson serverData) async {
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/
    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['patient=${serverData.patientId}'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Goal,
        client: client,
        parameters: parameters,
      );
      var token = serverData.authToken ?? "";
      try {
        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }


  static Future<dynamic> getTaskServiceRequestIdWise(String serviceRequestId,ServerModelJson serverData) async {
/*    var clientId = ProviderRequest.getClientId();
    var client;
    if (clientId == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/

    var client = ProviderRequest.getClientUrlWise(serverData.url, serverData.clientId,
        serverData.authToken);
    if (client != null && client.fhirUri.value != null) {
      List<String> parameters = ['_id=$serviceRequestId','_revinclude=Task:focus'];

      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.ServiceRequest,
        client: client,
        parameters: parameters,
      );

      var token = (serverData.authToken != "") ? serverData.authToken : "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        return response;
      } catch (error) {
        return Resource();
      }
    }
  }


  /// ********************************* Create/Update Exercise prescription **********************************

  Future<String> processExercisePrescription(ServiceRequest serviceRequest,ExercisePrescriptionSyncDataModel exercisePrescriptionSingleData) async {
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/

    var client = ProviderRequest.getClientUrlWise(exercisePrescriptionSingleData.qrUrl!, exercisePrescriptionSingleData.clientId,
        exercisePrescriptionSingleData.token!);

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
      var token = exercisePrescriptionSingleData.token ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processExercisePrescription......: ${response.toJson()}');
        return result;
      } catch (e) {
        Debug.printLog("Response from upload processExercisePrescription.error..."+e.toString());
        return "error";
      }
    } else {
      Debug.printLog("Response from upload processExercisePrescription.error...");
      return "error";
    }
  }

  // Create Prescription from the mixed screen
  ServiceRequest createExercisePrescription(ExercisePrescriptionSyncDataModel serviceRequest) {
    if (serviceRequest.objectId != "") {
      return ServiceRequest(
          id: serviceRequest.objectId,
          status: Code(serviceRequest.status!.toLowerCase()),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          intent: Code("original-order"),
          /*reasonCode: [
            CodeableConcept(
                text: serviceRequest.textReasonCode,
            )
          ],*/
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
              code: Code(serviceRequest.referralCode), // make it dynamic as per selection
              display: serviceRequest.referralScope,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          /*performer: [
            Reference(reference: 'Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName)
          ],*/
          performer:[Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          ],
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          occurrencePeriod:(serviceRequest.endDate == null)?
          Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),): Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject:Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotes()
      );
    } else {
      return ServiceRequest(
          status: Code(serviceRequest.status!.toLowerCase()),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          intent: Code("original-order"),
          /*reasonCode: [
            CodeableConcept(
              text: serviceRequest.textReasonCode,
            )
          ],*/
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
              code: Code(serviceRequest.referralCode), // make it dynamic as per selection
              display: serviceRequest.referralScope,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
         /* performer: [
            Reference(reference: 'Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName)
          ],*/
          performer:[Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),],
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          occurrencePeriod:(serviceRequest.endDate == null)?
          Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),):
          Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotes()
      );
    }
  }

  Task createTaskPrescription(
      ExercisePrescriptionSyncDataModel serviceRequest, String serviceRequestId, DateTime createdDate) {
    if (serviceRequest.taskId != "" && serviceRequest.taskId != "null") {
      Debug.printLog("createTask update.... ${serviceRequest.taskId}");
      return Task(
          id: serviceRequest.taskId,
          code: CodeableConcept(coding: [
            /*Coding(
              system: FhirUri('http://hl7.org/fhir/CodeSystem/task-code'),
              code: Code('fulfill'),
            ),*/
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(serviceRequest.code),
              display: serviceRequest.display,
            ),
          ], text: serviceRequest.text ),
          // status: Code("requested"),
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          // authoredOn: FhirDateTime(DateTime.now()),
          authoredOn: FhirDateTime(serviceRequest.createdDate),
          lastModified: FhirDateTime(DateTime.now()),
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          owner: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotes());
    }
    else {
      Debug.printLog("createTask create.... ${serviceRequest.taskId}");
      return Task(
          code: CodeableConcept(coding: [
            /*Coding(
              system: FhirUri('http://hl7.org/fhir/CodeSystem/task-code'),
              code: Code('fulfill'),
            ),*/
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(serviceRequest.code),
              display: serviceRequest.display,
            ),
          ], text: serviceRequest.text ),
          // status: Code("requested"),
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_:  Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          authoredOn: FhirDateTime(DateTime.now()),
          lastModified: FhirDateTime(DateTime.now()),
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          owner:  Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotes());
    }
  }
  /// ********************************* Create/Update Referrals **********************************

  Future<String> processReferral(ServiceRequest serviceRequest,ReferralSyncDataModel referralSingleData) async {
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/

    var client = ProviderRequest.getClientUrlWise(referralSingleData.qrUrl!, referralSingleData.clientId,
        referralSingleData.token!);

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
      var token = referralSingleData.token ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  ServiceRequest updateAssignedReferral(ReferralSyncDataModel serviceRequest,String requesterId,String requesterName) {
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
          // requester: Reference(reference: 'Practitioner/${getServiceProviderId()}',display: getCareManagerName()),
          /*Get id and name from response not static*/
          requester: Reference(reference: 'Practitioner/$requesterId',display: requesterName),
          occurrencePeriod: Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          note: serviceRequest.getNotesReferral()
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
          // requester: Reference(reference: 'Practitioner/${getServiceProviderId()}',display: getCareManagerName()),
          requester: Reference(reference: 'Practitioner/$requesterId',display: requesterName),
          occurrencePeriod: Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          note: serviceRequest.getNotesReferral()
      );
    }
  }

  // Create Referral from the mixed screen
  ServiceRequest createReferral(ReferralSyncDataModel serviceRequest,String baseUrl,List<Reference> perfomerList) {
    if(perfomerList.isNotEmpty){
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
              code: Code(serviceRequest.referralTypeCode), // make it dynamic as per selection
              display: serviceRequest.referralTypeDisplay,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          performer: perfomerList,
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          // requester: Reference(reference: '$baseUrl/Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          occurrencePeriod: (serviceRequest.endDate == null) ?
          Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),)
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotesReferral(),
          reasonReference: serviceRequest.getCondition(),
          identifier:(serviceRequest.taskId != "")? [Identifier(id:serviceRequest.taskId )]:null,
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
              code: Code(serviceRequest.referralTypeCode), // make it dynamic as per selection
              display: serviceRequest.referralTypeDisplay,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          performer: perfomerList,
          requester:Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          // requester:Reference(reference: '$baseUrl/Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          occurrencePeriod: (serviceRequest.endDate == null) ?
          Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),)
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject:Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotesReferral(),
          reasonReference: serviceRequest.getCondition(),
          identifier:(serviceRequest.taskId != "")? [Identifier(id:serviceRequest.taskId )]:null,
        );
      }
    }
    else{
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
              code: Code(serviceRequest.referralTypeCode), // make it dynamic as per selection
              display: serviceRequest.referralTypeDisplay,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          // performer: perfomerList,
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          // requester: Reference(reference: '$baseUrl/Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          occurrencePeriod: (serviceRequest.endDate == null) ?
          Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),)
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotesReferral(),
          reasonReference: serviceRequest.getCondition(),
          identifier:(serviceRequest.taskId != "")? [Identifier(id:serviceRequest.taskId )]:null,
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
              code: Code(serviceRequest.referralTypeCode), // make it dynamic as per selection
              display: serviceRequest.referralTypeDisplay,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          // performer: perfomerList,
          requester:Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          // requester:Reference(reference: '$baseUrl/Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          occurrencePeriod: (serviceRequest.endDate == null) ?
          Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),)
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject:Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          note: serviceRequest.getNotesReferral(),
          reasonReference: serviceRequest.getCondition(),
          identifier:(serviceRequest.taskId != "")? [Identifier(id:serviceRequest.taskId )]:null,
        );
      }
    }
  }

  ///  identifier = Task ID
  ServiceRequest updateReferralWithTaskId(ReferralSyncDataModel serviceRequest,
      String baseUrl, List<Reference> perfomerList, String taskId) {
    if (perfomerList.isNotEmpty) {
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
              code: Code(serviceRequest.referralTypeCode),
              // make it dynamic as per selection
              display: serviceRequest.referralTypeDisplay,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          performer: perfomerList,
          requester: Reference(
              reference: 'Practitioner/${serviceRequest.providerId}',
              display: "${serviceRequest.providerName}"),
          occurrencePeriod: (serviceRequest.endDate == null)
              ? Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),
          )
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(
              reference: 'Patient/${serviceRequest.patientId}',
              display: serviceRequest.patientName),
          note: serviceRequest.getNotesReferral(),
          reasonReference: serviceRequest.getCondition(),
          identifier: [Identifier(id:taskId )],);
          // orderDetail: [CodeableConcept(id: taskId)]);
    } else {
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
              code: Code(serviceRequest.referralTypeCode),
              display: serviceRequest.referralTypeDisplay,
            ),
          ], text: serviceRequest.textReasonCode),
          authoredOn: FhirDateTime(DateTime.now()),
          requester: Reference(
              reference: 'Practitioner/${serviceRequest.providerId}',
              display: "${serviceRequest.providerName}"),
          occurrencePeriod: (serviceRequest.endDate == null)
              ? Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),
          )
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(serviceRequest.endDate)),
          subject: Reference(
              reference: 'Patient/${serviceRequest.patientId}',
              display: serviceRequest.patientName),
          note: serviceRequest.getNotesReferral(),
          reasonReference: serviceRequest.getCondition(),
          identifier: [Identifier(id:taskId )],
          // orderDetail: [CodeableConcept(id: taskId)]
    );
    }
  }
  // Creation of Task for Referral created above.

  ///Focus search param is not working in the hapi library server
  Task createTask(
      ReferralSyncDataModel serviceRequest, String serviceRequestId, String baseUrl,Reference modelPerfomer) {
    if (serviceRequest.taskId != "") {
      Debug.printLog("createTask update.... ${serviceRequest.taskId}  $serviceRequestId");
      return Task(
          id: serviceRequest.taskId,
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(serviceRequest.code),
              display: serviceRequest.display,
            ),
          ], text: serviceRequest.text ),
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          authoredOn: FhirDateTime(serviceRequest.startDate ?? DateTime.now()),
          lastModified: FhirDateTime(DateTime.now()),
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          owner: modelPerfomer,
          note: serviceRequest.getNotesReferral());
    } else {
      Debug.printLog("createTask create.... ${serviceRequest.taskId}  $serviceRequestId");
      return Task(
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(serviceRequest.code),
              display: serviceRequest.display,
            ),
          ], text: serviceRequest.text ),
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          authoredOn: FhirDateTime(serviceRequest.startDate ?? DateTime.now()),
          lastModified: FhirDateTime(DateTime.now()),
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          owner: modelPerfomer,          // owner: Reference(reference: '$baseUrl/Practitioner/${serviceRequest.performerId}',display: serviceRequest.performerName),
          note: serviceRequest.getNotesReferral());
    }
  }

  ///Focus search param is not working in the hapi library server
  Task createTaskWithoutOwner(
      ReferralSyncDataModel serviceRequest, String serviceRequestId, String baseUrl) {
    if (serviceRequest.taskId != "") {
      Debug.printLog("createTask update.... ${serviceRequest.taskId}  $serviceRequestId");
      return Task(
          id: serviceRequest.taskId,
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(serviceRequest.code),
              display: serviceRequest.display,
            ),
          ], text: serviceRequest.text ),
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          authoredOn: FhirDateTime(serviceRequest.createdDate),
          lastModified: FhirDateTime(DateTime.now()),
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          note: serviceRequest.getNotesReferral());
    }
    else {
      Debug.printLog("createTask create.... ${serviceRequest.taskId}  $serviceRequestId");
      return Task(
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(serviceRequest.code),
              display: serviceRequest.display,
            ),
          ], text: serviceRequest.text ),
/*          executionPeriod: (serviceRequest.endDate == null)
              ? Period(
            start: FhirDateTime(
              serviceRequest.startDate,
            ),
          )
              : Period(
              start: FhirDateTime(
                serviceRequest.startDate,
              ),
              end: FhirDateTime(
                serviceRequest.endDate,
              )),*/
          status: Code(serviceRequest.status!.toLowerCase()),
          intent: Code("order"),
          priority: Code(serviceRequest.priority!.toLowerCase()),
          focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
          for_: Reference(reference: 'Patient/${serviceRequest.patientId}',display: serviceRequest.patientName),
          authoredOn: FhirDateTime(DateTime.now()),
          lastModified: FhirDateTime(DateTime.now()),
          requester: Reference(reference: 'Practitioner/${serviceRequest.providerId}',display: "${serviceRequest.providerName}"),
          note: serviceRequest.getNotesReferral());
    }
  }

  Future<String> processTask(Task task ,String qrUrl,String clientId,String tokens,) async {
    var primaryServerData = Utils.getServerList.where((element) => element.isPrimary && element.isSelected).toList();
    if(primaryServerData.isEmpty){
      return "";
    }

    var pData = primaryServerData[0];
    qrUrl = pData.url;
    clientId = pData.clientId;
    tokens = pData.authToken;

    var client = ProviderRequest.getClientUrlWise(qrUrl, clientId,
        tokens);

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
      var token = tokens ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
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
  Task createPatientTask(TaskSyncDataModel task) {
    var url = "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";
/*    var url = "";
    if (task.code == "complete-questionnaire") {
      url = "http://hl7.org/fhir/uv/sdc/CodeSystem/temp";
    } else {
      url =
          "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";
    }*/
    if (task.objectId != "") {
      return Task(
          id: task.objectId,
          // status: Code("requested"),
          status: Code(task.status.toString().toLowerCase()),
          statusReason: CodeableConcept(
            text: task.statusReason
          ),
          lastModified: FhirDateTime(task.lastUpdatedDate),
          intent: Code("order"),
          /*businessStatus: CodeableConcept(
            text: task.businessStatusReason
          ),*/
          priority: Code(task.priority.toLowerCase()),
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri(url),
              code: Code(task.code), // make it dynamic as per selection
              display: task.display,
            ),
          ], text: task.text),
        authoredOn: FhirDateTime(task.createdDate),
        /*for_: Reference(
            reference: 'Patient/${getCurrentPatient()}',
            display: getCurrentPatientName()),
        requester: Reference(
            reference: 'Practitioner/${getProviderId()}',
            display: getProviderName()),
        owner: Reference(
            reference: 'Patient/${getCurrentPatient()}',
            display: getCurrentPatientName()),*/
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
          ]: null,
        description: (task.display == Constant.toDoCodeDisplayMakeContact) ? task.makeContactDescription:(task.display == Constant.toDoCodeDisplayGeneralInfo) ? task.generalDescription: "",
        /*focus: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?Reference(
          reference: "#doc1",
        ): null,*/
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
        ]: null,
        output: (task.display == Constant.toDoCodeDisplayMakeContact && task.chosenContactText != "")
            ? [
                TaskOutput(
                  type: CodeableConcept(coding: [
                    Coding(
                        system: FhirUri(
                            "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                        code: Code("chosen-contact"),
                        display: "Chosen Contact")
                  ]),
                  valueMarkdown: Markdown(task.chosenContactText ?? ""),
                ),
              ]
            : (task.display == Constant.toDoCodeDisplayGeneralInfo && task.generalResponseText != "")
                ? [
                    TaskOutput(
                      type: CodeableConcept(coding: [
                        Coding(
                            system: FhirUri(
                                "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                            code: Code("general-information-response"),
                            display: "General Information Response")
                      ]),
                      valueMarkdown: Markdown(task.generalResponseText ?? ""),
                    ),
                  ]
                : null,
      );
    } else {
      return Task(
        // status: Code("requested"),
        status: Code(task.status.toString().toLowerCase()),
        intent: Code("order"),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        /*businessStatus: CodeableConcept(
            text: task.businessStatusReason
        ),*/
        lastModified: FhirDateTime(task.lastUpdatedDate!),
        priority: Code(task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code), // make it dynamic as per selection
            display: task.display,
          ),
        ], text: task.text),
        for_: Reference(reference: 'Patient/${task.patientId}',display: task.patientName),
        authoredOn: FhirDateTime(task.createdDate!),
        // requester: Reference(reference: 'Patient/${task.patientId}',display: task.patientName),
        requester: Reference(reference: 'Practitioner/${task.providerId}',display: task.providerName),
        owner: Reference(reference: 'Patient/${task.patientId}',display: task.patientName),
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
          /*focus: (task.display == Constant.toDoCodeDisplayReviewMaterial) ?Reference(
            reference: "#doc1",
          ): null,*/
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
          ]: [],
/*        output: (task.display == Constant.toDoCodeDisplayMakeContact)
            ? [
          TaskOutput(
            type: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                  code: Code("chosen-contact"),
                  display: "Chosen Contact")
            ]),
            valueMarkdown: Markdown(task.chosenContactText ?? ""),
          ),
        ]
            : (task.display == Constant.toDoCodeDisplayGeneralInfo)
            ? [
          TaskOutput(
            type: CodeableConcept(coding: [
              Coding(
                  system: FhirUri(
                      "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes"),
                  code: Code("general-information-response"),
                  display: "General Information Response")
            ]),
            valueMarkdown: Markdown(task.generalResponseText ?? ""),
          ),
        ]
            : null,*/
      );
    }
  }

  Task updateFocusPatientTask(
      TaskSyncDataModel task, String serviceRequestId) {
    var url = "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";

/*    var url = "";
    if (task.code == "complete-questionnaire") {
      url = "http://hl7.org/fhir/uv/sdc/CodeSystem/temp";
    } else {
      url =
      "http://hl7.org/fhir/us/sdoh-clinicalcare/CodeSystem/SDOHCC-CodeSystemTemporaryCodes";
    }*/
    if (task.objectId != "") {
      return Task(
        id: task.objectId,
        // status: Code("requested"),
        status: Code(task.status.toString().toLowerCase()),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        lastModified: FhirDateTime(DateTime.now()),
        intent: Code("order"),
        priority: (task.priority == null || task.priority == "Null" || task.priority == "null")?Code(Constant.priorityRoutine.toLowerCase()):Code(task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code),
            display: task.display,
          ),
        ], text: task.text),
        authoredOn: FhirDateTime(DateTime.now()),
        focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
        reasonCode: CodeableConcept(
            text: task.tag
        ),

        for_: task.forReference,
        requester: task.requesterReference,
        owner: task.ownerReference,
        note: task.getNotesBackendTask(),

      );
    } else {
      return Task(
        // status: Code("requested"),
        status: Code(task.status.toString().toLowerCase()),
        intent: Code("order"),
        statusReason: CodeableConcept(
            text: task.statusReason
        ),
        /*businessStatus: CodeableConcept(
            text: task.businessStatusReason
        ),*/
        lastModified: FhirDateTime(DateTime.now()),
        priority: (task.priority == null || task.priority == "Null" && task.priority == "null")?Code(Constant.priorityRoutine.toLowerCase()):Code(task.priority.toLowerCase()),
        code: CodeableConcept(coding: [
          Coding(
            system: FhirUri(url),
            code: Code(task.code), // make it dynamic as per selection
            display: task.display,
          ),
        ], text: task.text),
        focus: Reference(reference: 'ServiceRequest/$serviceRequestId'),
        for_: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
        authoredOn: FhirDateTime(DateTime.now()),
        requester: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
        owner: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
        note: task.getNotesBackendTask(),
      );
    }

  }

  /// ********************************* Create/Update CarePlans **********************************
  CarePlan createCarePlan(CarePlanSyncDataModel careplan) {
    if(careplan.text != null && careplan.text != "" ){
      if (careplan.objectId != "") {
        return CarePlan(
            id: careplan.objectId,
            // text: Narrative(div: careplan.text.toString()),
            text: Narrative(
                status: NarrativeStatus.additional,
                div:
                "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n<p> ${careplan.text.toString()}</p>\n</div>"),
            // subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
            subject: Reference(reference: 'Patient/${careplan.patientId}',display: careplan.patientName),
            author:  Reference(reference: 'Practitioner/${careplan.providerId}',display: "${careplan.providerName}"),
            period: (careplan.endDate == null)
                ? Period(
              start: FhirDateTime(
                careplan.startDate,
              ),
            )
                : Period(
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
      }
      else {
        return CarePlan(
          // text: Narrative(div: careplan.text.toString()),
            text: Narrative(
                status: NarrativeStatus.additional,
                div:
                "<div xmlns=\"http://www.w3.org/1999/xhtml\">\n<p> ${careplan.text.toString()}</p>\n</div>"),
            subject: Reference(reference: 'Patient/${careplan.patientId}',display: careplan.patientName),
            author:  Reference(reference: 'Practitioner/${careplan.providerId}',display: "${careplan.providerName}"),
            period: (careplan.endDate == null)
                ? Period(
              start: FhirDateTime(
                careplan.startDate,
              ),
            )
                : Period(
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
      }
    }else{
      if (careplan.objectId != "") {
        return CarePlan(
            id: careplan.objectId,
            // text: Narrative(div: careplan.text.toString()),
            // subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
            subject: Reference(reference: 'Patient/${careplan.patientId}',display: careplan.patientName),
            author:  Reference(reference: 'Practitioner/${careplan.providerId}',display: "${careplan.providerName}"),
            period: (careplan.endDate == null)
                ? Period(
              start: FhirDateTime(
                careplan.startDate,
              ),
            )
                : Period(
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
      }
      else {
        return CarePlan(
          // text: Narrative(div: careplan.text.toString()),
            subject: Reference(reference: 'Patient/${careplan.patientId}',display: careplan.patientName),
            author:  Reference(reference: 'Practitioner/${careplan.providerId}',display: "${careplan.providerName}"),
            period: (careplan.endDate == null)
                ? Period(
              start: FhirDateTime(
                careplan.startDate,
              ),
            )
                : Period(
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
      }
    }

  }

  Future<String> processCarePlan(CarePlan carePlan,CarePlanSyncDataModel carePlanSingleData) async {
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/

    var client = ProviderRequest.getClientUrlWise(carePlanSingleData.qrUrl!, carePlanSingleData.clientId,
        carePlanSingleData.token!);

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

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = carePlanSingleData.token ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource careplan.........: ${response.toJson()}');
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
    var clinicalStatus = "";
    if(condition.abatement == null){
      clinicalStatus = "active";
    }else{
      clinicalStatus = "resolved";
    }
    if(condition.abatement == null){
      if (condition.objectId != "") {
        return Condition(
          id: condition.objectId,
          // subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          subject: Reference(reference: 'Patient/${condition.patientId}',display: condition.patientName),
          // asserter: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
          onsetDateTime: (condition.onset != null) ? FhirDateTime(condition.onset) : null,
          /*code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/sid/icd-10-cm'),
              code: Code('Z72.3'),
              display: 'Lack of physical exercise',
            ),
          ]),*/
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(condition.code), // make it dynamic as per selection
              display: condition.display,
            ),
          ], text: condition.detalis),
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
                    // 'https://hl7.org/fhir/us/physical-activity/STU1/ValueSet-pa-condition-verification-status'),
                      'http://terminology.hl7.org/CodeSystem/condition-ver-status'),
                  code: Code(condition.verificationStatus!.toLowerCase()))
            ],
          ),
          clinicalStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/condition-clinical'),
                  code: Code(clinicalStatus))
            ],
          ),
        );
      }
      else {
        return Condition(
          subject: Reference(reference: 'Patient/${condition.patientId}',display: condition.patientName),
          // subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          // asserter: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
          onsetDateTime: (condition.onset != null) ? FhirDateTime(condition.onset) : null,
          /*code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/sid/icd-10-cm'),
              code: Code('Z72.3'),
              display: 'Lack of physical exercise',
            ),
          ]),*/
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(condition.code), // make it dynamic as per selection
              display: condition.display,
            ),
          ], text: condition.detalis),
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
                    // 'https://hl7.org/fhir/us/physical-activity/STU1/ValueSet-pa-condition-verification-status'),
                      'http://terminology.hl7.org/CodeSystem/condition-ver-status'),
                  code: Code(condition.verificationStatus!.toLowerCase()))
            ],
          ),
          clinicalStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/condition-clinical'),
                  code: Code(clinicalStatus))
            ],
          ),
        );
      }
    }
    else{
      if (condition.objectId != "") {
        return Condition(
          id: condition.objectId,
          subject: Reference(reference: 'Patient/${condition.patientId}',display: condition.patientName),
          // subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          // asserter: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
          onsetDateTime: (condition.onset != null) ? FhirDateTime(condition.onset) : null,
          abatementDateTime: FhirDateTime(condition.abatement),
          /*code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/sid/icd-10-cm'),
              code: Code('Z72.3'),
              display: 'Lack of physical exercise',
            ),
          ]),*/
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(condition.code), // make it dynamic as per selection
              display: condition.display,
            ),
          ], text: condition.detalis),
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
                    // 'https://hl7.org/fhir/us/physical-activity/STU1/ValueSet-pa-condition-verification-status'),
                      'http://terminology.hl7.org/CodeSystem/condition-ver-status'),
                  code: Code(condition.verificationStatus!.toLowerCase()))
            ],
          ),
          clinicalStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/condition-clinical'),
                  code: Code(clinicalStatus))
            ],
          ),
        );
      }
      else {
        return Condition(
          subject: Reference(reference: 'Patient/${condition.patientId}',display: condition.patientName),
          // subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          // asserter: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
          onsetDateTime: (condition.onset != null) ? FhirDateTime(condition.onset) : null,
          abatementDateTime: FhirDateTime(condition.abatement),
          /*code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://hl7.org/fhir/sid/icd-10-cm'),
              code: Code('Z72.3'),
              display: 'Lack of physical exercise',
            ),
          ]),*/
          code: CodeableConcept(coding: [
            Coding(
              system: FhirUri('http://snomed.info/sct'),
              code: Code(condition.code), // make it dynamic as per selection
              display: condition.display,
            ),
          ], text: condition.detalis),
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
                    // 'https://hl7.org/fhir/us/physical-activity/STU1/ValueSet-pa-condition-verification-status'),
                      'http://terminology.hl7.org/CodeSystem/condition-ver-status'),
                  code: Code(condition.verificationStatus!.toLowerCase()))
            ],
          ),
          clinicalStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/condition-clinical'),
                  code: Code(clinicalStatus))
            ],
          ),
        );
      }
    }

  }

  Future<String> processCondition(Condition condition,ConditionSyncDataModel conditionData) async {
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/

    var client = ProviderRequest.getClientUrlWise(conditionData.qrUrl!, conditionData.clientId,
        conditionData.token!);

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

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = conditionData.token?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
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

  Goal createGoal(GoalSyncDataModel allSyncingData) {
    if(allSyncingData.lifeCycleStatus == Constant.lifeCycleProposed){
      if(allSyncingData.objectId != ""){
        return Goal(
            id: allSyncingData.objectId,
            lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
            description: CodeableConcept(text: allSyncingData.description),
            expressedBy: Reference(reference: allSyncingData.expressedBy,display: allSyncingData.expressedByDisplay),
            // expressedBy: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
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
      else{
        if(allSyncingData.target != null && allSyncingData.target != ""){
          return Goal(
              lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
              description: CodeableConcept(text: allSyncingData.description),
              subject: Reference(reference: 'Patient/${allSyncingData.patientId}',display: allSyncingData.patientName),
              expressedBy: Reference(reference: 'Practitioner/${allSyncingData.providerId}',display: "${allSyncingData.providerName}"),
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
                      value:  Decimal(int.parse(allSyncingData.target.toString())),
                      system: FhirUri("http://unitsofmeasure.org"),
                      code: Code(allSyncingData.placeHolderValue)),
                  dueDate: Date(allSyncingData.dueDate),
                ),
                /*  GoalTarget(
              detailQuantity: Quantity(
                  value: Decimal(int.parse(allSyncingData.target.toString())),
                  system: FhirUri("http://unitsofmeasure.org"),
                  code: Code(allSyncingData.placeHolderValue)),
              dueDate: Date(allSyncingData.dueDate),
            )*/
              ],
              note: allSyncingData.getNotes());
        }else{
          return Goal(
              lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
              description: CodeableConcept(text: allSyncingData.description),
              subject: Reference(reference: 'Patient/${allSyncingData.patientId}',display: allSyncingData.patientName),
              expressedBy: Reference(reference: 'Practitioner/${allSyncingData.providerId}',display: "${allSyncingData.providerName}"),
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
                      system: FhirUri("http://unitsofmeasure.org"),
                      code: Code(allSyncingData.placeHolderValue)),
                  dueDate: Date(allSyncingData.dueDate),
                ),
                /*  GoalTarget(
              detailQuantity: Quantity(
                  value: Decimal(int.parse(allSyncingData.target.toString())),
                  system: FhirUri("http://unitsofmeasure.org"),
                  code: Code(allSyncingData.placeHolderValue)),
              dueDate: Date(allSyncingData.dueDate),
            )*/
              ],
              note: allSyncingData.getNotes());

        }
      }
    }
    else if (allSyncingData.objectId != "") {
      return Goal(
          id: allSyncingData.objectId,
          lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
          description: CodeableConcept(text: allSyncingData.description),
          expressedBy: Reference(reference: allSyncingData.expressedBy,display: allSyncingData.expressedByDisplay),
          // expressedBy: Reference(reference: 'Practitioner/${getProviderId()}',display: getProviderName()),
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
          achievementStatus: (allSyncingData.lifeCycleStatus != Constant.lifeCycleProposed && allSyncingData.achievementStatus != "") ? CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/goal-achievement'),
                  code: Code(allSyncingData.achievementStatus))
            ],
          ) : null,
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
            /*GoalTarget(
              detailQuantity: Quantity(
                  value: Decimal(int.parse(allSyncingData.target.toString())),
                  system: FhirUri("http://unitsofmeasure.org"),
                  code: Code(allSyncingData.placeHolderValue)),
              dueDate: Date(allSyncingData.dueDate),
            )*/
          ],
          note: allSyncingData.getNotes());
    }
    else {
      return Goal(
          lifecycleStatus: Code(allSyncingData.lifeCycleStatus!.toLowerCase()),
          description: CodeableConcept(text: allSyncingData.description),
          subject: Reference(reference: 'Patient/${allSyncingData.patientId}',display: allSyncingData.patientName),
          expressedBy: Reference(reference: 'Practitioner/${allSyncingData.providerId}',display: "${allSyncingData.providerName}"),
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
          /*achievementStatus: CodeableConcept(
            coding: [
              Coding(
                  system: FhirUri(
                      'http://terminology.hl7.org/CodeSystem/goal-achievement'),
                  code: Code(allSyncingData.achievementStatus))
            ],
          ),*/
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
          /*  GoalTarget(
              detailQuantity: Quantity(
                  value: Decimal(int.parse(allSyncingData.target.toString())),
                  system: FhirUri("http://unitsofmeasure.org"),
                  code: Code(allSyncingData.placeHolderValue)),
              dueDate: Date(allSyncingData.dueDate),
            )*/
          ],
          note: allSyncingData.getNotes());
    }
  }

  Future<String> processGoal(Goal goal,GoalSyncDataModel goalData ) async {
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/
    var client = ProviderRequest.getClientUrlWise(goalData.qrUrl!, goalData.clientId,
        goalData.token!);
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

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = goalData.token ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        //final response = await request.request();

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
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
    /*var request;
    var parameters = ['name=mickey'];
    request = FhirRequest.search(
      base: Uri.parse(Utils.getAPIEndPoint()),
      type: R4ResourceType.Practitioner,
      parameters: parameters,
    );
    try {
      var response = await request.request();

      return response;
    } catch (error) {
      return Resource();
    }*/

    /* var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/
    var client = ProviderRequest.getClientUrlWise(selectedUrlModel.url, selectedUrlModel.clientId,
        selectedUrlModel.authToken);


    if (client != null && client.fhirUri.value != null) {
      // var parameters = ['name=mickey'];
      var parameters = ['given='];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Practitioner,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
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

  static Future<dynamic> getPerformerSearchList(String? name,ServerModelJson serverModel) async {
    /*var request;
    var parameters = ['name=mickey'];
    request = FhirRequest.search(
      base: Uri.parse(Utils.getAPIEndPoint()),
      type: R4ResourceType.Practitioner,
      parameters: parameters,
    );
    try {
      var response = await request.request();

      return response;
    } catch (error) {
      return Resource();
    }*/

    var client = ProviderRequest.getClientUrlWise(serverModel.url, serverModel.clientId,
        serverModel.authToken);
/*    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();*/
    // }

    if (client != null && client.fhirUri.value != null) {
      var parameters = ['given=$name'];
      // var parameters = ['name=test'];
      var request = FhirRequest.search(
        base: client.fhirUri.value!,
        type: R4ResourceType.Practitioner,
        client: client,
        parameters: parameters,
      );
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = serverModel.authToken ?? "";
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

/*  Future<String> processResource(Observation oResource) async {
    var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
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

      var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }*/

/*
  Future<String> processResource(Observation oResource,String type, String url, String clientId, String token) async {
    */
/* var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/
  /*

    var client;
    List<ServerModelJson> serverData = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    if(serverData.isNotEmpty){
      */
/*var primaryData = serverData.where((element) => element.isPrimary).toList();
      if(primaryData.isNotEmpty){
        client = ProviderRequest.getClientUrlWise(primaryData[0].url, primaryData[0].clientId,
            primaryData[0].token);
      }*/
  /*

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
      Debug.printLog(
          'Token from API......: $token');
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');

        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }
*/

  Future<String> processResource(Observation oResource,String type, String url, String clientId, String token) async {
    /* var client_id = ProviderRequest.getClientId();
    var client;
    if (client_id == "") {
      client = ProviderRequest.getClient();
    } else {
      client = ProviderRequest.getSecureClient();
    }*/
    var client;
    // List<ServerModelJson> serverData = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];
    List<ServerModelJson> serverData = Utils.getServerList;
    if(serverData.isNotEmpty){
      /*var primaryData = serverData.where((element) => element.isPrimary).toList();
      if(primaryData.isNotEmpty){
        client = ProviderRequest.getClientUrlWise(primaryData[0].url, primaryData[0].clientId,
            primaryData[0].token);
      }*/
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
      Debug.printLog(
          'Token from API......: $token');
      try {

        final response = await request.request(headers: Utils.getHeader(token));
        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }



/*  //Text Box First
  Observation createObservationDaysPerWeeks(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  //Text Box Second
  Observation createObservationMintuesPerDay(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  //Text Box Third
  Observation createObservationMintuesPerWeek(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  //Text Box Fourth
  Observation createObservationStrengthDaysPerWeek(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  *//* Day Level Profiles *//*

  Observation createObservationAverageRestingHeartRate(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  Observation createObservationCaloriesPerDay(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  Observation createObservationDailyStepsPerDay(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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

  Observation createObservationDailyPeakHeartRate(
      SyncMonthlyActivityData currentObject) {
    if (currentObject.objectId != "") {
      return Observation(
          id: currentObject.objectId,
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
    } else {
      return Observation(
          subject: Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName()),
          performer: [Reference(reference: 'Patient/${getCurrentPatient()}',display: getCurrentPatientName())],
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
  }*/

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
      ,{final List<Identifier>? identifierDataList}) {
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

  Observation createObservationDailyPeakHeartRate(
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


  /*Create patient*/
  Patient createPatient(CreatePatientDataModel createPatientDataModel) {
    if(createPatientDataModel.patientId != ""){
      return Patient(
          id: createPatientDataModel.patientId,
          active: Boolean(true),
          name: [
            HumanName(
              use: HumanNameUse.official,
              family: createPatientDataModel.lName,
              given: createPatientDataModel.firstNameList,
            )
          ],
          telecom: createPatientDataModel.phoneNumbersList,
          gender: Code(createPatientDataModel.gender.toLowerCase()),
          birthDate: Date(createPatientDataModel.dob),
          deceasedBoolean: Boolean(false),
          address: createPatientDataModel.addressList,
          contact: createPatientDataModel.emergencyContactList,
          generalPractitioner: createPatientDataModel.referenceList
      );
    }else{
      return Patient(
          active: Boolean(true),
          name: [
            HumanName(
              use: HumanNameUse.official,
              family: createPatientDataModel.lName,
              given: createPatientDataModel.firstNameList,
            )
          ],
          telecom: createPatientDataModel.phoneNumbersList,
          gender: Code(createPatientDataModel.gender.toLowerCase()),
          birthDate: Date(createPatientDataModel.dob),
          deceasedBoolean: Boolean(false),
          address: createPatientDataModel.addressList,
          contact: createPatientDataModel.emergencyContactList,
          generalPractitioner: createPatientDataModel.referenceList
      );
    }
  }

  Future<String> processCreatePatient(Patient patient,ServerModelJson? getPrimaryData) async {
    var client = ProviderRequest.getClientUrlWise(getPrimaryData!.url, getPrimaryData.clientId,
        getPrimaryData.authToken);

    if (client != null && client.fhirUri.value != null) {
      var request;
      if(patient.id != null){
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: patient,
          client: client,
        );
      }else{
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: patient,
          client: client,
        );
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.providerId != "" &&
          element.isSelected).toList();

      var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      if(getPrimaryServerData.isNotEmpty) {
        if (getPrimaryServerData[0].isSecure &&
            Utils.isExpiredToken(getPrimaryServerData[0].lastLoggedTime,
                getPrimaryServerData[0].expireTime)) {
          // await Utils.checkTokenExpireTime(getPrimaryServerData[0]);
        }
      }
      var token = Utils.getPrimaryServerData()!.authToken ?? "";
      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processCreatePatient......: ${response.toJson()}');
        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

///Practitioner Create
  Practitioner createPractitioner(CreatePatientDataModel createPatientDataModel,String providerId) {
    if(providerId != ""){
      return Practitioner(
        id: providerId,
          resourceType: R4ResourceType.Practitioner,
          active: Boolean(true),
          name: [
            HumanName(
              use: HumanNameUse.official,
              family: createPatientDataModel.lName,
              given: createPatientDataModel.firstNameList,
            )
          ],
          telecom: createPatientDataModel.phoneNumbersList,
          gender: Code(createPatientDataModel.gender.toLowerCase()),
          birthDate: Date(createPatientDataModel.dob),
          address: createPatientDataModel.addressList,
          // qualification:createPatientDataModel.qualificationList
      );
    }else{
      return Practitioner(
          resourceType: R4ResourceType.Practitioner,
          active: Boolean(true),
          name: [
            HumanName(
              use: HumanNameUse.official,
              family: createPatientDataModel.lName,
              given: createPatientDataModel.firstNameList,
            )
          ],
          telecom: createPatientDataModel.phoneNumbersList,
          gender: Code(createPatientDataModel.gender.toLowerCase()),
          birthDate: Date(createPatientDataModel.dob),
          address: createPatientDataModel.addressList,
          // qualification:createPatientDataModel.qualificationList
      );

    }
  }

  Future<String> processCreatePractitioner(Practitioner practitioner, String providerId) async {
    var client = ProviderRequest.getClientUrlWise(Utils.getPrimaryServerData()!.url, Utils.getPrimaryServerData()!.clientId,
        Utils.getPrimaryServerData()!.authToken);

    if (client != null && client.fhirUri.value != null) {
      var request;
      if(practitioner.id != null){
        request = FhirRequest.update(
          base: client.fhirUri.value!,
          resource: practitioner,
          client: client,
        );
      }
      else{
        request = FhirRequest.create(
          base: client.fhirUri.value!,
          resource: practitioner,
          client: client,
        );
      }
      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.providerId != "" &&
          element.isSelected).toList();

      var getPrimaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      if(getPrimaryServerData.isNotEmpty) {
        if (getPrimaryServerData[0].isSecure &&
            Utils.isExpiredToken(getPrimaryServerData[0].lastLoggedTime,
                getPrimaryServerData[0].expireTime)) {
          // await Utils.checkTokenExpireTime(getPrimaryServerData[0]);
        }
      }

      // var token = Preference.shared.getString(Preference.authToken) ?? "";
      var token = Utils.getPrimaryServerData()!.authToken ?? "";

      try {

        final response = await request.request(headers: Utils.getHeader(token));

        var result = response.id.toString();
        Debug.printLog(
            'Response from upload processCreatePractitioner......: ${response.toJson()}');
        return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

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

    var client = ProviderRequest.getClientUrlWise(serverModel.url, serverModel.clientId,
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
      ,{final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
            identifier: identifierDataList,
            id: objectId,
            /*text: Narrative(
                status: NarrativeStatus.generated,
                div:
                "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
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
      ,{final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
          */status: Code('final'),
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
          /*text: Narrative(
                status: NarrativeStatus.generated,
                div:
                "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityGroup\"> </a><a name=\"hcExampleActivityGroup\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityGroup&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Physical Activity Panel <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PAPanel)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>hasMember</b>: </p><ul><li><a href=\"Observation-ExampleActivityType.html\">Observation/ExampleActivityType</a></li><li><a href=\"Observation-ExampleActivityDuration.html\">Observation/ExampleActivityDuration</a></li><li><a href=\"Observation-ExampleActivityModerate.html\">Observation/ExampleActivityModerate</a></li><li><a href=\"Observation-ExampleActivityVigorous.html\">Observation/ExampleActivityVigorous</a></li><li><a href=\"Observation-ExampleActivityPeakHR.html\">Observation/ExampleActivityPeakHR</a></li><li><a href=\"Observation-ExampleActivityCalories.html\">Observation/ExampleActivityCalories</a></li></ul></div>"),
            */status: Code('final'),
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
      DateTime activityStartDate,DateTime activityEndDate,double totalMin,
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();

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
        );
      }
    }
  }

  Observation createChildActivityModerateMinObservation(String objectId,String patientName,String patientId,
      DateTime activityStartDate,DateTime activityEndDate,double modMin,
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
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
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          identifier: identifierDataList,
          id: objectId,
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityVigorous\"> </a><a name=\"hcExampleActivityVigorous\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityVigorous&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Vigorous physical activity [IPAQ] <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#77593-2)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 35 minutes<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code min = 'min')</span></p></div>"),
          */status: Code('final'),
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
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityVigorous\"> </a><a name=\"hcExampleActivityVigorous\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityVigorous&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Vigorous physical activity [IPAQ] <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#77593-2)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 35 minutes<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code min = 'min')</span></p></div>"),
          */status: Code('final'),
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
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityVigorous\"> </a><a name=\"hcExampleActivityVigorous\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityVigorous&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Vigorous physical activity [IPAQ] <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#77593-2)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 35 minutes<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code min = 'min')</span></p></div>"),
          */status: Code('final'),
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
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityPeakHR\"> </a><a name=\"hcExampleActivityPeakHR\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityPeakHR&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Heart rate unspecified time maximum by Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55426-1)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 178 beats per minute<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code /min = '/min')</span></p></div>"),
          */status: Code('final'),
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
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityPeakHR\"> </a><a name=\"hcExampleActivityPeakHR\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityPeakHR&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Heart rate unspecified time maximum by Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55426-1)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 178 beats per minute<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code /min = '/min')</span></p></div>"),
          */status: Code('final'),
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
          /* text: Narrative(
              status: NarrativeStatus.generated,
              div:
              "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityPeakHR\"> </a><a name=\"hcExampleActivityPeakHR\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityPeakHR&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Heart rate unspecified time maximum by Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55426-1)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 178 beats per minute<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code /min = '/min')</span></p></div>"),
          */status: Code('final'),
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
      {final List<Identifier>? identifierDataList}) {
    Utils.setLastAPICalledDate();
    if (objectId != "") {
      if(identifierDataList!.isNotEmpty){
        return Observation(
          id: objectId,
          identifier: identifierDataList,
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityCalories\"> </a><a name=\"hcExampleActivityCalories\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityCalories&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Calories burned in unspecified time Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55424-6)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 738 kilocalories<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code kcal = 'kcal')</span></p></div>"),
          */status: Code('final'),
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
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityCalories\"> </a><a name=\"hcExampleActivityCalories\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityCalories&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Calories burned in unspecified time Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55424-6)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 738 kilocalories<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code kcal = 'kcal')</span></p></div>"),
          */status: Code('final'),
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
          /* text: Narrative(
              status: NarrativeStatus.generated,
              div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityCalories\"> </a><a name=\"hcExampleActivityCalories\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityCalories&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Calories burned in unspecified time Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55424-6)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 738 kilocalories<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code kcal = 'kcal')</span></p></div>"),
          */status: Code('final'),
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
          /*text: Narrative(
              status: NarrativeStatus.generated,
              div: "<div xmlns=\"http://www.w3.org/1999/xhtml\"><p><b>Generated Narrative: Observation</b><a name=\"ExampleActivityCalories\"> </a><a name=\"hcExampleActivityCalories\"> </a></p><div style=\"display: inline-block; background-color: #d9e0e7; padding: 6px; margin: 4px; border: 1px solid #8da1b4; border-radius: 5px; line-height: 60%\"><p style=\"margin-bottom: 0px\">Resource Observation &quot;ExampleActivityCalories&quot; </p></div><p><b>status</b>: final</p><p><b>category</b>: Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"http://terminology.hl7.org/5.0.0/CodeSystem-observation-category.html\">Observation Category Codes</a>#activity)</span>, Physical Activity <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"CodeSystem-pa-temporary-codes.html\">Temporary Codes</a>#PhysicalActivity)</span></p><p><b>code</b>: Calories burned in unspecified time Pedometer <span style=\"background: LightGoldenRodYellow; margin: 4px; border: 1px solid khaki\"> (<a href=\"https://loinc.org/\">LOINC</a>#55424-6)</span></p><p><b>subject</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>effective</b>: 2022-06-08</p><p><b>performer</b>: <a href=\"http://example.org/Patient/1\">http://example.org/Patient/1: Example Patient</a></p><p><b>value</b>: 738 kilocalories<span style=\"background: LightGoldenRodYellow\"> (Details: UCUM code kcal = 'kcal')</span></p></div>"),
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

  static Future<dynamic> getPractitionerDetailIdWise(R4ResourceType type,String? id) async {
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

        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.providerId != ""
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

}
