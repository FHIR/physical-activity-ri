import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:banny_table/db_helper/box/identifier_data.dart';
import 'package:banny_table/db_helper/box/monthly_log_data.dart';
import 'package:banny_table/db_helper/database_helper.dart';
import 'package:banny_table/healthData/getWorkOutDataModel.dart';
import 'package:banny_table/resources/PaaProfiles.dart';
import 'package:banny_table/resources/providerRequest.dart';
import 'package:banny_table/resources/syncing.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/configuration/datamodel/activity_dataModel.dart';
import 'package:banny_table/ui/goalForm/datamodel/goalTypeData.dart';
import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/ui/home/monthly/datamodel/monthNameAndNumber.dart';
import 'package:banny_table/ui/referralForm/datamodel/referralTypeCodeDataModel.dart';
import 'package:banny_table/ui/toDoList/dataModel/codeModel.dart';
import 'package:banny_table/ui/welcomeScreen/activityConfiguration/trackingPref/datamodel/trackingPref.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/preference.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:fhir_at_rest/r4/fhir_request.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:health/health.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/custom_indicator.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/indicator/material_indicator.dart';
import 'package:horizontal_data_table/refresh/pull_to_refresh/src/smart_refresher.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';
import 'package:xml/xml.dart';
import '../db_helper/box/activity_data.dart';
import '../db_helper/box/care_plan_form_data.dart';
import '../db_helper/box/condition_form_data.dart';
import '../db_helper/box/goal_data.dart';
import '../db_helper/box/notes_data.dart';
import '../db_helper/box/referral_data.dart';
import '../db_helper/box/routing_referral_data.dart';
import '../db_helper/box/server_detail_data.dart';
import '../db_helper/box/server_detail_data_mod_min.dart';
import '../db_helper/box/server_detail_data_vig_min.dart';
import '../fhir_auth/r4.dart';
import '../providers/api.dart';
import '../ui/configuration/datamodel/configuration_datamodel.dart';
import '../ui/graph/datamodel/graphDatamodel.dart';
import '../ui/graph/datamodel/graphWeeklyXDate.dart';
import '../ui/graph/views/graph_screen.dart';
import '../ui/history/datamodel/activityMinClass.dart';
import '../ui/history/datamodel/hasMemberListData.dart';
import '../ui/referralForm/datamodel/performerData.dart';
import '../ui/welcomeScreen/healthProvider/patientList/dataModel/patientDataModel.dart';
import '../ui/welcomeScreen/healthProvider/qrScanner/datamodel/serverModel.dart';
import '../ui/welcomeScreen/healthProvider/selectPrimaryServer/datamodel/serverModelJson.dart';
import 'constant.dart';
import 'package:fhir/r4.dart';
import 'package:http/http.dart' as http;


class Utils {
  static showToast(BuildContext context, String msg) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
    );
  }

  static bool isFirstTime() {
    return Preference.shared.getBool(Preference.isFirstTime) ?? true;
  }

  static bool isLogin() {
    var accessToken = Preference.shared.getString(Preference.authToken);
    return (accessToken != null && accessToken.isNotEmpty);
  }

  static List<String> getWeekDays() {
    return ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
  }

  static Widget dividerCustom({Color color = CColor.black}) {
    return Divider(
      color: color,
      thickness: 1,
      height: 1,
    );
  }

  static Widget verticalDividerCustom({Color color = CColor.black}) {
    return VerticalDivider(
      color: color,
      width: 1,
      thickness: 1,
    );
  }

  static String getShortDate(String date) {
    return "";
  }

  static String getIconNameFromType(int value) {
    // Debug.printLog("getIconNameFromType....$value");
    String labelIcon = Constant.icQuestionMark;
    if (value == -3) {
      labelIcon = Constant.smiley1ImgPath;
    } else if (value == -2) {
      labelIcon = Constant.smiley2ImgPath;
    } else if (value == -1) {
      labelIcon = Constant.smiley3ImgPath;
    } else if (value == 0) {
      labelIcon = Constant.smiley4ImgPath;
    } else if (value == 1) {
      labelIcon = Constant.smiley5ImgPath;
    } else if (value == 2) {
      labelIcon = Constant.smiley6ImgPath;
    } else if (value == 3) {
      labelIcon = Constant.smiley7ImgPath;
    } else {
      labelIcon = Constant.icQuestionMark;
    }
    return labelIcon;
  }

  /*static String getNumberIconNameFromType(String value) {
    String labelIcon = "assets/icons/ic_emoji(1).jpeg";
    if (value == Constant.itemOne) {
      labelIcon = "assets/icons/ic_1.png";
    } else if (value == Constant.itemTwo) {
      labelIcon = "assets/icons/ic_2.png";
    } else if (value == Constant.itemThree) {
      labelIcon = "assets/icons/ic_3.png";
    } else if (value == Constant.itemFour) {
      labelIcon = "assets/icons/ic_4.png";
    } else if (value == Constant.itemFive) {
      labelIcon = "assets/icons/ic_5.png";
    } else if (value == Constant.itemSix) {
      labelIcon = "assets/icons/ic_6.png";
    } else {
      labelIcon = "assets/icons/ic_1.png";
    }
    return labelIcon;
  }*/

/*  static String getNumberIconNameFromType(String value) {
    String labelIcon = "assets/icons/ic_bicycle.png";
    if (value == Constant.itemBicycling) {
      labelIcon = "assets/icons/ic_bicycle.png";
    } else if (value == Constant.itemJogging) {
      labelIcon = "assets/icons/ic_jogging.png";
    } else if (value == Constant.itemRunning) {
      labelIcon = "assets/icons/ic_running.png";
    } else if (value == Constant.itemSwimming) {
      labelIcon = "assets/icons/ic_swimming.png";
      // labelIcon = "assets/icons/ic_strength.png";
    } else if (value == Constant.itemWalking) {
      // labelIcon = "assets/icons/ic_swimming.png";
      labelIcon = "assets/icons/ic_walking.png";
    } else if (value == Constant.itemWeights) {
      // labelIcon = "assets/icons/ic_walking.png";
      labelIcon = "assets/icons/ic_strength.png";
    } else if (value == Constant.itemMixed) {
      labelIcon = "assets/icons/ic_mixed.png";
    } else if(value == Constant.activityAerobics){
      labelIcon = Constant.activityImagesAerobics;
    }
    else if(value == Constant.activityAmericanFootball){
      labelIcon = Constant.activityImagesAmericanFootball;
    }
    else if(value == Constant.activityBadminton){
      labelIcon = Constant.activityImagesBadminton;
    }
    else if(value == Constant.activityBaseball){
      labelIcon = Constant.activityImagesBaseball;
    }
    else if(value == Constant.activityBasketball){
      labelIcon = Constant.activityImagesBasketball;
    }
    else if(value == Constant.activityBiathlon){
      labelIcon = Constant.activityImagesBiathlon;
    }
    else if(value == Constant.activityBoxingGlove){
      labelIcon = Constant.activityImagesBoxingGlove;
    }    else if(value == Constant.activityCircuitTraining){
      labelIcon = Constant.activityCricket;
    }    else if(value == Constant.activityBoxingGlove){
      labelIcon = Constant.activityImagesCricket;
    }
    else if(value == Constant.activityCurlingStone){
      labelIcon = Constant.activityImagesCurlingStone;
    }    else if(value == Constant.activityCycling){
      labelIcon = Constant.activityImagesCycling;
    }
    else if(value == Constant.activityDancing){
      labelIcon = Constant.activityImagesDancing;
    }
    else if(value == Constant.activityDumbbell){
      labelIcon = Constant.activityImagesDumbbell;
    }
    else if(value == Constant.activityElliptical){
      labelIcon = Constant.activityImagesElliptical;
    }
    else if(value == Constant.activityErgoMeter){
      labelIcon = Constant.activityImagesErgometer;
    }
    else if(value == Constant.activityFencing){
      labelIcon = Constant.activityImagesFencing;
    }
    else if(value == Constant.activityRollerSkating){
      labelIcon = Constant.activityImagesRollerSkating;
    }
    else if(value == Constant.activityScubaDiving){
      labelIcon = Constant.activityImagesScubaDiving;
    }
    else if(value == Constant.activitySkiing){
      labelIcon = Constant.activityImagesSkiing;
    }
    else if(value == Constant.activitySoccerBall){
      labelIcon = Constant.activityImagesSoccerBall;
    }
    else if(value == Constant.activityVolleyball){
      labelIcon = Constant.activityImagesVolleyball;
    }
    else if(value == Constant.activityWalking){
      labelIcon = Constant.activityImagesWalking;
    }
    else if(value == Constant.activityWaterSkiing){
      labelIcon = Constant.activityImagesWaterskiing;
    }
    else if(value == Constant.activityYoga){
      labelIcon = Constant.activityImagesYoga;
    } else{
      labelIcon = "assets/icons/ic_bicycle.png";
    }
    return labelIcon;
  }*/

  static String getNumberIconNameFromType(String value) {
    var workoutData = (kIsWeb)?Utils.workOutDataListAndroid:(Platform.isIOS)?Utils.workOutDataListIos:Utils.workOutDataListAndroid;
    var data = workoutData.where((element) => element.workOutDataName == value).toList();
    if(data.isNotEmpty){
      return data[0].workOutDataImages;
    }else{
      return Constant.activityImagesOther;
    }
  }

  static int doubleToInt(value) {
    return double.parse(value).toInt();
  }

  static Widget getSmileyWidget(String imagePath, String text,
      {bool isWeb = false,BoxConstraints? constraints}) {
    return Row(
      children: [
        Image.asset(
          imagePath,
          width: (isWeb) ?(constraints != null) ? AppFontStyle.sizesWidthManageTrackingChartWeb(1.8, constraints) : Sizes.width_1_9 : Sizes.width_6,
        ),
        Container(
          margin: EdgeInsets.only(left: Sizes.width_1),
          child: Text(
            text,
          ),
        ),
      ],
    );
  }

  /* static List<String> allYearlyMonths = [
    Constant.jan,
    Constant.feb,
    Constant.mar,
    Constant.apr,
    Constant.may,
    Constant.jun,
    Constant.jul,
    Constant.aug,
    Constant.sep,
    Constant.oct,
    Constant.nov,
    Constant.edc,
  ];*/

  static List<MonthNameAndNumber> allYearlyMonths = [
    MonthNameAndNumber(Constant.jan, 1),
    MonthNameAndNumber(Constant.feb, 2),
    MonthNameAndNumber(Constant.mar, 3),
    MonthNameAndNumber(Constant.apr, 4),
    MonthNameAndNumber(Constant.may, 5),
    MonthNameAndNumber(Constant.jun, 6),
    MonthNameAndNumber(Constant.jul, 7),
    MonthNameAndNumber(Constant.aug, 8),
    MonthNameAndNumber(Constant.sep, 9),
    MonthNameAndNumber(Constant.oct, 10),
    MonthNameAndNumber(Constant.nov, 11),
    MonthNameAndNumber(Constant.dec, 12),
  ];

/*
  static KeyboardActionsConfig buildKeyboardActionsConfig(FocusNode focusNode) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.white,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode,
        ),
      ],
    );
  }
*/

  static List<String> statusList = [
    Constant.statusDraft,
    Constant.statusActive,
    Constant.statusOnHold,
    Constant.statusRevoked,
    Constant.statusCompleted,
    Constant.statusEnteredInError,
  ];

  static List<String> intentList = [
    Constant.intentOriginalOrder,
    Constant.intentOrder,
    Constant.intentFillerOrder,
  ];

  static List<String> priorityToDoList = [
    Constant.priorityRoutine,
    Constant.priorityUrgent,
  ];

  static List<String> priorityList = [
    Constant.priorityRoutine,
    Constant.priorityUrgent,
    Constant.priorityAsap,
    Constant.priorityStat,
  ];

  static List<ReferralTypeCodeDataModel> codeList = [
    ReferralTypeCodeDataModel(display:Constant.codePAGuidance, code: "819961005" ),
    ReferralTypeCodeDataModel(display:Constant.codePAAssessment, code: "398636004" ),
    ReferralTypeCodeDataModel(display:Constant.codeCounselingAboutPhysicalActivity, code: "435551000124105" ),
    ReferralTypeCodeDataModel(display:Constant.codeReferralToPhysicalActivityProgram, code: "390893007" ),
    ReferralTypeCodeDataModel(display:Constant.codeDeterminationOfPhysicalActivityTolerance, code: "426866005" ),
    ReferralTypeCodeDataModel(display:Constant.codeExerciseClass, code: "229095001" ),
    ReferralTypeCodeDataModel(display:Constant.codeExerciseTherapy, code: "229065009" ),
  ];

  static List<CodeToDoModel> codeTodoList = [
    CodeToDoModel(code: Constant.toDoCodeMakeContact ,display: Constant.toDoCodeDisplayMakeContact ),
    CodeToDoModel(code: Constant.toDoCodeReviewMaterial ,display: Constant.toDoCodeDisplayReviewMaterial ),
    CodeToDoModel(code: Constant.toDoCodeGeneralInfo ,display: Constant.toDoCodeDisplayGeneralInfo ),
    CodeToDoModel(code: Constant.toDoCodeCompleteQuestionnaire ,display: Constant.toDoCodeDisplayCompleteQuestionnaire ),

  ];

  // static List<String> performerList = [
  static List<PerformerData> performerList = [
    //   Use api and Get This List in Data
  ];

/*  static List<String> ownerList = [
  //   Use api and Get This List in Data
  ];*/

  static List<String> lifeCycleStatusList = [
    Constant.lifeCycleActive,
    // Constant.lifeCycleProposed,
    // Constant.lifeCyclePlanned,
    // Constant.lifeCycleAccepted,
    Constant.lifeCycleOnHold,
    Constant.lifeCycleCompleted,
    Constant.lifeCycleCancelled,
    // Constant.lifeCycleEnteredInError,
    // Constant.lifeCycleRejected,
  ];

  /*static List<GoalTypeData> multipleGoalsList = [
    GoalTypeData(goalHerder: Constant.goalTypesStep, goalTypeShow: Constant.goalTypesStepShow),
    GoalTypeData(goalHerder: Constant.goalTypesBPM, goalTypeShow: Constant.goalTypesBPMShow),
    GoalTypeData(goalHerder: Constant.goalTypesBPMRest, goalTypeShow: Constant.goalTypesBPMRestShow),
    GoalTypeData(goalHerder: Constant.goalTypesBPMCalories, goalTypeShow: Constant.goalTypesBPMCaloriesShow),
    GoalTypeData(goalHerder: Constant.goalTypesDaysPerWeek, goalTypeShow: Constant.goalTypesDaysPerWeekShow),
    GoalTypeData(goalHerder: Constant.goalTypesAverageMinutes, goalTypeShow: Constant.goalTypesAverageMinutesShow),
    GoalTypeData(goalHerder: Constant.goalTypesMinutesPerWeek, goalTypeShow: Constant.goalTypesMinutesPerWeekShow),
    GoalTypeData(goalHerder: Constant.goalTypesDaysPerWeekTraining, goalTypeShow: Constant.goalTypesDaysPerWeekTrainingShow),

  ];*/


  static List<GoalMeasure> multipleGoalsList = [
    GoalMeasure(code: "41950-7",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesStep,
        targetPlaceHolder: Constant.goalTypesStepShow,
        actualDescription: "Number of steps in 24 hour Measured"),
    GoalMeasure(code: "8873-2",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesBPM,
        targetPlaceHolder: Constant.goalTypesBPMShow,
        actualDescription: "Heart rate 24 hour maximum"),
    GoalMeasure(code: "40443-4",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesBPMRest,
        targetPlaceHolder: Constant.goalTypesBPMRestShow,
        actualDescription: "Heart rate --resting"),
    GoalMeasure(code: "41979-6",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesBPMCalories,
        targetPlaceHolder: Constant.goalTypesBPMCaloriesShow,
        actualDescription: "Calories burned in 24 hour Calculated"),
    GoalMeasure(code: "89555-7",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesDaysPerWeek,
        targetPlaceHolder: Constant.goalTypesDaysPerWeekShow,
        actualDescription: "How many days per week did you engage in moderate to strenuous physical activity in the last 30 days"),
    GoalMeasure(code: "68516-4",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesAverageMinutes,
        targetPlaceHolder: Constant.goalTypesAverageMinutesShow,
        actualDescription: "On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise"),
    GoalMeasure(code: "82290-8",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesMinutesPerWeek,
        targetPlaceHolder: Constant.goalTypesMinutesPerWeekShow,
        actualDescription: "Frequency of moderate to vigorous aerobic physical activity"),
    GoalMeasure(code: "82291-6",
        system: "http://loinc.org",
        goalValue: Constant.goalTypesDaysPerWeekTraining,
        targetPlaceHolder: Constant.goalTypesDaysPerWeekTrainingShow,
        actualDescription: "Frequency of muscle-strengthening physical activity"),
  ];

  static List<ActivityImagesModel> activityImagesList = [
    ActivityImagesModel(imageTitle: Constant.activityAerobics,
        imagesPath: Constant.activityImagesAerobics),
    ActivityImagesModel(imageTitle: Constant.activityAmericanFootball,
        imagesPath: Constant.activityImagesAmericanFootball),
    ActivityImagesModel(imageTitle: Constant.activityBadminton,
        imagesPath: Constant.activityImagesBadminton),
    ActivityImagesModel(imageTitle: Constant.activityBaseball,
        imagesPath: Constant.activityImagesBaseball),
    ActivityImagesModel(imageTitle: Constant.activityBasketball,
        imagesPath: Constant.activityImagesBasketball),
    ActivityImagesModel(imageTitle: Constant.activityBiathlon,
        imagesPath: Constant.activityImagesBiathlon),
    ActivityImagesModel(imageTitle: Constant.activityBoxingGlove,
        imagesPath: Constant.activityImagesBoxingGlove),
    ActivityImagesModel(imageTitle: Constant.activityCircuitTraining,
        imagesPath: Constant.activityImagesCircuitTraining),
    ActivityImagesModel(imageTitle: Constant.activityCricket,
        imagesPath: Constant.activityImagesCricket),
    ActivityImagesModel(imageTitle: Constant.activityCurlingStone,
        imagesPath: Constant.activityImagesCurlingStone),
    ActivityImagesModel(imageTitle: Constant.activityCycling,
        imagesPath: Constant.activityImagesCycling),
    ActivityImagesModel(imageTitle: Constant.activityDancing,
        imagesPath: Constant.activityImagesDancing),
    ActivityImagesModel(imageTitle: Constant.activityDumbbell,
        imagesPath: Constant.activityImagesDumbbell),
    ActivityImagesModel(imageTitle: Constant.activityElliptical,
        imagesPath: Constant.activityImagesElliptical),
    ActivityImagesModel(imageTitle: Constant.activityErgoMeter,
        imagesPath: Constant.activityImagesErgometer),
    ActivityImagesModel(imageTitle: Constant.activityFencing,
        imagesPath: Constant.activityImagesFencing),
    ActivityImagesModel(imageTitle: Constant.activityRollerSkating,
        imagesPath: Constant.activityImagesRollerSkating),
    ActivityImagesModel(imageTitle: Constant.activityScubaDiving,
        imagesPath: Constant.activityImagesScubaDiving),
    ActivityImagesModel(imageTitle: Constant.activitySkiing,
        imagesPath: Constant.activityImagesSkiing),
    ActivityImagesModel(imageTitle: Constant.activitySoccerBall,
        imagesPath: Constant.activityImagesSoccerBall),
    ActivityImagesModel(imageTitle: Constant.activityVolleyball,
        imagesPath: Constant.activityImagesVolleyball),
    ActivityImagesModel(imageTitle: Constant.activityWalking,
        imagesPath: Constant.activityImagesWalking),
    ActivityImagesModel(imageTitle: Constant.activityWaterSkiing,
        imagesPath: Constant.activityImagesWaterskiing),
    ActivityImagesModel(imageTitle: Constant.activityYoga,
        imagesPath: Constant.activityImagesYoga),
  ];


  static List<String> routingRoutesStatusWithOutComplete = [
    Constant.routingReferralRequested,
    Constant.routingReferralAccepted,
    Constant.routingReferralInProgress,
    Constant.routingReferralOnHold,
    Constant.routingReferralFailed,
    Constant.routingReferralEnteredInError,
  ];

  static List<String> routingReferralStatus = [
    Constant.routingReferralDraft,
    Constant.routingReferralRequested,
    Constant.routingReferralAccepted,
    Constant.routingReferralRejected,
    Constant.routingReferralCancelled,
    Constant.routingReferralInProgress,
    Constant.routingReferralCompleted,
    Constant.routingReferralOnHold,
    Constant.routingReferralFailed,
    Constant.routingReferralEnteredInError,
  ];

  static List<String> syncingTimeList = [
    Constant.realTime,
    Constant.daily,
    Constant.weekly
  ];

  static List<String> filterGoalList = [
    Constant.statusAll,
    Constant.statusActive
    // FilterData(filterName:Constant.statusAll ),
    // FilterData(filterName:Constant.statusActive ),
  ];


  static List<String> ownerLists = [
    Constant.priorityRoutine,
    Constant.priorityUrgent,
    Constant.priorityAsap,
    Constant.priorityStat,
    Constant.goalTypesBPM,
    Constant.goalTypesBPMRest,
    Constant.goalTypesBPMCalories,
    Constant.goalTypesDaysPerWeek,
    Constant.goalTypesAverageMinutes,
    Constant.goalTypesMinutesPerWeek,
    Constant.goalTypesDaysPerWeekTraining,
  ];

  static List multipleGoalsListString = [
    Constant.goalTypesStep,
    Constant.goalTypesBPM,
    Constant.goalTypesBPMRest,
    Constant.goalTypesBPMCalories,
    Constant.goalTypesDaysPerWeek,
    Constant.goalTypesAverageMinutes,
    Constant.goalTypesMinutesPerWeek,
    Constant.goalTypesDaysPerWeekTraining,
  ];

  /*static List<GoalMeasure> multipleGoalsCodes = [
    GoalMeasure("41950-7", "http://loinc.org",Constant.goalTypesStep),
    GoalMeasure("8873-2", "http://loinc.org",Constant.goalTypesBPM),
    GoalMeasure("40443-4", "http://loinc.org",Constant.goalTypesBPMRest),
    GoalMeasure("41979-6", "http://loinc.org",Constant.goalTypesBPMCalories),
    GoalMeasure("89555-7", "http://loinc.org",Constant.goalTypesDaysPerWeek),
    GoalMeasure("68516-4", "http://loinc.org",Constant.goalTypesAverageMinutes),
    GoalMeasure("82290-8", "http://loinc.org",Constant.goalTypesMinutesPerWeek),
    GoalMeasure("82291-6", "http://loinc.org",Constant.goalTypesDaysPerWeekTraining),
  ];*/


  static List<String> achievementStatusList = [
    Constant.achievementStatusInProgress,
    Constant.achievementStatusImproving,
    Constant.achievementStatusWorsening,
    Constant.achievementStatusNoChange,
    Constant.achievementStatusAchieved,
    Constant.achievementStatusSustaining,
    Constant.achievementStatusNotAchieved,
    Constant.achievementStatusNoProgress,
    Constant.achievementStatusNotAttainable,
  ];


  static List<String> verificationStatusList = [
    Constant.verificationStatusConfirmed,
    Constant.verificationStatusRefuted,
    Constant.verificationStatusEnteredInError,
  ];

  static List<String> statusInFoList = [
    Constant.statusDraft,
    Constant.statusActive,
    Constant.statusOnHold,
    Constant.statusRevoked,
    Constant.statusCompleted,
    Constant.statusEnteredInError,
    Constant.statusUnknown,
  ];

  static List<String> activityList = [
    Constant.itemBicycling,
    Constant.itemJogging,
    Constant.itemRunning,
    Constant.itemSwimming,
    Constant.itemWalking,
    Constant.itemWeights,
    // Constant.itemMixed,
  ];

  static List<String> timeList = [
    Constant.timeDay,
    Constant.timeWeek,
  ];

  static List<String> timeFrameList = [
    Constant.frameLastWeek,
    Constant.frame4Weeks,
    Constant.frame3Months,
    Constant.frame6Months,
    Constant.frame1Year,
    Constant.frameLifeTime,
  ];

  static List<String> todoStatusList = [
    Constant.toDoStatusReady,
    Constant.toDoStatusRequested,
    Constant.toDoStatusInProgress,
    Constant.toDoStatusCompleted,
    Constant.toDoStatusCancelled,
    Constant.toDoStatusOnHold,
    Constant.toDoStatusFailed,
    Constant.toDoStatusRejected,
    // Constant.toDoStatusEnteredInError,
  ];

  static List configurationManageList = [
    Constant.configurationHeaderMinutes,
    Constant.configurationHeaderVigorous,
    Constant.configurationHeaderTotal,
    Constant.configurationHeaderModerate,
    Constant.configurationHeaderSteps,
    Constant.configurationHeaderCalories,
    Constant.configurationHeaderDays,
    Constant.configurationHeaderRest,
    Constant.configurationHeaderPeck,

  ];


    static List<String> searchIdsAndManages = [
    Constant.patient,
    Constant.careManager,
    Constant.serviceProvider,
  ];

  static double getActivityMinRowColumnWidth(BuildContext context, bool mod,
      bool vig, HistoryController logic) {
    if (kIsWeb) {
      return (!mod && !vig)
          ? 0.15
          : 0.25;
    } else {
      if (logic.isPortrait) {
        return (!mod && !vig)
            ? 0.35
            : 0.45;
      } else {
        return (!mod && !vig)
            ? 0.15
            : 0.25;
      }
    }
  }

  static double getModRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return  /*(kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015)) :*/
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.11:0.1) : 0.2) : (isFromHeader)?0.11:0.1;
    return (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.09:0.1;

  }

  static double getVigRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return  (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015)) : ;
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.11:0.1) : 0.2) : (isFromHeader)?0.11:0.1;
    return (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.12:0.1;

  }

  static double getTotalRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return  (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015)) :
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.11:0.1) : 0.2) : (isFromHeader)?0.11:0.1;
    return  (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.10:0.1;

  }

  static double getNotesRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return  (kIsWeb) ? (isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015) :
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.11:0.1) : 0.2) : (isFromHeader)?0.11:0.1;
    return (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.08:0.1;

  }

  static double getDaysStrengthRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return  (kIsWeb) ? (isFromHeader)?0.1:0.1 : (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.13:0.12;
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.09:0.1) : 0.2) : (isFromHeader)?0.09:0.1;
    // return  (kIsWeb) ? (isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015) :
    return (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.13:0.12;
  }

  static double getCaloriesRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 5.0):Utils.sizesTrackingChartManage(context, 5.0)) : (logic.isPortrait) ?  ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.12:0.13;
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.09:0.1) : 0.2) : (isFromHeader)?0.09:0.1;
    // ((kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015)) :
    return (logic.isPortrait) ?  (isFromHeader)?0.213:0.21 : (isFromHeader)?0.12:0.13;


  }

  static double getStepsRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
    // return  (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 5.0):Utils.sizesTrackingChartManage(context, 5.0)) : (logic.isPortrait) ? ((isFromHeader)?0.213:0.21) : (isFromHeader)?0.12:0.1;
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.09:0.1) : 0.2) : (isFromHeader)?0.09:0.1;
    // ((kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.015):Utils.sizesTrackingChartManage(context, 0.015)) :
    return (logic.isPortrait) ? (isFromHeader)?0.213:0.21 : (isFromHeader)?0.12:0.1;


  }

  static double getRestHeartRateRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.2;
    // return  (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 5.0):Utils.sizesTrackingChartManage(context, 5.0)) : (logic.isPortrait) ? ((isFromHeader)?0.245:0.24) : (isFromHeader)?0.15:0.16;
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.09:0.1) : 0.15) : (isFromHeader)?0.15:0.21;
    // ((kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.016):Utils.sizesTrackingChartManage(context, 0.015)) :
    return (logic.isPortrait) ? ((isFromHeader)?0.245:0.24) : (isFromHeader)?0.15:0.16;


  }

  static double getPeakHeartRateRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.2;
    // return  (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 5.0):Utils.sizesTrackingChartManage(context, 5.0)) : (logic.isPortrait) ? ((isFromHeader)?0.245:0.24) : (isFromHeader)?0.18:0.18;
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.09:0.1) : 0.15) : (isFromHeader)?0.15:0.21;
    // ((kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.016):Utils.sizesTrackingChartManage(context, 0.015)) :
        return (logic.isPortrait) ?((isFromHeader)?0.245:0.24) : (isFromHeader)?0.18:0.18;

  }

  static double getExperienceRowColumnWidth(BuildContext context,
      HistoryController logic,{bool isFromHeader = true}) {
    // return  (kIsWeb) ? ((isFromHeader)?Utils.sizesTrackingChartManage(context, 0.016):Utils.sizesTrackingChartManage(context, 0.015)) :
    // return (logic.isPortrait) ? ((kIsWeb) ? ((isFromHeader)?0.09:0.1) : 0.25) : (isFromHeader)?0.15:0.1;
    return  (logic.isPortrait) ? ((isFromHeader)?0.225:0.22) : (isFromHeader)?0.15:0.135;
  }

  /*static double getActivityMinRowColumnWidth(BuildContext context, bool mod,
      bool vig, HistoryController logic) {
    if (kIsWeb) {
      return (!mod && !vig)
          ? 0.15
          : 0.25;
    } else {
      if (logic.isPortrait) {
        return (!mod && !vig)
            ? 0.4
            : 0.4;
      } else {
        return (!mod && !vig)
            ? 0.15
            : 0.25;
      }
    }
  }

  static double getDaysStrengthRowColumnWidth(BuildContext context,
      HistoryController logic) {
    return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
  }

  static double getCaloriesRowColumnWidth(BuildContext context,
      HistoryController logic) {
    return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
  }

  static double getStepsRowColumnWidth(BuildContext context,
      HistoryController logic) {
    return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
  }

  static double getHeartRateRowColumnWidth(BuildContext context,
      HistoryController logic) {
    return (logic.isPortrait) ? (kIsWeb) ? 0.2 : 0.3 : 0.2;
  }

  static double getExperienceRowColumnWidth(BuildContext context,
      HistoryController logic) {
    return (logic.isPortrait) ? (kIsWeb) ? 0.1 : 0.2 : 0.1;
  }

*/
  /* static double getTableWidth(BuildContext context, bool mod, bool vig,
      bool calories, bool steps, bool heartRate, bool heartPeakRate, bool ex,
      HistoryController logic) {
    var activityColumn = getModRowColumnWidth(context, logic);
    var activityVigColumn = getVigRowColumnWidth(context, logic);
    var activityTotalColumn = getTotalRowColumnWidth(context, logic);
    var activityNoteColumn = getNotesRowColumnWidth(context, logic);
    var daysStr = getDaysStrengthRowColumnWidth(context, logic);
    var caloriesColumn = getCaloriesRowColumnWidth(context, logic);
    var stepsColumn = getStepsRowColumnWidth(context, logic);
    var heartRateColumn = gePeaktHeartRateRowColumnWidth(context, logic);
    var heartPeakRateColumn = gePeaktHeartRateRowColumnWidth(context, logic);
    var exColumn = getExperienceRowColumnWidth(context, logic);
    var c = daysStr + activityColumn + activityVigColumn + activityTotalColumn + activityNoteColumn;

    if (calories) {
      c += caloriesColumn;
    }
    if (steps) {
      c += stepsColumn;
    }
    if (heartRate) {
      c += heartRateColumn;
    }
    if (heartPeakRate) {
      c += heartPeakRateColumn;
    }
    if (ex) {
      c += exColumn;
    }
    // Debug.printLog("count.,.....$c");
    return c;
  }

  static double getTableWidthWeb(BuildContext context, bool mod, bool vig,
      bool calories, bool steps, bool heartRate, bool ex,
      HistoryController logic) {
    var activityColumn = getActivityMinRowColumnWidthWeb(
        context, mod, vig, logic);
    var daysStr = getDaysStrengthRowColumnWidthWeb(context, logic);
    var caloriesColumn = getCaloriesRowColumnWidthWeb(context, logic);
    var stepsColumn = getStepsRowColumnWidthWeb(context, logic);
    var heartRateColumn = getHeartRateRowColumnWidthWeb(context, logic);
    var exColumn = getExperienceRowColumnWidthWeb(context, logic);
    var c = daysStr + activityColumn;

    if (calories) {
      c += caloriesColumn;
    }
    if (steps) {
      c += stepsColumn;
    }
    if (heartRate) {
      c += heartRateColumn;
    }
    if (ex) {
      c += exColumn;
    }
    // Debug.printLog("count.,.....$c");
    return c;
  }*/

  static double getTableWidth(BuildContext context, bool isMod, bool isVig, bool isTotal,bool isNotes,bool isDayStr,
      bool isCalories, bool isSteps, bool isRestHeart,bool isPeakHeart, bool isSmiley,
      HistoryController logic) {
    // Debug.printLog("getTableWidth....$isMod $isVig $isTotal $isCalories $isNotes $isSteps $isRestHeart $isPeakHeart $isSmiley $isDayStr");
    var sizeMod = getModRowColumnWidth(context,logic);
    var sizeVig = getVigRowColumnWidth(context,logic);
    var sizeTotal = getTotalRowColumnWidth(context,logic);
    var sizeNotes = getNotesRowColumnWidth(context,logic);
    var sizeDayStrength = getDaysStrengthRowColumnWidth(context, logic);
    var sizeCalories = getCaloriesRowColumnWidth(context, logic);
    var sizeSteps = getStepsRowColumnWidth(context, logic);
    var sizeRestHeart = getRestHeartRateRowColumnWidth(context, logic);
    var sizePeakHeart = getPeakHeartRateRowColumnWidth(context, logic);
    var sizeSmiley = getExperienceRowColumnWidth(context, logic);
    var c = 0.0;

    if(isMod){
      c += sizeMod;
    }

    if(isVig){
      c += sizeVig;
    }

    if(isTotal){
      c += sizeTotal;
    }

    if(isNotes){
      c += sizeNotes;
    }

    if(isDayStr){
      c += sizeDayStrength;
    }

    if (isCalories) {
      c += sizeCalories;
    }

    if (isSteps) {
      c += sizeSteps;
    }

    if (isRestHeart) {
      c += sizeRestHeart;
    }

    if (isPeakHeart) {
      c += sizePeakHeart;
    }

    if (isSmiley) {
      c += sizeSmiley;
    }
    if(kIsWeb){
      c += sizeSmiley;
    }
    // Debug.printLog("count.,.....$c");
    return c;
  }


  static double getTableWidthWeb(BuildContext context,BoxConstraints constraints, bool isMod, bool isVig, bool isTotal,bool isNotes,bool isDayStr,
      bool isCalories, bool isSteps, bool isRestHeart,bool isPeakHeart, bool isSmiley,
      HistoryController logic) {
    // Debug.printLog("getTableWidth....$isMod $isVig $isTotal $isCalories $isNotes $isSteps $isRestHeart $isPeakHeart $isSmiley $isDayStr");
    var sizeMod = getModRowColumnWidthWeb(context,logic,constraints);
    var sizeVig = getVigRowColumnWidthWeb(context,logic,constraints);
    var sizeTotal = getTotalRowColumnWidthWeb(context,logic,constraints);
    var sizeNotes = getNotesRowColumnWidthWeb(context,logic,constraints);
    var sizeDayStrength = getDaysStrengthRowColumnWidthWeb(context, logic,constraints);
    var sizeCalories = getCaloriesRowColumnWidthWeb(context, logic,constraints);
    var sizeSteps = getStepsRowColumnWidthWeb(context, logic,constraints);
    var sizeRestHeart = getRestHeartRateRowColumnWidthWeb(context, logic,constraints);
    var sizePeakHeart = getPeakHeartRateRowColumnWidthWeb(context, logic,constraints);
    var sizeSmiley = getExperienceRowColumnWidthWeb(context, logic,constraints);
    var c = 0.0;

    if(isMod){
      c += sizeMod;
    }

    if(isVig){
      c += sizeVig;
    }

    if(isTotal){
      c += sizeTotal;
    }

    if(isNotes){
      c += sizeNotes;
    }

    if(isDayStr){
      c += sizeDayStrength;
    }

    if (isCalories) {
      c += sizeCalories;
    }

    if (isSteps) {
      c += sizeSteps;
    }

    if (isRestHeart) {
      c += sizeRestHeart;
    }

    if (isPeakHeart) {
      c += sizePeakHeart;
    }

    if (isSmiley) {
      c += sizeSmiley;
    }
    if(kIsWeb){
      c += 20.0;
    }
    // Debug.printLog("count.,.....$c");
    return c;
  }



  static double getModRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getVigRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getTotalRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getNotesRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getDaysStrengthRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);
  }

  static double getCaloriesRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getStepsRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);


  }

  static double getRestHeartRateRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getPeakHeartRateRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }

  static double getExperienceRowColumnWidthWeb(BuildContext context,
      HistoryController logic,BoxConstraints constraints,{bool isFromHeader = true}) {
    return (isFromHeader)?AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints):AppFontStyle.sizesWidthManageTrackingChartWeb(13.0,constraints);

  }





  /*static double getTableWidthWeb(BuildContext context, bool mod, bool vig,
      bool calories, bool steps, bool heartRate, bool ex,
      HistoryController logic) {
    var activityColumn = getActivityMinRowColumnWidthWeb(
        context, mod, vig, logic);
    var daysStr = getDaysStrengthRowColumnWidthWeb(context, logic);
    var caloriesColumn = getCaloriesRowColumnWidthWeb(context, logic);
    var stepsColumn = getStepsRowColumnWidthWeb(context, logic);
    var heartRateColumn = getHeartRateRowColumnWidthWeb(context, logic);
    var exColumn = getExperienceRowColumnWidthWeb(context, logic);
    var c = daysStr + activityColumn;

    if (calories) {
      c += sizeCalories;
    }
    if (steps) {
      c += sizeSteps;
    }
    if (heartRate) {
      c += heartRateColumn;
    }
    if (ex) {
      c += sizeSmiley;
    }
    // Debug.printLog("count.,.....$c");
    return c;
  }*/

  static double getActivityMinRowColumnWidthWeb(BuildContext context, bool mod,
      bool vig, HistoryController logic) {
    // return (!mod && !vig) ? 0.15 : 1.5.w;
    return (!mod && !vig) ? 150 : 300;
  }

/*  static double getDaysStrengthRowColumnWidthWeb(BuildContext context,
      HistoryController logic) {
    return 150;
  }

  static double getCaloriesRowColumnWidthWeb(BuildContext context,
      HistoryController logic) {
    return 150;
  }

  static double getStepsRowColumnWidthWeb(BuildContext context,
      HistoryController logic) {
    return 150;
  }

  static double getHeartRateRowColumnWidthWeb(BuildContext context,
      HistoryController logic) {
    return 300;
  }

  static double getExperienceRowColumnWidthWeb(BuildContext context,
      HistoryController logic) {
    return 150;
  }*/

  static List<ListOfMeaSure> getMeaSureData() {
    List<ListOfMeaSure> listOfMeaSure = [];

    listOfMeaSure.add(ListOfMeaSure(Constant.activityMinutes, [
      SubListOfMeaSure(Constant.activityMinutesMod, true),
      SubListOfMeaSure(Constant.activityMinutesVig, true),
      SubListOfMeaSure(Constant.activityMinutesTotal, true),
    ], true));

    listOfMeaSure.add(ListOfMeaSure(Constant.heartRate, [
      SubListOfMeaSure(Constant.heartRateRest, false),
      SubListOfMeaSure(Constant.heartRatePeak, false),
    ], false));

    listOfMeaSure.add(ListOfMeaSure(Constant.calories, [], false));

    listOfMeaSure.add(ListOfMeaSure(Constant.steps, [], false));

    listOfMeaSure.add(ListOfMeaSure(Constant.experience, [], false));


    // listOfMeaSure.add(ListOfMeaSure(Constant.daysStrength, [], false));
    // listOfMeaSure.add(ListOfMeaSure(Constant.experience, [], false));

    return listOfMeaSure;
  }

  static List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
    List<DateTime> days = [];
    for (int i = 0; i <= (endDate
        .difference(startDate)
        .inDays); i++) {
      days.add(startDate.add(Duration(days: i)));
    }
    return days;
  }

  static DateTime findFirstDateOfTheWeekImport(DateTime dateTime) {
    if (dateTime.weekday == 7) {
      return dateTime;
    } else {
      return dateTime.subtract(Duration(days: dateTime.weekday));
    }
  }

  static DateTime findLastDateOfTheWeekImport(DateTime dateTime) {
    if (dateTime.weekday == 7) {
      return dateTime.add(Duration(days: dateTime.weekday - 1));
    } else {
      return dateTime.add(
          Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1));
    }
  }

  static DateTime findFirstDateOfTheWeek(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday));
  }

  static DateTime findLastDateOfTheWeek(DateTime dateTime) {
    return dateTime.add(
        Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1));
  }

  static DateTime findFirstDateOfTheWeekPrevious(DateTime dateTime) {
    return dateTime.subtract(Duration(days: dateTime.weekday));
  }

  static DateTime findLastDateOfTheWeekPrevious(DateTime dateTime) {
    return dateTime.add(
        Duration(days: DateTime.daysPerWeek - dateTime.weekday - 1));
  }

  static List<GraphWeeklyXDate> getTotalNumberOfLastWeeks(
      DateTime currentWeekStartDate, int numberOfTotalWeeks) {
    List<GraphWeeklyXDate> totalWeekList = [];

    for (int i = 0; i < numberOfTotalWeeks; i++) {
      var lastWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(Utils.
      findFirstDateOfTheWeekPrevious(currentWeekStartDate));
      var lastWeekStartDateStr = DateFormat(Constant.commonDateFormatDd)
          .format(Utils.
      findFirstDateOfTheWeekPrevious(currentWeekStartDate));

      var lastWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(
          Utils.findLastDateOfTheWeekPrevious(currentWeekStartDate));
      var lastWeekEndDateStr = DateFormat(Constant.commonDateFormatDdMMM)
          .format(Utils.
      findLastDateOfTheWeekPrevious(currentWeekStartDate));

      currentWeekStartDate =
          Utils.findFirstDateOfTheWeekPrevious(currentWeekStartDate);
      var weekDateStr = "$lastWeekStartDate-$lastWeekEndDate";
      var weekDateStrDisplay = "$lastWeekStartDateStr-$lastWeekEndDateStr";

      totalWeekList.add(GraphWeeklyXDate(weekDateStrDisplay, weekDateStr));
    }

    return totalWeekList.reversed.toList();
  }

  static List<ChartData> getChartListData(
      List<GraphWeeklyXDate> totalNumberOfWeeks, String activity,
      String? dbMeasureType,
      List<ActivityTable> activityTableData, String timeFrame) {
    List<ChartData> chartDataList = [];
    if (timeFrame == Constant.frameLastWeek) {
      chartDataList.add(ChartData(
          "", 0, 0, 0));
    }

    for (int i = 0; i < totalNumberOfWeeks.length; i++) {
      List<ActivityTable> activityData;
      if(Constant.titleNon == activity){
        if(dbMeasureType == Constant.heartRate){
          activityTableData = activityTableData
              .where((element) => (element.title == Constant.titleHeartRateRest ||
              element.title  == Constant.titleHeartRatePeak))
              .toList();
          activityData = activityTableData.where((element) =>
          element.weeksDate == totalNumberOfWeeks[i].compareDate /*&&
              element.title == Constant.titleHeartRateRest ||
                      element.title  == Constant.titleHeartRatePeak*/ && element.type == Constant.typeWeek)
              .toList();
          // var data = activityData[0];
          var yRestHeart = 0.0;
          var yPeckHeart = 0.0;
          for(int o = 0 ; o < activityData.length; o++) {
            if (activityData[o].title == Constant.titleHeartRateRest) {
              Debug.printLog(
                  "Date.....heartRateRest...........Total...${activityData[o].value1
                      .toString()}");
              yRestHeart += activityData[o].total ?? 0.0;
            }
            else if (activityData[o].title == Constant.titleHeartRatePeak) {
              Debug.printLog(
                  "Date..heartRatePeck..............Total...${activityData[o].value2
                      .toString()}");
              yPeckHeart += activityData[o].total ?? 0.0;
            }
          }
          chartDataList.add(ChartData(
              totalNumberOfWeeks[i].displayDate, 0.0, (yRestHeart == 0.0) ? null: yRestHeart,(yPeckHeart == 0.0) ? null:yPeckHeart));
        }
        else{
          if(dbMeasureType == Constant.experience){
            activityData = activityTableData.where((element) =>
            element.weeksDate == totalNumberOfWeeks[i].compareDate &&
                element.smileyType !=
                    null && element.type == Constant.typeWeek)
                .toList();
            var modCount = 0.0;
            var vigCount = 0.0;
            var totalCount = 0.0;
            for (int i = 0; i < activityData.length; i++) {
              modCount = activityData[i].value1 ?? 0.0;
              vigCount = activityData[i].value2 ?? 0.0;
              totalCount = activityData[i].smileyType?.toDouble() ?? 0.0;
            }
            chartDataList.add(ChartData(totalNumberOfWeeks[i].displayDate, totalCount,modCount,vigCount));
          }
          else{
            activityData = activityTableData.where((element) =>
            element.weeksDate == totalNumberOfWeeks[i].compareDate &&
                element.title ==
                    dbMeasureType && element.type == Constant.typeDay)
                .toList();

            var modCount = 0.0;
            var vigCount = 0.0;
            var totalCount = 0.0;
            for (int i = 0; i < activityData.length; i++) {
              modCount += activityData[i].value1 ?? 0.0;
              vigCount += activityData[i].value2 ?? 0.0;
              totalCount += activityData[i].total ?? 0.0;
            }
            chartDataList.add(ChartData(
                totalNumberOfWeeks[i].displayDate, totalCount, modCount, vigCount));
          }
        }
      }else {
        activityData = activityTableData.where((element) =>
        element.displayLabel == activity &&
            element.weeksDate == totalNumberOfWeeks[i].compareDate &&
            element.title ==
                dbMeasureType)
            .toList();

        var modCount = 0.0;
        var vigCount = 0.0;
        var totalCount = 0.0;
        for (int i = 0; i < activityData.length; i++) {
          modCount += activityData[i].value1 ?? 0.0;
          vigCount += activityData[i].value2 ?? 0.0;
          totalCount += activityData[i].total ?? 0.0;
        }
        chartDataList.add(ChartData(
            totalNumberOfWeeks[i].displayDate, totalCount, modCount, vigCount));
      }
    }
    if (timeFrame == Constant.frameLastWeek) {
      chartDataList.add(ChartData(
          " ", 0, 0, 0));
    }
    return chartDataList;
  }

  static List<ChartData> getChartGoalListData(
      List<GraphWeeklyXDate> totalNumberOfWeeks, String activity,
      String? dbMeasureType,
      List<GoalTableData> activityTableData, String timeFrame) {
    List<ChartData> chartDataList = [];
    if (timeFrame == Constant.frameLastWeek) {
      chartDataList.add(ChartData(
          "", 0, 0, 0));
    }
    for (int i = 0; i < totalNumberOfWeeks.length; i++) {
      // var startDateDateTime = totalNumberOfWeeks[i].compareDate.split("-")[0];
      var startDateDateTime = "${totalNumberOfWeeks[i].compareDate.split(
          "-")[0]}-${totalNumberOfWeeks[i].compareDate.split(
          "-")[1]}-${totalNumberOfWeeks[i].compareDate.split("-")[2]}";

      var endDateDateTime = "${totalNumberOfWeeks[i].compareDate.split(
          "-")[3]}-${totalNumberOfWeeks[i].compareDate.split(
          "-")[4]}-${totalNumberOfWeeks[i].compareDate.split("-")[5]}";

      // var endDateDateTime = totalNumberOfWeeks[i].compareDate.split("-")[1];
      var totalDays = Utils.getDaysInBetween(
          DateFormat(Constant.commonDateFormatDdMmYyyy).parse(
              startDateDateTime),
          DateFormat(Constant.commonDateFormatDdMmYyyy).parse(endDateDateTime));

      var comparedData = activityTableData
          .where((element) =>
      totalDays
          .where((elementTotalDays) => elementTotalDays == element.createdDate)
          .toList()
          .isNotEmpty)
          .toList();

      if (comparedData.isNotEmpty) {
        var chartData = ChartData(totalNumberOfWeeks[i].displayDate,
            double.parse(comparedData[0].target.toString()), 0, 0);
        chartDataList.add(chartData);
      } else {
        var chartData = ChartData(totalNumberOfWeeks[i].displayDate, 0, 0, 0);
        chartDataList.add(chartData);
      }
      Debug.printLog("getChartGoalListData....$comparedData");
    }
    if (timeFrame == Constant.frameLastWeek) {
      chartDataList.add(ChartData(
          " ", 0, 0, 0));
    }
    return chartDataList;
  }

  static String getRandomNumber() {
    Random random = Random();
    return random.nextInt(10000).toString();
  }

  static List<HealthDataType> getAllHealthTypeIos = [

    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.WORKOUT,
    // (Platform.isAndroid)?HealthDataType.MOVE_MINUTES:HealthDataType.EXERCISE_TIME,
  ];
  static List<HealthDataType> getAllHealthTypeIosWithOutWorkOut = [

    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.STEPS,
    HealthDataType.HEART_RATE,
    HealthDataType.RESTING_HEART_RATE,
  ];

  /*static List<HealthDataType> getAllHealthTypeIos =
  [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.AUDIOGRAM,
    HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataType.BLOOD_OXYGEN,
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataType.BODY_FAT_PERCENTAGE,
    HealthDataType.BODY_MASS_INDEX,
    HealthDataType.BODY_TEMPERATURE,
    HealthDataType.DIETARY_CARBS_CONSUMED,
    HealthDataType.DIETARY_ENERGY_CONSUMED,
    HealthDataType.DIETARY_FATS_CONSUMED,
    HealthDataType.DIETARY_PROTEIN_CONSUMED,
    HealthDataType.ELECTRODERMAL_ACTIVITY,
    HealthDataType.FORCED_EXPIRATORY_VOLUME,
    HealthDataType.HEART_RATE,
    HealthDataType.HEART_RATE_VARIABILITY_SDNN,
    HealthDataType.HEIGHT,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.RESPIRATORY_RATE,
    HealthDataType.PERIPHERAL_PERFUSION_INDEX,
    HealthDataType.STEPS,
    HealthDataType.WAIST_CIRCUMFERENCE,
    HealthDataType.WEIGHT,
    HealthDataType.FLIGHTS_CLIMBED,
    HealthDataType.DISTANCE_WALKING_RUNNING,
    HealthDataType.MINDFULNESS,
    HealthDataType.SLEEP_IN_BED,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.WATER,
    HealthDataType.EXERCISE_TIME,
    HealthDataType.WORKOUT,
    HealthDataType.HEADACHE_NOT_PRESENT,
    HealthDataType.HEADACHE_MILD,
    HealthDataType.HEADACHE_MODERATE,
    HealthDataType.HEADACHE_SEVERE,
    HealthDataType.HEADACHE_UNSPECIFIED,
    HealthDataType.NUTRITION,
  ];*/


/*  static List<HealthDataType> getAllHealthTypeAndroid  =
    [
      HealthDataType.ACTIVE_ENERGY_BURNED,
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
      HealthDataType.BASAL_ENERGY_BURNED,
    ];*/

  static List<HealthDataType> getAllHealthTypeAndroid =
  [
    HealthDataType.ACTIVE_ENERGY_BURNED,
    // HealthDataType.BASAL_ENERGY_BURNED,
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.WORKOUT,
    // HealthDataType.RESTING_HEART_RATE,
  ];


  static int totalDaysInMonth(DateTime date) {
    var firstDayThisMonth = DateTime(date.year, date.month, date.day);
    var firstDayNextMonth = DateTime(
        firstDayThisMonth.year, firstDayThisMonth.month + 1,
        firstDayThisMonth.day);
    return firstDayNextMonth
        .difference(firstDayThisMonth)
        .inDays;
  }

  static DateTime getDateFromFullDate(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime getDateForReferral(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String getIconNameFromStatus(String status) {
    var iconName = "";
    if (status == Constant.lifeCycleActive) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleProposed) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCyclePlanned) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleAccepted) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleOnHold) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleCompleted) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleCancelled) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleEnteredInError) {
      iconName = "assets/icons/ic_walking.png";
    } else if (status == Constant.lifeCycleRejected) {
      iconName = "assets/icons/ic_walking.png";
    }
    return iconName;
  }


  static writeStepData(DateTime dateTime, Health health, value,
      int i) async {
    var now = DateTime.now();
    /*var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour - 1, now.minute);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour - 2, now.minute);*/
    var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute-2);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute-3);
    bool successSteps = false;
    successSteps = await Health().writeHealthData(
        value: value,type: HealthDataType.STEPS, startTime: startDate,endTime: endDate);
    Debug.printLog("successSteps read and write....$successSteps $i $dateTime   $startDate  $endDate");
    Debug.printLog(
        "successSteps read and write....Steps $endDate $startDate $value $i   $startDate  $endDate");
  }

  static writeHeartRateData(DateTime dateTime, Health health,
      value) async {
    var now = DateTime.now();
    /*var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 5);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 30);*/
    var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 2);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 3);
    // final startDate = dateTime.subtract(const Duration(minutes: 20));
    bool successHeartRate = false;
    successHeartRate = await Health().writeHealthData(
       value: value,type:  HealthDataType.HEART_RATE,startTime: startDate,endTime: endDate);
    Debug.printLog(
        "successHeartRate read and write....$successHeartRate $dateTime   $startDate  $endDate");
    Debug.printLog(
        "successHeartRate read and write....Heart rate $dateTime $value   $startDate  $endDate");
  }

  static writeHeartRateRestData(DateTime dateTime, Health health,
      value) async {
    var now = DateTime.now();
    /*var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 5);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 10);*/
    var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 2);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour, now.minute - 3);
    bool successHeartRateRest = false;
    successHeartRateRest = await Health().writeHealthData(
        value: value,type: HealthDataType.RESTING_HEART_RATE,startTime: startDate,endTime: endDate);
    Debug.printLog(
        "successHeartRateRest read and write....$successHeartRateRest   $startDate  $endDate");
    Debug.printLog(
        "successHeartRateRest read and write....Heart rate rest $dateTime $value   $startDate  $endDate");
  }

  static writeCaloriesDataActivityLevel(Health health, double value,
      HealthWorkoutActivityType? healthDataType,DateTime activityStartDate,DateTime activityEndDate) async {
    bool successCalories = false;
    var getTotalMinFromTwoDates = Utils.getTotalMinFromTwoDates(activityStartDate,activityEndDate);
    Debug.printLog("getTotalMinFromTwoDates...$getTotalMinFromTwoDates");
    successCalories = await Health().writeWorkoutData(
         activityType: healthDataType ?? HealthWorkoutActivityType.RUNNING,
          start: activityStartDate,
          end: activityEndDate,
          totalEnergyBurned: value.toInt(),totalDistance: int.parse(getTotalMinFromTwoDates));
    Debug.printLog(
        "writeCaloriesDataActivityLevel read and write....Calories  $value  $healthDataType  $successCalories  $activityStartDate  $activityEndDate");
  }

  static writeCaloriesData(DateTime dateTime, Health health, value,
      bool isWorkOut, HealthWorkoutActivityType? healthDataType) async {
    var now = DateTime.now();
    var endDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour,
        now.minute - 2);
    var startDate = DateTime(
        dateTime.year, dateTime.month, dateTime.day, now.hour,
        now.minute - 3);
    bool successCalories = false;
    /*  if(isWorkOut){
      successCalories = await health.writeWorkoutData(healthDataType ?? HealthWorkoutActivityType.WALKING,startDate, endDate,totalEnergyBurned:value.toInt() );
    }else {*/
    successCalories = await Health().writeHealthData(
        value: value,type: HealthDataType.ACTIVE_ENERGY_BURNED, startTime: startDate,endTime: endDate);
    // }
    Debug.printLog(
        "successCalories read and write....$successCalories  $healthDataType  $startDate  $endDate");
    Debug.printLog(
        "successCalories read and write....Calories $dateTime $value   $startDate  $endDate");
  }

  static deleteWorkout(DateTime startDate,DateTime endDate, Health health) async {
    return await Health().delete(type: HealthDataType.WORKOUT,startTime: startDate,endTime: endDate);
  }

  ///capitalizeFirstLetter
  static String capitalizeFirstLetter(String input) {
    if (input.isEmpty) {
      return input;
    }
    return input.replaceRange(0, 1, input[0].toUpperCase());
  }

  static showSnackBar(BuildContext context, String message, bool isShow,{int second = 1}) {
    if (isShow) {
      var snackDemo = SnackBar(
        content: Text(message.toString()),
        backgroundColor: CColor.primaryColor,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(5),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackDemo);
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar(
          reason: SnackBarClosedReason.action);
      var snackDemo = SnackBar(
        content: Text(message.toString()),
        backgroundColor: CColor.primaryColor,
        elevation: 10,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(5),
        duration: Duration(seconds: second),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackDemo);
    }
  }

  static HealthWorkoutActivityType getWorkoutActivityType(String type) {
    var d = [
      // Both
      HealthWorkoutActivityType.ARCHERY,
      HealthWorkoutActivityType.BADMINTON,
      HealthWorkoutActivityType.BASEBALL,
      HealthWorkoutActivityType.BASKETBALL,
      HealthWorkoutActivityType.BIKING,
      // This also entails the iOS version where it is called CYCLING
      HealthWorkoutActivityType.BOXING,
      HealthWorkoutActivityType.CRICKET,
      HealthWorkoutActivityType.CURLING,
      HealthWorkoutActivityType.ELLIPTICAL,
      HealthWorkoutActivityType.FENCING,
      HealthWorkoutActivityType.AMERICAN_FOOTBALL,
      HealthWorkoutActivityType.AUSTRALIAN_FOOTBALL,
      HealthWorkoutActivityType.SOCCER,
      HealthWorkoutActivityType.GOLF,
      HealthWorkoutActivityType.GYMNASTICS,
      HealthWorkoutActivityType.HANDBALL,
      HealthWorkoutActivityType.HIGH_INTENSITY_INTERVAL_TRAINING,
      HealthWorkoutActivityType.HIKING,
      HealthWorkoutActivityType.HOCKEY,
      HealthWorkoutActivityType.SKATING,
      HealthWorkoutActivityType.JUMP_ROPE,
      HealthWorkoutActivityType.KICKBOXING,
      HealthWorkoutActivityType.MARTIAL_ARTS,
      HealthWorkoutActivityType.PILATES,
      HealthWorkoutActivityType.RACQUETBALL,
      HealthWorkoutActivityType.ROWING,
      HealthWorkoutActivityType.RUGBY,
      HealthWorkoutActivityType.RUNNING,
      HealthWorkoutActivityType.SAILING,
      HealthWorkoutActivityType.CROSS_COUNTRY_SKIING,
      HealthWorkoutActivityType.DOWNHILL_SKIING,
      HealthWorkoutActivityType.SNOWBOARDING,
      HealthWorkoutActivityType.SOFTBALL,
      HealthWorkoutActivityType.SQUASH,
      HealthWorkoutActivityType.STAIR_CLIMBING,
      HealthWorkoutActivityType.SWIMMING,
      HealthWorkoutActivityType.TABLE_TENNIS,
      HealthWorkoutActivityType.TENNIS,
      HealthWorkoutActivityType.VOLLEYBALL,
      HealthWorkoutActivityType.WALKING,
      HealthWorkoutActivityType.WATER_POLO,
      HealthWorkoutActivityType.YOGA,
      HealthWorkoutActivityType.BOWLING,
      HealthWorkoutActivityType.CROSS_TRAINING,
      HealthWorkoutActivityType.TRACK_AND_FIELD,
      HealthWorkoutActivityType.DISC_SPORTS,
      HealthWorkoutActivityType.LACROSSE,
      HealthWorkoutActivityType.PREPARATION_AND_RECOVERY,
      HealthWorkoutActivityType.FLEXIBILITY,
      HealthWorkoutActivityType.COOLDOWN,
      HealthWorkoutActivityType.WHEELCHAIR_WALK_PACE,
      HealthWorkoutActivityType.WHEELCHAIR_RUN_PACE,
      HealthWorkoutActivityType.HAND_CYCLING,
      HealthWorkoutActivityType.CORE_TRAINING,
      HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING,
      HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING,
      HealthWorkoutActivityType.MIXED_CARDIO,
      HealthWorkoutActivityType.STAIRS,
      HealthWorkoutActivityType.STEP_TRAINING,
      HealthWorkoutActivityType.FITNESS_GAMING,
      HealthWorkoutActivityType.BARRE,
      HealthWorkoutActivityType.CARDIO_DANCE,
      HealthWorkoutActivityType.SOCIAL_DANCE,
      HealthWorkoutActivityType.MIND_AND_BODY,
      HealthWorkoutActivityType.PICKLEBALL,
      HealthWorkoutActivityType.CLIMBING,
      HealthWorkoutActivityType.EQUESTRIAN_SPORTS,
      HealthWorkoutActivityType.FISHING,
      HealthWorkoutActivityType.HUNTING,
      HealthWorkoutActivityType.PLAY,
      HealthWorkoutActivityType.SNOW_SPORTS,
      HealthWorkoutActivityType.PADDLE_SPORTS,
      HealthWorkoutActivityType.SURFING_SPORTS,
      HealthWorkoutActivityType.WATER_FITNESS,
      HealthWorkoutActivityType.WATER_SPORTS,
      HealthWorkoutActivityType.TAI_CHI,
      HealthWorkoutActivityType.WRESTLING,
      HealthWorkoutActivityType.AEROBICS,
      HealthWorkoutActivityType.BIATHLON,
      HealthWorkoutActivityType.BIKING_HAND,
      HealthWorkoutActivityType.BIKING_MOUNTAIN,
      HealthWorkoutActivityType.BIKING_ROAD,
      HealthWorkoutActivityType.BIKING_SPINNING,
      HealthWorkoutActivityType.BIKING_STATIONARY,
      HealthWorkoutActivityType.BIKING_UTILITY,
      HealthWorkoutActivityType.CALISTHENICS,
      HealthWorkoutActivityType.CIRCUIT_TRAINING,
      HealthWorkoutActivityType.CROSS_FIT,
      HealthWorkoutActivityType.DANCING,
      HealthWorkoutActivityType.DIVING,
      HealthWorkoutActivityType.ELEVATOR,
      HealthWorkoutActivityType.ERGOMETER,
      HealthWorkoutActivityType.ESCALATOR,
      HealthWorkoutActivityType.FRISBEE_DISC,
      HealthWorkoutActivityType.GARDENING,
      HealthWorkoutActivityType.GUIDED_BREATHING,
      HealthWorkoutActivityType.HORSEBACK_RIDING,
      HealthWorkoutActivityType.HOUSEWORK,
      HealthWorkoutActivityType.INTERVAL_TRAINING,
      HealthWorkoutActivityType.IN_VEHICLE,
      HealthWorkoutActivityType.ICE_SKATING,
      HealthWorkoutActivityType.KAYAKING,
      HealthWorkoutActivityType.KETTLEBELL_TRAINING,
      HealthWorkoutActivityType.KICK_SCOOTER,
      HealthWorkoutActivityType.KITE_SURFING,
      HealthWorkoutActivityType.MEDITATION,
      HealthWorkoutActivityType.MIXED_MARTIAL_ARTS,
      HealthWorkoutActivityType.P90X,
      HealthWorkoutActivityType.PARAGLIDING,
      HealthWorkoutActivityType.POLO,
      HealthWorkoutActivityType.ROCK_CLIMBING,
      // on iOS this is the same as CLIMBING
      HealthWorkoutActivityType.ROWING_MACHINE,
      HealthWorkoutActivityType.RUNNING_JOGGING,
      // on iOS this is the same as RUNNING
      HealthWorkoutActivityType.RUNNING_SAND,
      // on iOS this is the same as RUNNING
      HealthWorkoutActivityType.RUNNING_TREADMILL,
      // on iOS this is the same as RUNNING
      HealthWorkoutActivityType.SCUBA_DIVING,
      HealthWorkoutActivityType.SKATING_CROSS,
      // on iOS this is the same as SKATING
      HealthWorkoutActivityType.SKATING_INDOOR,
      // on iOS this is the same as SKATING
      HealthWorkoutActivityType.SKATING_INLINE,
      // on iOS this is the same as SKATING
      HealthWorkoutActivityType.SKIING,
      HealthWorkoutActivityType.SKIING_BACK_COUNTRY,
      HealthWorkoutActivityType.SKIING_KITE,
      HealthWorkoutActivityType.SKIING_ROLLER,
      HealthWorkoutActivityType.SLEDDING,
      HealthWorkoutActivityType.SNOWMOBILE,
      HealthWorkoutActivityType.SNOWSHOEING,
      HealthWorkoutActivityType.STAIR_CLIMBING_MACHINE,
      HealthWorkoutActivityType.STANDUP_PADDLEBOARDING,
      HealthWorkoutActivityType.STILL,
      HealthWorkoutActivityType.STRENGTH_TRAINING,
      HealthWorkoutActivityType.SURFING,
      HealthWorkoutActivityType.SWIMMING_OPEN_WATER,
      HealthWorkoutActivityType.SWIMMING_POOL,
      HealthWorkoutActivityType.TEAM_SPORTS,
      HealthWorkoutActivityType.TILTING,
      HealthWorkoutActivityType.VOLLEYBALL_BEACH,
      HealthWorkoutActivityType.VOLLEYBALL_INDOOR,
      HealthWorkoutActivityType.WAKEBOARDING,
      HealthWorkoutActivityType.WALKING_FITNESS,
      HealthWorkoutActivityType.WALKING_NORDIC,
      HealthWorkoutActivityType.WALKING_STROLLER,
      HealthWorkoutActivityType.WALKING_TREADMILL,
      HealthWorkoutActivityType.WEIGHTLIFTING,
      HealthWorkoutActivityType.WHEELCHAIR,
      HealthWorkoutActivityType.WINDSURFING,
      HealthWorkoutActivityType.ZUMBA,
      HealthWorkoutActivityType.OTHER,
    ].where((element) => element.toString() == type).toList();
    if (d.isNotEmpty) {
      return d[0];
    } else {
      return HealthWorkoutActivityType.WALKING;
    }
  }

  static List<String> allExtraActivityIcons() {
    List<String> dataList = [];
    for (int i = 0; i < 20; i++) {
      dataList.add("assets/icons/activity/${i + 1}.png");
    }
    return dataList;
  }

  static String getPatientId() {
    // return Preference.shared.getString(Preference.patientId) ?? "";
    return (getPrimaryServerData() != null) ? getPrimaryServerData()!.patientId: "";
  }
  static String getPatientFName() {
    // return Preference.shared.getString(Preference.patientFName) ?? "";
    return (getPrimaryServerData() != null) ? getPrimaryServerData()!.patientFName: "";
  }
  static String getPatientLName() {
    // return Preference.shared.getString(Preference.patientLName) ?? "";
    return (getPrimaryServerData() != null) ? getPrimaryServerData()!.patientLName: "";
  }
  static String getPatientDob() {
    // return Preference.shared.getString(Preference.patientDob) ?? "";
    return (getPrimaryServerData() != null) ? getPrimaryServerData()!.patientDOB: "";
  }
  static String getPatientGender() {
    // return Preference.shared.getString(Preference.patientGender) ?? "";
    return (getPrimaryServerData() != null) ? getPrimaryServerData()!.patientGender: "";
  }

  static String getFullName() {
    String authorName = "";
    String fName = getPatientFName();
    String lName = getPatientLName();
    authorName = (fName == "null")?"":fName;
    authorName += (lName == "null")?"":" $lName";
    // authorName = '${(getPatientFName())} ${getPatientLName()}';
    return authorName;
  }

  static String getCareManagerId() {
    return Preference.shared.getString(Preference.careManagerId) ?? "";
  }

  static String getCareManagerName() {
    return Preference.shared.getString(Preference.careManageName) ?? "";
  }
  static String getCareManagerLastName() {
    return Preference.shared.getString(Preference.careManageLastName) ?? "";
  }

  static String getServiceProviderId() {
    return Preference.shared.getString(Preference.serviceProviderId) ?? "";
  }

  static String getServiceProviderName() {
    return Preference.shared.getString(Preference.serviceProviderName) ?? "";
  }
  static String getServiceProviderLastName() {
    return Preference.shared.getString(Preference.serviceProviderLastName) ?? "";
  }

  static String getAPIEndPoint() {
    List<ServerModelJson> serverModelList = [];
    String url = "";
    // serverModelList = Preference.shared.getServerList(Preference.serverUrlList) ?? [];
    serverModelList = Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    serverModelList = serverModelList.where((element) => element.isPrimary).toList() ?? [];
    if(serverModelList.isNotEmpty){
      url = serverModelList[0].url;
    }
    return url;
  }

  static getAndSetPatientId() async {
    // var currentPatientId = Preference.shared.getString(Preference.patientId);
    var currentPatientId = Utils.getPatientId();

    var monthlyDataList =
    Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (monthlyDataList.isNotEmpty) {
      var list = monthlyDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateMonthlyData(list[a]);
      }
    }


    var activityDataList =
    Hive
        .box<ActivityTable>(Constant.tableActivity)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (activityDataList.isNotEmpty) {
      var list = activityDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateActivityData(list[a]);
      }
    }


    var goalDataList =
    Hive
        .box<GoalTableData>(Constant.tableGoal)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (goalDataList.isNotEmpty) {
      var list = goalDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateGoalData(list[a]);
      }
    }

    var referralDataList =
    Hive
        .box<ReferralData>(Constant.tableReferral)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (referralDataList.isNotEmpty) {
      var list = referralDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateReferralData(list[a]);
      }
    }


    var referralRouteDataList =
    Hive
        .box<RoutingReferralData>(Constant.tableReferralRoute)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (referralRouteDataList.isNotEmpty) {
      var list = referralRouteDataList.where((element) =>
      element.patientId == "").toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateReferralRouteData(list[a]);
      }
    }


    var notesDataList =
    Hive
        .box<NoteTableData>(Constant.tableNoteData)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (notesDataList.isNotEmpty) {
      var list = notesDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateNoteData(list[a]);
      }
    }


    var conditionDataList =
    Hive
        .box<ConditionTableData>(Constant.tableCondition)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (conditionDataList.isNotEmpty) {
      var list = conditionDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateConditionData(list[a]);
      }
    }


    var carePlanDataList =
    Hive
        .box<CarePlanTableData>(Constant.tableCarePlan)
        .values
        .toList().where((element) => element.patientId == "").toList();
    if (carePlanDataList.isNotEmpty) {
      var list = carePlanDataList.where((element) => element.patientId == "")
          .toList();
      for (int a = 0; a < list.length; a++) {
        list[a].patientId = currentPatientId;
        await DataBaseHelper.shared.updateCarePlanData(list[a]);
      }
    }
  }

  static bool isSelectMonth(){
    return Constant.isMonth;
  }

  static DateTime getSplitDateFromAPIData(String date){
    try{
      return DateTime.parse(date.split("T")[0].toString());
    }catch(e){
      Debug.printLog("getSplitDateFromAPIData....Error$e");
      return DateTime.now();
    }
  }

  /*static checkTokenExpireTime(ServerModelJson primaryData) async {
      // var getServerListIndex = Utils.getServerList.indexWhere((element) => element == primaryData).toInt();
    var getServerListIndex = Utils.getServerList.indexWhere((element) => element.url == primaryData.url &&
        element.patientId == primaryData.patientId &&
        element.clientId == primaryData.clientId).toInt();
      Debug.printLog("toekn expired check  ${primaryData.isSecure && Utils.isExpiredToken(primaryData.lastLoggedTime, primaryData.expireTime)}");
      if (primaryData.isSecure && Utils.isExpiredToken(
          primaryData.lastLoggedTime, primaryData.expireTime)) {
        await Utils.getAccessTokenFromRefreshToken(primaryData.refreshToken,
            primaryData.clientId,primaryData.clientId).then((value) => {
          Debug.printLog("getSetMonthActivityData...getAccessTokenFromRefreshToken....$value"),
          if(value.isEmpty){
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              showDialog(
                context: Get.context!,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title:  const Text(Constant.txtExpireTitle),
                    content:  const Text(Constant.txtExpireDesc),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Get.back();
                          Utils.callSecureServerAPI(primaryData.url,
                              primaryData.clientId,
                              primaryData.title);
                        },
                        child: const Text("Log in"),
                      ),
                      TextButton(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                      ),
                    ],
                  );
                },
              );
            })
          }
          else{
            primaryData.authToken = value["access_token"],
            primaryData.expireTime = value["expires_in"],
            primaryData.refreshToken = value["refresh_token"],
            // ServerModelJson se;
            //  se = Utils.getServerList[getServerListIndex];
            Utils.getServerList[getServerListIndex].lastDateTimeStr = DateTime.now().toString(),
            Utils.getServerList[getServerListIndex].lastLoggedTime = DateTime.now().millisecondsSinceEpoch,
            Utils.getServerList[getServerListIndex].isSecure = true,
            // Utils.getServerList[getServerListIndex].isPrimary = Utils.getServerList[getServerListIndex].isPrimary,
            Utils.getServerList[getServerListIndex].isSelected = true,
            Utils.getServerList[getServerListIndex].authToken = value["access_token"],
            Utils.getServerList[getServerListIndex].refreshToken = value["refresh_token"],
            Utils.getServerList[getServerListIndex].expireTime = value["expires_in"],
            Preference.shared.setList(Preference.serverUrlAllListed,jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList())),
          }
        });
      }else{
        Debug.printLog("Not expire");
      }
  }*/

  static getSetMonthActivityData(String patientId,String currentYear,
  String patientName,String serverUrlFromAPI,String clientId,String token, List<ServerModelJson> primaryServerData,
      {bool isFromMonth = false,bool isFromActivity = false,DateTime? startAfterDate,DateTime? beforeEndDate}) async {
    // startAfterDate = DateTime(2024,06,16);
    // beforeEndDate = DateTime(2024,06,17);

    bool isChangeDate = Preference.shared.getBool(Preference.isFirstTimeTracking) ?? true;
    if(isChangeDate && isFromActivity){
      startAfterDate = getMonthStartDate(startAfterDate ?? DateTime.now());
    }

    if (primaryServerData.isNotEmpty) {
      var primaryData = primaryServerData[0];
      if (primaryData.isSecure &&
          Utils.isExpiredToken(
              primaryData.lastLoggedTime, primaryData.expireTime)) {
        // await checkTokenExpireTime(primaryData);
      }
    }
    if(startAfterDate != null && beforeEndDate != null) {
      startAfterDate = startAfterDate.subtract(const Duration(days: 1));
      beforeEndDate = beforeEndDate.add(const Duration(days: 1));
    }
    ///Monthly data
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();

    if(isFromMonth) {
      var listDataDayPerWeek = await PaaProfiles.getMonthActivityList(
          patientId,
          Constant.codeDayPerWeek,
          currentYear,
          clientId,
          serverUrlFromAPI,
          primaryServerData[0].authToken,
          primaryServerData,true);
      if (listDataDayPerWeek != null) {
        if (listDataDayPerWeek.resourceType == R4ResourceType.Bundle) {
          if (listDataDayPerWeek != null && listDataDayPerWeek.entry != null) {
            int length = listDataDayPerWeek.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listDataDayPerWeek.entry[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var objectId = data.resource.id.toString();
                var display = data.resource.code.coding[0].display.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var unit = data.resource.valueQuantity.unit.toString();
                var code = data.resource.valueQuantity.code.toString();
                var startDate;
                if (data.resource.effectivePeriod.start
                    .toString()
                    .isNotEmpty && data.resource.effectivePeriod.start != null) {
                  startDate = DateTime.parse(
                      data.resource.effectivePeriod.start.toString());
                }

                var endDate;
                if (data.resource.effectivePeriod.end
                    .toString()
                    .isNotEmpty && data.resource.effectivePeriod.end != null) {
                  endDate =
                      DateTime.parse(
                          data.resource.effectivePeriod.end.toString());
                }

                if(startDate != null && endDate != null) {

                  var mon = DateFormat('MMM').format(endDate);
                  var year = endDate.year.toInt();
                  Debug.printLog("month ........ $mon");

                  List<Identifier> identifierData = [];
                  if (data.resource.identifier != null) {
                    identifierData = data.resource.identifier;
                  }


                  insertUpdateMonthlyData(
                      Constant.typeDayPerWeek,
                      display,
                      value,
                      code,
                      unit,
                      mon,
                      year,
                      startDate,
                      endDate,
                      patientId,
                      objectId,
                      identifierData);
                }
                Debug.printLog("DayPerWeek............");
              }
            }
          }
        }
      }

      allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      var listDataAvgMin = await PaaProfiles.getMonthActivityList(
          patientId,
          Constant.codeAvgMin,
          currentYear,
          clientId,
          serverUrlFromAPI,
          primaryServerData[0].authToken,
          primaryServerData,true);
      if (listDataAvgMin != null) {
        if (listDataAvgMin.resourceType == R4ResourceType.Bundle) {
          if (listDataAvgMin != null && listDataAvgMin.entry != null) {
            int length = listDataAvgMin.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listDataAvgMin.entry[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var objectId = data.resource.id.toString();
                var display = data.resource.code.coding[0].display.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var unit = data.resource.valueQuantity.unit.toString();
                var code = data.resource.valueQuantity.code.toString();

                var startDate;
                if (data.resource.effectivePeriod.start
                    .toString()
                    .isNotEmpty && data.resource.effectivePeriod.start != null) {
                  startDate = DateTime.parse(
                      data.resource.effectivePeriod.start.toString());
                }

                var endDate;
                if (data.resource.effectivePeriod.end
                    .toString()
                    .isNotEmpty && data.resource.effectivePeriod != null) {
                  endDate =
                      DateTime.parse(
                          data.resource.effectivePeriod.end.toString());
                }


                if(startDate != null && endDate != null) {

                  var mon = DateFormat('MMM').format(endDate);
                  var year = endDate.year.toInt();
                  Debug.printLog(
                      "month ........ $mon StartDate ::$startDate EndDate $endDate");
                  List<Identifier> identifierData = [];
                  if (data.resource.identifier != null) {
                    identifierData = data.resource.identifier;
                  }

                  insertUpdateMonthlyData(
                      Constant.typeAvgMin,
                      display,
                      value,
                      code,
                      unit,
                      mon,
                      year,
                      startDate,
                      endDate,
                      patientId,
                      objectId,
                      identifierData);
                }
                Debug.printLog("AvgMin............");
                // }
              }
            }
          }
        }
      }

      allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      var listDataAvgMinPerWeek = await PaaProfiles.getMonthActivityList(
          patientId,
          Constant.codeAvgMinPerWeek,
          currentYear,
          clientId,
          serverUrlFromAPI,
          primaryServerData[0].authToken,
          primaryServerData,true);
      if (listDataAvgMinPerWeek != null) {
        if (listDataAvgMinPerWeek.resourceType == R4ResourceType.Bundle) {
          if (listDataAvgMinPerWeek != null &&
              listDataAvgMinPerWeek.entry != null) {
            int length = listDataAvgMinPerWeek.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listDataAvgMinPerWeek.entry[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var objectId = data.resource.id.toString();
                var display = data.resource.code.coding[0].display.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var unit = data.resource.valueQuantity.unit.toString();
                var code = data.resource.valueQuantity.code.toString();

                var startDate;
                if (data.resource.effectivePeriod.start
                    .toString()
                    .isNotEmpty && data.resource.effectivePeriod.start != null) {
                  startDate = DateTime.parse(
                      data.resource.effectivePeriod.start.toString());
                }

                var endDate;
                if (data.resource.effectivePeriod.end
                    .toString()
                    .isNotEmpty && data.resource.effectivePeriod.end != null) {
                  endDate =
                      DateTime.parse(
                          data.resource.effectivePeriod.end.toString());
                }


                if(startDate != null && endDate != null) {

                  var mon = DateFormat('MMM').format(endDate);
                  var year = endDate.year.toInt();
                  Debug.printLog(
                      "month ........ $mon StartDate ::$startDate EndDate $endDate");
                  List<Identifier> identifierData = [];
                  if (data.resource.identifier != null) {
                    identifierData = data.resource.identifier;
                  }

                  insertUpdateMonthlyData(
                      Constant.typeAvgMinPerWeek,
                      display,
                      value,
                      code,
                      unit,
                      mon,
                      year,
                      startDate,
                      endDate,
                      patientId,
                      objectId,
                      identifierData);
                }
                Debug.printLog(
                    "AvgMinWeek............ StartDate ::$startDate EndDate $endDate");
                // }
              }
            }
          }
        }
      }

      allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      var listDataStrDays = await PaaProfiles.getMonthActivityList(
          patientId,
          Constant.codeStrDays,
          currentYear,
          clientId,
          serverUrlFromAPI,
          primaryServerData[0].authToken,
          primaryServerData,true);
      if (listDataStrDays != null) {
        if (listDataStrDays.resourceType == R4ResourceType.Bundle) {
          if (listDataStrDays != null && listDataStrDays.entry != null) {
            int length = listDataStrDays.entry.length;
            for (int i = 0; i < length; i++) {
              var data = listDataStrDays.entry[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var objectId = data.resource.id.toString();
                var display = data.resource.code.coding[0].display.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var unit = data.resource.valueQuantity.unit.toString();
                var code = data.resource.valueQuantity.code.toString();

                var startDate;
                var endDate;
                if(data.resource.effectivePeriod != null){
                  if (data.resource.effectivePeriod.start
                      .toString()
                      .isNotEmpty && data.resource.effectivePeriod.start != null) {
                    // startDate = DateTime.parse(
                    //     data.resource.effectivePeriod.start.toString());
                    startDate = Utils.getSplitDateFromAPIData(
                        data.resource.effectivePeriod.start.toString());
                  }

                  if (data.resource.effectivePeriod.end
                      .toString()
                      .isNotEmpty && data.resource.effectivePeriod.end != null) {
                    // endDate =
                    //     DateTime.parse(data.resource.effectivePeriod.end.toString());
                    endDate = Utils.getSplitDateFromAPIData(
                        data.resource.effectivePeriod.end.toString());
                  }
                }

                if(startDate != null && endDate != null) {

                  var mon = DateFormat('MMM').format(endDate);
                  var year = endDate.year.toInt();
                  List<Identifier> identifierData = [];
                  if (data.resource.identifier != null) {
                    identifierData = data.resource.identifier;
                  }

                  insertUpdateMonthlyData(
                      Constant.typeStrength,
                      display,
                      value,
                      code,
                      unit,
                      mon,
                      year,
                      startDate,
                      endDate,
                      patientId,
                      objectId,
                      identifierData);
                }

                Debug.printLog("StrengthDay............");
                // }
              }
            }
          }
        }
      }
    }

    if(isFromActivity) {
      ///Activity data

      allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      // startAfterDate = DateTime(2024,06,10);
      // beforeEndDate = DateTime(2024,06,11);
      var listOfActivityData = await PaaProfiles.getMonthActivityList(
          patientId,
          "",
          currentYear,
          clientId,
          serverUrlFromAPI,
          primaryServerData[0].authToken,
          primaryServerData,false,
          count: "365",startAfterDate: startAfterDate,beforeEndDate:beforeEndDate);
      if(listOfActivityData != null){
        if (listOfActivityData.resourceType == R4ResourceType.Bundle) {
          if (listOfActivityData != null &&
              listOfActivityData.entry != null) {
            int length = listOfActivityData.entry.length;
            List<List<HasMemberListData>> mainHasMemberMapDataList = [];
            for (int i = 0; i < length; i++) {
              var data = listOfActivityData.entry[i];
              if (data.resource.resourceType == R4ResourceType.Observation &&
                  data.resource.hasMember != null) {
                List<HasMemberListData> hasMemberMapDataList = [];

                for (int m = 0; m < data.resource.hasMember.length; m++) {
                  if (data.resource.effectivePeriod != null) {
                    var id = data.resource.id.toString();
                    var hasMemberMapData = HasMemberListData();
                    var referenceId = data.resource.hasMember[m].reference.toString();
                    var hasMemberType = data.resource.hasMember[m].display.toString();
                    hasMemberMapData.parentId = id;
                    hasMemberMapData.hasMemberId = referenceId.split("/")[referenceId.split("/").length - 1].toString();
                    if(data.resource.effectivePeriod != null) {
                      hasMemberMapData.hasMemberStartDate =
                          Utils.convertUtcToLocal(
                              data.resource.effectivePeriod.start);
                      hasMemberMapData.hasMemberEndDate =
                          Utils.convertUtcToLocal(
                              data.resource.effectivePeriod.end);
                    }
                    hasMemberMapData.hasMemberType = hasMemberType;
                    Debug.printLog("data.resource.effectiveDateTime.valueDateTime....${hasMemberMapData.hasMemberStartDate} ${hasMemberMapData.hasMemberEndDate} $id  $referenceId ${hasMemberMapData.hasMemberType}");
                    if(hasMemberMapDataList.where((element) => element.hasMemberId == referenceId).toList().isEmpty) {
                      hasMemberMapDataList.add(hasMemberMapData);
                    }
                  }
                }
                mainHasMemberMapDataList.add(hasMemberMapDataList);
              }
            }

            for (int t = 0; t < mainHasMemberMapDataList.length; t++) {
              for (int a = 0; a < mainHasMemberMapDataList[t].length;a++) {
                var dataParentChild = mainHasMemberMapDataList[t][a];

                var parentIdHasMember = dataParentChild.parentId;
                var typesOfActivity = dataParentChild.hasMemberType ?? "";
                var hasMemberId = dataParentChild.hasMemberId.split("/")
                [dataParentChild.hasMemberId.split("/").length - 1]
                    .toString();
                var startEffectiveDate = dataParentChild.hasMemberStartDate;
                var endEffectiveDate = dataParentChild.hasMemberEndDate;

                var activityNameListDataDateWise = listOfActivityData.entry
                    .where((element) =>
                mainHasMemberMapDataList[t].where((elementIdOfMember) => element.resource.id ==
                    elementIdOfMember.hasMemberId).toList().isNotEmpty
                    &&
                    DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
                        Utils.convertUtcToLocal(element.resource.effectivePeriod.start))
                        == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(startEffectiveDate!)
                    &&
                    DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
                        Utils.convertUtcToLocal(element.resource.effectivePeriod.end))
                        == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(endEffectiveDate!)
                    && element.resource.valueCodeableConcept != null && element.resource.code.coding[0].display.toString() == Constant.txtPhysicalActivityPanel)
                    .toList();

                ///Find activity name
                var activityName = "";
                var activityIcon = "";
                var activityNameLoincCode = "";
                var dataTypeOfActivity = "";
                if(activityNameListDataDateWise.isNotEmpty){
                  var activityNameCoding = activityNameListDataDateWise[0].resource.valueCodeableConcept.coding;
                  if(activityNameCoding.isNotEmpty){
                    activityName = activityNameCoding[0].display;
                    var code = Code(activityNameCoding[0].code);
                    activityNameLoincCode = code.value ?? "";
                    List<WorkOutData> iconNameList =
                    (kIsWeb)
                        ? Utils.workOutDataListAndroid.where((element) =>
                    element.workOutDataName.toLowerCase() ==
                        activityName.toLowerCase()).toList()
                        :
                    ///Android
                    (Platform.isAndroid)
                        ? Utils.workOutDataListAndroid.where((element) =>
                    element.workOutDataName.toLowerCase() ==
                        activityName.toLowerCase()).toList()
                        :
                    ///Ios
                    Utils.workOutDataListIos
                        .where((element) => element.workOutDataName.toLowerCase() == activityName.toLowerCase()).toList();

                    if(iconNameList.isNotEmpty){
                      activityIcon = iconNameList[0].workOutDataImages;
                      if(Constant.configurationInfo.where((element) => element.title == activityName && element.iconImage == activityIcon).toList().isEmpty) {
                        Constant.configurationInfo.add(ConfigurationClass(
                            title: activityName,
                            iconImage: activityIcon,
                            activityCode: activityNameLoincCode));
                        // await Utils.callPushApiForConfigurationActivity();
                        Constant.configurationInfoGraphManage.clear();
                        Constant.configurationInfoGraphManage.add(
                          ConfigurationClass(title: Constant.titleNon,
                              iconImage: "",
                              activityCode: ""),
                        );
                        Constant.configurationInfoGraphManage.addAll(
                            Constant.configurationInfo);
                      }
                    }
                  }
                }

                ///Insert update parent data (HasMember)
                var activityTableDataList = getActivityListData();
                if(parentIdHasMember != "" && activityName != ""){
                  List<ActivityTable> activityParentListData = [];
                  activityParentListData = activityTableDataList.where((element) => element.displayLabel ==
                      activityName && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(startEffectiveDate ?? DateTime.now()) &&
                      Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                          Utils.changeDateFormatBasedOnDBDate(endEffectiveDate ?? DateTime.now()) && element.type == Constant.typeDaysData
                      && element.title == Constant.titleParent).toList();
                 /* if(activityParentListData.isEmpty){
                    activityParentListData = activityTableDataList.where((element) => element.displayLabel ==
                        activityName  && element.type == Constant.typeDaysData
                        && element.title == Constant.titleParent && element.serverDetailList.where((element) => element.serverUrl == serverUrlFromAPI
                        && element.objectId == mainHasMemberMapDataList[t][a].hasMemberId).toList().isEmpty).toList();
                  }*/

                  var data = listOfActivityData.entry
                      .where((element) =>
                  element.resource.id == parentIdHasMember  && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
                      Utils.convertUtcToLocal(element.resource.effectivePeriod.start)
                  ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(startEffectiveDate ?? DateTime.now())
                      && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
                      Utils.convertUtcToLocal(element.resource.effectivePeriod.end)
                  ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(endEffectiveDate ?? DateTime.now()))
                      .toList();

                  List<Identifier> identifierData = [];
                  var isAppleData = false;
                  if(data.isNotEmpty) {
                    if (data[0].resource.identifier != null) {
                      identifierData = data[0].resource.identifier;
                    }
                    var appleLink = data[0].resource.meta.source.toString();
                    isAppleData = appleLink.contains(Constant.appleLink);
                    Debug.printLog("apple link parent data....$isAppleData");
                  }

                  if(activityParentListData.isEmpty){
                    var insertingData = ActivityTable();
                    insertingData.displayLabel = activityName;
                    insertingData.dateTime = Utils.changeDateFormatBasedOnDBDate(startEffectiveDate ?? DateTime.now());
                    insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.changeDateFormatBasedOnDBDate(startEffectiveDate ?? DateTime.now()));
                    insertingData.activityStartDate = startEffectiveDate;
                    insertingData.activityEndDate = endEffectiveDate;
                    insertingData.title = Constant.titleParent;
                    insertingData.smileyType = null;
                    insertingData.total = null;
                    insertingData.value1 = null;
                    insertingData.value2 = null;
                    insertingData.type = Constant.typeDaysData;
                    insertingData.isFromAppleHealth = isAppleData;
                    // if(isAppleData){
                    insertingData.isSync = true;
                    // }
                    insertingData.activityStartDate = startEffectiveDate ?? DateTime.now();
                    insertingData.activityEndDate = endEffectiveDate ?? DateTime.now();

                    var startDateOfWeek = Utils.findFirstDateOfTheWeekImport(insertingData.dateTime ?? DateTime.now());
                    var lastDateOfWeek = Utils.findLastDateOfTheWeekImport(insertingData.dateTime ?? DateTime.now());
                    var selectedWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                        .format(startDateOfWeek);
                    var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
                        .format(lastDateOfWeek);
                    var weekDate = "$selectedWeekStartDate-$selectedWeekEndDate";
                    insertingData.weeksDate = weekDate;

                    var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
                    if(connectedServerUrl.isNotEmpty) {
                      for (int i = 0; i < connectedServerUrl.length; i++) {
                        var data = ServerDetailDataTable();
                        data.dataSyncServerWise = false;
                        if(connectedServerUrl[i].url == serverUrlFromAPI) {
                          data.objectId = dataParentChild.parentId;
                        }
                        data.serverUrl = connectedServerUrl[i].url;
                        data.patientId = connectedServerUrl[i].patientId;
                        data.clientId = connectedServerUrl[i].clientId;
                        data.serverToken = connectedServerUrl[i].authToken;
                        data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                            .patientLName}";
                        insertingData.serverDetailList.add(data);
                      }
                    }
                    for (int i = 0; i < identifierData.length; i++) {
                      var identifierDataTable = IdentifierTable();
                      identifierDataTable.url =
                          identifierData[i].system!.value.toString();
                      identifierDataTable.objectId =
                          identifierData[i].value.toString();
                      insertingData.identifierData.add(identifierDataTable);
                    }

                    await DataBaseHelper.shared.insertActivityData(insertingData);
                  }
                  else{
                    var allSelectedServersUrl = Utils.getServerListPreference().where((
                        element) => element.patientId != "" && element.isSelected).toList();

                    /*if (activityParentListData[0].serverDetailList.length !=
                        allSelectedServersUrl.length) {
                      for (int i = 0; i < allSelectedServersUrl.length; i++) {
                        var url = activityParentListData[0].serverDetailList;
                        if (url
                            .where((element) =>
                        element.serverUrl == allSelectedServersUrl[i].url)
                            .toList()
                            .isEmpty) {
                          var serverDetail = ServerDetailDataTable();
                          serverDetail.serverUrl = allSelectedServersUrl[i].url;
                          serverDetail.patientId = allSelectedServersUrl[i].patientId;
                          serverDetail.patientName = "${allSelectedServersUrl[i]
                              .patientFName}${allSelectedServersUrl[i].patientLName}";
                          if(serverUrlFromAPI == allSelectedServersUrl[i].url){
                            serverDetail.objectId = dataParentChild.parentId;
                          }
                          activityParentListData[0].serverDetailList.add(
                              serverDetail);
                        }
                      }
                    }*/

                    for (int i = 0; i < allSelectedServersUrl.length; i++) {
                      var url = activityParentListData[0].serverDetailList;
                      var totalMinServerData = url
                          .where((element) =>
                      element.serverUrl == allSelectedServersUrl[i].url).toList();
                      if (totalMinServerData.isEmpty) {
                        var serverDetail = ServerDetailDataTable();
                        serverDetail.serverUrl = allSelectedServersUrl[i].url;
                        serverDetail.patientId = allSelectedServersUrl[i].patientId;
                        serverDetail.patientName = "${allSelectedServersUrl[i]
                            .patientFName}${allSelectedServersUrl[i].patientLName}";
                        if (serverUrlFromAPI == allSelectedServersUrl[i].url) {
                          serverDetail.objectId = dataParentChild.parentId;
                        } else {
                          serverDetail.objectId = "";
                        }
                        activityParentListData[0].serverDetailList.add(
                            serverDetail);
                      }
                      else if (totalMinServerData
                          .where((element) => element.objectId == "")
                          .toList()
                          .isNotEmpty) {
                        var findIndex = totalMinServerData
                            .indexWhere((element) =>
                        element.serverUrl == allSelectedServersUrl[i].url)
                            .toInt();
                        if (serverUrlFromAPI == allSelectedServersUrl[i].url && findIndex >= 0) {
                          totalMinServerData[findIndex].objectId = dataParentChild.parentId;
                        }
                        activityParentListData[0].serverDetailList = totalMinServerData;
                      }
                    }

                    List<IdentifierTable> tempIdentifierList = [];
                    for (int i = 0; i < identifierData.length; i++) {
                      var identifierDataTable = IdentifierTable();
                      identifierDataTable.url =
                          identifierData[i].system!.value.toString();
                      identifierDataTable.objectId =
                          identifierData[i].value.toString();
                      tempIdentifierList.add(identifierDataTable);
                    }
                    activityParentListData[0].identifierData = tempIdentifierList;

                    var dbData = getActivityListData();
                    var activityParentListSync = dbData.where((element) => element.displayLabel ==
                        activityName &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(startEffectiveDate ?? DateTime.now()) &&
                        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now())  ==  Utils.changeDateFormatBasedOnDBDate(endEffectiveDate ?? DateTime.now())
                        && element.type == Constant.typeDaysData
                        && element.title == Constant.titleParent).toList();
                    Debug.printLog("activityParentListSync.....${activityParentListSync.length}  $activityName  $startEffectiveDate  $endEffectiveDate");
                    // if(isAppleData){
                    activityParentListData[0].isSync = true;
                    activityParentListData[0].needExport = false;
                    // }
                    await DataBaseHelper.shared.updateActivityData(
                        activityParentListData[0]);
                  }
                }


                var data = listOfActivityData.entry
                    .where((element) =>
                element.resource.id == hasMemberId  && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
                    Utils.convertUtcToLocal(element.resource.effectivePeriod.start)
                ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(startEffectiveDate ?? DateTime.now())
                    && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
                    Utils.convertUtcToLocal(element.resource.effectivePeriod.end)
                ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(endEffectiveDate ?? DateTime.now()))
                    .toList();

                List<Identifier> identifierData = [];

                if(data.isNotEmpty && activityName != ""){

                  var displayCode =  data[0].resource.code.coding[0].display.toString();
                  var has = data[0].resource.hasMember;
                  if(has != null && displayCode == "Physical Activity Panel"){
                    dataTypeOfActivity = Constant.parentType;
                  }else if(has == null && displayCode == "Physical Activity Panel"){
                    dataTypeOfActivity = Constant.hasMemberTypeActivity;
                  }else if(has == null && displayCode == "Exercise duration"){
                    dataTypeOfActivity = Constant.hasMemberTypeTotalMin;
                  }else if(has == null && displayCode == "Moderate physical activity [IPAQ]"){
                    dataTypeOfActivity = Constant.hasMemberTypeModMin;
                  }else if(has == null && displayCode == "Vigorous physical activity [IPAQ]"){
                    dataTypeOfActivity = Constant.hasMemberTypeVigMin;
                  }else if(has == null && displayCode == "Calories burned in unspecified time Pedometer"){
                    dataTypeOfActivity = Constant.hasMemberTypeCalories;
                  }else if(has == null && displayCode == "Heart rate unspecified time maximum by Pedometer"){
                    dataTypeOfActivity = Constant.hasMemberTypePeakHeartRate;
                  }else if(has == null && displayCode == "Number of steps in unspecified time Pedometer"){
                    dataTypeOfActivity = Constant.hasMemberTypeSteps;
                  }else if(has == null && displayCode == "Was this a good or bad experience [PhenX]"){
                    dataTypeOfActivity = Constant.hasMemberTypeEx;
                  }
                  if (data[0].resource.identifier != null) {
                    identifierData = data[0].resource.identifier;
                  }
                  if(data[0].resource.code.coding != null){
                    var code = data[0].resource.code.coding[0].code;
                    var appleLink = "";
                    var appleData = false;
                    if(data[0].resource.meta != null){
                      appleLink = data[0].resource.meta.source.toString();
                      appleData  = appleLink.contains(Constant.appleLink);
                      Debug.printLog("Child activity apple.....$appleData");
                    }
                    Debug.printLog("data[0].resource.code.coding[0].code....${data[0].resource.code.coding[0].code}  $startEffectiveDate");
                    if(code == Constant.codeChildActivityCalories){

                      if(data.isNotEmpty){
                        var activityCaloriesCoding = data[0].resource.code.coding;
                        if(activityCaloriesCoding.isNotEmpty){
                          if(activityCaloriesCoding[0].code == Code(Constant.codeChildActivityCalories) && typesOfActivity == Constant.hasMemberTypeCalories){
                            var totalMinQuantity = Quantity(value: data[0].resource.valueQuantity.value);
                            Debug.printLog("Total calories......${totalMinQuantity.value?.value}");
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                0,
                                0,
                                totalMinQuantity.value?.value,
                                0,
                                0,
                                0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity,serverUrlFromAPI,
                                mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                caloriesObjectId:dataParentChild.hasMemberId,isAppleData: appleData );
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityCalories..  $code  $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivityPeakHeartRate){
                      if(data.isNotEmpty){
                        var activityPeakHeartCoding = data[0].resource.code.coding;
                        if(activityPeakHeartCoding.isNotEmpty){
                          if(activityPeakHeartCoding[0].code == Code(Constant.codeChildActivityPeakHeartRate) && typesOfActivity == Constant.hasMemberTypePeakHeartRate){
                            var totalPeakHeartRate = Quantity(value: data[0].resource.valueQuantity.value);
                            Debug.printLog("Total calories......${totalPeakHeartRate.value?.value}");
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                0,
                                0,
                                0,
                                totalPeakHeartRate.value?.value,
                                0,
                                0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity
                                ,serverUrlFromAPI, mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                peakHeartRateObjectId:dataParentChild.hasMemberId,isAppleData: appleData );
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityPeakHeartRate..  $code $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivityVigorousMin){
                      if(data.isNotEmpty){
                        var activityVigMinCoding = data[0].resource.code.coding;
                        if(activityVigMinCoding.isNotEmpty){
                          if(activityVigMinCoding[0].code == Code(Constant.codeChildActivityVigorousMin) && typesOfActivity == Constant.hasMemberTypeVigMin){
                            var totalVigMin = Quantity(value: data[0].resource.valueQuantity.value);
                            Debug.printLog("Total vig min......${totalVigMin.value?.value}");
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                totalVigMin.value?.value,
                                0,
                                0,
                                0,
                                0,
                                0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity
                                ,serverUrlFromAPI, mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                vigValueObjectId:dataParentChild.hasMemberId,isAppleData: appleData );
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityVigorousMin..  $code $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivityModerateMin){
                      if(data.isNotEmpty){
                        var activityModMinCoding = data[0].resource.code.coding;
                        if(activityModMinCoding.isNotEmpty){
                          if(activityModMinCoding[0].code == Code(Constant.codeChildActivityModerateMin) && typesOfActivity == Constant.hasMemberTypeModMin){
                            var totalModMin = Quantity(value: data[0].resource.valueQuantity.value);
                            Debug.printLog("Total mod min......${totalModMin.value?.value}");
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                totalModMin.value?.value,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity
                                ,serverUrlFromAPI, mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                modValueObjectId:dataParentChild.hasMemberId,isAppleData: appleData );
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityModerateMin..  $code $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivityTotalMin){
                      if(data.isNotEmpty){
                        var activityTotalMinCoding = data[0].resource.code.coding;
                        if(activityTotalMinCoding.isNotEmpty){
                          if(activityTotalMinCoding[0].code == Code(Constant.codeChildActivityTotalMin) && typesOfActivity == Constant.hasMemberTypeTotalMin){
                            var totalMin = Quantity(value: data[0].resource.valueQuantity.value);
                            Debug.printLog("Total total min......${totalMin.value?.value}");
                            var note = "";
                            if (data[0].resource.note != null) {
                              var notesList = data[0].resource.note;
                              for (int i = 0; i < notesList.length; i++) {
                                note = notesList[i].text.toString();
                              }
                            }
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                0,
                                totalMin.value?.value,
                                0,
                                0,0,0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity
                                ,serverUrlFromAPI, mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                totalMinObjectId:dataParentChild.hasMemberId,note: note,isAppleData: appleData );
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityTotalMin..  $code $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivityType){
                      if(data.isNotEmpty){
                        var activityTypeCoding = data[0].resource.code.coding;
                        if(activityTypeCoding.isNotEmpty){
                          if(activityTypeCoding[0].code == Code(Constant.codeChildActivityType) && typesOfActivity == Constant.hasMemberTypeActivity){
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity
                                ,serverUrlFromAPI, mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                activityTypeObjectId:dataParentChild.hasMemberId ,isAppleData: appleData);
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityType..  $code $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivitySteps){
                      if(data.isNotEmpty){
                        var activityStepsCoding = data[0].resource.code.coding;
                        if(activityStepsCoding.isNotEmpty){
                          if(activityStepsCoding[0].code == Code(Constant.codeChildActivitySteps) && typesOfActivity == Constant.hasMemberTypeSteps){
                            var totalMinQuantity = Quantity(value: data[0].resource.valueQuantity.value);
                            Debug.printLog("Total stpes......${totalMinQuantity.value?.value}");
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                0,
                                0,
                                0,
                                0,
                                totalMinQuantity.value?.value,
                                0,
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity,serverUrlFromAPI,
                                mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                stepsObjectId:dataParentChild.hasMemberId,isAppleData: appleData );
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityCalories..  $code  $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                    else if(code == Constant.codeChildActivityEx){
                      if(data.isNotEmpty){
                        var activityExCoding = data[0].resource.code.coding;
                        if(activityExCoding.isNotEmpty){
                          if(activityExCoding[0].code == Code(Constant.codeChildActivityEx) && typesOfActivity == Constant.hasMemberTypeEx){
                            var value = data[0].resource.valueCodeableConcept.coding;
                            var ex = Code(value[0].code);
                            Debug.printLog("values........$ex");
                            await insertUpdateActivityLevelData(
                                activityName,
                                startEffectiveDate ?? DateTime.now(),
                                endEffectiveDate ?? DateTime.now(),
                                0,
                                0,
                                0,
                                0,
                                0,
                                0,
                                int.parse(ex.toString()),
                                serverUrlFromAPI,typesOfActivity,identifierData,dataTypeOfActivity,serverUrlFromAPI,
                                mainHasMemberMapDataList[t][a].hasMemberId,mainHasMemberMapDataList[t],listOfActivityData.entry,
                                exObjectId:dataParentChild.hasMemberId ,isAppleData: appleData);
                          }
                        }
                      }
                      Debug.printLog("codeChildActivityCalories..  $code  $startEffectiveDate ${dataParentChild.hasMemberId}");
                    }
                  }
                }
              }
            }
            Debug.printLog("data.resource.hasMember..  $mainHasMemberMapDataList ");

          }
        }
      }

      allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      if(listOfActivityData != null && listOfActivityData.entry != null){

        var listDataStepsData = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeSteps)
            .toList();
        if (listDataStepsData != null) {
          if (listDataStepsData != null) {
            int length = listDataStepsData.length;
            for (int i = 0; i < length; i++) {
              var data = listDataStepsData[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if(startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.titleSteps,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      "");
                  Debug.printLog("$startDate");
                }
              }
            }
          }
          // }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataCaloriesData = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeCalories)
            .toList();
        if (listDataCaloriesData != null) {
          if (listDataCaloriesData != null) {
            int length = listDataCaloriesData.length;
            for (int i = 0; i < length; i++) {
              var data = listDataCaloriesData[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                bool isOrveride = false;
                if(data.resource.bodySite != null ){
                  if(data.resource.bodySite.coding != null){
                    if(data.resource.bodySite.coding[0].display != null){
                      String v = data.resource.bodySite.coding[0].display.toString();
                      isOrveride = stringToBool(v);
                      Debug.printLog("IsOveride Manage.....$v");

                    }
                  }
                }

                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.titleCalories,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      "",
                      isOverride: isOrveride);
                  Debug.printLog(
                      "titleCalories...............$startDate  $value  $id");
                }
              }
            }
          }
          // }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataRestHeartData = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeRestHeart)
            .toList();
        if (listDataRestHeartData != null) {
          if (listDataRestHeartData != null) {
            int length = listDataRestHeartData.length;
            for (int i = 0; i < length; i++) {
              var data = listDataRestHeartData[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if(startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.titleHeartRateRest,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      "");
                  Debug.printLog("codeRestHeart...............$startDate");
                }
              }
            }
          }
          // }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataPeakHeartData = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codePeckHeart)
            .toList();
        if (listDataPeakHeartData != null) {
          if (listDataPeakHeartData != null) {
            int length = listDataPeakHeartData.length;
            for (int i = 0; i < length; i++) {
              var data = listDataPeakHeartData[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.titleHeartRatePeak,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      "");
                  Debug.printLog("titleHeartRatePeak...............$startDate");
                }
              }
            }
          }
          // }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataTotalMinDay = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeTotalMinDay)
            .toList();
        if (listDataTotalMinDay != null) {
          if (listDataTotalMinDay != null) {
            int length = listDataTotalMinDay.length;
            for (int i = 0; i < length; i++) {
              var data = listDataTotalMinDay[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                var note = "";
                if (data.resource.note != null) {
                  var notesList = data.resource.note;
                  for (int i = 0; i < notesList.length; i++) {
                    note = notesList[i].text.toString();
                  }
                }
                bool isOrveride = false;
                if(data.resource.bodySite != null ){
                  if(data.resource.bodySite.coding != null){
                    if(data.resource.bodySite.coding[0].display != null){
                      String min = data.resource.bodySite.coding[0].display.toString();
                      isOrveride = stringToBool(min);
                      Debug.printLog("IsOveride Manage.....$min");

                    }
                  }
                }

                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.totalMinPerDay,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      id,
                      "",
                      "",
                      notes: note,isOverride: isOrveride);
                  Debug.printLog("TOTAL min...............$startDate  $value");
                }
              }
            }
          }
          // }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataModMinDay = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeModMinDay)
            .toList();
        if (listDataModMinDay != null) {
          if (listDataModMinDay != null) {
            int length = listDataModMinDay.length;
            for (int i = 0; i < length; i++) {
              var data = listDataModMinDay[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.modMinPerDay,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      id,
                      "");
                  Debug.printLog("MOD min...............$startDate  $value");
                }
              }
            }
          }
        }
        // }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataVigMinDay = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeVigMinDay)
            .toList();
        if (listDataVigMinDay != null) {
          if (listDataVigMinDay != null ) {
            int length = listDataVigMinDay.length;
            for (int i = 0; i < length; i++) {
              var data = listDataVigMinDay[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();
                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.vigMinPerDay,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      id);
                  Debug.printLog("VIG min...............$startDate  $value");
                }
              }
            }
          }
          // }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listDataEx = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.experience)
            .toList();
        if (listDataEx != null) {
          if (listDataEx != null ) {
            int length = listDataEx.length;
            for (int i = 0; i < length; i++) {
              var data = listDataEx[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueCodeableConcept.coding;
                var code = Code(value[0].code);

                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.experience,
                      code.toString() ?? "",
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      "");
                  Debug.printLog("listDataEx...............$startDate");
                }
              }
            }
          }
        }

        allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
        var listOfStrBoxDayLevel = listOfActivityData.entry.where((element) =>
        element.resource.code.coding[0].code.toString() == Constant.codeCheckBoxDay)
            .toList();
        if (listOfStrBoxDayLevel != null) {
          if (listOfStrBoxDayLevel != null) {
            int length = listOfStrBoxDayLevel.length;
            for (int i = 0; i < length; i++) {
              var data = listOfStrBoxDayLevel[i];
              if (data.resource.resourceType == R4ResourceType.Observation) {
                var id = data.resource.id.toString();
                var value = data.resource.valueQuantity.value.valueString
                    .toString();

                var startDate;
                if (data.resource.effectiveDateTime
                    .toString()
                    .isNotEmpty && data.resource.effectiveDateTime != null) {
                  startDate = Utils.getSplitDateFromAPIData(
                      data.resource.effectiveDateTime.toString());
                }
                List<Identifier> identifierData = [];
                if (data.resource.identifier != null) {
                  identifierData = data.resource.identifier;
                }
                if (startDate != null) {
                  insertUpdateCalStepHeartMinDays(
                      Constant.titleDaysStr,
                      value,
                      startDate,
                      id,
                      patientName,
                      patientId,
                      serverUrlFromAPI,
                      identifierData,
                      "",
                      "",
                      "");
                  Debug.printLog(
                      "listOfStrBoxDayLevel...............$startDate ${value}");
                }
              }
            }
          }
        }
      }
      // }


      await Utils.callPushApiForConfigurationActivity();
      Constant.isCalledAPI = true;
    }
    // Debug.printLog("getSetMonthActivityData...${getActivityListData()}");

    if(getActivityListData().isNotEmpty) {
      Utils.setFirstTimeCallApi(false);
      Utils.setLastAPICalledDate();
    }
  }

  static insertUpdateActivityLevelData(
      String display,
      DateTime activityStartDate,
      DateTime activityEndDate,
      double? modValue,
      double? vigValue,
      double? totalValue,
      double? calories,
      double? peakHeartRate,
      double? steps,
      dynamic ex,
      String baseURL,
      String typesOfActivity,
      List<Identifier> identifierData,
      String dataTypeOfActivity,
      String serverUrl,
      String hasMemberId, List<HasMemberListData> dataParentChildIds, dynamic entry,
      {String activityTypeObjectId = "",
        String parentObjectId = "",
        String modValueObjectId = "",
        String vigValueObjectId = "",
        String totalMinObjectId = "",
        String caloriesObjectId = "",
        String peakHeartRateObjectId = "",
        String stepsObjectId = "",
        String exObjectId = "",
        String note = "",bool isAppleData = false
      }) async {
    var activityTableDataList = getActivityListData();

    var startDateOfWeek = Utils.findFirstDateOfTheWeekImport(activityStartDate);
    var lastDateOfWeek = Utils.findLastDateOfTheWeekImport(activityStartDate);
    var selectedWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(startDateOfWeek);
    var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(lastDateOfWeek);
    var weekDate = "$selectedWeekStartDate-$selectedWeekEndDate";

    ///titleActivityType
    List<ActivityTable>  activityTypeDataList = [];
    activityTypeDataList = activityTableDataList.where((element) => element.displayLabel ==
        display && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleActivityType).toList();
    if(activityTypeDataList.isEmpty){
      activityTypeDataList = activityTableDataList.where((element) => element.displayLabel ==
          display  && element.title == Constant.titleActivityType
          && element.serverDetailList.where((element) => element.serverUrl == serverUrl
              && element.objectId == activityTypeObjectId).toList().isNotEmpty).toList();
    }
    if(activityTypeDataList.isEmpty && activityTypeObjectId != ""){
      var insertingData = ActivityTable();
      insertingData.displayLabel = display;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = Constant.titleActivityType;
      insertingData.type = Constant.typeDaysData;
      insertingData.isFromAppleHealth = isAppleData;
      // if(isAppleData){
      insertingData.isSync = true;
      // }
      insertingData.weeksDate = weekDate;
      Debug.printLog("titleActivityType isFromAppleHealth...$isAppleData");
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
          && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          if(baseURL == connectedServerUrl[i].url) {
            data.objectId = activityTypeObjectId;
          }else{
            data.objectId = "";
          }
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }
      if(dataTypeOfActivity == Constant.hasMemberTypeActivity) {
        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          insertingData.identifierData.add(identifierDataTable);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else if(activityTypeDataList.isNotEmpty && activityTypeObjectId != ""){

      if(activityTypeObjectId != "") {
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityTypeDataList[0].serverDetailList;
          var totalMinServerData = url
              .where((element) =>
          element.serverUrl == allSelectedServersUrl[i].url).toList();
          if (totalMinServerData.isEmpty) {
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i]
                .patientFName}${allSelectedServersUrl[i].patientLName}";
            if (baseURL == allSelectedServersUrl[i].url) {
              serverDetail.objectId = activityTypeObjectId;
            } else {
              serverDetail.objectId = "";
            }
            activityTypeDataList[0].serverDetailList.add(
                serverDetail);
          }
          else if (allSelectedServersUrl.isNotEmpty && activityTypeDataList[0].serverDetailList.isNotEmpty) {
            var findIndex = totalMinServerData
                .indexWhere((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toInt();
            if (baseURL == allSelectedServersUrl[i].url && findIndex >= 0) {
              totalMinServerData[findIndex].objectId = activityTypeObjectId;
            }
            activityTypeDataList[0].serverDetailList = totalMinServerData;
          }
        }
        if(dataTypeOfActivity == Constant.hasMemberTypeActivity) {
          List<IdentifierTable> tempIdentifierList = [];
          for (int i = 0; i < identifierData.length; i++) {
            var identifierDataTable = IdentifierTable();
            identifierDataTable.url =
                identifierData[i].system!.value.toString();
            identifierDataTable.objectId =
                identifierData[i].value.toString();
            tempIdentifierList.add(identifierDataTable);
          }
          activityTypeDataList[0].identifierData = tempIdentifierList;
        }
        activityTypeDataList[0].activityStartDate = activityStartDate;
        activityTypeDataList[0].activityEndDate = activityEndDate;
        activityTypeDataList[0].isFromAppleHealth = isAppleData;
        activityTypeDataList[0].isSync = true;
        await DataBaseHelper.shared.updateActivityData(
            activityTypeDataList[0]);
      }
    }


    ///titleParent
    List<ActivityTable>  activityParentListData = [];
    activityParentListData = activityTableDataList.where((element) => element.displayLabel ==
        display && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) && element.type == Constant.typeDaysData
        && element.title == Constant.titleParent).toList();
    if(activityParentListData.isEmpty){
      activityParentListData = activityTableDataList.where((element) => element.displayLabel ==
          display && element.title == Constant.titleParent
          && element.serverDetailList.where((element) => element.serverUrl == serverUrl
              && element.objectId == parentObjectId).toList().isNotEmpty).toList();
    }
    if(activityParentListData.isEmpty && parentObjectId != ""){
      var insertingData = ActivityTable();
      insertingData.displayLabel = display;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = Constant.titleParent;
      insertingData.type = Constant.typeDaysData;
      insertingData.isFromAppleHealth = isAppleData;
      insertingData.weeksDate = weekDate;
      insertingData.isSync = true;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != ""
          && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          if(baseURL == connectedServerUrl[i].url) {
            data.objectId = parentObjectId;
          }else{
            data.objectId = "";
          }
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }
      if(dataTypeOfActivity == Constant.parentType) {
        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          insertingData.identifierData.add(identifierDataTable);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else if(activityParentListData.isNotEmpty && parentObjectId != ""){

      if(parentObjectId != "") {
        var allSelectedServersUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();

        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityParentListData[0].serverDetailList;
          var totalMinServerData = url
              .where((element) =>
          element.serverUrl == allSelectedServersUrl[i].url).toList();
          if (totalMinServerData.isEmpty) {
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i]
                .patientFName}${allSelectedServersUrl[i].patientLName}";
            if (baseURL == allSelectedServersUrl[i].url) {
              serverDetail.objectId = parentObjectId;
            } else {
              serverDetail.objectId = "";
            }
            activityParentListData[0].serverDetailList.add(
                serverDetail);
          }
          else if (allSelectedServersUrl.isNotEmpty && activityParentListData[0].serverDetailList.isNotEmpty) {
            var findIndex = totalMinServerData
                .indexWhere((element) =>
            element.serverUrl == allSelectedServersUrl[i].url)
                .toInt();
            if (baseURL == allSelectedServersUrl[i].url && findIndex >= 0) {
              totalMinServerData[findIndex].objectId = parentObjectId;
            }
            activityParentListData[0].serverDetailList = totalMinServerData;
          }
        }
        if(dataTypeOfActivity == Constant.hasMemberTypeTotalMin) {
          List<IdentifierTable> tempIdentifierList = [];
          for (int i = 0; i < identifierData.length; i++) {
            var identifierDataTable = IdentifierTable();
            identifierDataTable.url =
                identifierData[i].system!.value.toString();
            identifierDataTable.objectId =
                identifierData[i].value.toString();
            tempIdentifierList.add(identifierDataTable);
          }
          activityParentListData[0].identifierData = tempIdentifierList;
        }
        activityParentListData[0].activityStartDate = activityStartDate;
        activityParentListData[0].activityEndDate = activityEndDate;
        activityParentListData[0].isSync = true;
        await DataBaseHelper.shared.updateActivityData(
            activityParentListData[0]);
      }
    }


    ///Mod, Vig and Total min(Activity min
    List<ActivityTable> activityLevelDataList = [];
    /*if(parentObjectId == "" && activityTypeObjectId == "" &&
        caloriesObjectId == "" && peakHeartRateObjectId == "" ) {

    }*/
    if(totalMinObjectId != "") {
      activityLevelDataList = activityTableDataList
          .where((element) =>
      element.type == Constant.typeDaysData &&
          element.title == null &&
          element.smileyType == null &&
          element.displayLabel == display &&
          Utils.changeDateFormatBasedOnDBDate(
              element.activityStartDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
          Utils.changeDateFormatBasedOnDBDate(
              element.activityEndDate ?? DateTime.now()) ==
              Utils.changeDateFormatBasedOnDBDate(activityEndDate))
          .toList();
      if(activityLevelDataList.isEmpty){
        activityLevelDataList = activityTableDataList
            .where((element) =>
        element.type == Constant.typeDaysData &&
            element.title == null &&
            element.smileyType == null &&
            element.displayLabel == display
            && element.serverDetailList.where((element) =>
        element.serverUrl == serverUrl
            && element.objectId == totalMinObjectId)
            .toList()
            .isNotEmpty)
            .toList();
      }
      var modMinId =
      dataParentChildIds.where((element) => element.hasMemberType == Constant.hasMemberTypeModMin
          && element.hasMemberId != "").toList();
      if(modMinId.isNotEmpty){
        modValueObjectId = modMinId[0].hasMemberId;
        var data = entry
            .where((element) =>
        element.resource.id == modValueObjectId)
            .toList();
        if(data.isNotEmpty) {
          modValue =
              Quantity(value: data[0].resource.valueQuantity.value).value
                  ?.value;
        }
        Debug.printLog("Total modValue min......$modValue  $modValueObjectId");
      }


      var vigMin =
      dataParentChildIds.where((element) =>
      element.hasMemberType == Constant.hasMemberTypeVigMin
          && element.hasMemberId != "").toList();
      if (vigMin.isNotEmpty) {
        vigValueObjectId = vigMin[0].hasMemberId;
        var data = entry
            .where((element) =>
        element.resource.id == vigValueObjectId)
            .toList();
        if (data.isNotEmpty) {
          vigValue =
              Quantity(value: data[0].resource.valueQuantity.value).value
                  ?.value;
        }
        Debug.printLog("Total vigValue min......$vigValue  $vigValueObjectId");
      }


      var caloriesData =
      dataParentChildIds.where((element) =>
      element.hasMemberType == Constant.hasMemberTypeCalories
          && element.hasMemberId != "").toList();
      if (caloriesData.isNotEmpty) {
        caloriesObjectId = caloriesData[0].hasMemberId;
        var data = entry
            .where((element) =>
        element.resource.id == caloriesObjectId)
            .toList();
        if (data.isNotEmpty) {
          calories =
              Quantity(value: data[0].resource.valueQuantity.value).value
                  ?.value;
        }
        Debug.printLog("Total calories min......$calories  $caloriesObjectId");
      }

      var peakHeartRateData =
      dataParentChildIds.where((element) =>
      element.hasMemberType == Constant.hasMemberTypePeakHeartRate
          && element.hasMemberId != "").toList();
      if (peakHeartRateData.isNotEmpty) {
        peakHeartRateObjectId = peakHeartRateData[0].hasMemberId;
        var data = entry
            .where((element) =>
        element.resource.id == peakHeartRateObjectId)
            .toList();
        if (data.isNotEmpty) {
          peakHeartRate =
              Quantity(value: data[0].resource.valueQuantity.value).value
                  ?.value;
        }
        Debug.printLog(
            "Total peakHeartRate min......$peakHeartRate  $peakHeartRateObjectId");
      }

      var stepsData =
      dataParentChildIds.where((element) =>
      element.hasMemberType == Constant.hasMemberTypeSteps
          && element.hasMemberId != "").toList();
      if (stepsData.isNotEmpty) {
        stepsObjectId = stepsData[0].hasMemberId;
        var data = entry
            .where((element) =>
        element.resource.id == stepsObjectId)
            .toList();
        if (data.isNotEmpty) {
          steps =
              Quantity(value: data[0].resource.valueQuantity.value).value
                  ?.value;
        }
        Debug.printLog(
            "Total peakHeartRate min......$steps  $stepsObjectId");
      }

      var exData =
      dataParentChildIds.where((element) =>
      element.hasMemberType == Constant.hasMemberTypeEx
          && element.hasMemberId != "").toList();
      if (exData.isNotEmpty) {
        exObjectId = exData[0].hasMemberId;
        var data = entry
            .where((element) =>
        element.resource.id == exObjectId)
            .toList();
        if (data.isNotEmpty) {
          var value = data[0].resource.valueCodeableConcept.coding;
          // var code = ;
          ex = Code(value[0].code);
          ex = int.parse(ex.toString());
        }
        Debug.printLog(
            "Total peakHeartRate min......$ex  $exObjectId");
      }




      if (activityLevelDataList.isEmpty && parentObjectId == "" &&
          activityTypeObjectId == "") {
        var insertingData = ActivityTable();
        insertingData.isOverride = true;
        insertingData.displayLabel = display;
        insertingData.dateTime = activityStartDate;
        insertingData.date =
            DateFormat(Constant.commonDateFormatDdMmYyyy).format(
                activityStartDate ?? DateTime.now());
        insertingData.activityStartDate = activityStartDate;
        insertingData.activityEndDate = activityEndDate;
        insertingData.title = null;
        insertingData.smileyType = null;
        insertingData.isSync = true;
        insertingData.isFromAppleHealth = isAppleData;
        insertingData.iconPath = Utils.getNumberIconNameFromType(display);
        List<WorkOutData> getIconPathFromName = Utils.iconSetList().where((element) => element.workOutDataName.toLowerCase() == display.toLowerCase()).toList();
        ///Web
/*        (kIsWeb)
            ? Utils.workOutDataListAndroid.where((element) =>
        element.workOutDataName.toLowerCase() ==
            display.toLowerCase()).toList()
            :
        ///Android
        (Platform.isAndroid)
            ? Utils.workOutDataListAndroid.where((element) =>
        element.workOutDataName.toLowerCase() ==
            display.toLowerCase()).toList()
            :
        ///Ios
        Utils.workOutDataListIos
            .where((element) => element.workOutDataName.toLowerCase() == display.toLowerCase()).toList();*/
        if (getIconPathFromName.isNotEmpty) {
          insertingData.iconPath = getIconPathFromName[0].workOutDataImages;
        }

        ///Mod value
        if (modValueObjectId != "") {
          if (modValue == null) {
            insertingData.value1 = null;
          } else {
            insertingData.value1 = double.parse(modValue.toString());
          }

          var data = entry
              .where((element) =>
          element.resource.id == modValueObjectId  && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              Utils.convertUtcToLocal(element.resource.effectivePeriod.start)
          ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(activityStartDate ?? DateTime.now())
              && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              Utils.convertUtcToLocal(element.resource.effectivePeriod.end)
          ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(activityEndDate ?? DateTime.now()))
              .toList();

          List<Identifier> identifierData = [];
          if(data.isNotEmpty) {
            if (data[0].resource.identifier != null) {
              identifierData = data[0].resource.identifier;
            }
          }

          // if (dataTypeOfActivity == Constant.hasMemberTypeModMin) {
          for (int i = 0; i < identifierData.length; i++) {
            var identifierDataTable = IdentifierTable();
            identifierDataTable.url =
                identifierData[i].system!.value.toString();
            identifierDataTable.objectId = identifierData[i].value.toString();
            insertingData.identifierDataModMin.add(identifierDataTable);
          }
          // }
        }

        ///Vig value
        if (vigValueObjectId != "") {
          if (vigValue == null) {
            insertingData.value2 = null;
          } else {
            insertingData.value2 = double.parse(vigValue.toString());
          }

          var data = entry
              .where((element) =>
          element.resource.id == vigValueObjectId  && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              Utils.convertUtcToLocal(element.resource.effectivePeriod.start)
          ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(activityStartDate ?? DateTime.now())
              && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              Utils.convertUtcToLocal(element.resource.effectivePeriod.end)
          ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(activityEndDate ?? DateTime.now()))
              .toList();

          List<Identifier> identifierData = [];
          if(data.isNotEmpty) {
            if (data[0].resource.identifier != null) {
              identifierData = data[0].resource.identifier;
            }
          }
          // if (dataTypeOfActivity == Constant.hasMemberTypeVigMin) {
          for (int i = 0; i < identifierData.length; i++) {
            var identifierDataTable = IdentifierTable();
            identifierDataTable.url =
                identifierData[i].system!.value.toString();
            identifierDataTable.objectId = identifierData[i].value.toString();
            insertingData.identifierDataVigMin.add(identifierDataTable);
          }
          // }
        }

        if (totalMinObjectId != "") {
          if (totalValue == null) {
            insertingData.total = null;
          } else {
            insertingData.total = double.parse(totalValue.toString());
          }
          if(note != ""){
            insertingData.notes = note;
            Debug.printLog("notes days....$note");
          }
          var data = entry
              .where((element) =>
          element.resource.id == totalMinObjectId  && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              Utils.convertUtcToLocal(element.resource.effectivePeriod.start)
          ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(activityStartDate ?? DateTime.now())
              && DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(
              Utils.convertUtcToLocal(element.resource.effectivePeriod.end)
          ) == DateFormat(Constant.commonDateFormatYYYYMMDDHHMM).format(activityEndDate ?? DateTime.now()))
              .toList();

          List<Identifier> identifierData = [];
          if(data.isNotEmpty) {
            if (data[0].resource.identifier != null) {
              identifierData = data[0].resource.identifier;
            }
          }
          // if (dataTypeOfActivity == Constant.hasMemberTypeTotalMin) {
          for (int i = 0; i < identifierData.length; i++) {
            var identifierDataTable = IdentifierTable();
            identifierDataTable.url =
                identifierData[i].system!.value.toString();
            identifierDataTable.objectId = identifierData[i].value.toString();
            insertingData.identifierData.add(identifierDataTable);
          }
          // }
        }

        insertingData.type = Constant.typeDaysData;

        var connectedServerUrl = Utils.getServerListPreference().where((
            element) => element.patientId != "" && element.isSelected).toList();
        if (connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.dataSyncServerWise = false;
            if (baseURL == connectedServerUrl[i].url) {
              data.objectId = totalMinObjectId;
            } else {
              data.objectId = "";
            }
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            insertingData.serverDetailList.add(data);

            var dataMod = ServerDetailDataModMinTable();
            dataMod.modDataSyncServerWise = false;
            if (baseURL == connectedServerUrl[i].url) {
              dataMod.modObjectId = modValueObjectId;
            } else {
              dataMod.modObjectId = "";
            }
            dataMod.modServerUrl = connectedServerUrl[i].url;
            dataMod.modPatientId = connectedServerUrl[i].patientId;
            dataMod.modClientId = connectedServerUrl[i].clientId;
            dataMod.modServerToken = connectedServerUrl[i].authToken;
            dataMod.modPatientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            insertingData.serverDetailListModMin.add(dataMod);

            var dataVig = ServerDetailDataVigMinTable();
            dataVig.vigDataSyncServerWise = false;
            if (baseURL == connectedServerUrl[i].url) {
              dataVig.vigObjectId = vigValueObjectId;
            } else {
              dataVig.vigObjectId = "";
            }
            dataVig.vigServerUrl = connectedServerUrl[i].url;
            dataVig.vigPatientId = connectedServerUrl[i].patientId;
            dataVig.vigClientId = connectedServerUrl[i].clientId;
            dataVig.vigServerToken = connectedServerUrl[i].authToken;
            dataVig.vigPatientName =
            "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            insertingData.serverDetailListVigMin.add(dataVig);
          }
        }

        insertingData.weeksDate = weekDate;
        await DataBaseHelper.shared.insertActivityData(insertingData);
        await insertSingleEntryStepsRestStrDaysEx(
            display,
            activityStartDate,
            activityEndDate,
            weekDate,
            calories ?? 0.0,
            peakHeartRate ?? 0.0,
            steps ?? 0.0,
            ex ?? 0.0,
            baseURL,
            isAppleData: isAppleData,
            activityTypeObjectId: activityTypeObjectId,
            caloriesObjectId: caloriesObjectId,
            exObjectId: exObjectId,
            modValueObjectId: modValueObjectId,
            parentObjectId: parentObjectId,
            peakHeartRateObjectId: peakHeartRateObjectId,
            stepsObjectId: stepsObjectId,
            totalMinObjectId: totalMinObjectId,
            vigValueObjectId: vigValueObjectId
        );
      }
      else if (activityLevelDataList.isNotEmpty && parentObjectId == "" &&
          activityTypeObjectId == "" ) {
        if (activityLevelDataList.isNotEmpty) {
          if (activityLevelDataList[0].key  != null) {
            activityLevelDataList[0].isOverride = false;

            ///Mod value
            if (modValueObjectId != "") {
              if (modValue == null) {
                activityLevelDataList[0].value1 = null;
              } else {
                activityLevelDataList[0].value1 =
                    double.parse(modValue.toString());
              }
            }

            ///Vig value
            if (vigValueObjectId != "") {
              if (vigValue == null) {
                activityLevelDataList[0].value2 = null;
              } else {
                activityLevelDataList[0].value2 =
                    double.parse(vigValue.toString());
              }
            }

            if (totalMinObjectId != "") {
              if (totalValue == null) {
                activityLevelDataList[0].total = null;
              } else {
                activityLevelDataList[0].total =
                    double.parse(totalValue.toString());
              }
              if(note != ""){
                activityLevelDataList[0].notes = note;
                Debug.printLog("notes days....$note");
              }
            }

            var allSelectedServersUrl = Utils.getServerListPreference().where((
                element) => element.patientId != "" && element.isSelected)
                .toList();

            if (totalMinObjectId != "") {
              for (int i = 0; i < allSelectedServersUrl.length; i++) {
                var url = activityLevelDataList[0].serverDetailList;
                var totalMinServerData = url
                    .where((element) =>
                element.serverUrl == allSelectedServersUrl[i].url).toList();
                if (totalMinServerData.isEmpty) {
                  var serverDetail = ServerDetailDataTable();
                  serverDetail.serverUrl = allSelectedServersUrl[i].url;
                  serverDetail.patientId = allSelectedServersUrl[i].patientId;
                  serverDetail.patientName = "${allSelectedServersUrl[i]
                      .patientFName}${allSelectedServersUrl[i].patientLName}";
                  if (baseURL == allSelectedServersUrl[i].url) {
                    serverDetail.objectId = totalMinObjectId;
                  } else {
                    serverDetail.objectId = "";
                  }
                  activityLevelDataList[0].serverDetailList.add(
                      serverDetail);
                }
                else if (allSelectedServersUrl.isNotEmpty && activityLevelDataList[0].serverDetailList.isNotEmpty) {
                  var findIndex = totalMinServerData
                      .indexWhere((element) =>
                  element.serverUrl == allSelectedServersUrl[i].url)
                      .toInt();
                  if (baseURL == allSelectedServersUrl[i].url &&
                      findIndex >= 0) {
                    totalMinServerData[findIndex].objectId = totalMinObjectId;
                  }
                  activityLevelDataList[0].serverDetailList =
                      totalMinServerData;
                }
              }
              if (dataTypeOfActivity == Constant.hasMemberTypeTotalMin) {
                List<IdentifierTable> tempIdentifierList = [];
                for (int i = 0; i < identifierData.length; i++) {
                  var identifierDataTable = IdentifierTable();
                  identifierDataTable.url =
                      identifierData[i].system!.value.toString();
                  identifierDataTable.objectId =
                      identifierData[i].value.toString();
                  tempIdentifierList.add(identifierDataTable);
                }
                activityLevelDataList[0].identifierData = tempIdentifierList;
              }
            }

            if (modValueObjectId != "") {
              for (int i = 0; i < allSelectedServersUrl.length; i++) {
                var url = activityLevelDataList[0].serverDetailListModMin;
                var modMinServerData = url
                    .where((element) =>
                element.modServerUrl == allSelectedServersUrl[i].url).toList();
                if (modMinServerData.isEmpty) {
                  var serverDetail = ServerDetailDataModMinTable();
                  serverDetail.modServerUrl = allSelectedServersUrl[i].url;
                  serverDetail.modPatientId =
                      allSelectedServersUrl[i].patientId;
                  serverDetail.modPatientName = "${allSelectedServersUrl[i]
                      .patientFName}${allSelectedServersUrl[i].patientLName}";
                  if (baseURL == allSelectedServersUrl[i].url) {
                    serverDetail.modObjectId = modValueObjectId;
                  } else {
                    serverDetail.modObjectId = "";
                  }
                  activityLevelDataList[0].serverDetailListModMin.add(
                      serverDetail);
                }
                else if (allSelectedServersUrl.isNotEmpty && activityLevelDataList[0].serverDetailListModMin.isNotEmpty) {
                  var findIndex = modMinServerData
                      .indexWhere((element) =>
                  element.modServerUrl == allSelectedServersUrl[i].url)
                      .toInt();
                  if (baseURL == allSelectedServersUrl[i].url &&
                      modValueObjectId != "" && findIndex >= 0) {
                    modMinServerData[findIndex].modObjectId = modValueObjectId;
                  }
                  activityLevelDataList[0].serverDetailListModMin =
                      modMinServerData;
                }
              }
              if (dataTypeOfActivity == Constant.hasMemberTypeModMin) {
                List<IdentifierTable> tempIdentifierList = [];
                for (int i = 0; i < identifierData.length; i++) {
                  var identifierDataTable = IdentifierTable();
                  identifierDataTable.url =
                      identifierData[i].system!.value.toString();
                  identifierDataTable.objectId =
                      identifierData[i].value.toString();
                  tempIdentifierList.add(identifierDataTable);
                }
                activityLevelDataList[0].identifierDataModMin =
                    tempIdentifierList;
              }
            }

            if (vigValueObjectId != "") {
              for (int i = 0; i < allSelectedServersUrl.length; i++) {
                var url = activityLevelDataList[0].serverDetailListVigMin;
                var vigMinServerData = url
                    .where((element) =>
                element.vigServerUrl == allSelectedServersUrl[i].url).toList();
                if (vigMinServerData.isEmpty) {
                  var serverDetail = ServerDetailDataVigMinTable();
                  serverDetail.vigServerUrl = allSelectedServersUrl[i].url;
                  serverDetail.vigPatientId =
                      allSelectedServersUrl[i].patientId;
                  serverDetail.vigPatientName = "${allSelectedServersUrl[i]
                      .patientFName}${allSelectedServersUrl[i].patientLName}";
                  if (baseURL == allSelectedServersUrl[i].url) {
                    serverDetail.vigObjectId = vigValueObjectId;
                  } else {
                    serverDetail.vigObjectId = "";
                  }
                  activityLevelDataList[0].serverDetailListVigMin.add(
                      serverDetail);
                }
                else if (allSelectedServersUrl.isNotEmpty && activityLevelDataList[0].serverDetailListVigMin.isNotEmpty) {
                  var findIndex = vigMinServerData
                      .indexWhere((element) =>
                  element.vigServerUrl == allSelectedServersUrl[i].url)
                      .toInt();
                  if (baseURL == allSelectedServersUrl[i].url &&
                      findIndex >= 0) {
                    vigMinServerData[findIndex].vigObjectId = vigValueObjectId;
                  }
                  activityLevelDataList[0].serverDetailListVigMin =
                      vigMinServerData;
                }
              }
              if (dataTypeOfActivity == Constant.hasMemberTypeVigMin) {
                List<IdentifierTable> tempIdentifierList = [];
                for (int i = 0; i < identifierData.length; i++) {
                  var identifierDataTable = IdentifierTable();
                  identifierDataTable.url =
                      identifierData[i].system!.value.toString();
                  identifierDataTable.objectId =
                      identifierData[i].value.toString();
                  tempIdentifierList.add(identifierDataTable);
                }
                activityLevelDataList[0].identifierDataVigMin =
                    tempIdentifierList;
              }
            }

            if(caloriesObjectId != ""){
              var activityDatabaseData = getActivityListData();
              var caloriesData = activityDatabaseData
                  .where((element) =>
              element.type == Constant.typeDaysData &&
                  element.title == Constant.titleCalories &&
                  element.displayLabel == display  &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ??
                      DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityStartDate
                      ?? DateTime.now()) &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityEndDate
                          ?? DateTime.now()))
                  .toList();
              if(caloriesData.isNotEmpty){
                if(caloriesData[0].key != null){
                  caloriesData[0].activityStartDate =activityStartDate;
                  caloriesData[0].activityEndDate = activityEndDate;

                  if(calories != null){
                    caloriesData[0].total = calories;
                  }else {
                    caloriesData[0].total = null;
                  }
                  var allSelectedServersUrl = Utils.getServerListPreference().where((
                      element) => element.patientId != "" && element.isSelected).toList();

                  if(caloriesObjectId != "") {
                    for (int i = 0; i < allSelectedServersUrl.length; i++) {
                      var url = caloriesData[0].serverDetailList;
                      var caloriesServerData = url
                          .where((element) =>
                      element.serverUrl == allSelectedServersUrl[i].url).toList();
                      if (caloriesServerData.isEmpty) {
                        var serverDetail = ServerDetailDataTable();
                        serverDetail.serverUrl = allSelectedServersUrl[i].url;
                        serverDetail.patientId = allSelectedServersUrl[i].patientId;
                        serverDetail.patientName = "${allSelectedServersUrl[i]
                            .patientFName}${allSelectedServersUrl[i].patientLName}";
                        if (baseURL == allSelectedServersUrl[i].url) {
                          serverDetail.objectId = caloriesObjectId;
                        } else {
                          serverDetail.objectId = "";
                        }
                        caloriesData[0].serverDetailList.add(
                            serverDetail);
                      }
                      else if (allSelectedServersUrl.isNotEmpty && caloriesData[0].serverDetailList.isNotEmpty) {
                        var findIndex = caloriesServerData
                            .indexWhere((element) =>
                        element.serverUrl == allSelectedServersUrl[i].url)
                            .toInt();
                        if (baseURL == allSelectedServersUrl[i].url && findIndex >= 0) {
                          caloriesServerData[findIndex].objectId = caloriesObjectId;
                        }
                        caloriesData[0].serverDetailList =
                            caloriesServerData;
                      }
                    }
                  }
                  if(dataTypeOfActivity == Constant.hasMemberTypeCalories) {
                    List<IdentifierTable> tempIdentifierList = [];
                    for (int i = 0; i < identifierData.length; i++) {
                      var identifierDataTable = IdentifierTable();
                      identifierDataTable.url =
                          identifierData[i].system!.value.toString();
                      identifierDataTable.objectId = identifierData[i].value.toString();
                      tempIdentifierList.add(identifierDataTable);
                    }
                    caloriesData[0].identifierData = tempIdentifierList;
                  }
                  caloriesData[0].needExport = true;
                  caloriesData[0].isSync = true;
                  caloriesData[0].isFromAppleHealth = isAppleData;
                  await DataBaseHelper.shared.updateActivityData(
                      caloriesData[0]);
                }
              }
            }

            if(peakHeartRateObjectId != ""){
              var activityDatabaseData = getActivityListData();
              var peakHeartRateData = activityDatabaseData
                  .where((element) =>
              element.type == Constant.typeDaysData &&
                  element.title == Constant.titleHeartRatePeak &&
                  element.displayLabel == display  &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ??
                      DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityStartDate
                      ?? DateTime.now()) &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityEndDate
                          ?? DateTime.now()))
                  .toList();
              if(peakHeartRateData.isNotEmpty){
                if(peakHeartRateData[0].key != null){
                  peakHeartRateData[0].activityStartDate =activityStartDate;
                  peakHeartRateData[0].activityEndDate = activityEndDate;

                  if(peakHeartRate != null){
                    peakHeartRateData[0].total = peakHeartRate;
                  }else {
                    peakHeartRateData[0].total = null;
                  }
                  var allSelectedServersUrl = Utils.getServerListPreference().where((
                      element) => element.patientId != "" && element.isSelected).toList();

                  if(peakHeartRateObjectId != "") {
                    for (int i = 0; i < allSelectedServersUrl.length; i++) {
                      var url = peakHeartRateData[0].serverDetailList;
                      var peakHeartServerData = url
                          .where((element) =>
                      element.serverUrl == allSelectedServersUrl[i].url).toList();
                      if (peakHeartServerData.isEmpty) {
                        var serverDetail = ServerDetailDataTable();
                        serverDetail.serverUrl = allSelectedServersUrl[i].url;
                        serverDetail.patientId = allSelectedServersUrl[i].patientId;
                        serverDetail.patientName = "${allSelectedServersUrl[i]
                            .patientFName}${allSelectedServersUrl[i].patientLName}";
                        if (baseURL == allSelectedServersUrl[i].url) {
                          serverDetail.objectId = peakHeartRateObjectId;
                        } else {
                          serverDetail.objectId = "";
                        }
                        peakHeartRateData[0].serverDetailList.add(
                            serverDetail);
                      }
                      else if (allSelectedServersUrl.isNotEmpty && peakHeartRateData[0].serverDetailList.isNotEmpty) {
                        var findIndex = peakHeartServerData
                            .indexWhere((element) =>
                        element.serverUrl == allSelectedServersUrl[i].url)
                            .toInt();
                        if (baseURL == allSelectedServersUrl[i].url && findIndex >= 0) {
                          peakHeartServerData[findIndex].objectId = peakHeartRateObjectId;
                        }
                        peakHeartRateData[0].serverDetailList =
                            peakHeartServerData;
                      }
                    }
                  }
                  if(dataTypeOfActivity == Constant.hasMemberTypePeakHeartRate) {
                    List<IdentifierTable> tempIdentifierList = [];
                    for (int i = 0; i < identifierData.length; i++) {
                      var identifierDataTable = IdentifierTable();
                      identifierDataTable.url =
                          identifierData[i].system!.value.toString();
                      identifierDataTable.objectId = identifierData[i].value.toString();
                      tempIdentifierList.add(identifierDataTable);
                    }
                    peakHeartRateData[0].identifierData = tempIdentifierList;
                  }
                  peakHeartRateData[0].needExport = true;
                  peakHeartRateData[0].isSync = true;
                  peakHeartRateData[0].isFromAppleHealth = isAppleData;
                  await DataBaseHelper.shared.updateActivityData(
                      peakHeartRateData[0]);
                }
              }
            }

            if(stepsObjectId != ""){
              var activityDatabaseData = getActivityListData();
              var stepsListData = activityDatabaseData
                  .where((element) =>
              element.type == Constant.typeDaysData &&
                  element.title == Constant.titleSteps &&
                  element.displayLabel == display  &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ??
                      DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityStartDate
                      ?? DateTime.now()) &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityEndDate
                          ?? DateTime.now()))
                  .toList();
              if(stepsListData.isNotEmpty){
                if(stepsListData[0].key != null){
                  stepsListData[0].activityStartDate =activityStartDate;
                  stepsListData[0].activityEndDate = activityEndDate;

                  if(steps != null){
                    stepsListData[0].total = steps;
                  }else {
                    stepsListData[0].total = null;
                  }
                  var allSelectedServersUrl = Utils.getServerListPreference().where((
                      element) => element.patientId != "" && element.isSelected).toList();

                  if(stepsObjectId != "") {
                    for (int i = 0; i < allSelectedServersUrl.length; i++) {
                      var url = stepsListData[0].serverDetailList;
                      var stepsServerData = url
                          .where((element) =>
                      element.serverUrl == allSelectedServersUrl[i].url).toList();
                      if (stepsServerData.isEmpty) {
                        var serverDetail = ServerDetailDataTable();
                        serverDetail.serverUrl = allSelectedServersUrl[i].url;
                        serverDetail.patientId = allSelectedServersUrl[i].patientId;
                        serverDetail.patientName = "${allSelectedServersUrl[i]
                            .patientFName}${allSelectedServersUrl[i].patientLName}";
                        if (baseURL == allSelectedServersUrl[i].url) {
                          serverDetail.objectId = stepsObjectId;
                        } else {
                          serverDetail.objectId = "";
                        }
                        stepsListData[0].serverDetailList.add(
                            serverDetail);
                      }
                      else if (allSelectedServersUrl.isNotEmpty && stepsListData[0].serverDetailList.isNotEmpty) {
                        var findIndex = stepsServerData
                            .indexWhere((element) =>
                        element.serverUrl == allSelectedServersUrl[i].url)
                            .toInt();
                        if (baseURL == allSelectedServersUrl[i].url && findIndex >= 0) {
                          stepsServerData[findIndex].objectId = stepsObjectId;
                        }
                        stepsListData[0].serverDetailList =
                            stepsServerData;
                      }
                    }
                  }
                  if(dataTypeOfActivity == Constant.hasMemberTypeSteps) {
                    List<IdentifierTable> tempIdentifierList = [];
                    for (int i = 0; i < identifierData.length; i++) {
                      var identifierDataTable = IdentifierTable();
                      identifierDataTable.url =
                          identifierData[i].system!.value.toString();
                      identifierDataTable.objectId = identifierData[i].value.toString();
                      tempIdentifierList.add(identifierDataTable);
                    }
                    stepsListData[0].identifierData = tempIdentifierList;
                  }
                  stepsListData[0].isSync = true;
                  stepsListData[0].isFromAppleHealth = isAppleData;
                  await DataBaseHelper.shared.updateActivityData(
                      stepsListData[0]);
                }
              }
            }

            if(exObjectId != ""){
              var activityDatabaseData = getActivityListData();
              var exListData = activityDatabaseData
                  .where((element) =>
              element.type == Constant.typeDaysData &&
                  element.title == null && element.smileyType != null &&
                  element.displayLabel == display  &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ??
                      DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityStartDate
                      ?? DateTime.now()) &&
                  Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) ==
                      Utils.changeDateFormatBasedOnDBDate(activityLevelDataList[0].activityEndDate
                          ?? DateTime.now()))
                  .toList();
              if(exListData.isNotEmpty){
                if(exListData[0].key != null){
                  exListData[0].activityStartDate =activityStartDate;
                  exListData[0].activityEndDate = activityEndDate;

                  if(ex != null){
                    exListData[0].smileyType = ex.toInt();
                  }else {
                    exListData[0].smileyType = 0;
                  }
                  var allSelectedServersUrl = Utils.getServerListPreference().where((
                      element) => element.patientId != "" && element.isSelected).toList();

                  if(exObjectId != "") {
                    for (int i = 0; i < allSelectedServersUrl.length; i++) {
                      var url = exListData[0].serverDetailList;
                      var exServerData = url
                          .where((element) =>
                      element.serverUrl == allSelectedServersUrl[i].url).toList();
                      if (exServerData.isEmpty) {
                        var serverDetail = ServerDetailDataTable();
                        serverDetail.serverUrl = allSelectedServersUrl[i].url;
                        serverDetail.patientId = allSelectedServersUrl[i].patientId;
                        serverDetail.patientName = "${allSelectedServersUrl[i]
                            .patientFName}${allSelectedServersUrl[i].patientLName}";
                        if (baseURL == allSelectedServersUrl[i].url) {
                          serverDetail.objectId = exObjectId;
                        } else {
                          serverDetail.objectId = "";
                        }
                        exListData[0].serverDetailList.add(
                            serverDetail);
                      }
                      else if (allSelectedServersUrl.isNotEmpty && exListData[0].serverDetailList.isNotEmpty) {
                        var findIndex = exServerData
                            .indexWhere((element) =>
                        element.serverUrl == allSelectedServersUrl[i].url)
                            .toInt();
                        if (baseURL == allSelectedServersUrl[i].url && findIndex >= 0) {
                          exServerData[findIndex].objectId = exObjectId;
                        }
                        exListData[0].serverDetailList =
                            exServerData;
                      }
                    }
                  }
                  if(dataTypeOfActivity == Constant.hasMemberTypeEx) {
                    List<IdentifierTable> tempIdentifierList = [];
                    for (int i = 0; i < identifierData.length; i++) {
                      var identifierDataTable = IdentifierTable();
                      identifierDataTable.url =
                          identifierData[i].system!.value.toString();
                      identifierDataTable.objectId = identifierData[i].value.toString();
                      tempIdentifierList.add(identifierDataTable);
                    }
                    exListData[0].identifierData = tempIdentifierList;
                  }
                  exListData[0].isSync = true;
                  exListData[0].isFromAppleHealth = isAppleData;
                  await DataBaseHelper.shared.updateActivityData(
                      exListData[0]);
                }
              }
            }

            activityLevelDataList[0].activityStartDate = activityStartDate;
            activityLevelDataList[0].activityEndDate = activityEndDate;
            activityLevelDataList[0].isFromAppleHealth = isAppleData;
            activityLevelDataList[0].isSync = true;

            await DataBaseHelper.shared.updateActivityData(
                activityLevelDataList[0]);
          }
        }
      }
    }

    await insertUpdateDayLevelData(activityStartDate,calories ?? 0.0,activityTableDataList,
        totalValue!.toInt(),modValue!.toInt(),vigValue!.toInt(),steps ?? 0.0);
  }

  static insertSingleEntryStepsRestStrDaysEx(String display,DateTime activityStartDate,
      DateTime activityEndDate,String weekDate,double calories,double peakHeartRate,double steps ,dynamic ex,String baseURL,
      {String activityTypeObjectId = "",
        String parentObjectId = "",
        String modValueObjectId = "",
        String vigValueObjectId = "",
        String totalMinObjectId = "",
        String caloriesObjectId = "",
        String peakHeartRateObjectId = "",
        String stepsObjectId = "",
        String exObjectId = "",
        String note = "",bool isAppleData = false
      }) async {

    var insertingCaloriesData = ActivityTable();
    insertingCaloriesData.title = Constant.titleCalories;
    insertingCaloriesData.needExport = true;
    insertingCaloriesData.isSync = true;
    insertingCaloriesData.displayLabel = display;
    insertingCaloriesData.dateTime = activityStartDate;
    insertingCaloriesData.total = calories != 0.0 ?  calories : null;
    insertingCaloriesData.date =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            activityStartDate ?? DateTime.now());
    insertingCaloriesData.type = Constant.typeDaysData;
    insertingCaloriesData.activityStartDate = activityStartDate;
    insertingCaloriesData.activityEndDate = activityEndDate;
    insertingCaloriesData.weeksDate = weekDate;
    insertingCaloriesData.isFromAppleHealth = isAppleData;
    var connectedServerUrlCalories = Utils.getServerListPreference().where((
        element) => element.patientId != "" && element.isSelected)
        .toList();
    if (connectedServerUrlCalories.isNotEmpty) {
      for (int i = 0; i < connectedServerUrlCalories.length; i++) {
        var data = ServerDetailDataTable();
        data.dataSyncServerWise = false;
        // data.objectId = caloriesObjectId;
        if (baseURL == connectedServerUrlCalories[i].url) {
          data.objectId = caloriesObjectId;
        } else {
          data.objectId = "";
        }
        data.serverUrl = connectedServerUrlCalories[i].url;
        data.patientId = connectedServerUrlCalories[i].patientId;
        data.clientId = connectedServerUrlCalories[i].clientId;
        data.serverToken = connectedServerUrlCalories[i].authToken;
        data.patientName =
        "${connectedServerUrlCalories[i].patientFName}${connectedServerUrlCalories[i]
            .patientLName}";
        insertingCaloriesData.serverDetailList.add(data);
      }
    }
    await DataBaseHelper.shared.insertActivityData(insertingCaloriesData);


    ///Peak heart rate
    var insertingDataPeakHeartRate = ActivityTable();
    insertingDataPeakHeartRate.title = Constant.titleHeartRatePeak;
    insertingDataPeakHeartRate.needExport = true;
    insertingDataPeakHeartRate.isSync = true;
    insertingDataPeakHeartRate.displayLabel = display;
    insertingDataPeakHeartRate.dateTime = activityStartDate;
    insertingDataPeakHeartRate.total = peakHeartRate != 0.0 ?  peakHeartRate : null;
    insertingDataPeakHeartRate.date =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            activityStartDate ?? DateTime.now());
    insertingDataPeakHeartRate.type = Constant.typeDaysData;
    insertingDataPeakHeartRate.activityStartDate = activityStartDate;
    insertingDataPeakHeartRate.activityEndDate = activityEndDate;
    insertingDataPeakHeartRate.weeksDate = weekDate;
    var connectedServerUrlPeakHeartRate = Utils.getServerListPreference().where((
        element) => element.patientId != "" && element.isSelected)
        .toList();
    if (connectedServerUrlPeakHeartRate.isNotEmpty) {
      for (int i = 0; i < connectedServerUrlPeakHeartRate.length; i++) {
        var data = ServerDetailDataTable();
        data.dataSyncServerWise = false;
        // data.objectId = peakHeartRateObjectId;
        if (baseURL == connectedServerUrlPeakHeartRate[i].url) {
          data.objectId = peakHeartRateObjectId;
        } else {
          data.objectId = "";
        }
        data.serverUrl = connectedServerUrlPeakHeartRate[i].url;
        data.patientId = connectedServerUrlPeakHeartRate[i].patientId;
        data.clientId = connectedServerUrlPeakHeartRate[i].clientId;
        data.serverToken = connectedServerUrlPeakHeartRate[i].authToken;
        data.patientName =
        "${connectedServerUrlPeakHeartRate[i].patientFName}${connectedServerUrlPeakHeartRate[i]
            .patientLName}";
        insertingDataPeakHeartRate.serverDetailList.add(data);
      }
    }
    await DataBaseHelper.shared.insertActivityData(insertingDataPeakHeartRate);


    ///Rest
    var insertHeartRateRestData = ActivityTable();
    insertHeartRateRestData.title = Constant.titleHeartRateRest;
    insertHeartRateRestData.needExport = true;
    insertHeartRateRestData.isSync = true;
    insertHeartRateRestData.displayLabel = display;
    insertHeartRateRestData.dateTime = activityStartDate;
    insertHeartRateRestData.date =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            activityStartDate ?? DateTime.now());
    insertHeartRateRestData.total = null;
    insertHeartRateRestData.type = Constant.typeDaysData;
    insertHeartRateRestData.activityStartDate = activityStartDate;
    insertHeartRateRestData.activityEndDate = activityEndDate;
    insertHeartRateRestData.weeksDate = weekDate;
    insertHeartRateRestData.isFromAppleHealth = isAppleData;

    var connectedServerUrlRestHeartRate = Utils.getServerListPreference()
        .where((element) => element.patientId != "" && element.isSelected)
        .toList();
    if (connectedServerUrlRestHeartRate.isNotEmpty) {
      for (int i = 0; i < connectedServerUrlRestHeartRate.length; i++) {
        var data = ServerDetailDataTable();
        data.dataSyncServerWise = false;
        data.objectId = "";
        data.serverUrl = connectedServerUrlRestHeartRate[i].url;
        data.patientId = connectedServerUrlRestHeartRate[i].patientId;
        data.clientId = connectedServerUrlRestHeartRate[i].clientId;
        data.serverToken = connectedServerUrlRestHeartRate[i].authToken;
        data.patientName = "${connectedServerUrlRestHeartRate[i]
            .patientFName}${connectedServerUrlRestHeartRate[i]
            .patientLName}";
        insertHeartRateRestData.serverDetailList.add(data);
      }
    }
    await DataBaseHelper.shared.insertActivityData(
        insertHeartRateRestData);


    ///Days Str
    var insertingDataDaysStr = ActivityTable();
    insertingDataDaysStr.title = Constant.titleDaysStr;
    insertingDataDaysStr.needExport = true;
    insertingDataDaysStr.isSync = true;
    insertingDataDaysStr.displayLabel = display;
    insertingDataDaysStr.dateTime = activityStartDate;
    insertingDataDaysStr.date =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            activityStartDate ?? DateTime.now());
    insertingDataDaysStr.type = Constant.typeDaysData;
    insertingDataDaysStr.activityStartDate = activityStartDate;
    insertingDataDaysStr.activityEndDate = activityEndDate;
    insertingDataDaysStr.weeksDate = weekDate;
    insertingDataDaysStr.isFromAppleHealth = isAppleData;

    var connectedServerUrlDaysStr = Utils.getServerListPreference()
        .where((element) => element.patientId != "" && element.isSelected)
        .toList();
    if (connectedServerUrlDaysStr.isNotEmpty) {
      for (int i = 0; i < connectedServerUrlDaysStr.length; i++) {
        var data = ServerDetailDataTable();
        data.dataSyncServerWise = false;
        data.objectId = "";
        data.serverUrl = connectedServerUrlDaysStr[i].url;
        data.patientId = connectedServerUrlDaysStr[i].patientId;
        data.clientId = connectedServerUrlDaysStr[i].clientId;
        data.serverToken = connectedServerUrlDaysStr[i].authToken;
        data.patientName = "${connectedServerUrlDaysStr[i]
            .patientFName}${connectedServerUrlDaysStr[i]
            .patientLName}";
        insertingDataDaysStr.serverDetailList.add(data);
      }
    }
    await DataBaseHelper.shared.insertActivityData(insertingDataDaysStr);


    ///Steps
    var insertingDataSteps = ActivityTable();
    insertingDataSteps.title = Constant.titleSteps;
    insertingDataSteps.needExport = true;
    insertingDataSteps.isSync = true;
    insertingDataSteps.displayLabel = display;
    insertingDataSteps.dateTime = activityStartDate;
    insertingDataSteps.total = steps != 0.0 ?  steps : null;
    insertingDataSteps.date =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            activityStartDate ?? DateTime.now());
    insertingDataSteps.type = Constant.typeDaysData;
    insertingDataSteps.activityStartDate = activityStartDate;
    insertingDataSteps.activityEndDate = activityEndDate;
    insertingDataSteps.weeksDate = weekDate;
    insertingDataSteps.isFromAppleHealth = isAppleData;

    var connectedServerUrlSteps = Utils.getServerListPreference().where((
        element) => element.patientId != "" && element.isSelected)
        .toList();
    if (connectedServerUrlSteps.isNotEmpty) {
      for (int i = 0; i < connectedServerUrlSteps.length; i++) {
        var data = ServerDetailDataTable();
        data.dataSyncServerWise = false;
        if (baseURL == connectedServerUrlCalories[i].url) {
          data.objectId = stepsObjectId;
        } else {
          data.objectId = "";
        }
        data.serverUrl = connectedServerUrlSteps[i].url;
        data.patientId = connectedServerUrlSteps[i].patientId;
        data.clientId = connectedServerUrlSteps[i].clientId;
        data.serverToken = connectedServerUrlSteps[i].authToken;
        data.patientName = "${connectedServerUrlSteps[i]
            .patientFName}${connectedServerUrlSteps[i]
            .patientLName}";
        insertingDataSteps.serverDetailList.add(data);
      }
    }
    await DataBaseHelper.shared.insertActivityData(insertingDataSteps);


    ///ex
    var insertingDataEx = ActivityTable();
    insertingDataEx.title = null;
    if(ex != null){
      insertingDataEx.smileyType = int.parse(ex.toString()) ;
    }else{
      insertingDataEx.smileyType = Constant.defaultSmileyType;
    }
    insertingDataEx.date =
        DateFormat(Constant.commonDateFormatDdMmYyyy).format(
            activityStartDate ?? DateTime.now());
    insertingDataEx.dateTime = activityStartDate;
    insertingDataEx.displayLabel = display;
    insertingDataEx.type = Constant.typeDaysData;
    insertingDataEx.activityStartDate = activityStartDate;
    insertingDataEx.activityEndDate = activityEndDate;
    insertingDataEx.weeksDate = weekDate;
    insertingDataEx.isFromAppleHealth = isAppleData;

    var connectedServerUrlEx = Utils.getServerListPreference().where((
        element) => element.patientId != "" && element.isSelected)
        .toList();
    if (connectedServerUrlEx.isNotEmpty) {
      for (int i = 0; i < connectedServerUrlEx.length; i++) {
        var data = ServerDetailDataTable();
        data.dataSyncServerWise = false;
        if (baseURL == connectedServerUrlCalories[i].url) {
          data.objectId = exObjectId;
        } else {
          data.objectId = "";
        }
        data.serverUrl = connectedServerUrlEx[i].url;
        data.patientId = connectedServerUrlEx[i].patientId;
        data.clientId = connectedServerUrlEx[i].clientId;
        data.serverToken = connectedServerUrlEx[i].authToken;
        data.patientName =
        "${connectedServerUrlEx[i].patientFName}${connectedServerUrlEx[i]
            .patientLName}";
        insertingDataEx.serverDetailList.add(data);
      }
    }
    await DataBaseHelper.shared.insertActivityData(insertingDataEx);
  }

  static insertUpdateDayLevelData(DateTime dateTime,double? totalCalories,List<ActivityTable>
  allDataFromDB, int? totalMin,int? modMin,int? vigMin,double? steps)async{


    List<ActivityTable> activityDataListFor = Hive.box<ActivityTable>(Constant.tableActivity)
        .values.toList().where((element) => element.type == Constant.typeDaysData
        && element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)).toList();


    var activityMinData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDay &&
        element.title == null && element.smileyType == null).toList();

    if(activityMinData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.smileyType = null;

      insertingData.dateTime = dateTime;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);


      if(totalMin != null || (totalMin ?? 0) > 0) {
        insertingData.total = totalMin?.toDouble();
      }

      if(modMin != null || (modMin ?? 0) > 0) {
        insertingData.value1 = modMin?.toDouble();
      }

      if(vigMin != null || (vigMin ?? 0) > 0) {
        insertingData.value2 = vigMin?.toDouble();
      }


      insertingData.type = Constant.typeDay;
      insertingData.isSync = true;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      // var connectedServerUrl = Utils.getServerListPreference();
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);


          var dataMod = ServerDetailDataModMinTable();
          dataMod.modServerUrl = connectedServerUrl[i].url;
          dataMod.modPatientId = connectedServerUrl[i].patientId;
          dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          dataMod.modObjectId = "";
          dataMod.modServerToken = connectedServerUrl[i].authToken;
          dataMod.modClientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailListModMin.add(dataMod);

          var dataVig = ServerDetailDataVigMinTable();
          dataVig.vigServerUrl = connectedServerUrl[i].url;
          dataVig.vigPatientId = connectedServerUrl[i].patientId;
          dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          dataVig.vigObjectId = "";
          dataVig.vigServerToken = connectedServerUrl[i].authToken;
          dataVig.vigClientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailListVigMin.add(dataVig);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      var modValue = 0.0;
      var vigValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == null && activityDataListFor[i].smileyType == null){
          totalValue += activityDataListFor[i].total ?? 0.0;
          modValue += activityDataListFor[i].value1 ?? 0.0;
          vigValue += activityDataListFor[i].value2 ?? 0.0;
        }
      }

      /*if(totalValue == 0.0){
        activityMinData[0].total = null;
      }else{
        activityMinData[0].total = totalValue;
      }

      if(modValue == 0.0){
        activityMinData[0].value1 = null;
      }else{
        activityMinData[0].value1 = modValue;
      }

      if(vigValue == 0.0){
        activityMinData[0].value2 = null;
      }else{
        activityMinData[0].value2 = vigValue;
      }*/

      if(totalValue != 0.0){
        activityMinData[0].total = totalValue;
      }

      if(modValue != 0.0){
        activityMinData[0].value1 = modValue;
      }

      if(vigValue != 0.0){
        activityMinData[0].value2 = vigValue;
      }
      var allSelectedServersUrl = Utils.getServerListPreference().where((element) =>
      element.patientId != "" && element.isSelected).toList();

      if(activityMinData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            activityMinData[0].serverDetailList.add(serverDetail);
          }
        }
      }

      if (activityMinData[0].serverDetailListModMin.length != allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailListModMin;
          if (url.where((element) => element.modServerUrl == allSelectedServersUrl[i].url).toList().isEmpty) {
            var serverDetail = ServerDetailDataModMinTable();
            serverDetail.modServerUrl = allSelectedServersUrl[i].url;
            serverDetail.modPatientId = allSelectedServersUrl[i].patientId;
            serverDetail.modPatientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.modObjectId = "";
            activityMinData[0].serverDetailListModMin.add(serverDetail);
          }
        }
      }

      if (activityMinData[0].serverDetailListVigMin.length != allSelectedServersUrl.length) {
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = activityMinData[0].serverDetailListVigMin;
          if (url.where((element) => element.vigServerUrl == allSelectedServersUrl[i].url).toList().isEmpty) {
            var serverDetail = ServerDetailDataVigMinTable();
            serverDetail.vigServerUrl = allSelectedServersUrl[i].url;
            serverDetail.vigPatientId = allSelectedServersUrl[i].patientId;
            serverDetail.vigPatientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.vigObjectId = "";
            activityMinData[0].serverDetailListVigMin.add(serverDetail);
          }
        }
      }

      activityMinData[0].isSync = true;
      activityMinData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(activityMinData[0]);

    }

    List<ActivityTable> caloriesDayData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleCalories).toList();
    if(caloriesDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;

      insertingData.dateTime = dateTime;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);


      if(totalCalories != null || (totalCalories ?? 0.0) > 0.0) {
        insertingData.total = totalCalories;
      }

      insertingData.type = Constant.typeDay;
      insertingData.isSync = true;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      // var connectedServerUrl = Utils.getServerListPreference();
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == Constant.titleCalories){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      if(totalValue != 0.0){
        caloriesDayData[0].total = totalValue;
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(caloriesDayData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = caloriesDayData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            caloriesDayData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      caloriesDayData[0].isSync = true;
      caloriesDayData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(caloriesDayData[0]);

    }

    ///Steps
    List<ActivityTable> stepsData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleSteps).toList();
    if(stepsData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleSteps;

      insertingData.dateTime = dateTime;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);


      if(steps != null || (steps ?? 0.0) > 0.0) {
        insertingData.total = steps;
      }

      insertingData.type = Constant.typeDay;
      insertingData.isSync = true;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      // var connectedServerUrl = Utils.getServerListPreference();
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < activityDataListFor.length; i++) {
        if(activityDataListFor[i].title == Constant.titleSteps){
          totalValue += activityDataListFor[i].total ?? 0.0;
        }
      }

      if(totalValue != 0.0){
        stepsData[0].total = totalValue;
      }
      stepsData[0].isSync = true;

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(stepsData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = stepsData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            stepsData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      await DataBaseHelper.shared.updateActivityData(stepsData[0]);

    }

    List<ActivityTable> heartRatePeakDayDataActivityData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDaysData &&
        element.title == Constant.titleHeartRatePeak).toList();
    List<int> tempIntList = [];
    for( int i = 0;i<heartRatePeakDayDataActivityData.length;i++){
      if(heartRatePeakDayDataActivityData[i].total != 0) {
        if(heartRatePeakDayDataActivityData[i].total != null) {
          tempIntList.add(heartRatePeakDayDataActivityData[i].total?.toInt() ?? 0);
        }
      }
    }
    var min = 0;
    var max = 0;
    if(tempIntList.isNotEmpty) {
      min = tempIntList.reduce((a, b) => a < b ? a : b);
      max = tempIntList.reduce((a, b) => a > b ? a : b);
      Debug.printLog("heartRatePeakDayDatal .... title 6...$min $max");
    }
    List<ActivityTable> heartRatePeakDayData = allDataFromDB.where((element) =>
    element.date == DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime)
        && element.type == Constant.typeDay &&
        element.title == Constant.titleHeartRatePeak).toList();
    if(heartRatePeakDayData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRatePeak;

      insertingData.dateTime = dateTime;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);


      if((max) > 0.0) {
        insertingData.total = max.toDouble();
      }

      insertingData.type = Constant.typeDay;
      insertingData.isSync = true;

      String selectedWeekStartDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
      String selectedWeekEndDate =
      DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

      insertingData.weeksDate = "$selectedWeekStartDate-$selectedWeekEndDate";
      insertingData.needExport = true;
      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var serverDetail = ServerDetailDataTable();
          serverDetail.serverUrl = connectedServerUrl[i].url;
          serverDetail.patientId = connectedServerUrl[i].patientId;
          serverDetail.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i].patientLName}";
          serverDetail.objectId = "";
          serverDetail.serverToken = connectedServerUrl[i].authToken;
          serverDetail.clientId = connectedServerUrl[i].clientId;
          insertingData.serverDetailList.add(serverDetail);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else if(heartRatePeakDayData.isNotEmpty){
      if(max != 0.0){
        heartRatePeakDayData[0].total = max.toDouble();
      }

      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

      if(heartRatePeakDayData[0].serverDetailList.length != allSelectedServersUrl.length){
        for (int i = 0; i < allSelectedServersUrl.length; i++) {
          var url = heartRatePeakDayData[0].serverDetailList;
          if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = allSelectedServersUrl[i].url;
            serverDetail.patientId = allSelectedServersUrl[i].patientId;
            serverDetail.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
            serverDetail.objectId = "";
            heartRatePeakDayData[0].serverDetailList.add(serverDetail);
          }
        }
      }
      heartRatePeakDayData[0].isSync = true;
      heartRatePeakDayData[0].needExport = true;
      await DataBaseHelper.shared.updateActivityData(heartRatePeakDayData[0]);

    }

    String formattedDateStart =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findFirstDateOfTheWeekImport(dateTime));
    String formattedDateEnd =
    DateFormat(Constant.commonDateFormatDdMmYyyy).format(Utils.findLastDateOfTheWeekImport(dateTime));

    var weeksDate = "$formattedDateStart-$formattedDateEnd";
    await insertUpdateWeekLevel(dateTime,weeksDate,totalCalories,allDataFromDB,totalMin,modMin,vigMin,steps);
  }

  static insertUpdateWeekLevel(DateTime dateTime,String weekDate,double? totalCalories, List<ActivityTable> allDataFromDB,
      int? totalMin,int? modMin,int? vigMin,double? steps)async{

    List<ActivityTable> dailyDataList = Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where
      ((element) => element.type == Constant.typeDay
        && element.weeksDate == weekDate).toList();

    var activityMinWeeklyDataList = allDataFromDB
        .where((element) =>
    element.weeksDate ==  weekDate &&
        element.type == Constant.typeWeek && element.title == null && element.smileyType == null)
        .toList();
    if(activityMinWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = null;
      insertingData.smileyType = null;

      if(totalMin != null || (totalMin ?? 0) > 0) {
        insertingData.total = totalMin?.toDouble();
      }

      if(modMin != null || (modMin ?? 0) > 0) {
        insertingData.value1 = modMin?.toDouble();
      }

      if(vigMin != null || (vigMin ?? 0) > 0) {
        insertingData.value2 = vigMin?.toDouble();
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      var modValue = 0.0;
      var vigValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if(dailyDataList[i].title == null && dailyDataList[i].smileyType == null){
          totalValue += dailyDataList[i].total ?? 0.0;
          modValue += dailyDataList[i].value1 ?? 0.0;
          vigValue += dailyDataList[i].value2 ?? 0.0;
        }
      }
      /*if(totalValue == 0.0){
        activityMinWeeklyDataList[0].total = null;
      }else{
        activityMinWeeklyDataList[0].total = totalValue;
      }

      if(modValue == 0.0){
        activityMinWeeklyDataList[0].value1 = null;
      }else{
        activityMinWeeklyDataList[0].value1 = modValue;
      }

      if(vigValue == 0.0){
        activityMinWeeklyDataList[0].value2 = null;
      }else{
        activityMinWeeklyDataList[0].value2 = vigValue;
      }*/
      Debug.printLog("Total weekly....$totalValue $weekDate");
      if(totalValue != 0.0){
        activityMinWeeklyDataList[0].total = totalValue;
      }

      Debug.printLog("Mod weekly....$totalValue $weekDate");
      if(modValue != 0.0){
        activityMinWeeklyDataList[0].value1 = modValue;
      }

      Debug.printLog("Vig weekly....$totalValue $weekDate");
      if(vigValue != 0.0){
        activityMinWeeklyDataList[0].value2 = vigValue;
      }

      activityMinWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(activityMinWeeklyDataList[0]);
    }

    var caloriesWeeklyDataList = allDataFromDB
        .where((element) =>
    element.weeksDate ==  weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleCalories)
        .toList();
    if(caloriesWeeklyDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;

      if(totalCalories != null || (totalCalories ?? 0.0) > 0.0) {
        insertingData.total = totalCalories;
      }
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate ;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }
    else{
      var totalValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if(dailyDataList[i].title == Constant.titleCalories){
          totalValue += dailyDataList[i].total ?? 0.0;
        }
      }
      /*if(totalValue == 0.0){
        caloriesWeeklyDataList[0].total = null;
      }else{
        caloriesWeeklyDataList[0].total = totalValue;
      }*/
      Debug.printLog("Calories weekly....$totalValue $weekDate");
      if(totalValue != 0.0){
        caloriesWeeklyDataList[0].total = totalValue;
      }

      caloriesWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(caloriesWeeklyDataList[0]);
    }

    ///Steps
    var stepsWeeklyDataList = allDataFromDB
        .where((element) =>
    element.weeksDate ==  weekDate &&
        element.type == Constant.typeWeek && element.title == Constant.titleSteps)
        .toList();

    if (stepsWeeklyDataList.isEmpty) {
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleSteps;

      if (steps != null || (steps ?? 0.0) > 0.0) {
        insertingData.total = steps;
      }
      insertingData.date =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(dateTime);
      insertingData.type = Constant.typeWeek;
      insertingData.weeksDate = weekDate;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    } else {
      var totalValue = 0.0;
      for (int i = 0; i < dailyDataList.length; i++) {
        if (dailyDataList[i].title == Constant.titleCalories) {
          totalValue += dailyDataList[i].total ?? 0.0;
        }
      }
      /*if(totalValue == 0.0){
        caloriesWeeklyDataList[0].total = null;
      }else{
        caloriesWeeklyDataList[0].total = totalValue;
      }*/

      if (totalValue != 0.0) {
        stepsWeeklyDataList[0].total = totalValue;
      }

      stepsWeeklyDataList[0].isSync = false;
      await DataBaseHelper.shared.updateActivityData(stepsWeeklyDataList[0]);
    }

  }

  static singleEntryStepsRestStrDaysEx(String display,DateTime activityStartDate,DateTime activityEndDate,String weekDate, bool isAppleData,dynamic exCode) async {
    var activityTableDataList = getActivityListData();


    ///Mod, Vig and Total min(Activity min)
    var activityLevelDataList = activityTableDataList.where((element) =>
    element.type == Constant.typeDaysData && element.title == null && element.smileyType == null
        && element.displayLabel == display  && Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) ).toList();
    if(activityLevelDataList.isEmpty ){
      var insertingData = ActivityTable();
      insertingData.isOverride = true;
      insertingData.displayLabel = display;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.title = null;
      insertingData.smileyType = null;
      insertingData.isSync = true;
      List<WorkOutData> getIconPathFromName = Utils.iconSetList().where((element) => element.workOutDataName.toLowerCase() == display.toLowerCase()).toList();

      if(getIconPathFromName.isNotEmpty) {
        insertingData.iconPath = getIconPathFromName[0].workOutDataImages;
      }else{
        insertingData.iconPath = Constant.activityImagesOther;
      }
      insertingData.type = Constant.typeDaysData;

      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);

          var dataMod = ServerDetailDataModMinTable();
          dataMod.modDataSyncServerWise = false;
          dataMod.modObjectId = "";
          dataMod.modServerUrl = connectedServerUrl[i].url;
          dataMod.modPatientId = connectedServerUrl[i].patientId;
          dataMod.modClientId = connectedServerUrl[i].clientId;
          dataMod.modServerToken = connectedServerUrl[i].authToken;
          dataMod.modPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailListModMin.add(dataMod);

          var dataVig = ServerDetailDataVigMinTable();
          dataVig.vigDataSyncServerWise = false;
          dataVig.vigObjectId = "";
          dataVig.vigServerUrl = connectedServerUrl[i].url;
          dataVig.vigPatientId = connectedServerUrl[i].patientId;
          dataVig.vigClientId = connectedServerUrl[i].clientId;
          dataVig.vigServerToken = connectedServerUrl[i].authToken;
          dataVig.vigPatientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailListVigMin.add(dataVig);
        }
      }

      insertingData.weeksDate = weekDate;
      await DataBaseHelper.shared.insertActivityData(insertingData);
    }


    ///Calories
    var caloriesDataList = activityTableDataList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == Constant.titleCalories &&
        element.displayLabel == display  &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) )
        .toList();
    if(caloriesDataList.isEmpty ){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleCalories;
      insertingData.needExport = true;
      insertingData.displayLabel = display;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.type = Constant.typeDaysData;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.weeksDate = weekDate;
      insertingData.isSync = true;

      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }


    ///Peak heart rate
    var peakHeartRateDataList = activityTableDataList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == Constant.titleHeartRatePeak &&
        element.displayLabel == display  &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) )
        .toList();
    if(peakHeartRateDataList.isEmpty){
      var insertingData = ActivityTable();
      insertingData.title = Constant.titleHeartRatePeak;
      insertingData.needExport = true;
      insertingData.isSync = true;
      insertingData.displayLabel = display;
      insertingData.dateTime = activityStartDate;
      insertingData.date = DateFormat(Constant.commonDateFormatDdMmYyyy).format(activityStartDate ?? DateTime.now());
      insertingData.type = Constant.typeDaysData;
      insertingData.activityStartDate = activityStartDate;
      insertingData.activityEndDate = activityEndDate;
      insertingData.weeksDate = weekDate;

      var connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
      if(connectedServerUrl.isNotEmpty) {
        for (int i = 0; i < connectedServerUrl.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrl[i].url;
          data.patientId = connectedServerUrl[i].patientId;
          data.clientId = connectedServerUrl[i].clientId;
          data.serverToken = connectedServerUrl[i].authToken;
          data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
              .patientLName}";
          insertingData.serverDetailList.add(data);
        }
      }

      await DataBaseHelper.shared.insertActivityData(insertingData);
    }

    ///Heart rate rest
    var restingHeartRateListData = activityTableDataList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == Constant.titleHeartRateRest &&
        element.displayLabel == display  &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate))
        .toList();
    if(restingHeartRateListData.isEmpty) {
      var insertHeartRateRestData = ActivityTable();
      insertHeartRateRestData.title = Constant.titleHeartRateRest;
      insertHeartRateRestData.isSync = true;
      insertHeartRateRestData.needExport = true;
      insertHeartRateRestData.displayLabel = display;
      insertHeartRateRestData.dateTime = activityStartDate;
      insertHeartRateRestData.date =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(
              activityStartDate ?? DateTime.now());
      insertHeartRateRestData.total = null;
      insertHeartRateRestData.type = Constant.typeDaysData;
      insertHeartRateRestData.activityStartDate = activityStartDate;
      insertHeartRateRestData.activityEndDate = activityEndDate;
      insertHeartRateRestData.weeksDate = weekDate;
      var connectedServerUrlRestHeartRate = Utils.getServerListPreference()
          .where((element) => element.patientId != "" && element.isSelected)
          .toList();
      if (connectedServerUrlRestHeartRate.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlRestHeartRate.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlRestHeartRate[i].url;
          data.patientId = connectedServerUrlRestHeartRate[i].patientId;
          data.clientId = connectedServerUrlRestHeartRate[i].clientId;
          data.serverToken = connectedServerUrlRestHeartRate[i].authToken;
          data.patientName = "${connectedServerUrlRestHeartRate[i]
              .patientFName}${connectedServerUrlRestHeartRate[i]
              .patientLName}";
          insertHeartRateRestData.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertHeartRateRestData);
    }

    ///Days Str
    var daysStrDataList = activityTableDataList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == Constant.titleDaysStr &&
        element.displayLabel == display  &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) )
        .toList();
    if(daysStrDataList.isEmpty) {
      var insertingDataDaysStr = ActivityTable();
      insertingDataDaysStr.title = Constant.titleDaysStr;
      insertingDataDaysStr.needExport = true;
      insertingDataDaysStr.isSync = true;
      insertingDataDaysStr.displayLabel = display;
      insertingDataDaysStr.dateTime = activityStartDate;
      insertingDataDaysStr.date =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(
              activityStartDate ?? DateTime.now());
      insertingDataDaysStr.type = Constant.typeDaysData;
      insertingDataDaysStr.activityStartDate = activityStartDate;
      insertingDataDaysStr.activityEndDate = activityEndDate;
      insertingDataDaysStr.weeksDate = weekDate;
      var connectedServerUrlDaysStr = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlDaysStr.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlDaysStr.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlDaysStr[i].url;
          data.patientId = connectedServerUrlDaysStr[i].patientId;
          data.clientId = connectedServerUrlDaysStr[i].clientId;
          data.serverToken = connectedServerUrlDaysStr[i].authToken;
          data.patientName = "${connectedServerUrlDaysStr[i]
              .patientFName}${connectedServerUrlDaysStr[i]
              .patientLName}";
          insertingDataDaysStr.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingDataDaysStr);
    }

    ///Steps
    var stepsDataList = activityTableDataList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == Constant.titleSteps &&
        element.displayLabel == display  &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) )
        .toList();
    if(stepsDataList.isEmpty) {
      var insertingDataSteps = ActivityTable();
      insertingDataSteps.title = Constant.titleSteps;
      insertingDataSteps.needExport = true;
      insertingDataSteps.isSync = true;
      insertingDataSteps.displayLabel = display;
      insertingDataSteps.dateTime = activityStartDate;
      insertingDataSteps.date =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(
              activityStartDate ?? DateTime.now());
      insertingDataSteps.type = Constant.typeDaysData;
      insertingDataSteps.activityStartDate = activityStartDate;
      insertingDataSteps.activityEndDate = activityEndDate;
      insertingDataSteps.weeksDate = weekDate;
      var connectedServerUrlSteps = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlSteps.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlSteps.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlSteps[i].url;
          data.patientId = connectedServerUrlSteps[i].patientId;
          data.clientId = connectedServerUrlSteps[i].clientId;
          data.serverToken = connectedServerUrlSteps[i].authToken;
          data.patientName = "${connectedServerUrlSteps[i]
              .patientFName}${connectedServerUrlSteps[i]
              .patientLName}";
          insertingDataSteps.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingDataSteps);
    }


    ///smileyType
    var smileyDataList = activityTableDataList
        .where((element) =>
    element.type == Constant.typeDaysData &&
        element.title == null && element.smileyType != null && element.total == null &&
        element.displayLabel == display  &&  Utils.changeDateFormatBasedOnDBDate(element.activityStartDate ?? DateTime.now())== Utils.changeDateFormatBasedOnDBDate(activityStartDate) &&
        Utils.changeDateFormatBasedOnDBDate(element.activityEndDate ?? DateTime.now()) == Utils.changeDateFormatBasedOnDBDate(activityEndDate) )
        .toList();
    if(smileyDataList.isEmpty) {
      var insertingDataEx = ActivityTable();
      insertingDataEx.title = null;
      insertingDataEx.isSync = true;
      insertingDataEx.smileyType = (exCode != 0 && exCode != null && exCode != 0.0 )? exCode : Constant.defaultSmileyType;
      insertingDataEx.date =
          DateFormat(Constant.commonDateFormatDdMmYyyy).format(
              activityStartDate ?? DateTime.now());
      insertingDataEx.dateTime = activityStartDate;
      insertingDataEx.displayLabel = display;
      insertingDataEx.type = Constant.typeDaysData;
      insertingDataEx.activityStartDate = activityStartDate;
      insertingDataEx.activityEndDate = activityEndDate;
      insertingDataEx.weeksDate = weekDate;
      var connectedServerUrlEx = Utils.getServerListPreference().where((
          element) => element.patientId != "" && element.isSelected).toList();
      if (connectedServerUrlEx.isNotEmpty) {
        for (int i = 0; i < connectedServerUrlEx.length; i++) {
          var data = ServerDetailDataTable();
          data.dataSyncServerWise = false;
          data.objectId = "";
          data.serverUrl = connectedServerUrlEx[i].url;
          data.patientId = connectedServerUrlEx[i].patientId;
          data.clientId = connectedServerUrlEx[i].clientId;
          data.serverToken = connectedServerUrlEx[i].authToken;
          data.patientName =
          "${connectedServerUrlEx[i].patientFName}${connectedServerUrlEx[i]
              .patientLName}";
          insertingDataEx.serverDetailList.add(data);
        }
      }
      await DataBaseHelper.shared.insertActivityData(insertingDataEx);
    }
  }

  static insertHigherLevelOfDay(DateTime date, String titleName) async {
    ///Week level
    var startDateOfWeek = Utils.findFirstDateOfTheWeekImport(date);
    var lastDateOfWeek = Utils.findLastDateOfTheWeekImport(date);
    var selectedWeekStartDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(startDateOfWeek);
    var selectedWeekEndDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(lastDateOfWeek);

    var dataListHive = Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
    var weekDate =  "$selectedWeekStartDate-$selectedWeekEndDate";

    List<ActivityTable> dailyDataList = Hive.box<ActivityTable>(Constant.tableActivity)
        .values.toList().where((element) => element.type == Constant.typeDay
        && element.weeksDate == weekDate).toList();

    if(dailyDataList.isNotEmpty) {

      if(titleName == Constant.titleCalories){
        var caloriesWeeklyDataList = dataListHive
            .where((element) =>
        element.weeksDate == weekDate &&
            element.type == Constant.typeWeek &&
            element.title == Constant.titleCalories)
            .toList();
        if (caloriesWeeklyDataList.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.title = Constant.titleCalories;

          var totalValue = 0.0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleCalories) {
              totalValue += dailyDataList[i].total ?? 0.0;
            }
          }
          insertingData.total = totalValue;

          insertingData.date =
              DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
          insertingData.type = Constant.typeWeek;
          insertingData.weeksDate = weekDate;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
        else {
          var totalValue = 0.0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleCalories) {
              totalValue += dailyDataList[i].total ?? 0.0;
            }
          }
          caloriesWeeklyDataList[0].total = totalValue;

          caloriesWeeklyDataList[0].isSync = true;
          await DataBaseHelper.shared.updateActivityData(
              caloriesWeeklyDataList[0]);
        }
      }

      if(titleName == Constant.titleSteps){
        var stepsWeeklyDataList = dataListHive
            .where((element) =>
        element.weeksDate == weekDate &&
            element.type == Constant.typeWeek &&
            element.title == Constant.titleSteps)
            .toList();
        if (stepsWeeklyDataList.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.title = Constant.titleSteps;

          var totalValue = 0.0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleSteps) {
              totalValue += dailyDataList[i].total ?? 0.0;
            }
          }
          insertingData.total = totalValue;

          insertingData.date =
              DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
          insertingData.type = Constant.typeWeek;
          insertingData.weeksDate = weekDate;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
        else {
          var totalValue = 0.0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleSteps) {
              totalValue += dailyDataList[i].total ?? 0.0;
            }
          }
          stepsWeeklyDataList[0].total = totalValue;


          stepsWeeklyDataList[0].isSync = true;
          await DataBaseHelper.shared.updateActivityData(stepsWeeklyDataList[0]);
        }
      }

      if(titleName == Constant.titleHeartRateRest){
        var restHeartRateWeeklyDataList = dataListHive
            .where((element) =>
        element.weeksDate == weekDate &&
            element.type == Constant.typeWeek &&
            element.title == Constant.titleHeartRateRest)
            .toList();
        if (restHeartRateWeeklyDataList.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.title = Constant.titleHeartRateRest;

          List<int> tempIntList = [];
          var avgTotal = 0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleHeartRateRest &&
                dailyDataList[i].total != 0) {
              tempIntList.add((dailyDataList[i].total ?? 0).toInt());
              avgTotal += (dailyDataList[i].total ?? 0).toInt();
            }
          }
          if (tempIntList.isNotEmpty) {
            var totalFilledDataList = dailyDataList.where((element) =>
            element.total != 0 && element.title == Constant.titleHeartRateRest)
                .toList();
            if (totalFilledDataList.isNotEmpty) {
              avgTotal = avgTotal ~/ totalFilledDataList.length;
            }
          }
          insertingData.total = avgTotal.toDouble();

          insertingData.date =
              DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
          insertingData.type = Constant.typeWeek;
          insertingData.weeksDate = weekDate;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
        else {
          List<int> tempIntList = [];
          var avgTotal = 0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleHeartRateRest &&
                dailyDataList[i].total != 0) {
              tempIntList.add((dailyDataList[i].total ?? 0).toInt());
              avgTotal += (dailyDataList[i].total ?? 0).toInt();
            }
          }
          if (tempIntList.isNotEmpty) {
            var totalFilledDataList = dailyDataList.where((element) =>
            element.total != 0 && element.title == Constant.titleHeartRateRest)
                .toList();
            if (totalFilledDataList.isNotEmpty) {
              avgTotal = avgTotal ~/ totalFilledDataList.length;
            }
          }
          Debug.printLog("Week...restHeartRateWeeklyDataList....$avgTotal $date  $weekDate");
          restHeartRateWeeklyDataList[0].total = avgTotal.toDouble();


          restHeartRateWeeklyDataList[0].isSync = true;
          await DataBaseHelper.shared.updateActivityData(
              restHeartRateWeeklyDataList[0]);
        }
      }

      if(titleName == Constant.titleHeartRatePeak){
        var peakHeartRateWeeklyDataList = dataListHive
            .where((element) =>
        element.weeksDate == weekDate &&
            element.type == Constant.typeWeek &&
            element.title == Constant.titleHeartRatePeak)
            .toList();
        if (peakHeartRateWeeklyDataList.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.title = Constant.titleHeartRatePeak;

          List<int> tempIntList = [];
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleHeartRatePeak &&
                dailyDataList[i].total != 0) {
              tempIntList.add((dailyDataList[i].total ?? 0).toInt());
            }
          }
          var min = 0;
          var max = 0;
          if (tempIntList.isNotEmpty) {
            min = tempIntList.reduce((a, b) => a < b ? a : b);
            max = tempIntList.reduce((a, b) => a > b ? a : b);
          }

          insertingData.total = max.toDouble();
          insertingData.date =
              DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
          insertingData.type = Constant.typeWeek;
          insertingData.weeksDate = weekDate;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
        else {
          List<int> tempIntList = [];
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == Constant.titleHeartRatePeak &&
                dailyDataList[i].total != 0) {
              tempIntList.add((dailyDataList[i].total ?? 0).toInt());
            }
          }
          var min = 0;
          var max = 0;
          if (tempIntList.isNotEmpty) {
            min = tempIntList.reduce((a, b) => a < b ? a : b);
            max = tempIntList.reduce((a, b) => a > b ? a : b);
          }
          Debug.printLog("Week...peakHeartRateWeeklyDataList....$max $date $weekDate");
          peakHeartRateWeeklyDataList[0].total = max.toDouble();
          peakHeartRateWeeklyDataList[0].isSync = true;
          await DataBaseHelper.shared.updateActivityData(
              peakHeartRateWeeklyDataList[0]);
        }
      }

      if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay
          || titleName == Constant.vigMinPerDay){

        dailyDataList = Hive.box<ActivityTable>(Constant.tableActivity)
            .values.toList().where((element) => element.type == Constant.typeDay
            && element.weeksDate == weekDate && element.title == null && element.smileyType == null).toList();
        var stepsWeeklyDataList = dataListHive
            .where((element) =>
        element.weeksDate == weekDate &&
            element.type == Constant.typeWeek &&
            element.title == null && element.smileyType == null)
            .toList();
        if (stepsWeeklyDataList.isEmpty) {
          var insertingData = ActivityTable();
          insertingData.title = null;
          insertingData.smileyType = null;

          var totalValue = 0.0;
          var modValue = 0.0;
          var vigValue = 0.0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == null && dailyDataList[i].smileyType == null) {
              totalValue += dailyDataList[i].total ?? 0.0;
              modValue += dailyDataList[i].value1 ?? 0.0;
              vigValue += dailyDataList[i].value2 ?? 0.0;
            }
          }
          insertingData.total = totalValue;
          insertingData.value1 = modValue;
          insertingData.value2 = vigValue;

          insertingData.date =
              DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
          insertingData.type = Constant.typeWeek;
          insertingData.weeksDate = weekDate;
          await DataBaseHelper.shared.insertActivityData(insertingData);
        }
        else {
          var totalValue = 0.0;
          var modValue = 0.0;
          var vigValue = 0.0;
          for (int i = 0; i < dailyDataList.length; i++) {
            if (dailyDataList[i].title == null && dailyDataList[i].smileyType == null) {
              totalValue += dailyDataList[i].total ?? 0.0;
              modValue += dailyDataList[i].value1 ?? 0.0;
              vigValue += dailyDataList[i].value2 ?? 0.0;
            }
          }
          stepsWeeklyDataList[0].total = totalValue;
          stepsWeeklyDataList[0].value1 = modValue;
          stepsWeeklyDataList[0].value2 = vigValue;


          stepsWeeklyDataList[0].isSync = false;
          await DataBaseHelper.shared.updateActivityData(stepsWeeklyDataList[0]);
        }
      }

      if(titleName == Constant.titleDaysStr){
        var dailyDataList = Hive.box<ActivityTable>(Constant.tableActivity)
            .values.toList().where((element) => element.type == Constant.typeDay
            && element.weeksDate == weekDate && element.title == Constant.titleDaysStr && element.isCheckedDay != null && element.isCheckedDay == true).toList();
        if(dailyDataList.isNotEmpty){
          var totalSelectedBox = dailyDataList.length;
          var allDataFromDB = getActivityListData();
          var weekInsertedData = allDataFromDB
              .where((element) =>
          element.weeksDate == weekDate &&
              element.type == Constant.typeWeek && element.title == Constant.titleDaysStr)
              .toList();
          if(weekInsertedData.isEmpty){
            var insertingData = ActivityTable();
            insertingData.name = "";
            insertingData.date =
                DateFormat(Constant.commonDateFormatDdMmYyyy).format(date);
            insertingData.title = Constant.titleDaysStr;
            insertingData.total = totalSelectedBox.toDouble();
            insertingData.type = Constant.typeWeek;
            insertingData.dateTime = date;
            insertingData.weeksDate = weekDate;
            await DataBaseHelper.shared.insertActivityData(insertingData);
          }
          else{
            weekInsertedData[0].total = totalSelectedBox.toDouble();
            await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
          }
        }
      }
    }

  }

  static insertUpdateMonthlyData(
      int type,
      String display,
      String value,
      String code,
      String unit,
      String monthName,
      int year,
      DateTime startDate,
      DateTime endDate,String patientId,String objectId, List<Identifier> identifierData) async {

    var monthlyDataDbList = getMonthlyDataList();

    var foundedList = monthlyDataDbList.where((element) => element.monthName == monthName
        && element.year == year).toList();

    Debug.printLog("Type......$type");
    if(foundedList.isNotEmpty && value != "0.0"){

      // if (type == Constant.typeDayPerWeek) {
      //   foundedList[0].syncDayPerWeekServerWiseList = [];
      //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      // }
      // else if (type == Constant.typeAvgMin) {
      //   foundedList[0].syncAvgMinServerWiseList = [];
      //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      // }
      // else if (type == Constant.typeAvgMinPerWeek) {
      //   foundedList[0].syncAvgMinPerWeekServerWiseList = [];
      //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      // }
      // else if (type == Constant.typeStrength) {
      //   foundedList[0].syncStrengthServerWiseList = [];
      //   await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
      // }
      ///Update
      if (type == Constant.typeDayPerWeek) {
        foundedList[0].isSyncDayPerWeek = true;
        foundedList[0].isOverrideDayPerWeek = true;
        foundedList[0].dayPerWeekId = objectId;

        if(value == ""){
          foundedList[0].dayPerWeekValue  = null;
        }else{
          foundedList[0].dayPerWeekValue  = double.parse(value.toString());
        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        // for (int i = 0; i < allSelectedServersUrl.length; i++) {
        //   foundedList[0].syncDayPerWeekServerWiseList.add(true);
        // }

        // if(foundedList[0].serverDetailListDayPerWeek.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = foundedList[0].serverDetailListDayPerWeek;
            var compareUrl = "";
            if(url.isNotEmpty){
              compareUrl = url[0].serverUrl ?? "";
            }
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            if((compareUrl == "")?url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty:
            allSelectedServersUrl[i].url == compareUrl){
              var data = ServerDetailDataTable();
              data.serverUrl = allSelectedServersUrl[i].url;
              data.patientId = allSelectedServersUrl[i].patientId;
              data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              data.objectId = objectId;
              foundedList[0].serverDetailListDayPerWeek.clear();
              foundedList[0].serverDetailListDayPerWeek.add(data);
            }
          }
        // }
        List<IdentifierTable> tempDayPerWeekIdentifierData = [];

        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          tempDayPerWeekIdentifierData.add(identifierDataTable);
        }
        foundedList[0].dayPerWeekIdentifierData = tempDayPerWeekIdentifierData;

      }
      else if (type == Constant.typeAvgMin) {
        foundedList[0].isSyncAvgMin = true;
        foundedList[0].isOverrideAvgMin = true;
        foundedList[0].avgMinPerDayId = objectId;

        if(value == ""){
          foundedList[0].avgMinValue  = null;
        }else{
          foundedList[0].avgMinValue  = double.parse(value.toString());
        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = foundedList[0].serverDetailListAvgMin;
            var compareUrl = "";
            if(url.isNotEmpty){
              compareUrl = url[0].serverUrl ?? "";
            }
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            if((compareUrl == "")?url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty:
            allSelectedServersUrl[i].url == compareUrl){
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
              var data = ServerDetailDataTable();
              data.serverUrl = allSelectedServersUrl[i].url;
              data.patientId = allSelectedServersUrl[i].patientId;
              data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              data.objectId = objectId;
              foundedList[0].serverDetailListAvgMin.clear();
              foundedList[0].serverDetailListAvgMin.add(data);
            }
          }
        // }
        List<IdentifierTable> tempAvgMinIdentifierData = [];

        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          tempAvgMinIdentifierData.add(identifierDataTable);
        }
        foundedList[0].avgMinIdentifierData = tempAvgMinIdentifierData;

      }
      else if (type == Constant.typeAvgMinPerWeek) {
        foundedList[0].isSyncAvgMinPerWeek = true;
        foundedList[0].isOverrideAvgMinPerWeek = true;
        foundedList[0].avgPerWeekId = objectId;
        // foundedList[0].avgMInPerWeekValue  = double.parse(value.toString());
        if(value == ""){
          foundedList[0].avgMInPerWeekValue  = null;
        }else{
          foundedList[0].avgMInPerWeekValue  = double.parse(value.toString());
        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        // if(foundedList[0].serverDetailListAvgMinWeek.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = foundedList[0].serverDetailListAvgMinWeek;
            var compareUrl = "";
            if(url.isNotEmpty){
              compareUrl = url[0].serverUrl ?? "";
            }
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            if((compareUrl == "")?url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty:
            allSelectedServersUrl[i].url == compareUrl){
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
              var data = ServerDetailDataTable();
              data.serverUrl = allSelectedServersUrl[i].url;
              data.patientId = allSelectedServersUrl[i].patientId;
              data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              data.objectId = objectId;
              foundedList[0].serverDetailListAvgMinWeek.clear();
              foundedList[0].serverDetailListAvgMinWeek.add(data);
            }
          }
        // }
        List<IdentifierTable> tempAvgMinPerWeekIdentifierData = [];

        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          tempAvgMinPerWeekIdentifierData.add(identifierDataTable);
        }
        foundedList[0].avgMinPerWeekIdentifierData = tempAvgMinPerWeekIdentifierData;

      }
      else if (type == Constant.typeStrength) {
        foundedList[0].isSyncStrength = true;
        foundedList[0].isOverrideStrength = true;
        foundedList[0].strengthId = objectId;


        if(value == ""){
          foundedList[0].strengthValue  = null;
        }else{
          foundedList[0].strengthValue  = double.parse(value.toString());
        }
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        // if(foundedList[0].serverDetailListStrength.length != allSelectedServersUrl.length){
          for (int i = 0; i < allSelectedServersUrl.length; i++) {
            var url = foundedList[0].serverDetailListStrength;
            var compareUrl = "";
            if(url.isNotEmpty){
              compareUrl = url[0].serverUrl ?? "";
            }
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
            if((compareUrl == "")?url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty:
            allSelectedServersUrl[i].url == compareUrl){
            // if(url.where((element) => element.serverUrl == allSelectedServersUrl[i].url).toList().isEmpty){
              var data = ServerDetailDataTable();
              data.serverUrl = allSelectedServersUrl[i].url;
              data.patientId = allSelectedServersUrl[i].patientId;
              data.patientName = "${allSelectedServersUrl[i].patientFName}${allSelectedServersUrl[i].patientLName}";
              data.objectId = objectId;
              foundedList[0].serverDetailListStrength.clear();
              foundedList[0].serverDetailListStrength.add(data);
            }
          }
        // }
        List<IdentifierTable> tempStrengthIdentifierData = [];
        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
        }
        foundedList[0].strengthIdentifierData = tempStrengthIdentifierData;

      }

      await DataBaseHelper.shared.updateMonthlyData(foundedList[0]);
    }
    else if(value != "0.0"){
      ///Insert
      var newMonthlyData = MonthlyLogTableData();
      newMonthlyData.monthName = monthName;
      newMonthlyData.startDate = startDate;
      newMonthlyData.year = year;
      newMonthlyData.endDate = endDate;
      newMonthlyData.patientId = patientId;
      newMonthlyData.qrUrl = Utils.getAPIEndPoint();

      if (type == Constant.typeDayPerWeek) {
        newMonthlyData.isSyncDayPerWeek = true;
        newMonthlyData.isOverrideDayPerWeek = true;
        newMonthlyData.dayPerWeekId = objectId;
        if (newMonthlyData.dayPerWeekValue ==  0.0) {
          newMonthlyData.dayPerWeekValue = null;
        } else {
          newMonthlyData.dayPerWeekValue = double.parse(value.toString());
        }
        List<ServerModelJson> connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        if(connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            if(connectedServerUrl.where((element) => element.isPrimary && element.url == connectedServerUrl[i].url).toList().isNotEmpty){
              data.objectId = objectId;
            }else{
              data.objectId = "";
            }
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            newMonthlyData.serverDetailListDayPerWeek.add(data);
          }
        }
        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          newMonthlyData.dayPerWeekIdentifierData.add(identifierDataTable);
        }


      }
      else if (type == Constant.typeAvgMin) {
        newMonthlyData.isSyncAvgMin = true;
        newMonthlyData.isOverrideAvgMin = true;
        newMonthlyData.avgMinPerDayId = objectId;

        if (newMonthlyData.avgMinValue ==  0.0) {
          newMonthlyData.avgMinValue = null;
        } else {
          newMonthlyData.avgMinValue = double.parse(value.toString());
        }

        List<ServerModelJson> connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();

        // if(connectedServerUrl.isNotEmpty) {
        //   for (int i = 0; i < connectedServerUrl.length; i++) {
        //     newMonthlyData.syncAvgMinServerWiseList.add(true);
        //     newMonthlyData.objectIdAvgMinList.add(objectId);
        //     newMonthlyData.objectIdAvgMinList.add("");
        //     newMonthlyData.serverUrlAvgMinList.add(connectedServerUrl[i].url);
        //     newMonthlyData.patientIdAvgMinList.add(connectedServerUrl[i].patientId);
        //     newMonthlyData.clientIdAvgMinList.add(connectedServerUrl[i].clientId);
        //     newMonthlyData.patientNameAvgMinList.add(
        //         "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
        //             .patientLName}");
        //     newMonthlyData.serverTokenListAvgMinList.add(connectedServerUrl[i].authToken);
        //   }
        // }
        if(connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            if(connectedServerUrl.where((element) => element.isPrimary && element.url == connectedServerUrl[i].url).toList().isNotEmpty){
              data.objectId = objectId;
            }else{
              data.objectId = "";
            }
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            newMonthlyData.serverDetailListAvgMin.add(data);
          }
        }

        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          newMonthlyData.avgMinIdentifierData.add(identifierDataTable);
        }
      }
      else if (type == Constant.typeAvgMinPerWeek) {
        newMonthlyData.isSyncAvgMinPerWeek = true;
        newMonthlyData.isOverrideAvgMinPerWeek = true;
        newMonthlyData.avgPerWeekId = objectId;

        if (newMonthlyData.avgMInPerWeekValue != null) {
          newMonthlyData.avgMInPerWeekValue = null;
        } else {
          newMonthlyData.avgMInPerWeekValue = double.parse(value.toString());
        }

        List<ServerModelJson> connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        // if(connectedServerUrl.isNotEmpty) {
        //   for (int i = 0; i < connectedServerUrl.length; i++) {
        //     newMonthlyData.syncAvgMinPerWeekServerWiseList.add(true);
        //     newMonthlyData.objectIdAvgMinPerWeekList.add(objectId);
        //     newMonthlyData.objectIdAvgMinPerWeekList.add("");
        //     newMonthlyData.serverUrlAvgMinPerWeekList.add(connectedServerUrl[i].url);
        //     newMonthlyData.patientIdAvgMinPerWeekList.add(connectedServerUrl[i].patientId);
        //     newMonthlyData.clientIdAvgMinPerWeekList.add(connectedServerUrl[i].clientId);
        //     newMonthlyData.patientNameAvgMinPerWeekList.add(
        //         "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
        //             .patientLName}");
        //     newMonthlyData.serverTokenListAvgMinPerWeekList.add(connectedServerUrl[i].authToken);
        //   }
        // }

        if(connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            if(connectedServerUrl.where((element) => element.isPrimary && element.url == connectedServerUrl[i].url).toList().isNotEmpty){
              data.objectId = objectId;
            }else{
              data.objectId = "";
            }
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            newMonthlyData.serverDetailListAvgMinWeek.add(data);
          }
        }

        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          newMonthlyData.avgMinPerWeekIdentifierData.add(identifierDataTable);
        }

      }
      else if (type == Constant.typeStrength) {
        newMonthlyData.isSyncStrength = true;
        newMonthlyData.isOverrideStrength = true;
        newMonthlyData.strengthId = objectId;

        if (newMonthlyData.strengthValue != null) {
          newMonthlyData.strengthValue = null;
        } else {
          newMonthlyData.strengthValue = double.parse(value.toString());
        }

        List<ServerModelJson> connectedServerUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
        if(connectedServerUrl.isNotEmpty) {
          for (int i = 0; i < connectedServerUrl.length; i++) {
            var data = ServerDetailDataTable();
            data.serverUrl = connectedServerUrl[i].url;
            data.patientId = connectedServerUrl[i].patientId;
            data.clientId = connectedServerUrl[i].clientId;
            if(connectedServerUrl.where((element) => element.isPrimary && element.url == connectedServerUrl[i].url).toList().isNotEmpty){
              data.objectId = objectId;
            }else{
              data.objectId = "";
            }
            data.serverToken = connectedServerUrl[i].authToken;
            data.patientName = "${connectedServerUrl[i].patientFName}${connectedServerUrl[i]
                .patientLName}";
            newMonthlyData.serverDetailListStrength.add(data);
          }
        }

        for (int i = 0; i < identifierData.length; i++) {
          var identifierDataTable = IdentifierTable();
          identifierDataTable.url = identifierData[i].system!.value.toString();
          identifierDataTable.objectId = identifierData[i].value.toString();
          newMonthlyData.strengthIdentifierData.add(identifierDataTable);
        }
      }
      await DataBaseHelper.shared.insertMonthlyData(newMonthlyData);
    }

  }

  static List<ActivityTable> getActivityListData(){
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();
  }

/*  static List<ActivityTable> getActivityListData(){
    *//* return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList();*//*
    Debug.printLog("Total Data ...${Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.serverDetailList.where((element) => element.patientId == Utils.getPatientId()).toList().isNotEmpty).toList().length}");
    Debug.printLog("value");
    return Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.serverDetailList.where((element) => element.patientId == Utils.getPatientId()).toList().isNotEmpty).toList();
  }*/

  static insertUpdateCalStepHeartMinDays(String titleName,String value,DateTime date,String objectId,
      String patientName,String patientId,String url, List<Identifier> identifierData,String totalMinObjectId
      ,String modMinObjectId,String vigMinObjectId,{String notes = "",bool isOverride = false}) async {
    var allDataFromDB = getActivityListData();
    List<ActivityTable> weekInsertedData = [];
    String formattedDate = "";
    formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
        .format(date);

    if(titleName == Constant.experience){
      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDay && element.title == null
      && element.smileyType != null && element.total == null )
          .toList();
    }
    else if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay ||
        titleName == Constant.vigMinPerDay){
      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDay && element.title == null && element.smileyType == null)
          .toList();
    }else{
      weekInsertedData = allDataFromDB.where((element) =>
      element.date == formattedDate &&
          element.type == Constant.typeDay && element.title == titleName)
          .toList();
    }


    if(weekInsertedData.isEmpty){
      var insertingData = ActivityTable();
      insertingData.objectId = objectId;

      var selectedServer = Utils.getServerListPreference().where((element) => element.isSelected && element.patientId != "").toList();
      if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay ||
          titleName == Constant.vigMinPerDay){
        if(titleName == Constant.totalMinPerDay){
          insertingData.isOverride = isOverride;
        }
        for (int i = 0; i < selectedServer.length; i++) {
          if(selectedServer[i].url == url){
            var data = ServerDetailDataTable();
            data.objectId = totalMinObjectId;
            data.serverUrl = url;
            data.patientId = patientId;
            data.patientName = patientName;
            insertingData.serverDetailList.add(data);

            var dataMod = ServerDetailDataModMinTable();
            dataMod.modObjectId = modMinObjectId;
            dataMod.modServerUrl = url;
            dataMod.modPatientId = patientId;
            dataMod.modPatientName = patientName;
            insertingData.serverDetailListModMin.add(dataMod);

            var dataVig = ServerDetailDataVigMinTable();
            dataVig.vigObjectId = vigMinObjectId;
            dataVig.vigServerUrl = url;
            dataVig.vigPatientId = patientId;
            dataVig.vigPatientName = patientName;
            insertingData.serverDetailListVigMin.add(dataVig);
          }
          else{
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = selectedServer[i].url;
            serverDetail.patientId = selectedServer[i].patientId;
            serverDetail.patientName = "${selectedServer[i].patientFName}${selectedServer[i].patientLName}";
            serverDetail.objectId = "";
            insertingData.serverDetailList.add(serverDetail);

            var dataMod = ServerDetailDataModMinTable();
            dataMod.modServerUrl = selectedServer[i].url;
            dataMod.modPatientId = selectedServer[i].patientId;
            dataMod.modPatientName = "${selectedServer[i].patientFName}${selectedServer[i].patientLName}";
            dataMod.modObjectId = "";
            insertingData.serverDetailListModMin.add(dataMod);

            var dataVig = ServerDetailDataVigMinTable();
            dataVig.vigServerUrl =  selectedServer[i].url;
            dataVig.vigPatientId = selectedServer[i].patientId;
            dataVig.vigPatientName = "${selectedServer[i].patientFName}${selectedServer[i].patientLName}";
            dataVig.vigObjectId = "";
            insertingData.serverDetailListVigMin.add(dataVig);
          }

        }
      }
      else{
        for (int i = 0; i < selectedServer.length; i++) {
          if(selectedServer[i].url == url){

            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = url;
            serverDetail.patientId = patientId;
            serverDetail.patientName = patientName;
            serverDetail.objectId = objectId;
            insertingData.serverDetailList.add(serverDetail);
          }else{
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = selectedServer[i].url;
            serverDetail.patientId = selectedServer[i].patientId;
            serverDetail.patientName = "${selectedServer[i].patientFName}${selectedServer[i].patientLName}";
            serverDetail.objectId = "";
            insertingData.serverDetailList.add(serverDetail);
          }

        }
      }

      for (int i = 0; i < identifierData.length; i++) {
        var identifierDataTable = IdentifierTable();
        identifierDataTable.url = identifierData[i].system!.value.toString();
        identifierDataTable.objectId = identifierData[i].value.toString();
        if(identifierDataTable.objectId != "" && identifierDataTable.objectId != "null" &&
            identifierDataTable.objectId != "Null" && identifierDataTable.objectId != "NULL") {
          insertingData.identifierData.add(identifierDataTable);
        }
      }

      if(titleName == Constant.experience){
        insertingData.title = null;
      }else if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay ||
          titleName == Constant.vigMinPerDay){
        insertingData.title = null;
        insertingData.smileyType = null;
      }else{
        insertingData.title = titleName;
      }

      if(titleName == Constant.titleCalories){
        insertingData.isOverride = isOverride;
      }

      insertingData.date = formattedDate;
      insertingData.dateTime = date;
      insertingData.qrUrl = Utils.getAPIEndPoint();

      if(titleName == Constant.experience){
        if(value != ""){
          insertingData.smileyType = int.parse(value);
        }
      }else if(titleName == Constant.totalMinPerDay){
        if(value == "" || value == "0"){
          insertingData.total = null;
        }else{
          insertingData.total =  double.parse(value);
          Debug.printLog("totalMinPerDay....$value ${ double.parse(value)}");
        }
        if(notes != ""){
          insertingData.notes = notes;
          Debug.printLog("notes days....$notes");
        }
      }else if(titleName == Constant.modMinPerDay){
        if(value == "" || value == "0"){
          insertingData.value1 = null;
        }else{
          Debug.printLog("modMinPerDay....$value ${ double.parse(value)}");
          insertingData.value1 = double.parse(value);
        }
      }else if(titleName == Constant.vigMinPerDay){
        if(value == "" || value == "0"){
          insertingData.value2 = null;
        }else{
          Debug.printLog("vigMinPerDay....$value ${ double.parse(value)}");
          insertingData.value2 = double.parse(value);
        }
      }else if(titleName == Constant.titleDaysStr){
        if(value == "0.0" || value == "0"){
          insertingData.isCheckedDay = false;
        }else if(value == "1.0" || value == "1"){
          insertingData.isCheckedDay = true;
        }
      }else{
        if(value == "" || value == "0"){
          insertingData.total = null;
        }else{
          Debug.printLog("Value calories....$value ${ double.parse(value)}");
          insertingData.total = double.parse(value);
        }
      }

      insertingData.type = Constant.typeDay;
      insertingData.isSync = true;
      String formattedDateStart = "";
      String formattedDateEnd = "";


      var startDateOfWeek = Utils.findFirstDateOfTheWeekImport(date);
      var lastDateOfWeek = Utils.findLastDateOfTheWeekImport(date);
      formattedDateStart = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(startDateOfWeek);
      formattedDateEnd = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(lastDateOfWeek);

      insertingData.weeksDate = "$formattedDateStart-$formattedDateEnd";
      insertingData.needExport = false;
      if(titleName == Constant.experience && value != ""){
        await DataBaseHelper.shared.insertActivityData(insertingData);
      }else{
        await DataBaseHelper.shared.insertActivityData(insertingData);
      }
    }
    else{

      String formattedDate = "";
      formattedDate = DateFormat(Constant.commonDateFormatDdMmYyyy)
          .format(date);

      if(titleName == Constant.titleSteps) {
        Debug.printLog("value steps.....$value  ${weekInsertedData[0].key}");
      }

      if(titleName == Constant.experience){
        if(value != ""){
          weekInsertedData[0].smileyType = int.parse(value);
        }
      }else if(titleName == Constant.totalMinPerDay){
        if(value == "" || value == "0"){
          weekInsertedData[0].total = null;
        }else{
          Debug.printLog("totalMinPerDay update....$value ${ double.parse(value)}");
          weekInsertedData[0].total = double.parse(value);
        }
        if(notes != ""){
          weekInsertedData[0].notes = notes;
          Debug.printLog("notes days....$notes");
        }
          weekInsertedData[0].isOverride = isOverride;
      }else if(titleName == Constant.modMinPerDay){
        if(value == "" || value == "0"){
          weekInsertedData[0].value1 = null;
        }else{
          Debug.printLog("modMinPerDay update....$value ${ double.parse(value)}");
          weekInsertedData[0].value1 = double.parse(value);
        }
      }else if(titleName == Constant.vigMinPerDay){
        if(value == "" || value == "0"){
          weekInsertedData[0].value2 = null;
        }else{
          Debug.printLog("vigMinPerDay update....$value ${ double.parse(value)}");
          weekInsertedData[0].value2 = double.parse(value);
        }
      }else if(titleName == Constant.titleDaysStr){
        if(value == "0.0" || value == "0"){
          weekInsertedData[0].isCheckedDay = false;
        }else if(value == "1.0" || value == "1"){
          weekInsertedData[0].isCheckedDay = true;
        }
        Debug.printLog("isCheckedDay update...$value  ${weekInsertedData[0].isCheckedDay}");
      }else{
        if(value == "" || value == "0"){
          weekInsertedData[0].total = null;
        }else{
          weekInsertedData[0].total = double.parse(value);
        }
        Debug.printLog("Value calories update....$value ${ double.parse(value)}  $date");
      }

      if(titleName == Constant.titleCalories){
        weekInsertedData[0].isOverride = isOverride;
      }
      weekInsertedData[0].isSync = true;
      weekInsertedData[0].needExport = false;

      List<IdentifierTable> tempIdentifierList = [];
      for (int i = 0; i < identifierData.length; i++) {
        var identifierDataTable = IdentifierTable();
        identifierDataTable.url = identifierData[i].system!.value.toString();
        identifierDataTable.objectId = identifierData[i].value.toString();
        if(identifierDataTable.objectId != "" && identifierDataTable.objectId != "null" &&
            identifierDataTable.objectId != "Null" && identifierDataTable.objectId != "NULL") {
          tempIdentifierList.add(identifierDataTable);
        }
      }

      if(tempIdentifierList.isNotEmpty) {
        if (titleName == Constant.totalMinPerDay) {
          weekInsertedData[0].identifierData = tempIdentifierList;
        } else if (titleName == Constant.modMinPerDay) {
          weekInsertedData[0].identifierDataModMin = tempIdentifierList;
        } else if (titleName == Constant.vigMinPerDay) {
          weekInsertedData[0].identifierDataVigMin = tempIdentifierList;
        } else {
          weekInsertedData[0].identifierData = tempIdentifierList;
        }
      }

      List<ActivityTable> tempArray = [];
      if(titleName == Constant.experience){
        tempArray = allDataFromDB.where((element) =>
        element.date == formattedDate &&
            element.type == Constant.typeDay && element.title == null && element.smileyType != null &&  element.total == null &&
            element.serverDetailList.where((element) => element.serverUrl == url).toList().isEmpty &&
            element.serverDetailList.where((element) => element.objectId == objectId).toList().isEmpty )
            .toList();
      }
      else if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay ||
          titleName == Constant.vigMinPerDay){

        if(titleName == Constant.totalMinPerDay){
          tempArray = allDataFromDB.where((element) =>
          element.date == formattedDate &&
              element.type == Constant.typeDay && element.title == null && element.smileyType == null &&
              element.serverDetailList.where((element) => element.serverUrl == url).toList().isEmpty &&
              element.serverDetailList.where((element) => element.objectId == objectId).toList().isEmpty )
              .toList();

        }else if(titleName == Constant.modMinPerDay){
          tempArray = allDataFromDB.where((element) =>
          element.date == formattedDate &&
              element.type == Constant.typeDay && element.title == null && element.smileyType == null &&
              element.serverDetailListModMin.where((element) => element.modServerUrl == url).toList().isEmpty &&
              element.serverDetailListModMin.where((element) => element.modObjectId == objectId).toList().isEmpty )
              .toList();

        }else if(titleName == Constant.vigMinPerDay){
          tempArray = allDataFromDB.where((element) =>
          element.date == formattedDate &&
              element.type == Constant.typeDay && element.title == null && element.smileyType == null &&
              element.serverDetailListVigMin.where((element) => element.vigServerUrl == url).toList().isEmpty &&
              element.serverDetailListVigMin.where((element) => element.vigObjectId == objectId).toList().isEmpty )
              .toList();
        }


      }
      else{
        tempArray = allDataFromDB.where((element) =>
        element.date == formattedDate &&
            element.type == Constant.typeDay && element.title == titleName &&
            element.serverDetailList.where((element) => element.serverUrl == url).toList().isEmpty &&
            element.serverDetailList.where((element) => element.objectId == objectId).toList().isEmpty )
            .toList();
      }


      if(tempArray.isEmpty) {
        if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay ||
            titleName == Constant.vigMinPerDay){
          if(titleName == Constant.totalMinPerDay){
            if(weekInsertedData[0].serverDetailList.where((element) => element.serverUrl == url).toList().isEmpty &&
                weekInsertedData[0].serverDetailList.where((element) => element.objectId == objectId).toList().isEmpty){
              var serverDetail = ServerDetailDataTable();
              serverDetail.serverUrl = url;
              serverDetail.patientId = patientId;
              serverDetail.patientName = patientName;
              serverDetail.objectId = objectId;
              weekInsertedData[0].serverDetailList.add(serverDetail);
            }
          }
          else if(titleName == Constant.modMinPerDay){
            if(weekInsertedData[0].serverDetailListModMin.where((element) => element.modServerUrl == url).toList().isEmpty &&
                weekInsertedData[0].serverDetailListModMin.where((element) => element.modObjectId == objectId).toList().isEmpty){
              var serverDetail = ServerDetailDataModMinTable();
              serverDetail.modServerUrl = url;
              serverDetail.modPatientId = patientId;
              serverDetail.modPatientName = patientName;
              serverDetail.modObjectId = objectId;
              weekInsertedData[0].serverDetailListModMin.add(serverDetail);
            }
          }
          else if(titleName == Constant.vigMinPerDay){
            if(weekInsertedData[0].serverDetailListVigMin.where((element) => element.vigServerUrl == url).toList().isEmpty &&
                weekInsertedData[0].serverDetailListVigMin.where((element) => element.vigObjectId == objectId).toList().isEmpty){
              var serverDetail = ServerDetailDataVigMinTable();
              serverDetail.vigServerUrl = url;
              serverDetail.vigPatientId = patientId;
              serverDetail.vigPatientName = patientName;
              serverDetail.vigObjectId = objectId;
              weekInsertedData[0].serverDetailListVigMin.add(serverDetail);
            }
          }
        }
        else{
          if(weekInsertedData[0].serverDetailList.where((element) => element.serverUrl == url).toList().isEmpty &&
              weekInsertedData[0].serverDetailList.where((element) => element.objectId == objectId).toList().isEmpty){
            var serverDetail = ServerDetailDataTable();
            serverDetail.serverUrl = url;
            serverDetail.patientId = patientId;
            serverDetail.patientName = patientName;
            serverDetail.objectId = objectId;
            weekInsertedData[0].serverDetailList.add(serverDetail);
          }
        }

      }


      var selectedServer = Utils.getServerListPreference().where((element) => element.isSelected &&
          element.patientId != "" && element.isPrimary).toList();
      if(titleName == Constant.totalMinPerDay || titleName == Constant.modMinPerDay ||
          titleName == Constant.vigMinPerDay){
        if(titleName == Constant.totalMinPerDay){
          if(selectedServer.isNotEmpty && weekInsertedData[0].serverDetailList.isNotEmpty){
            var primaryDataIndex = weekInsertedData[0].serverDetailList.indexWhere((element) => element.serverUrl ==
                selectedServer[0].url  && element.patientId == selectedServer[0].patientId).toInt();
            // if(weekInsertedData[0].serverDetailList[primaryDataIndex].objectId == "") {
            if(primaryDataIndex != -1) {
              weekInsertedData[0].serverDetailList[primaryDataIndex].objectId =
                  objectId;
            }
          }
        }
        else if(titleName == Constant.modMinPerDay){
          if(selectedServer.isNotEmpty && weekInsertedData[0].serverDetailListModMin.isNotEmpty){
            var primaryDataIndex = weekInsertedData[0].serverDetailListModMin.indexWhere((element) =>
            element.modServerUrl ==
                selectedServer[0].url  && element.modPatientId == selectedServer[0].patientId).toInt();
            // if(weekInsertedData[0].serverDetailListModMin[primaryDataIndex].modObjectId == "") {
            if(primaryDataIndex != -1) {
              weekInsertedData[0].serverDetailListModMin[primaryDataIndex].modObjectId =
                  objectId;
            }
          }
        }
        else if(titleName == Constant.vigMinPerDay){
          if(selectedServer.isNotEmpty && weekInsertedData[0].serverDetailListVigMin.isNotEmpty){
            var primaryDataIndex = weekInsertedData[0].serverDetailListVigMin.indexWhere((element) =>
            element.vigServerUrl ==
                selectedServer[0].url  && element.vigPatientId == selectedServer[0].patientId).toInt();
            // if(weekInsertedData[0].serverDetailListVigMin[primaryDataIndex].vigObjectId == "") {
            if(primaryDataIndex != -1) {
              weekInsertedData[0].serverDetailListVigMin[primaryDataIndex].vigObjectId =
                  objectId;
            }
          }
        }
      }else{
      if(selectedServer.isNotEmpty && weekInsertedData[0].serverDetailList.isNotEmpty){
         var primaryDataIndex = weekInsertedData[0].serverDetailList.indexWhere((element) => element.serverUrl ==
             selectedServer[0].url  && element.patientId == selectedServer[0].patientId).toInt();
         // if(weekInsertedData[0].serverDetailList[primaryDataIndex].objectId == "") {
         if(primaryDataIndex != -1) {
           weekInsertedData[0].serverDetailList[primaryDataIndex].objectId =
               objectId;
           Debug.printLog("Calories ob id....$objectId");
         }
       }
      }

      if(titleName == Constant.experience && value != ""){
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }else{
        await DataBaseHelper.shared.updateActivityData(weekInsertedData[0]);
      }

    }

    await insertHigherLevelOfDay(date,titleName);
  }

  static List<MonthlyLogTableData> getMonthlyDataList(){
    return Hive
        .box<MonthlyLogTableData>(Constant.tableMonthlyLog)
        .values
        .toList().where((element) => element.patientId == Utils.getPatientId()).toList();
  }

  static setPermissionHealth(bool value){
    Preference.shared.setBool(Preference.healthPermission, value);
  }
  static bool getPermissionHealth(){
    return Preference.shared.getBool(Preference.healthPermission) ?? false;
  }

  static getPerformerDataList(ServerModelJson selectedUrlModel) async {
    Utils.performerList.clear();
    var performerData = await PaaProfiles.getPerformerList(selectedUrlModel);
    if (performerData.resourceType == R4ResourceType.Bundle && performerData.entry != null) {
      var totalLength = performerData.entry.length;
      /*if(performerData.total != null){
        totalLength = performerData.total.valueNumber.toInt();
      }else{
        totalLength = 20;
      }*/
      if (performerData != null) {
        for (int i = 0; i < totalLength; i++) {
          var data = performerData.entry[i];
          if(performerData.entry[i].resource.resourceType == R4ResourceType.Practitioner) {
            var id;
            if (data.resource.id != null) {
              id = data.resource.id.toString();
            }
            var performer = data.resource.name[0].family.toString();
            Debug.printLog("patient info....$performer  $id");
            var performerDataModel = PerformerData();
            performerDataModel.performerId = id;
            performerDataModel.performerName = performer;

            if (!Utils.performerList.contains(performerDataModel)) {
              Utils.performerList.add(performerDataModel);
            }
          }
        }
      }
    }
    Debug.printLog("performerLists....... ${Utils.performerList.toString()}");
  }

  static Map<String, String> getHeader(String token) {
    return (kIsWeb)
        ? ((token == "") ? {} : {
      "Authorization": "bearer $token",
      // "access-control-allow-origin": "https://testphysicalactivity.com",
      // "access-control-allow-methods": "get, post",
      'Content-Type': 'application/json',
      'Accept': '*/*'
    })
        : ((token == "")
        ? {}
        : {
      // "Authorization": "Bearer: $token",
      "authorization": "bearer $token",
      "access-control-allow-origin": "*",
      "access-control-allow-methods": "get, post",
      "access-control-allow-headers": "x-requested-with",
      'content-type': 'application/json',
      'accept': '*/*'
    });
  }


  static setMonthlyAndActivityData(String currentYear,
      {bool isFromMonth = false,bool isFromActivity = false,DateTime? startAfterDate,DateTime? beforeEndDate}) async {
    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSelected).toList();
    if(allSelectedServersUrl.isNotEmpty) {
      var primaryServerData = allSelectedServersUrl.where((element) => element.isPrimary).toList();
      if(primaryServerData.isNotEmpty) {
        await Utils.getSetMonthActivityData(
            Utils.getPatientId(),
            currentYear.toString(),
            Utils.getPatientFName(),
            Utils.getAPIEndPoint(),
            "",
            "",
            primaryServerData,
            isFromMonth: isFromMonth,
            isFromActivity: isFromActivity
            ,
            startAfterDate: startAfterDate,
            beforeEndDate: beforeEndDate);
      }
    }
  }

  static showDialogForProgress(BuildContext context,String title,String message) {
    if(kIsWeb){
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            backgroundColor: CColor.white,
            child:  LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return Container(
                  padding: EdgeInsets.only(
                      left: AppFontStyle.sizesWidthManageWeb(1.3,constraints),
                      top: AppFontStyle.sizesHeightManageWeb(2.0,constraints),
                      right: AppFontStyle.sizesWidthManageWeb(1.3,constraints),
                      bottom:AppFontStyle.sizesHeightManageWeb(2.0,constraints)),
                      // height: (kIsWeb) ? Sizes.height_9 :Get.height * 0.1,
                      child: Wrap(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // const CircularProgressIndicator(),
                              Container(
                                margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                                child: Text(
                                  title,
                                  style: AppFontStyle.styleW700(CColor.black,
                                      AppFontStyle.sizesFontManageWeb(1.5,constraints)),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                  right: Sizes.width_1
                                ),
                                child: Text(message,
                                    style:
                                    AppFontStyle.styleW400(CColor.black,
                                        AppFontStyle.sizesFontManageWeb(1.3,constraints))),
                              )

                            ],
                          ),
                        ],
                      ),
                    );
              }
            )

          );
        },
      );
    }else {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
            backgroundColor: CColor.white,
            content: Container(
              padding: EdgeInsets.only(
                  left: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_3
                  , top: (kIsWeb) ? Sizes.height_0_5 : Sizes.height_2
                  , bottom: (kIsWeb) ? Sizes.height_0_5 : Sizes.height_2),
              // height: (kIsWeb) ? Sizes.height_9 :Get.height * 0.1,
              child: Wrap(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const CircularProgressIndicator(),
                      Container(
                        margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                        child: Text(
                          title,
                          style: AppFontStyle.styleW700(CColor.black,
                              (kIsWeb) ? FontSize.size_6 : FontSize.size_12),
                        ),
                      ),
                      Text(message,
                          style:
                          AppFontStyle.styleW400(CColor.black,
                              (kIsWeb) ? FontSize.size_4 : FontSize.size_10))

                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    }
  }


  static SmartRefresher pullToRefreshApi(Widget widget ,
      RefreshController refreshController, onRefresh,onLoading){
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      reverse: false,
      physics: AlwaysScrollableScrollPhysics(),
      header: WaterDropMaterialHeader(
          backgroundColor:  CColor.primaryColor
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          }
          else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          }
          else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          }
          else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          }
          else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: widget,
    );
  }

  static SmartRefresher pullToRefreshApiWithOutScroll(Widget widget ,
      RefreshController refreshController, onRefresh,onLoading){
    return SmartRefresher(
      enablePullDown: true,
      enablePullUp: false,
      reverse: false,
      physics: NeverScrollableScrollPhysics(),
      header: WaterDropMaterialHeader(
          backgroundColor:  CColor.primaryColor
      ),
      footer: CustomFooter(
        builder: (BuildContext context, LoadStatus? mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("pull up load");
          }
          else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator();
          }
          else if (mode == LoadStatus.failed) {
            body = Text("Load Failed!Click retry!");
          }
          else if (mode == LoadStatus.canLoading) {
            body = Text("release to load more");
          }
          else {
            body = Text("No more Data");
          }
          return Container(
            height: 55.0,
            child: Center(child: body),
          );
        },
      ),
      controller: refreshController,
      onRefresh: onRefresh,
      onLoading: onLoading,
      child: widget,
    );
  }

  static TextInputType getInputTypeKeyboard(){
    return const TextInputType.numberWithOptions(decimal: true,signed: true);
  }

  static double sizesFontManage( BuildContext context,double value){
    // Debug.printLog("callsizesFontManage.............. ");
    double screenWidth = context.width;
    double scaleFactor;
    if(screenWidth > 2100){
      scaleFactor = 1.4;
      // Debug.printLog("2100");
    }else if (screenWidth > 1900) {
      scaleFactor = 1.45;
      // Debug.printLog("1900");
    } else if (screenWidth > 1700) {
      scaleFactor = 1.5;
      // Debug.printLog("1700");
    } else if (screenWidth > 1500) {
      scaleFactor = 1.6;
      // Debug.printLog("1500");
    } else if (screenWidth > 1300) {
      scaleFactor = 1.85;
      // Debug.printLog("1300");
    } else if (screenWidth > 1100) {
      scaleFactor = 1.8;
      // Debug.printLog("1100");
    } else if (screenWidth > 900) {
      scaleFactor = 2.2;
      // Debug.printLog("900");
    } else if (screenWidth > 700) {
      scaleFactor = 2.4;
      // Debug.printLog("700");
    } else if (screenWidth > 500) {
      scaleFactor = 2.5;
      // Debug.printLog("500");
    }else if(screenWidth > 300) {
      scaleFactor = 2.6;
      // Debug.printLog("300");
    } else {
      // Debug.printLog("else");
      scaleFactor = 2.7;
    }
    double fontSize = value.sp * scaleFactor;

    // Debug.printLog("width.......${screenWidth.toString()}.....Sizes ${fontSize.toString()}");

    return fontSize;

  }


  static double sizesHeightManage( BuildContext context,double value){
    double screenWidth = context.height;
    double scaleFactor;
    if(screenWidth > 2100){
      scaleFactor = 1.4;
      // Debug.printLog("2100");
    }else if (screenWidth > 1900) {
      scaleFactor = 1.45;
      // Debug.printLog("1900");
    } else if (screenWidth > 1700) {
      scaleFactor = 1.5;
      // Debug.printLog("1700");
    } else if (screenWidth > 1500) {
      scaleFactor = 1.6;
      // Debug.printLog("1500");
    } else if (screenWidth > 1300) {
      scaleFactor = 1.85;
      // Debug.printLog("1300");
    } else if (screenWidth > 1100) {
      scaleFactor = 1.8;
      // Debug.printLog("1100");
    } else if (screenWidth > 900) {
      scaleFactor = 2.2;
      // Debug.printLog("900");
    } else if (screenWidth > 700) {
      scaleFactor = 2.4;
      // Debug.printLog("700");
    } else if (screenWidth > 500) {
      scaleFactor = 2.5;
      // Debug.printLog("500");
    }else if(screenWidth > 300) {
      scaleFactor = 2.6;
      // Debug.printLog("300");
    } else {
      // Debug.printLog("else");
      scaleFactor = 2.7;
    }
    double fontSize = value.h * scaleFactor;

    // Debug.printLog("width.......${screenWidth.toString()}.....Sizes ${fontSize.toString()}");

    return fontSize;

  }

  static double sizesWidthManage( BuildContext context,double value){
    // Debug.printLog("call.....sizesWidthManage");
    double screenWidth = context.width;
    double scaleFactor;
    if(screenWidth > 2100){
      scaleFactor = 1.4;
      // Debug.printLog("2100");
    }else if (screenWidth > 1900) {
      scaleFactor = 1.45;
      // Debug.printLog("1900");
    } else if (screenWidth > 1700) {
      scaleFactor = 1.5;
      // Debug.printLog("1700");
    } else if (screenWidth > 1500) {
      scaleFactor = 1.6;
      // Debug.printLog("1500");
    } else if (screenWidth > 1300) {
      scaleFactor = 1.85;
      // Debug.printLog("1300");
    } else if (screenWidth > 1100) {
      scaleFactor = 1.8;
      // Debug.printLog("1100");
    } else if (screenWidth > 900) {
      scaleFactor = 2.2;
      // Debug.printLog("900");
    } else if (screenWidth > 700) {
      scaleFactor = 2.4;
      // Debug.printLog("700");
    } else if (screenWidth > 500) {
      scaleFactor = 2.5;
      // Debug.printLog("500");
    }else if(screenWidth > 300) {
      scaleFactor = 2.6;
      // Debug.printLog("300");
    } else {
      // Debug.printLog("else");
      scaleFactor = 2.7;
    }
    double fontSize = value.w * scaleFactor;

    // Debug.printLog("width.......${screenWidth.toString()}.....Sizes ${fontSize.toString()}");

    return fontSize;

  }

/*  static double sizesTrackingChartManage( BuildContext context,double value){
    // Debug.printLog("call.....sizesWidthManage");
    double screenWidth = context.width;
    double scaleFactor;
    if(screenWidth > 2100){
      scaleFactor = 1.4;
      // Debug.printLog("2100");
    }else if (screenWidth > 1900) {
      scaleFactor = 1.45;
      // Debug.printLog("1900");
    } else if (screenWidth > 1700) {
      scaleFactor = 1.5;
      // Debug.printLog("1700");
    } else if (screenWidth > 1500) {
      scaleFactor = 1.6;
      // Debug.printLog("1500");
    } else if (screenWidth > 1300) {
      scaleFactor = 1.85;
      // Debug.printLog("1300");
    } else if (screenWidth > 1100) {
      scaleFactor = 3.5;
      // Debug.printLog("1100");
    } else if (screenWidth > 900) {
      scaleFactor = 3.9;
      // Debug.printLog("900");
    } else if (screenWidth > 700) {
      scaleFactor = 4.3;
      // Debug.printLog("700");
    } else if (screenWidth > 500) {
      scaleFactor = 4.4;
      // Debug.printLog("500");
    }else if(screenWidth > 300) {
      scaleFactor = 4.8;
      // Debug.printLog("300");
    } else {
      // Debug.printLog("else");
      scaleFactor = 5.0;
    }
    double fontSize = value.w * scaleFactor;

    // Debug.printLog("width.......${screenWidth.toString()}.....Sizes ${fontSize.toString()}");

    return fontSize;

  }*/

  static String getSeriesMeasureType(List<ChartData> chartDataList,int pointIndex, int seriesIndex, series, data, point, String titleName){
    var date = chartDataList[pointIndex].x;
    // var month = date.split("\n")[0].split("-")[0];
    // var day = date.split("\n")[0].split("-")[1];
    // var year = date.split("\n")[1];
    // var value = point.y.toString();
    var measureType = "";

    if(titleName == Constant.activityMinutes){
      if(seriesIndex == 0){
        measureType = Constant.activityMinutesTotal;
      }else if(seriesIndex == 1){
        measureType = Constant.activityMinutesVig;
      }else if(seriesIndex == 2){
        measureType = Constant.activityMinutesMod;
      }
    }else if(titleName == Constant.heartRate){
      if(seriesIndex == 0){
        measureType = Constant.heartRateRest;
      }else if(seriesIndex == 1){
        measureType = Constant.heartRatePeak;
      }
    }else if(titleName == Constant.calories){
      measureType = Constant.calories;
    }else if(titleName == Constant.steps){
      measureType = Constant.steps;
    }

    return measureType;
  }

  static String getSeriesDate(List<ChartData> chartDataList,int pointIndex, int seriesIndex, series, data, point, String titleName){
    var date = chartDataList[pointIndex].x;
/*    var month = date.split("\n")[0].split("-")[0];
    var day = date.split("\n")[0].split("-")[1];
    var year = date.split("\n")[1];*/
    var value = point.y.toString();
    var measureType = "";
    var selectedTimeFrame = Constant.selectedTime;
    var month = "";
    var day = "";
    var year = "";
    try {
      if(selectedTimeFrame == Constant.timeDay) {
        month = date.split("\n")[1].split("-")[0];
        day = date.split("\n")[1].split("-")[1];
        year = date.split("\n")[0].split("-")[0];
      }else{
        day = date.split("\n")[0];
        month = date.split("\n")[1];
        Debug.printLog("date week...$date");
      }
    } catch (e) {
      Debug.printLog(e.toString());
    }

    ///date.split("\n")[0].split("-")[0] = Year  date.split("\n")[1].split("-")[0]==Month   date.split("\n")[1].split("-")[1]==>date
    if(titleName == Constant.activityMinutes){
      if(seriesIndex == 0){
        measureType = Constant.activityMinutesTotal;
      }else if(seriesIndex == 1){
        measureType = Constant.activityMinutesVig;
      }else if(seriesIndex == 2){
        measureType = Constant.activityMinutesMod;
      }
    }else if(titleName == Constant.heartRate){
      if(seriesIndex == 0){
        measureType = Constant.heartRateRest;
      }else if(seriesIndex == 1){
        measureType = Constant.heartRatePeak;
      }
    }else if(titleName == Constant.calories){
      measureType = Constant.calories;
    }else if(titleName == Constant.steps){
      measureType = Constant.steps;
    }
    if(selectedTimeFrame == Constant.timeDay) {
      return "Date:- $year-$month-$day";
    }else{
      return "Week:- $month $day";
    }
  }

  static String getSeriesValue(List<ChartData> chartDataList,int pointIndex, int seriesIndex, series, data, point, String titleName){
    var titleType = "";
    var value = double.parse(point.y.toString()).round();
    if(titleName == Constant.activityMinutes){
      titleType = Constant.minutesType;
    }else if(titleName == Constant.heartRate){
      titleType = Constant.heartRateType;
    }else if(titleName == Constant.calories){
      titleType = Constant.caloriesType;
    }else if(titleName == Constant.steps){
      titleType = Constant.stepsType;
    }

    return "$titleType$value";
  }

  /*static List<ServerModel> getServerList = [
    ServerModel(isSecure: true, displayName: Constant.secureServerPaa,
        url: Constant.secureServerPaa, clientId: Constant.clientIdMeld1,isSelected: false,isPrimary: false,title: "Paa"),
    ServerModel(isSecure: true, displayName: Constant.secureServerPaa2,
        url: Constant.secureServerPaa2, clientId: Constant.clientIdMeld2,isSelected: false,isPrimary: false,title: "Paa2"),
    ServerModel(isSecure: true, displayName: Constant.secureServerPaa2,
        url: Constant.secureServerPaa2, clientId: Constant.clientIdMeld3,isSelected: false,isPrimary: false,title: "Paa3"),
    ServerModel(isSecure: false, displayName: Constant.server1Hapi,
        url: Constant.server1Hapi, clientId: "",isSelected: false,isPrimary: false,title: "Hapi"),
    ServerModel(isSecure: false, displayName: Constant.server2Fire,
        url: Constant.server2Fire, clientId: "",isSelected: false,isPrimary: false,title: "Fire"),
  ];*/

  static List<ServerModelJson> getServerList = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];

//   static List<ServerModelJson> getServerList = (Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed)!.isEmpty)?
//   [
// /*    ServerModelJson(isSecure: false, displayName: Constant.server1Hapi,
//         url: Constant.server1Hapi, clientId: "",isSelected: false,isPrimary: false,title: "Hapi"),
//     ServerModelJson(isSecure: false, displayName: Constant.server2Fire,
//         url: Constant.server2Fire, clientId: "",isSelected: false,isPrimary: false,title: "Firely"),
//     ServerModelJson(isSecure: false, displayName: Constant.server5Meld,
//         url: Constant.server5Meld, clientId: "",isSelected: false,isPrimary: false,title: "Physical"),
//     ServerModelJson(isSecure: true, displayName: Constant.server3Meld,
//         url: Constant.server3Meld, clientId: "37862658-025c-42b3-ba86-8c16452c2e22",isSelected: false,
//         isPrimary: false,title: "Meld"),
//     ServerModelJson(isSecure: true, displayName: Constant.local,
//         url: Constant.local, clientId: "physical_activity",isSelected: false,
//         isPrimary: false,title: "Local 8080"),*/
//   ]:Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];

  static List<ServerModelJson> getServerListPreference(){
    return  Preference.shared.getServerList(Preference.serverUrlAllListed) ?? [];
    return  Utils.getServerList;
  }

  static ServerModelJson? getPrimaryServerData(){
    List<ServerModelJson> primaryData = getServerListPreference().where((element) => element.isPrimary).toList();
    if(primaryData.isNotEmpty){
      return  primaryData[0];
    }else{
      return null;
    }
  }

  static String getIconPatFromStatus(String status){
    var iconPath = "";
    if(status == Constant.toDoStatusCompleted){
      iconPath = "assets/icons/ic_todo_done.png";
    }else if(status == Constant.toDoStatusCancelled || status == Constant.toDoStatusFailed){
      iconPath = "assets/icons/ic_todo_close.png";
    }else{
      iconPath = "assets/icons/ic_todo_edited.png";
    }
    return iconPath;
  }

  static List<ActivityTable> getActivityGraphData(){
    return (Utils.getPatientId() != "") ? Hive.box<ActivityTable>(Constant.tableActivity).values.toList().where((element) =>
    element.patientId == Utils.getPatientId()).toList() : Hive.box<ActivityTable>(Constant.tableActivity).values.toList();
  }

  static bool isThisOutSideTitle(String title){
    var isOutSide = true;
    if(title == Constant.itemBicycling){
      isOutSide = false;
    }
    if(title == Constant.itemJogging){
      isOutSide = false;
    }
    if(title == Constant.itemRunning){
      isOutSide = false;
    }
    if(title == Constant.itemSwimming){
      isOutSide = false;
    }
    if(title == Constant.itemWalking){
      isOutSide = false;
    }
    if(title == Constant.itemWeights){
      isOutSide = false;
    }
    /*if(title == Constant.itemMixed){
      isOutSide = false;
    }*/
    return isOutSide;
  }

  static bool isExpiredToken(int lastLoggedDateTime, int durationInSeconds) {
    // durationInSeconds = 60;
    var dateFromTimeStamp = DateTime.fromMillisecondsSinceEpoch(lastLoggedDateTime);
    DateTime expiryDateTime = dateFromTimeStamp.add(Duration(seconds: durationInSeconds));
    DateTime currentDateTime = DateTime.now();
    Debug.printLog("isExpiredToken....${currentDateTime.isAfter(expiryDateTime)}");
    return currentDateTime.isAfter(expiryDateTime);
  }

  static Future<void> callSecureServerAPI(String url,String clientId,String serverName,
      {Function? callBackFroAddServerIntoList,Function? callBack}) async {
    if (url.isNotEmpty) {
      var isShowDialog = false;
      try {
        SmartFhirClient? smartFhirClient;
        if (clientId != "") {
          FhirUri redirect;
          if(kIsWeb){
            redirect = Api.fhirCallbackWeb;
          }
          else
          {
            redirect = Api.fhirCallback;
          }
          Debug.printLog("Call api for secure server....$redirect  $url  $clientId  $serverName");
          smartFhirClient = SmartFhirClient(
              fhirUri: FhirUri(url),
              clientId: clientId,
              redirectUri: redirect
          );
          // showDialogForProgress(getX.Get.context!);
          if(kIsWeb){
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (context) {
                return Dialog(
                  insetPadding: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  backgroundColor: CColor.white,
                  child: LayoutBuilder(
                      builder: (BuildContext context,BoxConstraints  constraints) {
                        return Container(
                          padding: EdgeInsets.only(
                              left: AppFontStyle.sizesWidthManageWeb(1.3,constraints),
                              top: AppFontStyle.sizesHeightManageWeb(2.0,constraints),
                              right: AppFontStyle.sizesWidthManageWeb(1.3,constraints),
                              bottom:AppFontStyle.sizesHeightManageWeb(2.0,constraints)),
                          // height: (kIsWeb) ? Sizes.height_9 :Get.height * 0.1,
                          child: Wrap(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // const CircularProgressIndicator(),
                                  Container(
                                    margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                                    child: Text(
                                      Constant.txtPleaseWait,
                                      style: AppFontStyle.styleW700(CColor.black,
                                          AppFontStyle.sizesFontManageWeb(1.5,constraints)),
                                    ),
                                  ),
                                  Text(Constant.txtConnectingPatient,
                                      style:
                                      AppFontStyle.styleW400(CColor.black,
                                          AppFontStyle.sizesFontManageWeb(1.3,constraints))),

                                ],
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                );
              },
            );
          }
          else {
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  contentPadding: const EdgeInsets.all(0),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(5.0),
                    ),
                  ),
                  backgroundColor: CColor.white,
                  content: Container(
                    padding: EdgeInsets.only(left: Sizes.width_3),
                    height: (kIsWeb) ? Sizes.height_20 : Get.height * 0.1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const CircularProgressIndicator(),
                        Container(
                          margin: EdgeInsets.only(bottom: Sizes.height_0_5),
                          child: Text(
                            Constant.txtPleaseWait,
                            style: AppFontStyle.styleW700(CColor.black,
                                (kIsWeb) ? FontSize.size_10 : FontSize.size_12),
                          ),
                        ),
                        Text(Constant.txtConnectingPatient,
                            style: AppFontStyle.styleW400(CColor.black,
                                (kIsWeb) ? FontSize.size_8 : FontSize.size_10))
                      ],
                    ),
                  ),
                );
              },
            );
          }
          isShowDialog = true;
          var msg = "";
          var isSuccess = true;
          var fhirParameters = {};

          try {
            await smartFhirClient.login(callBackFunction: (value){
              Debug.printLog("Smart login.....$value");
              var mapData = value;
              msg = mapData[Constant.msg];
              isSuccess = mapData[Constant.isSuccess];
              fhirParameters = mapData[Constant.fhirParameters];
            },callBackForTokenUrl: (url){
              Debug.printLog("Token Url....$url");
              Preference.shared.setString(Preference.tokenUrl, url);
            });
          } catch (e) {
            Debug.printLog(e.toString());
          }


          if(!isSuccess && fhirParameters.isEmpty){
            Get.back();
            // Utils.showToast(Get.context!, msg);
            Utils.showErrorDialog(Get.context!, Constant.txtError, msg);
            if(callBack != null) {
              callBack.call("return");
            }
            return;
          }

          String authToken = Preference.shared.getString(Preference.authToken) ?? "";
          String refreshToken = Preference.shared.getString(Preference.refreshToken) ?? "";
          int expireTime = Preference.shared.getInt(Preference.expireTime) ?? 0;
          String smartFhirPatientDisplayName = Preference.shared.getString(Preference.smartFhirPatientName) ?? "";
          String smartFhirPatientId = Preference.shared.getString(Preference.smartFhirPatientId) ?? "";
          var getIndexOfSecureServer = Utils.getServerList.indexWhere((element) => element.url == url &&
              element.clientId == clientId && element.title == serverName).toInt();

          if(getIndexOfSecureServer != -1){
            var serverData = Utils.getServerList;
            serverData[getIndexOfSecureServer].lastLoggedTime = DateTime.now().millisecondsSinceEpoch;
            serverData[getIndexOfSecureServer].isSecure = true;
            serverData[getIndexOfSecureServer].isSelected = true;
            serverData[getIndexOfSecureServer].authToken = authToken;
            serverData[getIndexOfSecureServer].refreshToken = refreshToken;
            serverData[getIndexOfSecureServer].expireTime = expireTime;
            serverData[getIndexOfSecureServer].patientId = smartFhirPatientId;
            serverData[getIndexOfSecureServer].patientFName = smartFhirPatientDisplayName;
            serverData[getIndexOfSecureServer].patientLName = smartFhirPatientDisplayName;
            var json = jsonEncode(serverData.map((e) => e.toJson()).toList());
            Preference.shared.setList(Preference.serverUrlAllListed,json);
            Debug.printLog("Server In......${DateTime.fromMillisecondsSinceEpoch(serverData[getIndexOfSecureServer].lastLoggedTime).toString()}.........New Time ${DateTime.now().millisecondsSinceEpoch}");
          }
          if(callBackFroAddServerIntoList != null) {
            if(authToken != "") {
              Map mapTokenData = {
                "token": authToken,
                "refreshToken": refreshToken,
                "expireTime": expireTime,
                "smartFhirPatientId":smartFhirPatientId,
                "smartFhirPatientDisplayName":smartFhirPatientDisplayName,
              };
              callBackFroAddServerIntoList.call(mapTokenData);
              var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
              Preference.shared.setList(Preference.serverUrlAllListed,json);
              await Utils.setPatientDetailIdWise();
              Get.back();
              return;
            }
          }
        }

        var json = jsonEncode(Utils.getServerListPreference().map((e) => e.toJson()).toList());
        Preference.shared.setList(Preference.serverUrlAllListed,json);

        if (isShowDialog) {
          isShowDialog = false;
          Get.back();
        }
      } catch (e) {
        Debug.printLog(e.toString());
        Utils.showToast(Get.context!, e.toString());
        if (isShowDialog) {
          Get.back();
        }
      }
    }
  }

  static String getTotalMinFromTwoDates(DateTime fromDate,DateTime toDate){
    Duration difference = toDate.difference(fromDate);
    Debug.printLog('Total difference in minutes......: ${difference.inMinutes}'); // Output the result
    return "${difference.inMinutes}";
  }

  static String getActivityNameFromSyncData(String value){
    try {
      var data = "";
      if(value == "OTHER"){
            data = value.toLowerCase();
            data = Utils.capitalizeFirstLetter(data);
          } else if(value == "BIKING"){
            data = Constant.itemBicycling;
          } else if(value == "RUNNING_SAND"){
            data = Constant.itemRunning;
          } else if(value == "RUNNING_TREADMILL"){
            data = Constant.itemRunning;
          } else if(value == "RUNNING_JOGGING"){
            data = Constant.itemRunning;
          } else {
            if(value.contains("_")){
              List<String> splitList = value.split("_");
              for (int i = 0; i < splitList.length; i++) {
                if(data == ""){
                  data = splitList[i].toLowerCase();
                  data = Utils.capitalizeFirstLetter(data);
                }else{
                  data += " ${splitList[i].toLowerCase()}";
                }
              }
            }else{
              data = value.toLowerCase();
              data = Utils.capitalizeFirstLetter(data);
            }
          }
      Debug.printLog("getActivityNameFromSyncData....$data");
      return data;
    } catch (e) {
      Debug.printLog(e.toString());
      return "";
    }
  }

  static String getActivityCodeFromSyncData(String value){
    try {
      var data = "";
      if(value == "OTHER"){
        data = value.toLowerCase();
        data = Utils.capitalizeFirstLetter(data);
      } else if(value == "BIKING"){
        data = Constant.itemBicycling;
      } else if(value == "RUNNING_SAND"){
        data = Constant.itemRunning;
      } else if(value == "RUNNING_TREADMILL"){
        data = Constant.itemRunning;
      } else if(value == "RUNNING_JOGGING"){
        data = Constant.itemRunning;
      } else {
        if(value.contains("_")){
          List<String> splitList = value.split("_");
          for (int i = 0; i < splitList.length; i++) {
            if(data == ""){
              data = splitList[i].toLowerCase();
              data = Utils.capitalizeFirstLetter(data);
            }else{
              data += " ${splitList[i].toLowerCase()}";
            }
          }
        }else{
          data = value.toLowerCase();
          data = Utils.capitalizeFirstLetter(data);
        }
      }
      Debug.printLog("getActivityNameFromSyncData....$data");
      var configurationInfo = getAllWorkoutListData;

      var code = configurationInfo.where((element) => element.workOutDataName == data).toList();
      if(code.isNotEmpty){
        return code[0].workOutDataCode;
      }else{
        return "";
      }

    } catch (e) {
      Debug.printLog(e.toString());
      return "";
    }
  }

  static DateTime getPickedDateFromStoredDate(DateTime? dateTime){
    // var now = DateTime.now();
    dateTime ??= DateTime.now();
    // return DateTime(dateTime.year,dateTime.month,dateTime.day,now.hour,now.minute,now.second);
    return DateTime(dateTime.year,dateTime.month,dateTime.day,dateTime.hour,dateTime.minute,dateTime.second);
  }

  static List<WorkOutData> getWorkoutDataList = (kIsWeb)?workOutDataListAndroid.where((element) => element.isShow  ?? true).toList():((Platform.isIOS)?workOutDataListIos:workOutDataListAndroid).where((element) => element.isShow  ?? true).toList();
  static List<WorkOutData> getAllWorkoutListData = (kIsWeb)?workOutDataListAndroid:((Platform.isIOS)?workOutDataListIos:workOutDataListAndroid);

  /// Android Use this List
  static List<WorkOutData> workOutDataListAndroid = [
    WorkOutData(workOutDataName: Constant.activityAmericanFootballAndroid, workOutDataImages: Constant.activityImagesAmericanFootball, datatype: HealthWorkoutActivityType.AMERICAN_FOOTBALL,workOutDataCode: Constant.activityAmericanFootballAndroidCode),
    WorkOutData(workOutDataName: Constant.activityAustralianFootballAndroid, workOutDataImages: Constant.activityImagesAustralianFootball, datatype: HealthWorkoutActivityType.AUSTRALIAN_FOOTBALL,workOutDataCode: Constant.activityAustralianFootballAndroidCode),
    WorkOutData(workOutDataName: Constant.activityBadmintonAndroid, workOutDataImages: Constant.activityImagesBadminton, datatype: HealthWorkoutActivityType.BADMINTON,workOutDataCode: Constant.activityBadmintonAndroidCode),
    WorkOutData(workOutDataName: Constant.activityBaseballAndroid, workOutDataImages: Constant.activityImagesBaseball, datatype: HealthWorkoutActivityType.BASEBALL,workOutDataCode: Constant.activityBaseballAndroidCode),
    WorkOutData(workOutDataName: Constant.activityBasketballAndroid, workOutDataImages: Constant.activityImagesBasketball, datatype: HealthWorkoutActivityType.BASKETBALL,workOutDataCode: Constant.activityBasketballAndroidCode),
    WorkOutData(workOutDataName: Constant.activityBoxingAndroid, workOutDataImages: Constant.activityImagesBoxingGlove, datatype: HealthWorkoutActivityType.BOXING,workOutDataCode: Constant.activityBoxingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityCalisthenicsAndroid, workOutDataImages: Constant.activityImagesCalisthenics, datatype: HealthWorkoutActivityType.CALISTHENICS,workOutDataCode: Constant.activityCalisthenicsAndroidCode),
    WorkOutData(workOutDataName: Constant.activityCricketAndroid, workOutDataImages: Constant.activityImagesCricket, datatype: HealthWorkoutActivityType.CRICKET,workOutDataCode: Constant.activityCricketAndroidCode),
    WorkOutData(workOutDataName: Constant.activityDancingAndroid, workOutDataImages: Constant.activityImagesDancing, datatype: HealthWorkoutActivityType.DANCING,workOutDataCode: Constant.activityDancingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityEllipticalAndroid, workOutDataImages: Constant.activityImagesElliptical, datatype: HealthWorkoutActivityType.ELLIPTICAL,workOutDataCode: Constant.activityEllipticalAndroidCode),
    WorkOutData(workOutDataName: Constant.activityFencingAndroid, workOutDataImages: Constant.activityImagesFencing, datatype: HealthWorkoutActivityType.FENCING,workOutDataCode: Constant.activityFencingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityFrisbeeAndroid, workOutDataImages: Constant.activityImagesFrisbee, datatype: HealthWorkoutActivityType.FRISBEE_DISC,workOutDataCode: Constant.activityFrisbeeAndroidCode),
    WorkOutData(workOutDataName: Constant.activityGolfAndroid, workOutDataImages: Constant.activityImagesGolf, datatype: HealthWorkoutActivityType.GOLF,workOutDataCode: Constant.activityGolfAndroidCode),
    WorkOutData(workOutDataName: Constant.activityGymnasticsAndroid, workOutDataImages: Constant.activityImagesGymnastics, datatype: HealthWorkoutActivityType.GYMNASTICS,workOutDataCode: Constant.activityGymnasticsAndroidCode),
    WorkOutData(workOutDataName: Constant.activityHandballAndroid, workOutDataImages: Constant.activityImagesHandball, datatype: HealthWorkoutActivityType.HANDBALL,workOutDataCode: Constant.activityHandballAndroidCode),
    WorkOutData(workOutDataName: Constant.activityMartialArtsAndroid, workOutDataImages: Constant.activityImagesMartialArts, datatype: HealthWorkoutActivityType.MARTIAL_ARTS,workOutDataCode: Constant.activityMartialArtsAndroidCode),
    WorkOutData(workOutDataName: Constant.activityOpenWaterSwimmingAndroid, workOutDataImages: Constant.activityImagesOpenWaterSwimming, datatype: HealthWorkoutActivityType.SWIMMING_OPEN_WATER,workOutDataCode: Constant.activityOpenWaterSwimmingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityOtherAndroid, workOutDataImages: Constant.activityImagesOther, datatype: HealthWorkoutActivityType.OTHER,workOutDataCode: Constant.activityOtherAndroidCode),
    WorkOutData(workOutDataName: Constant.activityParaglidingAndroid, workOutDataImages: Constant.activityImagesParagliding, datatype: HealthWorkoutActivityType.PARAGLIDING,workOutDataCode: Constant.activityParaglidingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityPilatesAndroid, workOutDataImages: Constant.activityImagesPilates, datatype: HealthWorkoutActivityType.PILATES,workOutDataCode: Constant.activityPilatesAndroidCode),
    WorkOutData(workOutDataName: Constant.activityPoolSwimmingAndroid, workOutDataImages: Constant.activityImagesPoolSwimming, datatype: HealthWorkoutActivityType.SWIMMING_POOL,workOutDataCode: Constant.activityPoolSwimmingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityRacquetballAndroid, workOutDataImages: Constant.activityImagesRacquetball, datatype: HealthWorkoutActivityType.RACQUETBALL,workOutDataCode: Constant.activityRacquetballAndroidCode),
    WorkOutData(workOutDataName: Constant.activityRockClimbingAndroid, workOutDataImages: Constant.activityImagesRockClimbing, datatype: HealthWorkoutActivityType.ROCK_CLIMBING,workOutDataCode: Constant.activityRockClimbingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityRollerSkiingAndroid, workOutDataImages: Constant.activityImagesRollerSkating, datatype: HealthWorkoutActivityType.SKIING_ROLLER,workOutDataCode: Constant.activityRollerSkiingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityRowingAndroid, workOutDataImages: Constant.activityImagesRowing, datatype: HealthWorkoutActivityType.ROWING,workOutDataCode: Constant.activityRowingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityRugbyAndroid, workOutDataImages: Constant.activityImagesRugby, datatype: HealthWorkoutActivityType.RUGBY,workOutDataCode: Constant.activityRugbyAndroidCode),
    WorkOutData(workOutDataName: Constant.activitySailingAndroid, workOutDataImages: Constant.activityImagesSailing, datatype: HealthWorkoutActivityType.SAILING,workOutDataCode: Constant.activitySailingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityScubaDivingAndroid, workOutDataImages: Constant.activityImagesScubaDiving, datatype: HealthWorkoutActivityType.SCUBA_DIVING,workOutDataCode: Constant.activityScubaDivingAndroidCode),
    WorkOutData(workOutDataName: Constant.activitySkatingAndroid, workOutDataImages: Constant.activityImagesSkiing, datatype: HealthWorkoutActivityType.SKIING,workOutDataCode: Constant.activitySkatingAndroidCode),
    WorkOutData(workOutDataName: Constant.activitySnowboardingAndroid, workOutDataImages: Constant.activityImagesSnowboarding, datatype: HealthWorkoutActivityType.SNOWBOARDING,workOutDataCode: Constant.activitySnowboardingAndroidCode),
    WorkOutData(workOutDataName: Constant.activitySoftballAndroid, workOutDataImages: Constant.activityImagesSoftball, datatype: HealthWorkoutActivityType.SOFTBALL,workOutDataCode: Constant.activitySoftballAndroidCode),
    WorkOutData(workOutDataName: Constant.activitySquashAndroid, workOutDataImages: Constant.activityImagesSquash, datatype: HealthWorkoutActivityType.SQUASH,workOutDataCode: Constant.activitySquashAndroidCode),
    WorkOutData(workOutDataName: Constant.activityStairClimbingAndroid, workOutDataImages: Constant.activityImagesStairClimbing, datatype: HealthWorkoutActivityType.STAIR_CLIMBING,workOutDataCode: Constant.activityStairClimbingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityStairClimbingMachineAndroid, workOutDataImages: Constant.activityImagesStairClimbingMachine, datatype: HealthWorkoutActivityType.STAIR_CLIMBING_MACHINE,workOutDataCode: Constant.activityStairClimbingMachineAndroidCode),
    WorkOutData(workOutDataName: Constant.activityStrengthTrainingAndroid, workOutDataImages: Constant.activityImagesStrengthTraining, datatype: HealthWorkoutActivityType.STRENGTH_TRAINING,workOutDataCode: Constant.activityStrengthTrainingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityTableTennisAndroid, workOutDataImages: Constant.activityImagesTableTennis, datatype: HealthWorkoutActivityType.TABLE_TENNIS,workOutDataCode: Constant.activityTableTennisAndroidCode),
    WorkOutData(workOutDataName: Constant.activityTennisAndroid, workOutDataImages: Constant.activityImagesTennis, datatype: HealthWorkoutActivityType.TENNIS,workOutDataCode: Constant.activityTennisAndroidCode),
    WorkOutData(workOutDataName: Constant.activityTreadmillRunningAndroid, workOutDataImages: Constant.activityImagesTreadmillRunning, datatype: HealthWorkoutActivityType.RUNNING_TREADMILL,workOutDataCode: Constant.activityTreadmillRunningAndroidCode),
    WorkOutData(workOutDataName: Constant.activityVolleyballAndroid, workOutDataImages: Constant.activityImagesVolleyball, datatype: HealthWorkoutActivityType.VOLLEYBALL,workOutDataCode: Constant.activityVolleyballAndroidCode),
    WorkOutData(workOutDataName: Constant.itemBicycling, workOutDataImages: Constant.iconBicycling, datatype: HealthWorkoutActivityType.BIKING,isShow: false,workOutDataCode: Constant.codeBicycling),
    WorkOutData(workOutDataName: Constant.itemJogging, workOutDataImages: Constant.iconJogging, datatype: HealthWorkoutActivityType.OTHER,isShow: false,workOutDataCode: Constant.codeJogging),
    WorkOutData(workOutDataName: Constant.itemRunning, workOutDataImages: Constant.iconRunning, datatype: HealthWorkoutActivityType.RUNNING,isShow: false,workOutDataCode: Constant.codeRunning),
    WorkOutData(workOutDataName: Constant.itemSwimming, workOutDataImages: Constant.iconSwimming, datatype: HealthWorkoutActivityType.OTHER,isShow: false,workOutDataCode: Constant.codeSwimming),
    WorkOutData(workOutDataName: Constant.itemWalking, workOutDataImages: Constant.iconWalking, datatype: HealthWorkoutActivityType.WALKING,isShow: false,workOutDataCode: Constant.codeWalking),
    WorkOutData(workOutDataName: Constant.itemWeights, workOutDataImages: Constant.iconWeights, datatype: HealthWorkoutActivityType.OTHER,isShow: false,workOutDataCode: Constant.codeWeights),
    WorkOutData(workOutDataName: Constant.activityWaterPoloAndroid, workOutDataImages: Constant.activityImagesWaterPolo, datatype: HealthWorkoutActivityType.WATER_POLO,workOutDataCode: Constant.activityWaterPoloAndroidCode),
    WorkOutData(workOutDataName: Constant.activityWeightliftingAndroid, workOutDataImages: Constant.activityImagesWeightlifting, datatype: HealthWorkoutActivityType.WEIGHTLIFTING,workOutDataCode: Constant.activityWeightliftingAndroidCode),
    WorkOutData(workOutDataName: Constant.activityWheelChairAndroid, workOutDataImages: Constant.activityImagesWheelchair, datatype: HealthWorkoutActivityType.WHEELCHAIR,workOutDataCode: Constant.activityWheelChairAndroidCode),
    WorkOutData(workOutDataName: Constant.activityYogaAndroid, workOutDataImages: Constant.activityImagesYoga, datatype: HealthWorkoutActivityType.YOGA,workOutDataCode: Constant.activityYogaAndroidCode),
  ];

  /// IOS Use this List
  static List<WorkOutData> workOutDataListIos = [
    WorkOutData(workOutDataName: Constant.activityAmericanFootballIos, workOutDataImages: Constant.activityImagesAmericanFootball, datatype: HealthWorkoutActivityType.AMERICAN_FOOTBALL,workOutDataCode: Constant.activityAmericanFootballIosCode),
    WorkOutData(workOutDataName: Constant.activityArcheryIos, workOutDataImages: Constant.activityImagesArchery, datatype: HealthWorkoutActivityType.ARCHERY,workOutDataCode: Constant.activityArcheryIosCode),
    WorkOutData(workOutDataName: Constant.activityAustralianFootballIos, workOutDataImages: Constant.activityImagesAustralianFootball, datatype: HealthWorkoutActivityType.AUSTRALIAN_FOOTBALL,workOutDataCode: Constant.activityAustralianFootballIosCode),
    WorkOutData(workOutDataName: Constant.activityBadmintonIos, workOutDataImages: Constant.activityImagesBadminton, datatype: HealthWorkoutActivityType.BADMINTON,workOutDataCode: Constant.activityBadmintonIosCode),
    WorkOutData(workOutDataName: Constant.activityBarreIos, workOutDataImages: Constant.activityImagesBarre, datatype: HealthWorkoutActivityType.BARRE,workOutDataCode: Constant.activityBarreIosCode),
    WorkOutData(workOutDataName: Constant.activityBaseballIos, workOutDataImages: Constant.activityImagesBaseball, datatype: HealthWorkoutActivityType.BASEBALL,workOutDataCode: Constant.activityBaseballIosCode),
    WorkOutData(workOutDataName: Constant.activityBasketballIos, workOutDataImages: Constant.activityImagesBasketball, datatype: HealthWorkoutActivityType.BASKETBALL,workOutDataCode: Constant.activityBasketballIosCode),
    WorkOutData(workOutDataName: Constant.activityBowlingIos, workOutDataImages: Constant.activityImagesBowling, datatype: HealthWorkoutActivityType.BOWLING,workOutDataCode: Constant.activityBowlingIosCode),
    WorkOutData(workOutDataName: Constant.activityBoxingIos, workOutDataImages: Constant.activityImagesBoxingGlove, datatype: HealthWorkoutActivityType.BOXING,workOutDataCode: Constant.activityBoxingIosCode),
    WorkOutData(workOutDataName: Constant.activityClimbingIos, workOutDataImages: Constant.activityImagesClimbing, datatype: HealthWorkoutActivityType.CLIMBING,workOutDataCode: Constant.activityClimbingIosCode),
    WorkOutData(workOutDataName: Constant.activityCoolDownIos, workOutDataImages: Constant.activityImagesCoolDown, datatype: HealthWorkoutActivityType.COOLDOWN,workOutDataCode: Constant.activityCoolDownIosCode),
    WorkOutData(workOutDataName: Constant.activityCoreTrainingIos, workOutDataImages: Constant.activityImagesCoreTraining, datatype: HealthWorkoutActivityType.CORE_TRAINING,workOutDataCode: Constant.activityCoreTrainingIosCode),
    WorkOutData(workOutDataName: Constant.activityCricketIos, workOutDataImages: Constant.activityImagesCricket, datatype: HealthWorkoutActivityType.CRICKET,workOutDataCode: Constant.activityCricketIosCode),
    WorkOutData(workOutDataName: Constant.activityCrossTrainingIos, workOutDataImages: Constant.activityImagesCrossTraining, datatype: HealthWorkoutActivityType.CROSS_TRAINING,workOutDataCode: Constant.activityCrossTrainingIosCode),
    WorkOutData(workOutDataName: Constant.activityCyclingIos, workOutDataImages: Constant.activityImagesCycling, datatype: HealthWorkoutActivityType.HAND_CYCLING,workOutDataCode: Constant.activityCyclingIosCode),
    WorkOutData(workOutDataName: Constant.activityCrossCountrySkiingIos, workOutDataImages: Constant.activityImagesCrossCountrySkiing, datatype: HealthWorkoutActivityType.CROSS_COUNTRY_SKIING,workOutDataCode: Constant.activityCrossCountrySkiingIosCode),
    WorkOutData(workOutDataName: Constant.activityCurlingIos, workOutDataImages: Constant.activityImagesCurlingStone, datatype: HealthWorkoutActivityType.CURLING,workOutDataCode: Constant.activityCurlingIosCode),
    WorkOutData(workOutDataName: Constant.activityDancingIos, workOutDataImages: Constant.activityImagesDancing, datatype: HealthWorkoutActivityType.SOCIAL_DANCE,workOutDataCode: Constant.activityDancingIosCode),
    WorkOutData(workOutDataName: Constant.activityDiskSportsIos, workOutDataImages: Constant.activityImagesDiskSports, datatype: HealthWorkoutActivityType.DISC_SPORTS,workOutDataCode: Constant.activityDiskSportsIosCode),
    WorkOutData(workOutDataName: Constant.activityDownhillSkiingIos, workOutDataImages: Constant.activityImagesDownhillSkiing, datatype: HealthWorkoutActivityType.DOWNHILL_SKIING,workOutDataCode: Constant.activityDownhillSkiingIosCode),
    WorkOutData(workOutDataName: Constant.activityEllipticalIos, workOutDataImages: Constant.activityImagesElliptical, datatype: HealthWorkoutActivityType.ELLIPTICAL,workOutDataCode: Constant.activityEllipticalIosCode),
    WorkOutData(workOutDataName: Constant.activityEquestrianSportsIos, workOutDataImages: Constant.activityImagesEquestrianSport, datatype: HealthWorkoutActivityType.EQUESTRIAN_SPORTS,workOutDataCode: Constant.activityEquestrianSportsIosCode),
    WorkOutData(workOutDataName: Constant.activityFencingIos, workOutDataImages: Constant.activityImagesFencing, datatype: HealthWorkoutActivityType.FENCING,workOutDataCode: Constant.activityFencingIosCode),
    WorkOutData(workOutDataName: Constant.activityFishingIos, workOutDataImages: Constant.activityImagesFishing, datatype: HealthWorkoutActivityType.FISHING,workOutDataCode: Constant.activityFishingIosCode),
    WorkOutData(workOutDataName: Constant.activityFitnessGamingIos, workOutDataImages: Constant.activityImagesFitnessGaming, datatype: HealthWorkoutActivityType.FITNESS_GAMING,workOutDataCode: Constant.activityFitnessGamingIosCode),
    WorkOutData(workOutDataName: Constant.activityFlexibilityIos, workOutDataImages: Constant.activityImagesFlexibility, datatype: HealthWorkoutActivityType.FLEXIBILITY,workOutDataCode: Constant.activityFlexibilityIosCode),
    WorkOutData(workOutDataName: Constant.activityFunctionalStrengthTrainingIos, workOutDataImages: Constant.activityImagesStrengthTraining, datatype: HealthWorkoutActivityType.FUNCTIONAL_STRENGTH_TRAINING,workOutDataCode: Constant.activityFunctionalStrengthTrainingIosCode),
    WorkOutData(workOutDataName: Constant.activityGolfIos, workOutDataImages: Constant.activityImagesGolf, datatype: HealthWorkoutActivityType.GOLF,workOutDataCode: Constant.activityGolfIosCode),
    WorkOutData(workOutDataName: Constant.activityGymnasticsIos, workOutDataImages: Constant.activityImagesGymnastics, datatype: HealthWorkoutActivityType.GYMNASTICS,workOutDataCode: Constant.activityGymnasticsIosCode),
    WorkOutData(workOutDataName: Constant.activityHandCycleIos, workOutDataImages: Constant.activityImagesCycling, datatype: HealthWorkoutActivityType.HAND_CYCLING,workOutDataCode: Constant.activityHandCycleIosCode),
    WorkOutData(workOutDataName: Constant.activityHandballIos, workOutDataImages: Constant.activityImagesHandball, datatype: HealthWorkoutActivityType.HANDBALL,workOutDataCode: Constant.activityHandballIosCode),
    WorkOutData(workOutDataName: Constant.activityHikingIos, workOutDataImages: Constant.activityImagesHiking, datatype: HealthWorkoutActivityType.HIKING,workOutDataCode: Constant.activityHikingIosCode),
    WorkOutData(workOutDataName: Constant.activityHockeyIos, workOutDataImages: Constant.activityImagesHockey, datatype: HealthWorkoutActivityType.HOCKEY,workOutDataCode: Constant.activityHockeyIosCode),
    WorkOutData(workOutDataName: Constant.activityHuntingIos, workOutDataImages: Constant.activityImagesHunting, datatype: HealthWorkoutActivityType.HUNTING,workOutDataCode: Constant.activityHuntingIosCode),
    WorkOutData(workOutDataName: Constant.activityKickBoxingIos, workOutDataImages: Constant.activityImagesKickBoxing, datatype: HealthWorkoutActivityType.KICKBOXING,workOutDataCode: Constant.activityKickBoxingIosCode),
    WorkOutData(workOutDataName: Constant.activityLacrosseIos, workOutDataImages: Constant.activityImagesLacrosse, datatype: HealthWorkoutActivityType.LACROSSE,workOutDataCode: Constant.activityLacrosseIosCode),
    WorkOutData(workOutDataName: Constant.activityMartialArtsIos, workOutDataImages: Constant.activityImagesMartialArts, datatype: HealthWorkoutActivityType.MARTIAL_ARTS,workOutDataCode: Constant.activityMartialArtsIosCode),
    WorkOutData(workOutDataName: Constant.activityPaddleSportsIos, workOutDataImages: Constant.activityImagesPaddleSports, datatype: HealthWorkoutActivityType.PADDLE_SPORTS,workOutDataCode: Constant.activityPaddleSportsIosCode),
    WorkOutData(workOutDataName: Constant.activityPickleballIos, workOutDataImages: Constant.activityImagesPickleball, datatype: HealthWorkoutActivityType.PICKLEBALL,workOutDataCode: Constant.activityPickleballIosCode),
    WorkOutData(workOutDataName: Constant.activityPlayIos, workOutDataImages: Constant.activityImagesPlay, datatype: HealthWorkoutActivityType.PLAY,workOutDataCode: Constant.activityPlayIosCode),
    WorkOutData(workOutDataName: Constant.activityPilatesIos, workOutDataImages: Constant.activityImagesPilates, datatype: HealthWorkoutActivityType.PILATES,workOutDataCode: Constant.activityPilatesIosCode),
    WorkOutData(workOutDataName: Constant.activityPreparationAndRecoveryIos, workOutDataImages: Constant.activityImagesPacedWalking, datatype: HealthWorkoutActivityType.PREPARATION_AND_RECOVERY,workOutDataCode: Constant.activityPreparationAndRecoveryIosCode),
    WorkOutData(workOutDataName: Constant.activityRowingIos, workOutDataImages: Constant.activityImagesRowing, datatype: HealthWorkoutActivityType.ROWING,workOutDataCode: Constant.activityRowingIosCode),
    WorkOutData(workOutDataName: Constant.activityRugbyIos, workOutDataImages: Constant.activityImagesRugby, datatype: HealthWorkoutActivityType.RUGBY,workOutDataCode: Constant.activityRugbyIosCode),
    WorkOutData(workOutDataName: Constant.activitySailingIos, workOutDataImages: Constant.activityImagesSailing, datatype: HealthWorkoutActivityType.SAILING,workOutDataCode: Constant.activitySailingIosCode),
    WorkOutData(workOutDataName: Constant.activitySkatingSportIos, workOutDataImages: Constant.activityImagesSkating, datatype: HealthWorkoutActivityType.SKATING,workOutDataCode: Constant.activitySkatingSportIosCode),
    WorkOutData(workOutDataName: Constant.activitySnowSportIos, workOutDataImages: Constant.activityImagesSnowboarding, datatype: HealthWorkoutActivityType.SNOW_SPORTS,workOutDataCode: Constant.activitySnowSportIosCode),
    WorkOutData(workOutDataName: Constant.activitySocialDanceIos, workOutDataImages: Constant.activityImagesDancing, datatype: HealthWorkoutActivityType.SOCIAL_DANCE,workOutDataCode: Constant.activitySocialDanceIosCode),
    WorkOutData(workOutDataName: Constant.activitySnowboardingIos, workOutDataImages: Constant.activityImagesSnowboarding, datatype: HealthWorkoutActivityType.SNOWBOARDING,workOutDataCode: Constant.activitySnowboardingIosCode),
    WorkOutData(workOutDataName: Constant.activitySoftballIos, workOutDataImages: Constant.activityImagesSoftball, datatype: HealthWorkoutActivityType.SOFTBALL,workOutDataCode: Constant.activitySoftballIosCode),
    WorkOutData(workOutDataName: Constant.activityStairIos, workOutDataImages: Constant.activityImagesStairClimbing, datatype: HealthWorkoutActivityType.STAIRS,workOutDataCode: Constant.activityStairIosCode),
    WorkOutData(workOutDataName: Constant.activityStepTrainingIos, workOutDataImages: Constant.activityImagesStrengthTraining, datatype: HealthWorkoutActivityType.STEP_TRAINING,workOutDataCode: Constant.activityStepTrainingIosCode),
    WorkOutData(workOutDataName: Constant.activitySurfingSportsIos, workOutDataImages: Constant.activityImagesSurfing, datatype: HealthWorkoutActivityType.SURFING_SPORTS,workOutDataCode: Constant.activitySurfingSportsIosCode),
    WorkOutData(workOutDataName: Constant.activityTableTennisIos, workOutDataImages: Constant.activityImagesTableTennis, datatype: HealthWorkoutActivityType.TABLE_TENNIS,workOutDataCode: Constant.activityTableTennisIosCode),
    WorkOutData(workOutDataName: Constant.activityTennisIos, workOutDataImages: Constant.activityImagesTennis, datatype: HealthWorkoutActivityType.TENNIS,workOutDataCode: Constant.activityTennisIosCode),
    WorkOutData(workOutDataName: Constant.activityTaiChiIos, workOutDataImages: Constant.activityImagesTaichi, datatype: HealthWorkoutActivityType.TAI_CHI,workOutDataCode: Constant.activityTaiChiIosCode),
    WorkOutData(workOutDataName: Constant.activityTraditionalStrengthTrainingIos, workOutDataImages: Constant.activityImagesStrengthTraining, datatype: HealthWorkoutActivityType.TRADITIONAL_STRENGTH_TRAINING,workOutDataCode: Constant.activityTraditionalStrengthTrainingIosCode),
    WorkOutData(workOutDataName: Constant.itemBicycling, workOutDataImages: Constant.iconBicycling, datatype: HealthWorkoutActivityType.BIKING,isShow: false,workOutDataCode: Constant.codeBicycling),
    WorkOutData(workOutDataName: Constant.itemJogging, workOutDataImages: Constant.iconJogging, datatype: HealthWorkoutActivityType.OTHER,isShow: false,workOutDataCode: Constant.codeJogging),
    WorkOutData(workOutDataName: Constant.itemRunning, workOutDataImages: Constant.iconRunning, datatype: HealthWorkoutActivityType.RUNNING,isShow: false,workOutDataCode: Constant.codeRunning),
    WorkOutData(workOutDataName: Constant.itemSwimming, workOutDataImages: Constant.iconSwimming, datatype: HealthWorkoutActivityType.SWIMMING,isShow: false,workOutDataCode: Constant.codeSwimming),
    WorkOutData(workOutDataName: Constant.itemWalking, workOutDataImages: Constant.iconWalking, datatype: HealthWorkoutActivityType.WALKING,isShow: false,workOutDataCode: Constant.codeWalking),
    WorkOutData(workOutDataName: Constant.itemWeights, workOutDataImages: Constant.iconWeights, datatype: HealthWorkoutActivityType.OTHER,isShow: false,workOutDataCode: Constant.codeWeights),
    WorkOutData(workOutDataName: Constant.activityWaterFitnessIos, workOutDataImages: Constant.activityImagesWaterPolo, datatype: HealthWorkoutActivityType.WATER_FITNESS,workOutDataCode: Constant.activityWaterFitnessIosCode),
    WorkOutData(workOutDataName: Constant.activityWheelChairRunPaceIos, workOutDataImages: Constant.activityImagesWheelchair, datatype: HealthWorkoutActivityType.WHEELCHAIR_RUN_PACE,workOutDataCode: Constant.activityWheelChairRunPaceIosCode),
    WorkOutData(workOutDataName: Constant.activityWheelChairWalkPaceIos, workOutDataImages: Constant.activityImagesTreadmillWalking, datatype: HealthWorkoutActivityType.WHEELCHAIR_WALK_PACE,workOutDataCode: Constant.activityWheelChairWalkPaceIosCode),
    WorkOutData(workOutDataName: Constant.activityWrestlingIos, workOutDataImages: Constant.activityImagesWrestling, datatype: HealthWorkoutActivityType.WRESTLING,workOutDataCode: Constant.activityWrestlingIosCode),
    WorkOutData(workOutDataName: Constant.activityYogaIos, workOutDataImages: Constant.activityImagesYoga, datatype: HealthWorkoutActivityType.YOGA,workOutDataCode: Constant.activityYogaIosCode),
    WorkOutData(workOutDataName: Constant.activityOtherIos, workOutDataImages: Constant.activityImagesOther, datatype: HealthWorkoutActivityType.OTHER,workOutDataCode: Constant.activityOtherIosCode),
  ];

  static List<WorkOutData> iconSetList(){
    List<WorkOutData> iconList = [];
    iconList.addAll(workOutDataListAndroid);
    for(int i =0;i<workOutDataListIos.length ; i++){
      if(iconList.where((element) => element.workOutDataName == workOutDataListIos[i].workOutDataName).toList().isEmpty){
        iconList.add(workOutDataListIos[i]);
      }
    }
    Debug.printLog("iconList.............${iconList.length}");
    return iconList;
  }

  /// Json to Base64
  static String jsonToBase64(jsonData) {
    // Convert JSON to String
    String jsonString = jsonEncode(jsonData);

    // Encode JSON String to Base64
    String base64String = base64Encode(utf8.encode(jsonString));

    Debug.printLog('JSON: $jsonString');
    Debug.printLog('Base64 Encoded: $base64String');
    return base64String;
  }

  ///Base64 to Json
  static Map<String, dynamic> base64ToJson(String base64String ) {
    // Decode Base64 string to UTF-8 bytes
    List<int> bytes = base64.decode(base64String);
    // Convert UTF-8 bytes to JSON String
    String jsonString = utf8.decode(bytes);
    // Convert JSON String to Map
    try{
      Map<String, dynamic> jsonData =  jsonDecode(jsonString);
      Debug.printLog('Base64 Encoded: $base64String');
      Debug.printLog('JSON: $jsonData');
      return jsonData;
    }catch(e){
      Debug.printLog("json DeCode Errror....$e");
      return <String,dynamic>{};
    }

  }

  /// Join Two Json in One Json
  static String storeJson(generalJson,activityJson){
    Map<String, dynamic> jsonBoth = {
      'generalJson': generalJson,
      'activityJson': activityJson,
    };
    String jsonBase64 = jsonToBase64(jsonBoth);
    return jsonBase64;
  }


  static callPushApiForConfigurationActivity() async {
    var json = jsonEncode(Constant.configurationInfo.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.configurationInfo, json);
    List<TrackingPref> trackingPref = Preference.shared.getTrackingPrefList(Preference.trackingPrefList)!;
    var jsonTracking = jsonEncode(trackingPref.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.trackingPrefList, jsonTracking);
    ServerModelJson? serverModel =  Utils.getPrimaryServerData();
    if(Constant.configurationInfo.isNotEmpty && trackingPref.isNotEmpty && serverModel != null &&
        Utils.getPatientId() != "" ){
      await Syncing.callApiForConfigurationData(Utils.storeJson(jsonTracking,json));
    }
  }

  static bool isBetween(DateTime a, DateTime b, DateTime c, DateTime d) {
    return (c.isAfter(a) && c.isBefore(b)) || (d.isAfter(a) && d.isBefore(b));
  }

 /* static bool isBetween(DateTime a, DateTime b, DateTime date) {
    return date.isAfter(a) && date.isBefore(b);
  }*/

  // static bool checkDateOverlap(List<ActivityLevelData> dateRanges, DateTime givenStartDate, DateTime givenEndDate,
  //     { ActivityLevelData? currentActivityData}) {
  //   if(currentActivityData != null){
  //     dateRanges = dateRanges.where((element) => element != currentActivityData).toList();
  //   }
  //
  //   for (var range in dateRanges) {
  //     DateTime rangeStartDate = range.activityStartDate;
  //     DateTime rangeEndDate = range.activityEndDate;
  //
  //     if ((givenStartDate.isAfter(rangeStartDate) || givenStartDate.isAtSameMomentAs(rangeStartDate)) &&
  //         (givenStartDate.isBefore(rangeEndDate) || givenStartDate.isAtSameMomentAs(rangeEndDate))) {
  //       return true; // There is an overlap
  //     }
  //
  //     if ((givenEndDate.isAfter(rangeStartDate) || givenEndDate.isAtSameMomentAs(rangeStartDate)) &&
  //         (givenEndDate.isBefore(rangeEndDate) || givenEndDate.isAtSameMomentAs(rangeEndDate))) {
  //       return true; // There is an overlap
  //     }
  //
  //   }
  //
  //   return false;
  // }

  static bool checkDateOverlapFromDb(List<ActivityTable> dateRanges,  DateTime givenStartDate, DateTime givenEndDate,
      { ActivityTable? currentActivityData}) {
    if(currentActivityData != null){
      dateRanges = dateRanges.where((element) => element != currentActivityData).toList();
    }
    List<DateTime> dateTimeList = generateDateTimeList(givenStartDate, givenEndDate);

    for (var range in dateRanges) {
      DateTime rangeStartDate = range.activityStartDate ?? DateTime.now();
      DateTime rangeEndDate = range.activityEndDate ?? DateTime.now();
      var rangeDateList = generateDateTimeList(rangeStartDate, rangeEndDate);

      var a = rangeDateList.where((element) => dateTimeList.contains(element));
      if(a.isNotEmpty){
        return true;
      }

      if (dateTimeList.contains(rangeStartDate) || dateTimeList.contains(rangeEndDate) || dateTimeList.isEmpty) {
        return true;
      }
    }
    return false;
  }

  static bool checkDateOverlap(List<ActivityLevelData> dateRanges,  DateTime givenStartDate, DateTime givenEndDate,
      { ActivityLevelData? currentActivityData}) {
    if(currentActivityData != null){
      dateRanges = dateRanges.where((element) => element != currentActivityData).toList();
    }
    List<DateTime> dateTimeList = generateDateTimeList(givenStartDate, givenEndDate);

    for (var range in dateRanges) {
      DateTime rangeStartDate = range.activityStartDate;
      DateTime rangeEndDate = range.activityEndDate;
      var rangeDateList = generateDateTimeList(rangeStartDate, rangeEndDate);

      var a = rangeDateList.where((element) => dateTimeList.contains(element));
      if(a.isNotEmpty){
        return true;
      }

      if (dateTimeList.contains(rangeStartDate) || dateTimeList.contains(rangeEndDate) || dateTimeList.isEmpty) {
        return true;
      }
    }
    return false;
  }

  static List<DateTime> generateDateTimeList(DateTime startDate, DateTime endDate) {
    List<DateTime> dateTimeList = [];
    // Add the start date and end date directly
    dateTimeList.add(startDate);
    dateTimeList.add(endDate);
    for (DateTime date = startDate; date.isBefore(endDate); date = date.add(const Duration(days: 1))) {
      for (int hour = 0; hour < 24; hour++) {
        for (int minute = 0; minute < 60; minute += 1) {
          DateTime dateTime = DateTime(date.year, date.month, date.day, hour, minute);
          if (dateTime.isAfter(startDate) && dateTime.isBefore(endDate)) {
            dateTimeList.add(dateTime);
          }
        }
      }
    }

    return dateTimeList;
  }

  static apiCallApplyDelay10second() async {
    await Future.delayed(const Duration(seconds: 10));
    Debug.printLog("delayed Completed 10 second..........................");
  }

  static Future<String> getPackageName() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  static getConfigurationActivityDataListApi() async {
    var listData = await PaaProfiles.getConfigurationActivityData();
    if(listData != null) {
      if (listData.resourceType == R4ResourceType.Bundle) {
        if (listData != null && listData.entry != null) {
          int length = listData.entry.length;
          for (int i = 0; i < length; i++) {
            var data = listData.entry[i];
            if (data.resource.resourceType ==
                R4ResourceType.DocumentReference) {
              var id;
              if (data.resource.id != null) {
                id = data.resource.id.toString();
              }
              var jsonDataActivity;
              // var jsonData = data.resource.content[0].attachment.data;
              if (data.resource.content[0].attachment != null) {
                if (data.resource.content[0].attachment.data != null) {
                  jsonDataActivity =
                      data.resource.content[0].attachment.data.value.toString();
                }
              }
              if (jsonDataActivity != "" && (id != null || id != "null") &&
                  jsonDataActivity != null) {
                Preference.shared.setString(
                    Preference.idActivityConfiguration, id);
                var dataJson = Utils.base64ToJson(jsonDataActivity);
                var generalJson = dataJson[Constant.generalJson];
                var activityJson = dataJson[Constant.activityJson];
                Preference.shared.setList(
                    Preference.trackingPrefList, generalJson);
                Preference.shared.setList(
                    Preference.configurationInfo, activityJson);
                List<ConfigurationClass> prefData = Preference.shared
                    .getConfigPrefList(Preference.configurationInfo) ?? [];
                List<TrackingPref> prefDataGeneralJson = Preference.shared
                    .getTrackingPrefList(Preference.trackingPrefList) ?? [];
                Debug.printLog("Configuration data length.... ${prefData
                    .length}.......${prefDataGeneralJson.length}");
              }
              Debug.printLog("DocumentReference id......$id ");
            }
          }
        }
      }
    }
  }

  static Map<String, List<HasMemberListData>> groupBy(List<HasMemberListData> data, String Function(HasMemberListData) keyExtractor) {
    Map<String, List<HasMemberListData>> groupedMap = {};

    for (var obj in data) {
      var key = keyExtractor(obj);
      groupedMap[key] ??= [];
      groupedMap[key]?.add(obj);
    }

    return groupedMap;
  }

  static DateTime changeDateFormatBasedOnDBDate(DateTime dateTime){
    return DateTime(dateTime.year, dateTime.month, dateTime.day, dateTime.hour, dateTime.minute);
  }

  static DateTime changeDateFormatBasedOnDBDateWithOutTIme(DateTime dateTime){
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static DateTime convertUtcToLocal(dynamic value){
    var splitStr = value.valueString.toString().split("T")[0].toString();
    splitStr += " ${
        value.valueString
            .toString()
            .split("T")[1]
            .toString()
            .split(".")[0]
            .toString()
    }";
    return DateTime.parse(splitStr);
  }

  static void showSnackBarAPI(BuildContext context,String title) {
    final snackBar = SnackBar(
      content: Text(title),
      backgroundColor: CColor.primaryColor,
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'Dismiss',
        disabledTextColor: Colors.white,
        textColor: Colors.yellow,
        onPressed: () {
          //Do whatever you want
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static DateTime convertDateTimeFormat(DateTime date){
    return DateTime(date.year,date.month,date.day);
  }

  static setLastAPICalledDate(){
    Preference.shared.setString(Preference.lastApiCalledTime, DateTime.now().toString());
  }
  static setFirstTimeCallApi(bool isValues){
    Preference.shared.setBool(Preference.isFirstTimeTracking, isValues);
  }

  static getLastAPICalledDate(){
    return Preference.shared.getString(Preference.lastApiCalledTime) ?? "";
  }

  static Future<Map> getAccessTokenFromRefreshToken(String refreshToken,String clientId,String authToken) async {
    // var url = Uri.parse('http://143.198.107.157:8081/realms/physical_activity/protocol/openid-connect/token');
    var tokenUrl = Preference.shared.getString(Preference.tokenUrl) ?? "";
    if(tokenUrl == ""){
      return {};
    }
    // var url = Uri.parse('http://143.198.107.157:8081/realms/physical_activity/protocol/openid-connect/token');
    var url = Uri.parse(tokenUrl);
    var response = await http.post(
      url,
      headers: {
        // 'Content-Type': 'application/x-www-form-urlencoded',
        "authorization": "bearer $authToken",
        "access-control-allow-origin": "*",
        "access-control-allow-methods": "post",
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'grant_type': 'refresh_token',
        'client_id': clientId,
        'refresh_token':refreshToken,
      },
    );
    var token = {};
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      token["access_token"] = jsonResponse['access_token'];
      token["expires_in"] = jsonResponse['expires_in'];
      token["refresh_token"] = jsonResponse['refresh_token'];
      token["id_token"] = jsonResponse['id_token'];
    } else {
      Debug.printLog('Request failed with status: ${response.statusCode}.');
    }
    return token;
  }

  static setPatientDetailIdWise() async {
    // List getServerList  = Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed) ?? [];

    if(Preference.shared.getServerListedAllUrl(Preference.serverUrlAllListed)!.where((element) => element.isSelected && element.isPrimary && element.isSecure).toList().isNotEmpty){
      var primaryServer = getServerList.where((element) => element.isSelected && element.isPrimary).toList();
      if(primaryServer.isEmpty){
        return;
      }
      var indexOfPrimaryServer = getServerList.indexWhere((element) => element.isSelected && element.isPrimary).toInt();
      if(indexOfPrimaryServer == -1){
        return;
      }
      Debug.printLog("setPractitionerDetailIdWise....${primaryServer.length}  $indexOfPrimaryServer");
      var listData = await PaaProfiles.getPatientDetailIdWise(
          R4ResourceType.Patient,
          getServerList[indexOfPrimaryServer].patientId);
      if (listData.resourceType == R4ResourceType.Bundle) {
        if (listData != null && listData.entry != null) {
          int length = listData.entry.length;
          for (int i = 0; i < length; i++) {
            if (listData.entry[i].resource.resourceType ==
                R4ResourceType.Patient) {
              var data = listData.entry[i];
              var id;
              if (data.resource.id != null) {
                id = data.resource.id.toString();
              }
              var lName = "";
              try {
                lName = data.resource.name[0].family.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              var fName = "";
              List<String> givenNameList = [];
              try {
                for(int i = 0; i<data.resource.name[0].given.length;i++){
                  givenNameList.add("${data.resource.name[0].given[i]} ");
                  fName += "${data.resource.name[0].given[i]} ";
                }
              } catch (e) {
                Debug.printLog("fName...$e");
              }


              var gender = "";
              try {
                gender = Utils.capitalizeFirstLetter(data.resource.gender.toString());
              } catch (e) {
                Debug.printLog("lName...$e");
              }

              var dob = "";
              try {
                dob = data.resource.birthDate.toString();
              } catch (e) {
                Debug.printLog("lName...$e");
              }

            getServerList[indexOfPrimaryServer].patientFName = fName;
            getServerList[indexOfPrimaryServer].patientLName = lName;
            getServerList[indexOfPrimaryServer].patientDOB = dob;
            getServerList[indexOfPrimaryServer].patientGender = gender;
            var json = jsonEncode(getServerList.map((e) => e.toJson()).toList());
            Preference.shared.setList(Preference.serverUrlAllListed, json);

              Debug.printLog(
                  "patient info set practitioner data....$fName  $lName  $gender  $dob  $id");
            }
          }
        }
      }
    }
  }

  static Future<Map> checkWhetherSecureOrNot(String serverUrl,
      BuildContext context) async {
    var isShowDialog = false;
    var token = {};
    Timer? timer;
    try {
      serverUrl = "$serverUrl/metadata";
      Utils.showDialogForProgress(
          context, Constant.txtPleaseWait, Constant.txtConnectingUrlProgress);
      isShowDialog = true;

      int totalSec = Constant.totalSecondOfTimeOut;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (totalSec > 0) {
          totalSec--;
          Debug.printLog("Total sec.....$totalSec");
        } else {
          timer.cancel();
          if(isShowDialog) {
            Get.back();
          }
          Get.back();
          Debug.printLog("Time out.....$totalSec");
          Utils.showErrorDialog(context, Constant.txtError, Constant.connectionTimeOut);
          return;
        }
      });
      var url = Uri.parse(serverUrl);
      var response = await http.get(
        url,
      );
      if (response.statusCode == 200) {
        try{
          timer.cancel();
        }catch(e){
          Debug.printLog("Try catch for timer cancel....$e");
        }
        var jsonResponse = jsonDecode(response.body);
        token[Constant.metaDataServerName] = Constant.metaDataServerNameDefault;
        token[Constant.metaDataServerSecure] = false;

        if(jsonResponse['software'] != null){
          if(jsonResponse['software']['name'] != null){
            token[Constant.metaDataServerName] = jsonResponse['software']['name'];
          }
        }

        if(jsonResponse['rest'] != null){
          if(jsonResponse['rest'][0]['security'] != null){
            token[Constant.metaDataServerSecure] = jsonResponse['rest'][0]['security'] != null;
          }
        }

        token[Constant.msg] = Constant.successFullyConnected;
        Debug.printLog("Meta data based on URL....$jsonResponse");
      } else {
        try{
          timer.cancel();
        }catch(e){
          Debug.printLog("Try catch for timer cancel....$e");
        }
        token[Constant.msg] = Constant.failedConnected;
        Debug.printLog('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      try{
        timer?.cancel();
      }catch(e){
        Debug.printLog("Try catch for timer cancel....$e");
      }
      isShowDialog = false;
      token[Constant.msg] = Constant.failedConnected;
      Debug.printLog(e.toString());
    }
    return token;
  }

  static bool isValidDateFormat(String dateString,String formattedDate) {
    try {
      Debug.printLog("dateString........${dateString}");
      DateTime parsedDate = DateTime.parse(dateString);
      String formattedDate = "${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.year}";
      DateTime parsedFormattedDate = DateTime.parse(formattedDate);
      if (parsedDate != parsedFormattedDate) {
        return false;
      }
    } catch (e) {
      return false;
    }
    return true;
  }

  static String checkDateFormat(String dateString ,String formattedDate) {
    if (isValidDateFormat(dateString,formattedDate)) {
       String date = DateFormat(formattedDate).format(DateTime.parse(dateString));
    return date;
    } else {
      return '';
    }
  }

  static String checkDate(String formattedDate) {
/*    if (isValidDateFormat(dateString,formattedDate)) {
       String date = DateFormat(formattedDate).format(DateTime.parse(dateString));
    return date;
    } else {
    }*/

    try{
      String date = DateFormat(Constant.commonDateFormatMmmDdYyyy).format(DateTime.parse(formattedDate));
      return date;
    }catch(e){
      return "";
    }

  }


  static wizardMode() async {
    await DataBaseHelper.shared.dbQRCodeBox?.clear();
    await DataBaseHelper.shared.dbMonthlyLogCodeBox?.clear();
    Preference.shared.setBool(Preference.keyWelcomeDetails,true);
    Preference.shared.setBool(Preference.keyHealthProvider,false);
    Preference.shared.setBool(Preference.keyIntegrationScreen,false);
    Preference.shared.setBool(Preference.keyGoalView,false);
    Preference.shared.setBool(Preference.keyConfiguration,false);
    Utils.setFirstTimeCallApi(true);
    Utils.getServerList.clear();
    var json = jsonEncode(Utils.getServerList.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.serverUrlAllListed, json);
    Constant.configurationInfo.clear();
    var jsonActivity = jsonEncode(
        Constant.configurationInfo.map((e) => e.toJson()).toList());
    Preference.shared.setList(Preference.configurationInfo, jsonActivity);
    Get.offAndToNamed(AppRoutes.welcomeScreen);
  }

  static showErrorDialog(BuildContext context,String title,String msg) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Wrap(
                children: [
                  Center(
                    child: Container(
                      padding: EdgeInsets.all(Sizes.width_5),
                      width: Get.width * 0.8,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(bottom: Sizes.height_1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: AppFontStyle.styleW700(CColor.red,
                                      (kIsWeb) ? FontSize.size_3 : FontSize.size_13),
                                ),
                                GestureDetector(
                                    onTap: (){
                                      Get.back();
                                    },
                                    child: const Icon(Icons.close))
                              ],
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(
                                top: Sizes.height_0_5
                            ),
                            child: Text(
                              msg,
                              style: AppFontStyle.styleW700(CColor.black,
                                  (kIsWeb) ? FontSize.size_3 : FontSize.size_11),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((value) => (value) {
      Debug.printLog("Close a Dialog");
    });
  }

  static Future<bool> isExpireTokenAPICall(String screenType,Function callback) async {
    Debug.printLog("isExpireTokenAPICall..type....$screenType");
    try {
      ServerModelJson primaryData;
      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
          element.isSelected && element.isSecure && element.isPrimary).toList();
      if (allSelectedServersUrl.isEmpty) {
        return false;
      }
      primaryData = allSelectedServersUrl[0];
      var isExpire = false;
      if (primaryData.isSecure && Utils.isExpiredToken(
          primaryData.lastLoggedTime, primaryData.expireTime)) {
        isExpire = true;
        if(screenType == Constant.screenTypeHistory){
          Debug.printLog("screenTypeHistory..type....$screenType");
          Get.back();
        }
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          showDialog(
            context: Get.context!,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return AlertDialog(
                title:  const Text(Constant.txtExpireTitle),
                content:   Text("${Constant.txtExpireDesc} For${primaryData.url}"),
                actions: <Widget>[
                  TextButton(
                    onPressed: () async {
                      Get.back();
                      await Utils.callSecureServerAPI(primaryData.url,
                          primaryData.clientId,
                          primaryData.title,
                          callBackFroAddServerIntoList: (value) {
                            if (value.isNotEmpty) {
                              var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
                                  element.isSecure && !element.isPrimary).toList();
                              if(allSelectedServersUrl.isEmpty) {
                                isExpire = false;
                                // callback.call(isExpire);
                              }else{
                                for(int i =0;i<allSelectedServersUrl.length;i++){
                                  if (allSelectedServersUrl[i].isSecure && Utils.isExpiredToken(
                                      allSelectedServersUrl[i].lastLoggedTime, allSelectedServersUrl[i].expireTime)) {
                                    isExpire = true;
                                    // callback.call(isExpire);
                                    WidgetsBinding.instance.addPostFrameCallback((_) async {
                                      showDialog(
                                        context: Get.context!,
                                        barrierDismissible: false,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title:  const Text(Constant.txtExpireTitle),
                                            content:   Text("${Constant.txtExpireDesc} For${allSelectedServersUrl[0].url}"),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () async {
                                                  Get.back();
                                                  await Utils.callSecureServerAPI(allSelectedServersUrl[i].url,
                                                      allSelectedServersUrl[i].clientId,
                                                      allSelectedServersUrl[i].title,
                                                      callBackFroAddServerIntoList: (value) {
                                                        if (value.isNotEmpty) {
                                                          var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
                                                              element.isSecure && !element.isPrimary).toList();
                                                          if(allSelectedServersUrl.isEmpty) {
                                                            isExpire = false;
                                                            callback.call(isExpire);
                                                          }else{
                                                            isExpire = true;
                                                            callback.call(isExpire);
                                                          }
                                                        }
                                                      });
                                                },
                                                child: const Text("Log in"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    });
                                  }
                                }
                              }
                            }
                          });
                    },
                    child: const Text("Log in"),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Cancel"),
                  ),
                ],
              );
            },
          );
        });
      }
      else{
        Debug.printLog("Not expire");
        var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSecure && !element.isPrimary).toList();
        if(allSelectedServersUrl.isEmpty) {
          isExpire = false;
          // callback.call(isExpire);
        }else{
          for(int i= 0;i<allSelectedServersUrl.length;i++){
            if(allSelectedServersUrl[i].isSecure && Utils.isExpiredToken(
                allSelectedServersUrl[i].lastLoggedTime, allSelectedServersUrl[i].expireTime)){
              // isExpire = true;
              // callback.call(isExpire);
              WidgetsBinding.instance.addPostFrameCallback((_) async {
                showDialog(
                  context: Get.context!,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title:  const Text(Constant.txtExpireTitle),
                      content:   Text("${Constant.txtExpireDesc} For${allSelectedServersUrl[0].url}"),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            Get.back();
                            await Utils.callSecureServerAPI(allSelectedServersUrl[i].url,
                                allSelectedServersUrl[i].clientId,
                                allSelectedServersUrl[i].title,
                                callBackFroAddServerIntoList: (value) {
                                  if (value.isNotEmpty) {
                                    var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" &&
                                        element.isSecure && !element.isPrimary).toList();
                                    if(allSelectedServersUrl.isEmpty) {
                                      isExpire = false;
                                      callback.call(isExpire);
                                    }else{
                                      isExpire = true;
                                      callback.call(isExpire);
                                    }
                                  }
                                });
                          },
                          child: const Text("Log in"),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: const Text("Cancel"),
                        ),
                      ],
                    );
                  },
                );
              });
            }else{
              isExpire = false;
              // callback.call(isExpire);
            }
          }

        }
      }
      return isExpire;
    } catch (e) {
      return false;
    }
  }


  /*static Future<bool> isExpireTokenAPICall(String screenType,Function callback) async {
    Debug.printLog("isExpireTokenAPICall..type....$screenType");
    try {
      ServerModelJson primaryData;
      var allSelectedServersUrl = Utils.getServerListPreference().where((element) => element.patientId != "" && element.isSecure).toList();
      if (allSelectedServersUrl.isEmpty) {
        return false;
      }
      var isExpire = false;
      for (int a = 0; a < allSelectedServersUrl.length; a++) {
        primaryData = allSelectedServersUrl[a];
        if (primaryData.isSecure && Utils.isExpiredToken(
            primaryData.lastLoggedTime, primaryData.expireTime)) {
          isExpire = true;
          if(screenType == Constant.screenTypeHistory){
            Debug.printLog("screenTypeHistory..type....$screenType");
            Get.back();
          }
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            showDialog(
              context: Get.context!,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return AlertDialog(
                  title:  const Text(Constant.txtExpireTitle),
                  content:   Text("${Constant.txtExpireDesc} For${primaryData.url}"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () async {
                        Get.back();
                        await Utils.callSecureServerAPI(primaryData.url,
                            primaryData.clientId,
                            primaryData.title,
                            callBackFroAddServerIntoList: (value) {
                              if (value.isNotEmpty) {
                                if(allSelectedServersUrl.length > a){
                                  var nextIndex = a++;
                                  ///nextIndex = When you back to login from previous server then
                                  ///If we have another server then we will check server token that it's expire or not
                                  if(allSelectedServersUrl[nextIndex].isSecure && Utils.isExpiredToken(
                                      allSelectedServersUrl[nextIndex].lastLoggedTime, allSelectedServersUrl[nextIndex].expireTime)){
                                    isExpire = true;
                                    callback.call(isExpire);
                                  }else{
                                    isExpire = false;
                                    callback.call(isExpire);
                                  }
                                }else{
                                  isExpire = false;
                                  callback.call(isExpire);
                                }

                              }
                            });
                      },
                      child: const Text("Log in"),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                );
              },
            );
          });
        }
      }
      return isExpire;
    } catch (e) {
      return false;
    }
  }*/


  static String uiStatusFromAPIStatus(String status){
    if(status == Constant.toDoStatusReady){
      status = Constant.statusAwaitingReview;
    }else if(status == Constant.toDoStatusInProgress){
      status = Constant.statusInProgress;
    }
    return status;
  }

  static Color uiStatusColorFromAPIStatus(String status){
    return CColor.statusRequestedColor;
  }

  static DateTime startDateTime(DateTime selectedDate){
    var dateParseStartPreviousWeek5 = Utils.findFirstDateOfTheWeekImport(selectedDate);
    var dateParseStartPreviousWeek4 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek5);
    var dateParseStartPreviousWeek3 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek4);
    var dateParseStartPreviousWeek2 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek3);
    var dateParseStartPreviousWeek1 = Utils.findFirstDateOfTheWeekPrevious(dateParseStartPreviousWeek2);
    return dateParseStartPreviousWeek1;
  }

  static DateTime endDateTime(DateTime selectedDate){
    var dateParseLastTimePreviousWeek5 = Utils.findLastDateOfTheWeekImport(selectedDate);
    return dateParseLastTimePreviousWeek5;
  }

  static deleteConfiguration(String id) async {
    ServerModelJson? serverModel =  Utils.getPrimaryServerData();
    var client = ProviderRequest.getClientUrlWise(serverModel!.url ?? "", serverModel.clientId,
        serverModel.authToken ?? "");

    if (client != null && client.fhirUri.value != null) {
      var request;
        request = FhirRequest.delete(
          base: client.fhirUri.value!,
          client: client,
          id: id,
          type: R4ResourceType.DocumentReference,
        );

      var token = serverModel.authToken;
      try {

        final response = await request.request(headers: Utils.getHeader(token));

        Debug.printLog(
            'Response from upload processResource......: ${response.toJson()}');
        // return result;
      } catch (e) {
        Debug.printLog(e.toString());
        return "error";
      }
    } else {
      return "error";
    }
  }

  static clearTrackingChartData() async {
    if(Utils.getServerListPreference().isNotEmpty) {
      Constant.isCalledAPI = false;
      await DataBaseHelper.shared.dbQRCodeBox?.clear();
      // await DataBaseHelper.shared.dbMonthlyLogCodeBox?.clear();
      Utils.setFirstTimeCallApi(true);
      Debug.printLog("Clean history Data");
    }
  }

  static List<String> timeFrame = [
    Constant.frameLastWeek,
    Constant.frame4Weeks,
    Constant.frame3Months,
    Constant.frame6Months,
    Constant.frame1Year,
    Constant.frameLifeTime,
  ];


  static DateTime findCurrentWeekLastDate(DateTime now){
    // Assuming the week starts on Sunday
    int currentWeekDay = now.weekday; // Monday = 1, ..., Sunday = 7
    DateTime firstDayOfWeek = now.subtract(Duration(days: currentWeekDay));
    DateTime lastDayOfWeek = firstDayOfWeek.add(Duration(days: 6));

    // Format the dates if needed
    String firstDayFormatted = DateFormat('yyyy-MM-dd').format(firstDayOfWeek);
    String lastDayFormatted = DateFormat('yyyy-MM-dd').format(lastDayOfWeek);

    Debug.printLog('First day of the week: $firstDayFormatted');
    Debug.printLog('Last day of the week: $lastDayFormatted');
    return lastDayOfWeek;
  }
  static String htmlToPlainText(String htmlContent) {
    if(htmlContent == "")  return "";
    final RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    String plainText = htmlContent.replaceAll(exp, '');
    return plainText;
  }


  static String extractTextFromHtml(String htmlString) {
    final document = XmlDocument.parse(htmlString);
    var htmlData =  document.rootElement.children[1].firstChild.toString();
    // Debug.printLog("....$htmlData");
    return htmlData.toString();


    // return htmlString.toString().split("<div xmlns=\"http://www.w3.org/1999/xhtml\">\n<p> ")[1].split("</p>\n</div>")[0].toString();
  }

  static Future<void> launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }


  static clearGoalData() async {
    await DataBaseHelper.shared.dbGoalCodeBox?.clear();
    await DataBaseHelper.shared.dbNoteDataCodeBox?.clear();
  }

  static DateTime getLastDateOfCurrentMonth() {
    DateTime now = DateTime.now();
    int lastDay = DateTime(now.year, now.month + 1, 0).day;
    return DateTime(now.year, now.month, lastDay);
  }

  static DateTime getFirstDateOfMonth(int month, int year) {
    return DateTime(year, month, 1);
  }

  static DateTime getLastDateOfMonth(int month, int year) {
    int lastDay = DateTime(year, month + 1, 0).day;
    return DateTime(year, month, lastDay);
  }

  static String getMonthName(int monthNumber,int year) {
    if (monthNumber < 1 || monthNumber > 12) {
      throw ArgumentError('Month number must be between 1 and 12.');
    }
    DateTime date = DateTime(year, monthNumber);
    return DateFormat.MMM().format(date);
  }

  static int getMonthNumber(String monthName) {
    int monthNumber = Constant.months.indexOf(monthName);

    if (monthNumber == 0) {
      throw ArgumentError('Invalid month name: $monthName');
    }

    return monthNumber;
  }

  static List<DateTime> getDatesInMonth(int year, String monthName) {
    int month = getMonthNumber(monthName);
    List<DateTime> dates = [];
    int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      dates.add(DateTime(year, month, i));
    }
    // Debug.printLog("getDatesInMonth...$dates");
    return dates;
  }

  static List<DateTime> getDatesInMonthCountWise(int year, int month) {
    List<DateTime> dates = [];
    int daysInMonth = DateTime(year, month + 1, 0).day;

    for (int i = 1; i <= daysInMonth; i++) {
      dates.add(DateTime(year, month, i));
    }
    // Debug.printLog("getDatesInMonth...$dates");
    return dates;
  }

  static String getHtmlFromDelta(String jsonData) {
    Debug.printLog('getHtmlFromDelta before: $jsonData');
    try {
      List<Map<String, dynamic>> parsedList = jsonDecode(jsonData).cast<Map<String, dynamic>>();
      final converter = QuillDeltaToHtmlConverter(parsedList);
      final html = converter.convert();
      Debug.printLog('getHtmlFromDelta: after $html.......$converter');
      return html;
    } catch (e) {
      print('Error converting JSON to HTML: $e');
      return ''; // or handle error as needed
    }
  }

  int getTotalWeeksInMonth(int month, int year) {
    ///  DateTime date = DateTime(2023, 8, 15); // Example date
    ///   int monthDates = getMonthStartAndEndDate(date);
    /// Get the first day of the month
    final DateTime firstDayOfMonth = DateTime(year, month, 1);

    // Get the total number of days in the month
    final DateTime nextMonth = (month == 12) ? DateTime(year + 1, 1, 1) : DateTime(year, month + 1, 1);
    final int totalDaysInMonth = nextMonth.subtract(const Duration(days: 1)).day;

    // Calculate the total number of weeks in the month
    final int totalWeeks = (totalDaysInMonth / 7).round();

    return totalWeeks;
  }

  static DateTime getMonthStartDate(DateTime date) {
    DateTime startDate = DateTime(date.year, date.month, 1);
    return startDate;
  }

  static DateTime getMonthEndDate(DateTime date) {
    DateTime endDate = DateTime(date.year, date.month + 1, 0);
    return endDate;
  }

  static bool manageCalenderInNavigation(){
    return true;
  }


  static List<DateTime> generateDateList(DateTime start, DateTime end) {
    List<DateTime> dates = [];
    DateTime currentDate = start;

    while (currentDate.isBefore(end) || currentDate.isAtSameMomentAs(end)) {
      dates.add(currentDate);
      currentDate = currentDate.add(Duration(days: 1));
    }

    return dates;
  }


  static bool stringToBool(String value) {
    return value.toLowerCase() == 'true';
  }

}