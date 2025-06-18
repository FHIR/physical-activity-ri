import 'package:banny_table/ui/home/activityLog/views/web_home_screen.dart';
import 'package:banny_table/ui/home/monthly/views/home_monthly_screen.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../bottomNavigation/controllers/bottom_navigation_controller.dart';
import '../controllers/home_controllers.dart';
import 'mobile_home_screen.dart';

class HomeScreen extends StatelessWidget {
  BottomNavigationController? bottomNavigationController;
  HomeScreen({super.key, @required this.bottomNavigationController});

  /*HomeControllers controller = Get.find<HomeControllers>();
  HomeMonthlyControllers monthlyControllers = Get.find<
      HomeMonthlyControllers>();*/

  // final LogControllers logic = Get.find<LogControllers>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: GetBuilder<HomeControllers>(
              assignId: true,
              init: HomeControllers(),
              // init: Get.put(HomeControllers()),
              builder: (logic) {
            // return (logic.isMonth)?
            return (Constant.isMonth)?
                  HomeMonthlyScreen(bottomNavigationController: bottomNavigationController,)
                :Container(
              child: (kIsWeb) ?
              const WebHomeScreen() :
              MobileHomeScreen(),
            );
          })
      ),
    );
  }
}
