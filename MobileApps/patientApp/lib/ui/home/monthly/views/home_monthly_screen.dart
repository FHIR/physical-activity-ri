import 'package:banny_table/ui/home/monthly/controllers/home_monthly_controllers.dart';
import 'package:banny_table/ui/home/monthly/views/home_monthly_mobile_screen.dart';
import 'package:banny_table/ui/home/monthly/views/home_monthly_web_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../bottomNavigation/controllers/bottom_navigation_controller.dart';

class HomeMonthlyScreen extends StatelessWidget {
  BottomNavigationController? bottomNavigationController;
  HomeMonthlyScreen({super.key, @required this.bottomNavigationController});
  // const HomeMonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<HomeMonthlyControllers>(
          assignId: true,
          // init: Get.put(HomeMonthlyControllers(),permanent: true),
          init: HomeMonthlyControllers(),
          builder: (logic) {
        return Stack(
          children: [
            Container(
              child: (kIsWeb) ?
              const HomeMonthlyWebScreen() :
              HomeMonthlyMobileScreen(bottomNavigationController: bottomNavigationController),
            ),
          ],
        );
      }),
    );
  }
}
