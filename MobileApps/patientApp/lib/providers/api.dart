import 'package:fhir/primitive_types/fhir_uri.dart';

mixin Api {
  /// redirect url for oauth2 authentication
  static final fhirCallback = FhirUri('com.myshiny.newapp://callback');
  static final fhirCallbackWeb = FhirUri('http://localhost:5000/redirect.html');

  /// HAPI Server
  static const hapiUrl = 'https://hapi.fhir.org/baseR4';

  /// Interop
  static const interopClientId = 'e77063f5-1234-1234-9de4-137e1abcd83c';
  static const interopUrl = 'https://api.interop.community/Demo/data';

  /// MELD
  static const meldClientId = '37862658-025c-42b3-ba86-8c16452c2e22';
  static const meldUrl = 'https://gw.interop.community/PAA/data';

  // EPIC 

static const epicPatientClientId = 'ffb905d2-f94d-4cb5-a29c-0b048275f662';
static const epicClinicianClientId = 'f8e8754d-d0e6-404c-807f-be0265d624c0';
static const epicUrl = 'https://fhir.epic.com/interconnect-fhir-oauth/api/FHIR/R4';

// Cerner

static const cernerPatientClientId = '9a0eac0d-4c0c-4302-88bf-1f4b1a932f2c';
static const cernerPatientUrl = 'https://fhir-ehr-code.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d';

static const cernerClinicianClientId = '359e607c-e6f3-41ae-bbd4-9fda7a0b25c5';
static const cernerClinicianUrl = 'https://fhir-ehr-code.cerner.com/r4/ec2458f2-1e24-41c8-b71b-0e701af7583d';
}