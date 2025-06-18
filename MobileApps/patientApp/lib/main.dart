import 'package:banny_table/routes/app_pages.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/themes/app_theme.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:health/health.dart';
import 'package:oauth2/oauth2.dart';
import 'connectivitymanager/connectivitymanager.dart';
import 'db_helper/database_helper.dart';


Future<void> main() async {
  try{
    WidgetsFlutterBinding.ensureInitialized();
    await Preference().instance();
    await InternetConnectivity().instance();
    await DataBaseHelper().initialize();
    if(!kIsWeb){
      Health().configure(useHealthConnectIfAvailable: true);
    }

    // await Permission.activityRecognition.request();
    // _configureLocalTimeZone();
    // await setClient();
    await Future.delayed(const Duration(seconds : 3 ));
  }catch(e){
    Debug.printLog("Health Main issue.....$e");
  }

  runApp(const MyApp());
}

/*Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}*/

/*Future<void> setClient()async{
  try {
    var urlQrData = Preference.shared.getString(Preference.qrUrlData) ?? "";
    if(urlQrData != ""){
      var linkAndClientId = urlQrData;
      var url = urlQrData;
      var clientId = "";
      if(linkAndClientId.contains("?"))
      {
        url = linkAndClientId.split("?")[0];
        if(linkAndClientId.split("?").length > 1)
        {
          clientId = linkAndClientId.split("?")[1].split("=")[1];
          ProviderRequest.setClientId(clientId);
        }
      }

      ProviderRequest.setClient(url);
      Constant.settingQRScan = urlQrData;
    }

  } catch (e) {
    Debug.printLog(e.toString());
  }
}*/

Future<bool> isLoggedIn(Client client) async =>
    client?.credentials.accessToken != null &&
        (client!.credentials.expiration?.isAfter(DateTime.now()) ?? false);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
        useMaterial3: false
      ),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: "It’s Time To Move",
        color: CColor.white,
        themeMode: ThemeMode.light,
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
          ),
        theme: ThemeData(
          useMaterial3: false
        ),
        darkTheme: AppTheme.light,
        locale: Get.deviceLocale,
        getPages: AppPages.list,
          initialRoute: ((Preference.shared.getBool(Preference.isDisclaimerUnChecked) ??
              true))?AppRoutes.disclaimer:(((Preference.shared.getBool(Preference.keyWelcomeDetails) ??
                  true))
              ? AppRoutes.welcomeScreen
              : (!(Preference.shared.getBool(Preference.keyWelcomeDetails) ?? true) &&
                      (Preference.shared.getBool(Preference.keyHealthProvider) ??
                          true))
                  ? AppRoutes.healthProvider
                  : (!(Preference.shared.getBool(Preference.keyHealthProvider) ??
                              true) &&
                          (Preference.shared
                                  .getBool(Preference.keyIntegrationScreen) ??
                              true))
                      ? AppRoutes.integrationScreen
                      : (!(Preference.shared
                                      .getBool(Preference.keyIntegrationScreen) ??
                                  true) &&
                              (Preference.shared
                                      .getBool(Preference.keyConfiguration) ??
                                  true))
                          ? AppRoutes.configurationMain
                          : (!(Preference.shared.getBool(Preference.keyIntegrationScreen) ??
                                      true) &&
                                  (Preference.shared.getBool(Preference.keyGoalView) ??
                                      true))
                              ? AppRoutes.goalViewScreen
                              : AppRoutes.bottomNavigation)),
    );
  }
}

