import 'package:banny_table/fhir_auth/fhir_client/fhir_client.dart';
import 'package:banny_table/fhir_auth/fhir_client/smart_fhir_client.dart';

class ServerModelJson {
  bool isSecure = false;
  String displayName = "";
  String title = "";
  String url = "";
  String clientId = "";
  bool isSelected = false;
  bool isPrimary = false;
  String patientId = "";
  String authToken = "";
  String refreshToken = "";
  int lastLoggedTime = 0;
  int expireTime = 0;
  String patientFName = "";
  String patientLName = "";
  String patientDOB = "";
  String patientGender = "";
  String lastDateTimeStr = "";

  ServerModelJson(
      {required this.isSecure,
        required this.displayName,
        required this.title,
        required this.url,
        required this.clientId,
        required this.isSelected,
        required this.isPrimary,
      });

  ServerModelJson.fromJson(Map<String, dynamic> json) {
    isSecure = json['isSecure'];
    displayName = json['displayName'];
    title = json['title'];
    url = json['url'];
    clientId = json['clientId'];
    isSelected = json['isSelected'];
    isPrimary = json['isPrimary'];
    patientId = json['patientId'];
    authToken = json['authToken'];
    refreshToken = json['refreshToken'];
    expireTime = json['expireTime'];
    patientFName = json['patientFName'];
    patientLName = json['patientLName'];
    patientDOB = json['patientDOB'];
    patientGender = json['patientGender'];
    lastLoggedTime = json['lastLoggedTime'];
    lastDateTimeStr = json['lastDateTimeStr'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isSecure'] = isSecure;
    data['displayName'] = displayName;
    data['title'] = title;
    data['url'] = url;
    data['clientId'] = clientId;
    data['isSelected'] = isSelected;
    data['isPrimary'] = isPrimary;
    data['patientId'] = patientId;
    data['authToken'] = authToken;
    data['refreshToken'] = refreshToken;
    data['expireTime'] = expireTime;
    data['patientFName'] = patientFName;
    data['patientLName'] = patientLName;
    data['patientDOB'] = patientDOB;
    data['patientGender'] = patientGender;
    data['lastLoggedTime'] = lastLoggedTime;
    data['lastDateTimeStr'] = lastDateTimeStr;
    return data;
  }
}
