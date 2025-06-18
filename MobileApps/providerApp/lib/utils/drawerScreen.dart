import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'color.dart';
import 'font_style.dart';

class DrawerScreen extends StatefulWidget {
  String screenType = "";
  DrawerScreen({super.key,required this.screenType});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          child: Container(
            margin: EdgeInsets.only(top: Sizes.height_1),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  "assets/images/flutter.jpeg",
                  height: Sizes.height_7,
                  width: Sizes.height_7,
                ),
                Container(
                  margin: EdgeInsets.only(top: Sizes.height_1),
                  child: Text(
                    'Banny table',
                    style: AppFontStyle.styleW700(CColor.white,
                        (kIsWeb) ? FontSize.size_5 : FontSize.size_12),
                  ),
                ),
              ],
            ),
          ),
        ),
        ListTile(
          title: const Text('Home'),
          onTap: () {
            /*if(widget.screenType == AppRoutes.dashBoard){
              Get.back();
            }else {
              Get.offAllNamed(AppRoutes.dashBoard);
            }*/
            // Get.delete<HomeController>();
            // Get.delete<SettingController>();
            // Get.delete<LogControllers>();
            // Get.toNamed(AppRoutes.dashBoard);
          },
        ),
        ListTile(
          title: const Text('Calender'),
          onTap: () {
            /*if(widget.screenType == AppRoutes.home){
              Get.back();
            }else {
              Get.offAllNamed(AppRoutes.home);
            // }*/
            // Get.delete<LogControllers>();
            // Get.delete<SettingController>();
            // Get.delete<DashboardController>();
            // Get.toNamed(AppRoutes.home);
          },
        ),
        ListTile(
          title: const Text('Setting'),
          onTap: () {
            /*if(widget.screenType == AppRoutes.setting){
              Get.back();
            }else {
              Get.offAllNamed(AppRoutes.setting);
            }*/
            // Get.delete<HomeController>();
            // Get.delete<LogControllers>();
            // Get.delete<DashboardController>();
            // Get.toNamed(AppRoutes.setting);
          },
        ),
        ListTile(
          title: const Text('Log'),
          onTap: () {
            /*if(widget.screenType == AppRoutes.setting){
              Get.back();
            }else {
              Get.offAllNamed(AppRoutes.setting);
            }*/
            // Get.delete<HomeController>();
            // Get.delete<SettingController>();
            // Get.delete<DashboardController>();
            // Get.toNamed(AppRoutes.log);
          },
        ),

      ],
    ));
  }
}
