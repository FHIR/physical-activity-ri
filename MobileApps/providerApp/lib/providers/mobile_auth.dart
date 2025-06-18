import 'dart:convert';

import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';

import '../fhir_auth/fhir_client/smart_fhir_client.dart';
import 'api.dart';
import 'scopes.dart';

Future mobileAuth() async {

  print("I am in Cerner Mobile request");

  final client = SmartFhirClient(
    fhirUri: FhirUri(Api.cernerPatientUrl),
    authorizeUrl: FhirUri("https://authorization.cerner.com/tenants/ec2458f2-1e24-41c8-b71b-0e701af7583d/protocols/oauth2/profiles/smart-v1/personas/patient/authorize"),
    clientId: Api.cernerPatientClientId,
    redirectUri: Api.fhirCallback,
    scopes: scopes.scopesList(),
  );

  print("Initiating the OAuth");

  client.login();

  if (client.fhirUri.value != null && client.patientId != null) {
    final request = FhirRequest.read(
      base: client.fhirUri.value ?? Uri.parse('127.0.0.1'),
      type: R4ResourceType.Patient,
      id: '${client.patientId}',
      client: client,
    );
    try {
      final response = await request.request();
      print(jsonEncode(response.toJson()));
      print('Response from read:\n${response.toJson()}');
    } catch (e) {
      print(e);
    }
  }
}
