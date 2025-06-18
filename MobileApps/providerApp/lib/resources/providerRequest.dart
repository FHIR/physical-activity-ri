import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4/fhir_request.dart';
import 'package:flutter/foundation.dart';

import '../fhir_auth/fhir_client/fhir_client.dart';
import '../fhir_auth/fhir_client/smart_fhir_client.dart';
import '../providers/api.dart';
import '../providers/new_patient.dart';
import '../providers/scopes.dart';

class ProviderRequest
{
  static SmartFhirClient? secureClient;
  static FhirClient? client;
  static String? patient_Id;
  static String? client_id;

  static getExpirationTime()
  {

  }

  static setPatientId(String patientId)
  {
    patient_Id =  patientId;
  }
  static String getPatientId()
  {
    return patient_Id?? "";
  }

  static setClientId(String clientId)
  {
    client_id =  clientId;
  }
  static String getClientId()
  {
    return client_id?? "";
  }

  static setClient(String url)
  {
    if(client_id == "" || client_id == null)
      {
        client = FhirClient(
          // fhirUri: FhirUri(Api.hapiUrl),
          fhirUri: FhirUri(url/*Utils.getAPIEndPoint()*/),
          scopes: scopes.scopesList(),
        );
      }
    else
      {
        var redirect;
        if(kIsWeb){
          redirect = Api.fhirCallbackWeb;
        }
        else
        {
          redirect = Api.fhirCallback;
        }
        secureClient = SmartFhirClient(
            fhirUri: FhirUri(url),
            //clientId: Api.meldClientId,
            clientId: client_id,
            redirectUri: redirect
        );
      }


  }
  static SmartFhirClient? getSecureClient(){
    return secureClient;
  }
  static FhirClient? getClient(){
    return client;
  }

  static getPatient(String patientId) async
  {
      final request2 = FhirRequest.read(
        base: client!.fhirUri.value!,
        type: R4ResourceType.Patient,
        id: patientId,
        client: client,
      );
      try {
        final response =  await request2.request(headers: {});
        print('Response from read:\n${response.toJson()}');
      } catch (e) {
        print(e);
      }

  }

  static Future<String> CreatePatient() async
  {
    try {
      if (client?.fhirUri.value != null) {
        final _newPatient = newPatient();
        print('Patient to be uploaded:\n${_newPatient.toJson()}');
        final request1 = FhirRequest.create(
          base: client!.fhirUri.value!,
          resource: _newPatient,
          client: client,
        );

        String? newId;
        try {
          final response = await request1.request(headers: {});
          print('Response from upload:\n${response.toJson()}');
          newId = response.id;
        } catch (e) {
          print(e);
        }

        return newId?? "";
      }
    } catch (e, stack) {
      print('Error $e');
      print('Stack $stack');
      return "";
    }
    return "";
  }

  static dynamic getClientUrlWise(String url,String? clientId, String token){
    /* if(clientId == "" || clientId == null || token == ""){
      return FhirClient(
        fhirUri: FhirUri(url),
        scopes: scopes.scopesList(),
      );
    }else{
      FhirUri redirect;
      if(kIsWeb){
        redirect = Api.fhirCallbackWeb;
      }
      else
      {
        redirect = Api.fhirCallback;
      }
      return SmartFhirClient(
          fhirUri: FhirUri(url),
          //clientId: Api.meldClientId,
          clientId: clientId,
          redirectUri: redirect
      );
    }*/
    return FhirClient(
      fhirUri: FhirUri(url),
      scopes: scopes.scopesList(),
    );
  }
}
