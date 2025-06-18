import 'package:banny_table/ui/bottomNavigation/views/bottom_navigation_screen.dart';
import 'package:banny_table/ui/cameraScreen/binding/camera_binding.dart';
import 'package:banny_table/ui/cameraScreen/views/camera_screen.dart';
import 'package:banny_table/ui/carePlanForm/bindings/care_plan_form_binding.dart';
import 'package:banny_table/ui/carePlanForm/views/care_plan_form_screen.dart';
import 'package:banny_table/ui/carePlanList/bindings/care_plan_list_binding.dart';
import 'package:banny_table/ui/carePlanList/views/care_plan_list_screen.dart';
import 'package:banny_table/ui/conditionForm/bindings/condition_form_binding.dart';
import 'package:banny_table/ui/conditionForm/views/condition_form_screen.dart';
import 'package:banny_table/ui/conditionList/bindings/condition_list_binding.dart';
import 'package:banny_table/ui/conditionList/views/condition_list_screen.dart';
import 'package:banny_table/ui/configuration/binding/configuration_binding.dart';
import 'package:banny_table/ui/configuration/views/configuration_screen.dart';
import 'package:banny_table/ui/disclaimer/views/disclaimer_screen.dart';
import 'package:banny_table/ui/goalForm/bindings/goal_form_binding.dart';
import 'package:banny_table/ui/goalForm/views/goal_form_screen.dart';
import 'package:banny_table/ui/goalList/bindings/goal_list_binding.dart';
import 'package:banny_table/ui/goalList/views/goal_list_screen.dart';
import 'package:banny_table/ui/graph/bindings/graph_binding.dart';
import 'package:banny_table/ui/graph/views/graph_screen.dart';
import 'package:banny_table/ui/history/views/history_screen.dart';
import 'package:banny_table/ui/home/monthly/bindings/home_monthly_binding.dart';
import 'package:banny_table/ui/importExport/bindings/import_export_binding.dart';
import 'package:banny_table/ui/importExport/views/import_export_screen.dart';
import 'package:banny_table/ui/logtableList/bindings/log_table_binding.dart';
import 'package:banny_table/ui/logtableList/views/log_table_screen.dart';
import 'package:banny_table/ui/routingReferral/bindings/routing_referral_binding.dart';
import 'package:banny_table/ui/routingReferral/views/routing_referral_screen.dart';
import 'package:banny_table/ui/referralForm/bindings/referral_form_binding.dart';
import 'package:banny_table/ui/referralForm/views/referral_form_screen.dart';
import 'package:banny_table/ui/referralList/bindings/referral_list_binding.dart';
import 'package:banny_table/ui/referralList/views/referral_list_screen.dart';
import 'package:banny_table/ui/setting/views/setting_screen.dart';
import 'package:banny_table/ui/toDoForm/bindings/to_do_form_binding.dart';
import 'package:banny_table/ui/toDoForm/views/to_do_form_screen.dart';
import 'package:banny_table/ui/toDoList/bindings/to_do_list_binding.dart';
import 'package:banny_table/ui/toDoList/views/to_do_list_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/activitySelection/bindings/activity_selection_binding.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/activitySelection/views/activity_selection_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/bindings/configuration_binding.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/configuration/views/configuration_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/bindings/configuration_intro_binding.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/introConfiguration/views/configuration_intro_screen.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/bindings/tracking_pref_binding.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/views/tracking_pref_screen.dart';
import 'package:banny_table/ui/welcomeScreen/goalView/bindings/goal_view_binding.dart';
import 'package:banny_table/ui/welcomeScreen/goalView/views/goal_view_screen.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/bindings/select_primary_binding.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/selectPrimaryServer/views/select_primary_screen.dart';
import 'package:banny_table/ui/welcomeScreen/integration/bindings/integration_binding.dart';
import 'package:banny_table/ui/welcomeScreen/integration/views/integration_screen.dart';
import 'package:banny_table/ui/welcomeScreen/welcome/bindings/welcome_binding.dart';
import 'package:banny_table/ui/welcomeScreen/welcome/views/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import '../ui/bottomNavigation/bindings/bottom_navigation_binding.dart';
import '../ui/disclaimer/bindings/disclaimer_binding.dart';
import '../ui/exerciseDataList/bindings/exercise_list_binding.dart';
import '../ui/exerciseDataList/views/exercise_list_screen.dart';
import '../ui/exercisePrescriptionForm/bindings/exercise_prescription_form_binding.dart';
import '../ui/exercisePrescriptionForm/views/exercise_prescription_form_screen.dart';
import '../ui/history/bindings/history_binding.dart';
import '../ui/home/activityLog/views/home_screen.dart';
import '../ui/home/monthly/views/home_monthly_screen.dart';
import '../ui/mixed/bindings/mixed_binding.dart';
import '../ui/mixed/views/mixed_screen.dart';
import '../ui/setting/bindings/setting_binding.dart';
import '../ui/welcomeScreen/healthProvider/healthProvider/bindings/health_provider_binding.dart';
import '../ui/welcomeScreen/healthProvider/healthProvider/views/health_provider_screen.dart';
import '../ui/welcomeScreen/healthProvider/intro/bindings/health_provider_intro_binding.dart';
import '../ui/welcomeScreen/healthProvider/intro/views/health_provider_intro_screen.dart';
import '../ui/welcomeScreen/healthProvider/patientList/bindings/patient_list_binding.dart';
import '../ui/welcomeScreen/healthProvider/patientList/views/patient_list_screen.dart';
import '../ui/welcomeScreen/healthProvider/qrScanner/bindings/qr_scanner_binding.dart';
import '../ui/welcomeScreen/healthProvider/qrScanner/views/qr_scanner_screen.dart';
import '../utils/color.dart';
import 'app_routes.dart';

class AppPages {
  static var list = [
    GetPage(
      name: AppRoutes.home,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HomeScreen(),
          );
        },
      ),
      binding: HistoryBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.history,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HistoryScreen(),
          );
        },
      ),
      binding: HistoryBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.setting,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: SettingScreen(),
          );
        },
      ),
      binding: SettingBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.graph,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: GraphScreen(),
          );
        },
      ),
      binding: GraphBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.mixed,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: MixedScreen(),
          );
        },
      ),
      binding: MixedBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.bottomNavigation,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: BottomNavigationScreen(),
          );
        },
      ),
      binding: BottomNavigationBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.homeMonthly,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HomeMonthlyScreen(),
          );
        },
      ),
      binding: HomeMonthlyBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.goalList,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: GoalListScreen(),
          );
        },
      ),
      binding: GoalListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.goalForm,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: GoalFormScreen(),
          );
        },
      ),
      binding: GoalFormBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.configuration,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ConfigurationScreen(),
          );
        },
      ),
      binding: ConfigurationBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.referralList,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ReferralListScreen(),
          );
        },
      ),
      binding: ReferralListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.referralForm,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ReferralFormScreen(),
          );
        },
      ),
      binding: ReferralFormBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.routingReferral,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: RoutingReferralScreen(),
          );
        },
      ),
      binding: RoutingReferralBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: AppRoutes.importExport,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ImportExportScreen(),
          );
        },
      ),
      binding: ImportExportBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.conditionForm,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ConditionFormScreen(),
          );
        },
      ),
      binding: ConditionFormBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.carePlanForm,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: CarePlanFormScreen(),
          );
        },
      ),
      binding: CarePlanFormBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: AppRoutes.conditionList,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ConditionListScreen(),
          );
        },
      ),
      binding: ConditionListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.carePlanList,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: CarePlanListScreen(),
          );
        },
      ),
      binding: CarePlanListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.welcomeScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: WelcomeScreen(),
          );
        },
      ),
      binding: WelcomeBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.integrationScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: IntegrationScreen(),
          );
        },
      ),
      binding: IntegrationBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.goalViewScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: GoalViewScreen(),
          );
        },
      ),
      binding: GoalViewBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.healthProvider,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return   const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HealthProviderScreen(),
          );
        },
      ),
      binding: HealthProviderBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.healthProviderIntro,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: HealthProviderIntroScreen(),
          );
        },
      ),
      binding: HealthProviderIntroBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.healthQrScanner,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return   AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: QrScannerScreen(),
          );
        },
      ),
      binding: QrScannerBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.healthPatientList,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: PatientListScreen(),
          );
        },
      ),
      binding: PatientListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.configurationMain,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return   const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ConfigurationMainScreen(),
          );
        },
      ),
      binding: ConfigurationMainBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.configurationIntro,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return   AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ConfigurationIntroScreen(),
          );
        },
      ),
      binding: ConfigurationIntroBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: AppRoutes.trackingPref,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: TrackingPrefScreen(),
          );
        },
      ),
      binding: TrackingPrefBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),

    GetPage(
      name: AppRoutes.activitySelection,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ActivitySelectionScreen(),
          );
        },
      ),
      binding: ActivitySelectionBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.toDoFormScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ToDoFormScreen(),
          );
        },
      ),
      binding: ToDoFormBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.toDoListScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ToDoListScreen(),
          );
        },
      ),
      binding: ToDoListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.logTableScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: LogTableScreen(),
          );
        },
      ),
      binding: LogTableBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.selectPrimaryScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  AnnotatedRegion<SystemUiOverlayStyle>(
            value: const SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: SelectPrimaryScreen(),
          );
        },
      ),
      binding: SelectPrimaryBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.cameraScreen,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: CameraScreen(),
          );
        },
      ),
      binding: CameraBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.exerciseForm,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ExercisePrescriptionScreen(),
          );
        },
      ),
      binding: ExercisePrescriptionBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.exerciseDataList,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: ExerciseListScreen(),
          );
        },
      ),
      binding: ExerciseListBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.disclaimer,
      page: () => Sizer(
        builder: (context, orientation, deviceType) {
          return  const AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
              statusBarColor: CColor.transparent,
              statusBarIconBrightness: Brightness.dark,
              systemNavigationBarIconBrightness: Brightness.light,
            ),
            child: DisclaimerScreen(),
          );
        },
      ),
      binding: DisclaimerBinding(),
      transition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
  ];
}
