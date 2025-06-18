import 'package:banny_table/fhir_auth/fhir_client/fhir_client.dart';
import 'package:banny_table/fhir_auth/fhir_client/smart_fhir_client.dart';

class ServerModel{
  bool isSecure = false;
  String displayName = "";
  String title = "";
  String url = "";
  String clientId = "";
  bool isSelected = false;
  bool isPrimary = false;
  String patientId = "";
  SmartFhirClient? smartFhirClient;
  FhirClient? fhirClientUnSecure;
  String token = "";
  String patientFName = "";
  String patientLName = "";
  String patientDOB = "";
  String patientGender = "";

  ServerModel(
      {required this.isSecure,
      required this.displayName,
      required this.url,
      required this.clientId,
      required this.isSelected,
      required this.isPrimary,
      required this.title});
}