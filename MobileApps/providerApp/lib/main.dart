import 'package:banny_table/resources/providerRequest.dart';
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
import 'package:get/get.dart';
import 'package:oauth2/oauth2.dart';
import 'connectivitymanager/connectivitymanager.dart';
import 'db_helper/database_helper.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preference().instance();
  await InternetConnectivity().instance();
  await DataBaseHelper().initialize();
  // await Permission.activityRecognition.request();
  // _configureLocalTimeZone();
  await setClient();
  await Future.delayed(const Duration(seconds : 3 ));
  runApp(const MyApp());
}

/*Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}*/

Future<void> setClient()async{
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
}

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
        title: "TTM Provider",
        color: CColor.white,
        themeMode: ThemeMode.light,
          scrollBehavior: MaterialScrollBehavior().copyWith(
            dragDevices: {PointerDeviceKind.mouse, PointerDeviceKind.touch, PointerDeviceKind.stylus, PointerDeviceKind.unknown},
          ),
        theme: AppTheme.light,
        darkTheme: AppTheme.light,
        locale: Get.deviceLocale,
        getPages: AppPages.list,
          initialRoute: ((Preference.shared.getBool(Preference.isDisclaimerUnChecked) ??
    true))?AppRoutes.disclaimer:( ((Preference.shared.getBool(Constant.keyIndependentPatient) ?? true) &&
                  (Preference.shared.getBool(Constant.keyWelcomeDetails) ?? true))
              ? AppRoutes.welcomeScreen
              : ((Preference.shared.getBool(Constant.keyIndependentPatient) ?? true) &&
                      !(Preference.shared.getBool(Constant.keyWelcomeDetails) ?? true))
                  ? AppRoutes.patientIndependentMode
                  : (Preference.shared.getBool(Constant.keyWelcomeDetails) ?? true)
                      ? AppRoutes.welcomeScreen
                      : AppRoutes.bottomNavigation)),
    );
  }
}

