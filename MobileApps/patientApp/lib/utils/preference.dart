import 'dart:async';
import 'dart:convert';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import 'package:get_storage/get_storage.dart';

import '../ui/configuration/datamodel/configuration_datamodel.dart';
import '../ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import '../ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
/* global class for handle all the preference activity into application */

class Preference {
  // Preference key
  static const String tokenUrl = "tokenUrl";
  static const String connectSuccess = "connectSuccess";
  static const String authToken = "authToken";
  static const String isFirstTime = "IS_FIRST_TIME";
  // static const String activityData = "activityData";
  // static const String activityDataIcons = "activityDataIcons";
  // static const String activityDataCode = "activityDataCode";
  static const String qrUrlData = "qrUrlData";
  static const String refreshToken = "idToken";
  static const String expireTime = "expireTime";
  static const String patientId = "patientId";
  static const String patientFName = "patientFName";
  static const String getPatientFNameApi = "fNameCallApi";
  static const String patientLName = "patientLName";
  static const String patientDob = "patientDob";
  static const String patientGender = "patientGender";
  static const String healthPermission = "healthPermission";
  // static const String serverUrlList = "serverUrlList";
  static const String serverUrlAllListed = "serverUrlAllListed";
  static const String trackingPrefList = "trackingPrefList";
  static const String configurationInfo = "configurationInfo";
  static const String keyWelcomeDetails = "keyWelcomeDetails";
  static const String keyHealthProvider = "keyHealthProvider";
  static const String keyIntegrationScreen = "keyIntegrationScreen";
  static const String keyGoalView = "keyGoalView";
  static const String keyConfiguration = "keyConfiguration";
  static const String idActivityConfiguration = "idActivityConfiguration";

  static const String careManagerId = "careManagerId";
  static const String careManageName = "careManagerName";
  static const String careManageLastName = "careManagerLastName";

  static const String serviceProviderName = "serviceProviderName";
  static const String serviceProviderLastName = "serviceProviderLastName";
  static const String serviceProviderId = "serviceProviderId";
  static const String smartFhirPatientId = "smartFhirPatientId";
  static const String smartFhirPatientName = "smartFhirPatientName";

  static const String lastApiCalledTime = "lastApiCalledTime";
  static const String isAutoCalMode = "isAutoCalMode";
  static const String isDisclaimerUnChecked = "isDisclaimerUnChecked";

  static const String isFirstTimeTracking = "isFirstTimeTracking";

  // ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static GetStorage? _pref;

  /* make connection with preference only once in application */
  Future<GetStorage?> instance() async {
    if (_pref != null) return _pref;
    await GetStorage.init().then((value) {
      if (value) {
        _pref = GetStorage();
      }
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  String? getString(String key) {
    return _pref!.read(key);
  }

  Future<void> setString(String key, String value) {
    return _pref!.write(key, value);
  }

  int? getInt(String key) {
    return _pref!.read(key);
  }

  Future<void> setInt(String key, int value) {
    return _pref!.write(key, value);
  }

  bool? getBool(String key) {
    return _pref!.read(key);
  }

  Future<void> setBool(String key, bool value) {
    return _pref!.write(key, value);
  }

  // Double get & set
  double? getDouble(String key) {
    return _pref!.read(key);
  }

  Future<void> setDouble(String key, double value) {
    return _pref!.write(key, value);
  }

  // Array get & set
  List<String>? getStringList(String key) {
    return _pref!.read(key);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _pref!.write(key, value);
  }

  List<ServerModelJson>? getServerList(String key) {
    var jsonBody = _pref!.read(Preference.serverUrlAllListed);

    if(jsonBody != null){
      Iterable l = json.decode(jsonBody);
      List<ServerModelJson> serverDataList = List<ServerModelJson>.from(l.map((model)=> ServerModelJson.fromJson(model)));
      return serverDataList;
    }else{
      return [];
    }
  }

  List<ServerModelJson>? getServerListedAllUrl(String key) {
    var jsonBody = _pref!.read(key);

    if(jsonBody != null){
      Iterable l = json.decode(jsonBody);
      List<ServerModelJson> serverDataList = List<ServerModelJson>.from(l.map((model)=> ServerModelJson.fromJson(model)));
      return serverDataList;
    }else{
      return [];
    }
  }

  List<TrackingPref>? getTrackingPrefList(String key) {
    var jsonBody = _pref!.read(key);

    if(jsonBody != null){
      Iterable l = json.decode(jsonBody);
      List<TrackingPref> serverDataList = List<TrackingPref>.from(l.map((model)=> TrackingPref.fromJson(model)));
      return serverDataList;
    }else{
      return [];
    }
  }

  List<ConfigurationClass>? getConfigPrefList(String key) {
    var jsonBody = _pref!.read(key);

    if(jsonBody != null){
      Iterable l = json.decode(jsonBody);
      List<ConfigurationClass> serverDataList = List<ConfigurationClass>.from(l.map((model)=> ConfigurationClass.fromJson(model)));
      return serverDataList;
    }else{
      return [];
    }
  }

  // Future<void> setList(String key, List<ServerModelJson> value) {
  Future<void> setList(String key, String jsonValue) {
    return _pref!.write(key, jsonValue);
  }

  /* remove element from preferences */
  Future<void> remove(key, [multi = false]) async {
    GetStorage? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref!.remove(f);
      });
    } else {
      return await pref!.remove(key);
    }
  }

  /* remove all elements from preferences */
  static Future<bool> clear() async {
    // return await _pref.clear();
    _pref!.getKeys().forEach((key) async {
      await _pref!.remove(key);
    });

    return Future.value(true);
  }

  static Future<bool> clearLogout() async {
    /*_pref!.getKeys().forEach((key) async {
      if (key == accessToken ||
          key == tokenType ||
          key == expiresIn ||
          key == userEmail ||
          key == userData) {
        await _pref!.remove(key);
      }
    });*/
    return Future.value(true);
  }
}
