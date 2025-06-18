import 'package:banny_table/utils/utils.dart';
import 'package:fhir/r4.dart';
import 'package:fhir_at_rest/r4.dart';
import '../fhir_auth/r4.dart';

import 'new_patient.dart';
import 'scopes.dart';

Future hapiRequest() async {
  final client = FhirClient(
    // fhirUri: FhirUri(Api.hapiUrl),
    fhirUri: FhirUri(Utils.getAPIEndPoint()),
    scopes: scopes.scopesList(),
  );

  try {
    if (client.fhirUri.value != null) {
      final _newPatient = newPatient();
      print('Patient to be uploaded:\n${_newPatient.toJson()}');
      final request1 = FhirRequest.create(
        base: client.fhirUri.value!,
        //?? Uri.parse('127.0.0.1'),
        resource: _newPatient,
        client: client,
      );

      String? newId;
      try {
        final response = await request1.request();
        print('Response from upload:\n${response.toJson()}');
        newId = response.id;
      } catch (e) {
        print(e);
      }
      if (newId is! String) {
        print(newId);
      } else {
        final request2 = FhirRequest.read(
          base: client.fhirUri.value ?? Uri.parse('127.0.0.1'),
          type: R4ResourceType.Patient,
          id: newId,
          client: client,
        );
        try {
          final response = await request2.request();
          print('Response from read:\n${response.toJson()}');
        } catch (e) {
          print(e);
        }
      }
    }
  } catch (e, stack) {
    print('Error $e');
    print('Stack $stack');
  }
}



  final client = FhirClient(
    // fhirUri: FhirUri(Api.hapiUrl),
    fhirUri: FhirUri(Utils.getAPIEndPoint()),
    scopes: scopes.scopesList(),
  );


  Future<List<Patient>> searchPatients(String searchQuery)  async {
    List<String> search =["name=$searchQuery"];

    final searchRequest = FhirRequest.search(
      base: client.fhirUri.value!,
      parameters: search ,
      pretty: true,
      type: R4ResourceType.Patient,
      client: client,
    );

    try {
      final response = await searchRequest.request();
      if (response is Bundle) {
        final patients = response.entry
            ?.whereType<BundleEntry>()
            .map((e) => e.resource)

            .whereType<Patient>()
            .toList();

        return patients ?? [];
      } else {
        print('Failed to fetch patients');
      }
    } catch (e) {
      print('Error fetching patients: $e');
    }
    return [];
  }
  
  Future getPatient() async {  
  {
    List<Patient> patients = await searchPatients("raikot");

    for (Patient element in patients) {
      print(element.name);
      print(element.id);
    }
  }
  }