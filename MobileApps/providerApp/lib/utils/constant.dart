import 'dart:io';

import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/db_helper/box/activity_data.dart';
import 'package:banny_table/ui/graph/datamodel/graphDatamodel.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../ui/configuration/datamodel/configuration_datamodel.dart';


class Constant {

  static const failureCode = false;
  static const successCode = true;
  static const responseFailureCode = 400;
  static const responseSuccessCode = 200;
  static const responseNoDataCode = 202;
  static const responseCreatedCode = 201;
  static const responseUnauthorizedCode = 401;
  static const responsePaymentRequired = 402;
  static const responseRequired = 422;
  static const responseInCorrectString = "404";
  static const responseNotFound = 404;


  static bool isEditMode = false;
  static bool isAutoCalMode = false;

  static const baseUrl = "";

  static const fontFamilyPoppins = "Poppins";
  static const healthProviderImage = "assets/images/health_provider.svg";

  static const returnType = "return";
  static const type = "type";
  static const fhirParameters = "fhirParameters";
  static const isSuccess = "isSuccess";
  static const msg = "msg";
  static const failed = "Failed";
  static const successFullyConnected = "Successfully connected";
  static const accoutnNotApproved = "Account does not have practitioner linked yet. Please contact admin of the application";
  static const providerAcNotFound = "Provider account not found";
  static const normalDate = "normalDate";
  static const periodDate = "periodDate";

  static const tableActivity = "activity";
  static const tableMonthlyLog = "monthlyLog";
  static const tableGoal = "tableGoal";
  static const tableReferral = "tableReferral";
  static const tableReferralRoute = "tableReferralRoute";
  static const tableNoteData = "tableNoteData";
  static const tableCondition= "tableCondition";
  static const tableCarePlan = "tableCarePlan";
  static const tableToDoList = "tableToDoList";
  static const tableExerciseList = "tableExercise";


  /*shared_preferences Keys*/
  static const  keySyncingTime = "syncingTime";
  static const  keySyncing = "keySyncing";
  static const  keyWelcomeDetails = "keyWelcomeDetails";
  static const  keyIndependentPatient = "keyIndependentPatient";
  static const  txtDisclaimer = "Disclaimer";

  static const serviceRequest = "ServiceRequest";
  static const task = "Task";
  static const carePlan = "CarePlan";
  static const condition = "Condition";
  static const goal = "Goal";
  static const observation = "Observation";
  static const monthly = "Monthly";
  static const trackingChart = "TrackingChart";

  static const titleNon = "None";
  static const titleDaysStr = "Days Strength";
  static const titleCalories = "Calories";
  static const titleSteps = "Steps";
  static const titleHeartRateRest = "Heart Rate Rest";
  static const titleHeartRatePeak = "Heart Rate Peak";
  static const titleExperience = "Experience";
  static const titleParent = "Parent";
  static const titleActivityType = "Activity Type";
  static const totalMinPerDay = "Total min per day";
  static const modMinPerDay = "Mod min per day";
  static const vigMinPerDay = "Vig min per day";
  static const strengthPerDay = "Mod min per day";


  static const itemBicycling = "Bicycling";
  static const itemJogging = "Jogging";
  static const itemRunning = "Running";
  static const itemSwimming = "Swimming";
  static const itemWalking = "Walking";
  static const itemWeights = "Weights";
  static const itemMixed = "Mixed";

  static const welcomeIcon =  "assets/images/welcome.png";
  static const welcomeIconLogo =  "assets/images/provider_logo.png";



  /*Icons*/
  static const iconBicycling =  "assets/icons/ic_bicycle.png";
  static const iconJogging = "assets/icons/ic_jogging.png";
  static const iconRunning = "assets/icons/ic_running.png";
  static const iconSwimming = "assets/icons/ic_swimming.png";
  static const iconWalking = "assets/icons/ic_walking.png";
  static const iconWeights = "assets/icons/ic_strength.png";
  static const iconMixed = "assets/icons/ic_mixed.png";


  static const iconActivity = "assets/icons/ic_activity_add.png";


  static const timeDay = "Day";
  static const timeWeek = "Week";

  static const frameLastWeek = "Last Week";
  static const frame2Weeks = "2 Weeks";
  static const frame3Weeks = "3 Weeks";
  static const frame4Weeks = "4 Weeks";
  static const frame5Weeks = "5 Weeks";
  static const frame6Weeks = "6 Weeks";
  static const frame2Months = "2 Months";
  static const frame3Months = "3 Months";
  static const frame4Months = "4 Months";
  static const frame5Months = "5 Months";
  static const frame6Months = "6 Months";
  static const frame7Months = "7 Months";
  static const frame8Months = "8 Months";
  static const frame9Months = "9 Months";
  static const frame10Months = "10 Months";
  static const frame11Months = "11 Months";
  static const frame1Year = "1 Year";
  static const frameLifeTime = "Life Time";

  static const activityMinShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemMixed
  ];
  static const daysStrengthShowWithItem = [itemWeights, itemMixed];

  static const caloriesShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemMixed
  ];
  static const stepsShowWithItem = [
    itemJogging,
    itemRunning,
    itemWalking,
    itemMixed
  ];
  static const heartPeckShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemWeights,
    itemMixed
  ];
  static const experienceShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemWeights,
    itemMixed
  ];
  /*And Use configurationInfo screen*/

  static List<ConfigurationClass> configurationInfo = [
   /* ConfigurationClass(itemBicycling,iconBicycling),
    ConfigurationClass(itemJogging,iconJogging),
    ConfigurationClass(itemRunning,iconRunning),
    ConfigurationClass(itemSwimming,iconSwimming),
    ConfigurationClass(itemWalking,iconWalking),
    ConfigurationClass(itemWeights,iconWeights),
    ConfigurationClass(itemMixed,iconMixed),*/
  ];

  static List<ConfigurationClass> configurationInfoGraphManage = [
  ];

  static List<PatientDataModel> patientList = [];


  static const typeWeek = 0;
  static const typeDay = 1;
  static const typeDaysData = 2;

  static var cursorHeightForWeb = Sizes.height_2;
  static var webTextFiledTextSize = FontSize.size_3;
  static var webTextFiledHeight = Sizes.height_2;
  static var limitOfValue = 100;
  static var limitOfWValue = 5;
  static var limitOfZValue = 100;

  static const activityMinutes = "Activity Minutes";
  static const activityMinutesMod = "Mod";
  static const trackingChartModHeader = "Mod\nMins";
  static const activityMinutesVig = "Vig";
  static const trackingChartVigHeader = "Vig\nMins";
  static const activityMinutesTotal = "Total";
  static const trackingChartTotalHeader = "Total\nMins";
  static const daysStrength = "Days Str.";
  static const calories = "Calories";
  static const steps = "Steps";
  static const heartRate = "Heart Rate";
  static const heartRateRest = "Rest";
  static const trackingChartRateRestHeader = "Rest\nHeart Rate";
  static const trackingChartRatePeakHeader = "Peak\nHeart Rate";
  static const heartRatePeak = "Peak";
  static const experience = "Experience";
  static const minutesType = "Minutes:- ";
  static const heartRateType = "Heart Rate:- ";
  static const caloriesType = "Calories:- ";
  static const stepsType = "Steps:- ";
  static const noteType = "Note ";

  // static const commonDateFormatDdMmYyyy = "dd/MM/yyyy";
  static const commonDateFormatDdMmYyyy = "yyyy-MM-dd";
  static const commonDateFormatMmDd = "MM-dd";
  static const commonDateFormatMmmDd = "MMM dd";
  static const commonDateFormatMMMM = "MMM";
  // static const commonDateForChart = "MM-dd\nyyyy";
  static const commonDateForChart = "yyyy\nMM-dd";
  static const commonDateFormatMmmDdYyyy = "MMM dd, yyyy";
  // static const commonDateFormatYyyyMM = "MMM dd, yyyy";
  static const commonDateFormatDd = "dd";
  static const commonDateFormatDdMMM = "dd\nMMM";
  static const commonDateFormatMMM = "MMM";
  static const commonDateFormatFullDate = "yyyy-MM-dd hh:mm a";
  static const commonDateFormatYYYYMMDDHHMM = "yyyy-MM-dd hh:mm";
  static const commonDateFormatForActivityConfiguration = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

  static const monthlyTotalWeek = 4;
  static const totalCountDayOfLast4Week = 28;
  static const totalDaysOf5Weeks = 35;
  static var commonHeightForTableBoxMobileHeader = (kIsWeb) ?Utils.sizesFontManage(Get.context!, 2.5): Sizes.height_6;
  static var commonHeightForTableBoxMobile = Sizes.height_5;
  static var commonHeightForTableBoxWebHeader = /*(kIsWeb) ? Utils.sizesFontManage(Get.context!, 5.5): */Sizes.height_8;
  static var commonHeightForTableBoxWeb =/*(kIsWeb) ?Utils.sizesFontManage(Get.context!, 2.9): */Sizes.height_7;

  static const smiley1Title = "Very Bad";
  static const smiley2Title = "Bad";
  static const smiley3Title = "Fairly Bad";
  static const smiley4Title = "Neutral";
  static const smiley5Title = "Fairly Good";
  static const smiley6Title = "Good";
  static const smiley7Title = "Very Good";

  static const smiley1ImgPath = "assets/icons/ic_very_sad.png";
  static const smiley2ImgPath = "assets/icons/ic_sad.png";
  static const smiley3ImgPath = "assets/icons/ic_fairly_sad.png";
  static const smiley4ImgPath = "assets/icons/ic_neutral.png";
  static const smiley5ImgPath = "assets/icons/ic_fairly_good.png";
  static const smiley6ImgPath = "assets/icons/ic_good.png";
  static const smiley7ImgPath = "assets/icons/ic_very_good.png";
  static const icQuestionMark = "assets/icons/ic_question_mark.png";


  /*Use on Home Screen*/
  static const homeRecordActivity = "assets/icons/ic_record.png";
  static const homeMonthlySummary = "assets/icons/ic_calender.png";
  static const homeTrackingChart = "assets/icons/ic_tracking.png";
  static const homeIcHistory = "assets/icons/ic_historyTraking.png";
  static const homeToDO = "assets/icons/ic_to_do_list_home.png";

  static const homeRecord = "Record Activity";
  static const homeMonthly = "Monthly Summary";
  static const homeTracking = "Tracking Chart ";
  static const homePatientTask = "Patient Tasks";
  static const homeReferral = "Referrals";
  static const homeExercisePrescription = "Exercise Prescriptions";


  /*use on Setting Screen*/
  static const settingEditMode  = "Edit mode";
  static String settingQRScan  = "QR connect provider";
  static const settingSwitchProfile  = "Switch profile";
  static const settingAutoCalculation  = "Auto calculation";
  static const settingConfiguration  = "Activity Configuration";
  static const settingProfileConfiguration  = "Profile Configuration";
  static const settingProfilePhysicalActivity  = "Switch to Provider view";
  static const settingReferral  = "Referral";
  static const settingCondition  = "Condition";
  static const settingCarePlan  = "CarePlan";
  static const settingToDoList  = "Create Task for Patient";
  static const settingSyncingTime  = "Syncing time";
  static const settingImportExportHealthData  = "Import/Export health data";
  static const settingImportHealthData  = "Import health data";
  static const settingExportHealthData  = "Export health data";
  static const googleFit  = "Google Fit";
  static const appleHealth  = "Apple Health";
  static const settingAuthentication = "Authentication";


  static const settingConfigurationIcons = "assets/icons/ic_Configuration.png";
  static const settingReferralIcons = "assets/icons/ic_referral.png";
  static const settingConditionIcons = "assets/icons/ic_care_plan.png";
  static const settingCarePlanIcons = "assets/icons/ic_conditions.png";
  static const settingSyncIcons = "assets/icons/ic_sync.png";
  static const settingImportIcons = "assets/icons/ic_import.png";
  static const settingExportIcons = "assets/icons/ic_export.png";
  static const settingIosImportExportIcons = "assets/icons/ic_apple_health.png";
  static const settingAndroidImportExportIcons = "assets/icons/ic_google_fit.png";
  static const settingHealthConnectIcons = "assets/icons/ic_health_conenct.png";
  static const settingProfileIcons = "assets/icons/ic_user.png";


  static const goalViewMainIcons = "assets/icons/ic_goalView.png";





  /*HeaderConfiguration*/

  static const configurationHeaderAll = "All";
  static const configurationHeaderEnabled = "Enabled?";
  static const configurationHeaderMinutes = "Minutes";
  static const configurationHeaderModerate = "Moderate Minutes";
  static const configurationHeaderVigorous = "Vigorous Minutes";
  static const configurationHeaderTotal = "Total Minutes";
  static const configurationNotes = "Notes";
  static const configurationHeaderDays = "Strength Days";
  static const configurationHeaderCalories = "Calories";
  static const configurationHeaderSteps = "Steps";
  static const configurationHeaderRest = "Resting Heart Rate";
  static const configurationHeaderPeck = "Peak Heart Rate";
  static const configurationExperience = "Experience";


  /*This Is Use on The Configuration Activity Manage*/
  static bool isTotal = true;
  static bool isModerate = true;
  static bool isVigorous = true;
  static bool isStrengthDay = true;
  static bool isCalories = true;
  static bool isSteps = true;
  static bool isRest = true;
  static bool isPeck = true;
  static bool isExperience = true;
  static bool isNotes = true;




  static const verificationStatusConfirmed = "Confirmed";
  static const verificationStatusRefuted = "Refuted";
  static const verificationStatusEnteredInError = "Entered-in-error";
  static const pleaseSelect = "Please select";





  static const jan = "Jan";
  static const feb = "Feb";
  static const mar = "Mar";
  static const apr = "Apr";
  static const may = "May";
  static const jun = "Jun";
  static const jul = "Jul";
  static const aug = "Aug";
  static const sep = "Sep";
  static const oct = "Oct";
  static const nov = "Nov";
  static const dec = "Dec";

  static List months = ["",jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec];

  static const headerDayPerWeek = "Day per week";
  static const headerAverageMin = "Avg min\n";
  static const headerAverageMinPerWeek = "Avg min per week";
  static const headerStrength = "Strength Days";

  static const typeDayPerWeek = 1;
  static const typeAvgMin = 2;
  static const typeAvgMinPerWeek = 3;
  static const typeStrength = 4;

  static const realTime = "Real-Time";
  static const daily  = "Daily";
  static const weekly = "Weekly";


  /*Header names*/
  static const headerLogScreen = "Physical Activity Tracker";
  static const headerHistoryScreen = "Tracking Chart";
  static const headerGraphLogScreen = "Patient Graphs";
  static const headerSettingScreen = "Setting";
  static const headerMixedScreen = "Mixed";
  static const headerConfigurationScreen = "Configuration";
  static const headerPatientProfileScreen  = "Patient Profile";
  static const headerPatientUserScreen  = "Patient";


  static const statusAll  = "All";
  static const statusDraft  = "Draft";
  static const statusActive  = "Active";
  static const statusOnHold  = "On-hold";
  static const statusRevoked  = "Revoked";
  static const statusCompleted  = "Completed";
  static const statusCanceled  = "Canceled";
  static const statusRejected  = "Rejected";
  static const statusEnteredInError  = "Entered-in-error";
  static const statusUnknown  = "Unknown";
  static const statusAwaitingReview  = "Awaiting Review";

  static const intentOriginalOrder  = "Original-order";
  static const intentOrder  = "Order";
  static const intentFillerOrder  = "Filler-order";

  static const priorityRoutine  = "Routine";
  static const priorityUrgent  = "Urgent";
  static const priorityAsap  = "Asap";
  static const priorityStat  = "Stat";

  static const codePAGuidance  = "PA guidance";
  static const codePAAssessment  = "PA assessment";
  static const codeCounselingAboutPhysicalActivity  = "Counseling about physical activity";
  static const codeReferralToPhysicalActivityProgram  = "Referral to physical activity program";
  static const codeDeterminationOfPhysicalActivityTolerance  = "Determination of physical activity tolerance";
  static const codeExerciseClass  = "Exercise class";
  static const codeExerciseTherapy  = "Exercise therapy";

  static const toDoCodeMakeContact  = "make-contact";
  static const toDoCodeReviewMaterial  = "review-material";
  static const toDoCodeGeneralInfo  = "general-information";
  static const toDoCodeCompleteQuestionnaire  = "complete-questionnaire";

  static const toDoCodeDisplayMakeContact  = "Make Contact";
  static const toDoCodeDisplayReviewMaterial  = "Review Material";
  static const toDoCodeDisplayGeneralInfo  = "General Information";
  static const toDoCodeDisplayCompleteQuestionnaire  = "Complete Questionnaire";

  static const lifeCycleProposed  = "Proposed";
  static const lifeCyclePlanned  = "Planned";
  static const lifeCycleAccepted  = "Accepted";
  static const lifeCycleActive  = "Active";
  static const lifeCycleOnHold  = "On-hold";
  static const lifeCycleCompleted  = "Completed";
  static const lifeCycleCancelled  = "Cancelled";
  static const lifeCycleEnteredInError  = "Entered-in-error";
  static const lifeCycleRejected  = "Rejected";

  static const lifeCycleActiveIcon  = "assets/icons/ic_active.png";
  static const lifeCycleCancelIcon  = "assets/icons/ic_cancel.png";
  static const lifeCycleCompletedIcon  = "assets/icons/ic_completed.png";
  static const lifeCycleHoldIcon  = "assets/icons/ic_on_hold.png";



  static const leftArrowIcons  = "assets/icons/left_arrow.png";
  static const rightArrowIcons  = "assets/icons/right_arrow.png";
  static const welcomeIcons  = "assets/icons/ic_welcome.png";
  static const icCloseIcons  = "assets/icons/ic_close.png";


  /*Activity IMages*/
  static const activityImagesAerobics = "assets/icons/activity/ic_Aerobics.png";
  static const activityImagesAmericanFootball = "assets/icons/activity/ic_american_football.png";
  static const activityImagesBadminton = "assets/icons/activity/ic_badminton.png";
  static const activityImagesBaseball = "assets/icons/activity/ic_baseball.png";
  static const activityImagesBasketball = "assets/icons/activity/ic_basketball.png";
  static const activityImagesBiathlon = "assets/icons/activity/ic_biathlon.png";
  static const activityImagesBoxingGlove = "assets/icons/activity/ic_boxing_glove.png";
  static const activityImagesCircuitTraining = "assets/icons/activity/ic_circuit_training.png";
  static const activityImagesCricket = "assets/icons/activity/ic_cricket.png";
  static const activityImagesCurlingStone = "assets/icons/activity/ic_curling_stone.png";
  static const activityImagesCycling = "assets/icons/activity/ic_cycling.png";
  static const activityImagesDancing = "assets/icons/activity/ic_dancing.png";
  static const activityImagesDumbbell = "assets/icons/activity/ic_dumbbell.png";
  static const activityImagesElliptical = "assets/icons/activity/ic_elliptical.png";
  static const activityImagesErgometer = "assets/icons/activity/ic_ergometer.png";
  static const activityImagesFencing = "assets/icons/activity/ic_fencing.png";
  static const activityImagesRollerSkating = "assets/icons/activity/ic_roller_skating.png";
  static const activityImagesScubaDiving = "assets/icons/activity/ic_scuba_diving.png";
  static const activityImagesSkiing = "assets/icons/activity/ic_skiing.png";
  static const activityImagesSoccerBall = "assets/icons/activity/ic_soccer_ball.png";
  static const activityImagesVolleyball = "assets/icons/activity/ic_volleyball.png";
  static const activityImagesWalking = "assets/icons/activity/ic_walking.png";
  static const activityImagesWaterskiing = "assets/icons/activity/ic_waterskiing.png";
  static const activityImagesYoga = "assets/icons/activity/ic_yoga.png";


  /*Activity Name*/
  static const activityAerobics = "Aerobics";
  static const activityAmericanFootball = "American Football";
  static const activityBadminton = "Badminton";
  static const activityBaseball = "Baseball";
  static const activityBasketball = "Basketball";
  static const activityBiathlon = "Biathlon";
  static const activityBoxingGlove = "BoxingGlove";
  static const activityCircuitTraining = "CircuitTraining";
  static const activityCricket = "Cricket";
  static const activityCurlingStone = "CurlingStone";
  static const activityCycling = "Cycling";
  static const activityDancing = "Dancing";
  static const activityDumbbell = "Dumbbell";
  static const activityElliptical = "Elliptical";
  static const activityErgoMeter = "Ergo meter";
  static const activityFencing = "Fencing";
  static const activityRollerSkating = "Roller-Skating";
  static const activityScubaDiving = "ScubaDiving";
  static const activitySkiing = "Skiing";
  static const activitySoccerBall = "SoccerBall";
  static const activityVolleyball = "Volleyball";
  static const activityWalking = "Walking";
  static const activityWaterSkiing = "Water skiing";
  static const activityYoga = "Yoga";






  static const lifeCycleStatusAccepted = "assets/icons/ic_play.png";
  static const lifeCycleStatusOnHold = "assets/icons/ic_pause.png";
  static const lifeCycleStatusCancelled = "assets/icons/ic_stop.png";
  static const lifeCycleStatusCompleted = "assets/icons/ic_checkMark_gray.png";


  static const icScreenHistory = "assets/icons/ic_history.png";


  /*static const goalTypeMinWeek  = "Min/Week";
  static const goalTypeMinDay  = "Min/Day";
  static const goalTypeMinMonth  = "Min/Month";
  static const goalTypeHourWeek  = "Hr/Week";
  static const goalTypeHourDay  = "Hr/Day";
  static const goalTypeHourMonth  = "Hr/Month";*/
  static const goalTypesStep  = "Average daily step count";
  static const goalTypesBPM  = "Target resting heart rate";
  static const goalTypesBPMRest  = "Minimum daily peak heart rate";
  static const goalTypesBPMCalories  = "Average daily calories burned";
  static const goalTypesDaysPerWeek  = "Average days per week of physical activity";
  static const goalTypesAverageMinutes  = "Average minutes per day of physical activity";
  static const goalTypesMinutesPerWeek  = "Average minutes per week of physical activity";
  static const goalTypesDaysPerWeekTraining  = "Average days per week of strength training";
/*ShowTarget*/
  static const goalTypesStepShow  = "Steps";
  static const goalTypesBPMShow  = "BPM";
  static const goalTypesBPMRestShow  = "BPM";
  static const goalTypesBPMCaloriesShow  = "Calories";
  static const goalTypesDaysPerWeekShow  = "Days per Week";
  static const goalTypesAverageMinutesShow  = "Average Minutes";
  static const goalTypesMinutesPerWeekShow  = "min/wk";
  static const goalTypesDaysPerWeekTrainingShow  = "Days per Week";

  static const achievementStatusInProgress  = "In-progress";
  static const achievementStatusImproving  = "Improving";
  static const achievementStatusWorsening   = "Worsening";
  static const achievementStatusNoChange  = "No-change";
  static const achievementStatusAchieved  = "Achieved";
  static const achievementStatusSustaining  = "Sustaining";
  static const achievementStatusNotAchieved  = "Not-achieved";
  static const achievementStatusNoProgress  = "No-progress";
  static const achievementStatusNotAttainable  = "Not-attainable";


  static const toDoStatusReady  = "Ready";
  static const toDoStatusRequested  = "Requested";
  static const toDoStatusInProgress  = "In-progress";
  static const toDoStatusCompleted  = "Completed";
  static const toDoStatusCancelled  = "Cancelled";
  static const toDoStatusOnHold  = "On-hold";
  static const toDoStatusFailed  = "Failed";
  static const toDoStatusEnteredInError  = "Entered-in-error";
  static const toDoStatusRejected  = "Rejected";
  static const toDoStatusDraft  = "Draft";
  static const toDoStatusAwaitingReview  = "Awaiting Review";

  static const popupStuffManual = "Keep manual";
  static const popupStuffReCalculate = "Recalculate";
  static const popupStuffCancel = "Cancel";
  static const popupStuffAutoCalculate = "Set default";

  /*Use on RoutingReferral*/
  static const routingReferralDraft  = "Draft ";
  static const routingReferralRequested  = "Requested ";
  static const routingReferralAccepted = "Accepted";
  static const routingReferralRejected = "Rejected";
  static const routingReferralCancelled  = "Cancelled ";
  static const routingReferralInProgress = "In-progress";
  static const routingReferralOnHold = "On-hold";
  static const routingReferralFailed  = "Failed ";
  static const routingReferralEnteredInError   = "Entered-in-error";
  static const routingReferralCompleted   = "Completed";

  static const icToToList = "assets/icons/ic_to_do_list.png";
  static const todoListContent = "addTodoListContent";


  static const graphActivityType  = 1;
  static const graphAMeaSureType  = 2;
  static const graphTimeType  = 3;
  static const graphTimeFrameType  = 4;

  static const delayTimeForOnChangeTextMilliseconds  = 1000;
  static const isSetDummyDataForGoal = false;

  // static const patientId = "41835319";
  // static String patientId = Utils.getPatientId();

  static const whenWhatWidth = 200.0;

  static String settingSetupWizard = "Click to initiate a guided setup if you skipped the initial configuration or wish to update your settings.";
  static const healthProviderIntro = "This app enables you to seamlessly integrate with your existing healthcare systems, whether you're using your own server or have access to an EHR FHIR server. By connecting, you can access patient's physical activity data, including, condition, care plans, referrals and exercise prescriptions.";
  static const healthProviderIntroShort = "Please proceed to setup the connections.";
  static const syncDescIos = "This app allows you to Connect with Apple Health if you grant permission. You can control what information (if any) is shared.";
  static const syncDescAndroid = "This app allows you to Connect with Apple Health if you grant permission. You can control what information (if any) is shared.";
  static String syncPermissionReadDetail = "Read: Allow this app to access steps, calories, minutes, or other Apple Health’s activity data.";
  static String syncPermissionWriteDetail = "Write: Share information you log in this application with other connected apps ${(Platform.isAndroid)?"Android":"iOS"} device";
  static String syncConfirmAndroidIos = "Do you want to configure syncing with ${(Platform.isAndroid)?"Health connect":"Apple health"} ?";
  static const healthProviderPatient = "Your provider has given you access to multiple patient records (likely family members or others you have a care relationship with). Please indicate which patient record is ‘yours’ and will be associated with steps or other activity tracked on this device.";
  static const healthProviderOrganization = "Does your organization have its own FHIR server for managing patient information, or will you be accessing information held in servers held by other organizations?";


  static const configurationIntro = "In this App, you can record information about your physical activity, including general information such as daily steps, as well as information about specific exercise events.";
  static const configurationIntroShort = "Choose Your Activities: Select the activities you love.";
  static const configurationIntroShortSecond = "Track What Matters: Decide what to measure – Steps, Heart Rate, Calories, and more.";
  static const configurationIntroInfo = "Would you like to customize your activities and tracking preferences now? ";
  static String trackingPrefDesc = "Select the data you want the app to track. There is no need to list data your phone will capture automatically if you have shared Apple Health permission.";
  static String activitySelectionDesc = "Which types of activities would you like to track? This app will only show activities you choose. (You can add or remove activities later too.)";

  /*Observation Pull*/
  /*Monthly value*/
  /*Unit*/
  static const unitObservationMonthDayPerWeek = "days per week";
  static const unitObservationMonthAvgMin = "minutes per day";
  static const unitObservationMonthAvgMinWeek = "minutes per week";
  static const unitObservationMonthStrengthDay = "days per week";

  /*Code*/
  static const codeObservationMonthDayPerWeek = "d/wk";
  static const codeObservationMonthAvgMin = "min/d";
  static const codeObservationMonthAvgMinWeek = "min/wk";
  static const codeObservationMonthStrengthDay = "d/wk";

  /*Display*/
  static const displayObservationMonthDayPerWeek = "How many days per week did you engage in moderate to strenuous physical activity in the last 30 days";
  static const displayObservationMonthAvgMin = "On those days that you engage in moderate to strenuous exercise, how many minutes, on average, do you exercise";
  static const displayObservationMonthAvgMinWeek = "Frequency of moderate to vigorous aerobic physical activity";
  static const displayObservationMonthStrengthDay = "Frequency of muscle-strengthening physical activity";



  /*Activity Data day wise*/
  /*Unit*/
  static const unitObservationActivityCalories = "kilokalories per day";
  static const unitObservationActivitySteps = "steps per day";
  static const unitObservationActivityHeartRest = "beats per minute";
  static const unitObservationActivityHeartPeck = "beats per minute";

  /*Code*/
  static const codeObservationActivityCalories = "kcal/d";
  static const codeObservationActivitySteps = "/d";
  static const codeObservationActivityHeartRest = "/min";
  static const codeObservationActivityHeartPeck = "/min";
  static bool isMonth = false;
  /*Display*/
  static const displayObservationActivityCalories = "Calories burned in 24 hour Calculated";
  static const displayObservationActivitySteps = "Number of steps in 24 hour Measured";
  static const displayObservationActivityHeartRest = "Heart rate --resting";
  static const displayObservationActivityHeartPeck = "Heart rate 24 hour maximum";

  static const codeDayPerWeek = "89555-7";
  static const codeAvgMin = "68516-4";
  static const codeAvgMinPerWeek = "82290-8";
  static const codeStrDays = "82291-6";

  static const codeRestHeart = "40443-4";
  static const codePeckHeart = "8873-2";
  static const codeCalories = "41979-6";
  static const codeSteps = "41950-7";
  static const codeTotalMinDay = "101691-4";
  static const codeModMinDay = "101689-8";
  static const codeVigMinDay = "101690-6";
  static const codeCheckBoxDay = "82291-6";

  static const patient = "Patient";
  static const provider = "Provider";
  // static const serviceProvider = "serviceProvider";


  static bool boolCalories = false;
  static bool boolSteps = false;
  static bool boolHeartRate = false;
  static bool boolExperience = false;
  static bool boolActivityMinMod = false;
  static bool boolActivityMinVig = false;

  static const txtPleaseWait = "Please wait";
  static const txtActivityDataProgress = "Tracking chart data sync is in progress    ";
  static const txtGraphDataProgress = "Graph data sync is in progress";
  static const txtMonthlyDataProgress = "Monthly data is in progress";
  static const txtToDoDataProgress = "ToDo task data is in progress";
  static const txtGoalDataProgress = "Goal data is in progress";
  static const txtPatientDataProgress = "patient add is in progress";
  static const txtPractitionerDataProgress = "Practitioner add is in progress";
  static const txtReferralDataProgress = "Referral data is in progress";
  static const txtConditionDataProgress = "Condition data is in progress";
  static const txtCarePlanDataProgress = "Careplan data is in progress";
  static const txtConnectingUrlProgress = "Connection is in progress...";

  static const txtHealthConnect = "Health connect";
  static const txtAppleHealth = "Apple health";
  static const txtWelcomeMessage = "Welcome to the Physical Activity Provider App!";
  static const txtWelcomeAllow = "This app supports you in:";
  static const txtActivityMonitoring = "Activity Monitoring : ";
  static const txtActivityMonitoringDesc = "Monitor patient physical activity, including steps, calories burned, heart rate, and activity minutes.";
  static const txtActivityCareCoordination = "Care Coordination : ";
  static const txtActivityCareCoordinationDesc = " Review, edit, and create Conditions, Care Plans, Exercise Prescriptions, Goals, and Referrals for comprehensive patient care.";
  static const txtActivityPatientInteraction = "Patient Interaction : ";
  static const txtActivityPatientInteractionDesc = "Engage with patients directly, such as creating tasks for them or requesting them to fill out forms.";
  static const txtActivitySystemManagement = "System Management: ";
  static const txtActivitySystemManagementDesc = "Seamlessly search for and manage patient information, enhancing operational efficiency and patient care delivery.";

  static const server1Hapi = "https://hapi.fhir.org/baseR4";
  static const server2Fire = "https://server.fire.ly/r4";
  static const server6Fire = "https://server.fire.ly/r5";
  static const server3Meld = "https://gw.interop.community/PAA/data";
  static const server5Meld = "https://gw.interop.community/Physical/open";

  static const local = "http://143.198.107.157:8080/fhir";
  // physical_activity
  //admin@gmail.com 1234
  //carry@gmail.com
  ///https://fhir.testphysicalactivity.com/fhir?client_id=physical_activity

  static const clientIdMeld = "37862658-025c-42b3-ba86-8c16452c2e22";

  static const local1 = "http://192.168.1.12:8082/fhir";
  static const local2 = "http://192.168.1.12:8081/fhir";
  static const local3 = "http://192.168.1.12:8080/fhir";

  static const profileTypeInitProvider = "profileTypeInitProvider";
  static const profileTypeInitPatient = "profileTypeInitPatient";
  static const profileTypeSetting = "profileTypeSetting";

  static const headerProfilePatient = "Patient profile";
  static const headerProfileProvider = "Provider profile";
  static const headerSelectProvider = "Select Provider";
  static const headerSelectPatient = "Select Patient";

  static const todoFromAssigned = "todoFromAssigned";
  static const todoFromCreated = "todoFromCreated";
  static const todoFromSetting = "todoFromSetting";
  static const conditionFromCreated = "conditionFromCreated";
  static const todoMsg = "Patient task data getting....";


  ///Monthly Summary
  static const dayPerWeek = "For an average week in the last 30 days, how many days per week did you engage in moderate to vigorous exercise (like walking fast, running, jogging, dancing, swimming, biking, or other activities that cause a light or heavy sweat)?";
  static const avgMin = " On those days that you engage in moderate to vigorous exercise, how many minutes, on average, do you exercise?";
  static const avgMinPerWeek = "The product of the two Exercise Vital Sign (EVS) measures, giving an average amount of moderate to vigorous physical activity in minutes/week (and captured using LOINC code 82290-8)";
  static const strengthDays = "An indication of the frequency of strength-based exercises a patient has performed, expressed as days/week (and captured using LOINC code 82291-6)";
  static const genderMale = "Male";
  static const genderFemale = "Female";
  static const genderOther = "Other";
  static const genderUnknown = "Unknown";


  static const phoneNumberAdd = "addPhoneNumber" ;
  static const emergencyPhoneNumberAdd = "emergencyPhoneNumberAdd" ;
  static const emailIdAdd = "addEmailId" ;
  static const qualificationAdd = "addQualification" ;
  static const addAddressAdd = "addAddress" ;
  static const gpAdd = "gpAdd" ;
  static const firstNameAdd = "firstNameAdd" ;
  static const givenNameAdd = "givenNameAdd" ;

  static const addressTypeResidence = "Residence" ;
  static const addressTypeMailing = "Mailing" ;
  static const addressTypeBoth = "Both" ;

  static const communicationEnglish = "English (US) " ;
  static const communicationEnglishCanada = "English (Canada) " ;
  static const communicationFrench = "French" ;
  static const communicationKorean = "Korean" ;
  static const communicationGerman = "German" ;


  static const phoneNoTypeWork = "Work" ;
  static const phoneNoTypeHome = "Home" ;
  // static const phoneNoTypeOld = "Old" ;
  static const phoneNoTypeMobile = "Mobile" ;
  static const emailType = "email" ;


  static TextEditingController historyCount = TextEditingController(text: "5");

/*  static const conditionHypertension = "Hypertension" ;
  static const conditionDiabetes = "Diabetes" ;
  static const conditionObesity = "Obesity" ;
  static const conditionHighBloodPressure = "High blood pressure" ;
  static const conditionHighCholesterol = "High cholesterol" ;
  static const conditionStroke = "Stroke" ;*/

  static const conditionHypertension = "Hypertension" ;
  static const conditionDiabetes = "Diabetes" ;
  static const conditionObesity = "Obesity" ;
  static const conditionHighCholesterol  = "High Cholesterol " ;
  static const conditionStroke = "Stroke" ;
  static const conditionCancer = "Cancer" ;
  static const conditionOsteoarthritis = "Osteoarthritis" ;
  static const conditionFallRisk = "Fall Risk" ;
  static const conditionDepression = "Depression" ;
  static const conditionAnxiety = "Anxiety" ;
  static const conditionCardiovascularDisease = "Cardiovascular disease" ;

  static const statusTaskReviewed = "Reviewed" ;

  static const icAssign  = "assets/icons/ic_home_referrals_assign.png";
  static const icCreated  = "assets/icons/ic_home_referrals_created.png";

  // static const icHomeReferralsAssign  = "assets/icons/ic_home_referrals_assign.png";
  // static const icHomeReferralsCreated  = "assets/icons/ic_home_referrals_created.png";

  static const icHomePatientTask  = "assets/icons/ic_home_patient_task.png";
  static const icHomeReferrals  = "assets/icons/ic_home_referrals.png";
  static const icHomeExercisePrescriptions  = "assets/icons/ic_home_exercise_prescriptions.png";
  static const icHomeGoals  = "assets/icons/ic_home_goals.png";
  static const icHomeCarePlan  = "assets/icons/ic_home_carePlan.png";
  static const icHomeConditions  = "assets/icons/ic_home_conditions.png";
  static const totalCountOfAPIData  = "10000";



  static String selectedTimeFrame = Utils.timeFrameList[0];
  static String selectedTime = Utils.timeList[0];
  static const defaultCount  = 500;

  static const homeConditions  = "Conditions";
  static const homeCarePlans  = "Physical activity plan";
  static const homeGoals  = "Goals";


  static const icCareCondition  = "assets/icons/ic_care_condition.png";
  static const icAcivityMonitoring  = "assets/icons/ic_acivity_monitoring.png";
  static const icPatientManagement  = "assets/icons/ic_patient_manegment.png";


  static const icInfo  = "assets/icons/ic_info.png";
  static const icInformation = "assets/icons/ic_information.png";


  static const progressLoader = "assets/json/loading.json";


  /*Activity IMages*/
  static const activityImagesAustralianFootball = "assets/icons/activity/ic_Australian_Football.png";
  static const activityImagesBackCountrySkiing = "assets/icons/activity/ic_BackCountry_Skiing.png";
  static const activityImagesBeachVolleyball = "assets/icons/activity/ic_Beach_Volleyball.png";
  static const activityImagesCalisthenics = "assets/icons/activity/ic_Calisthenics.png";
  static const activityImagesCrossCountrySkiing = "assets/icons/activity/ic_Cross_Country_Skiing.png";
  static const activityImagesCrossSkating = "assets/icons/activity/ic_Cross_Skating.png";
  static const activityImagesCrossFit = "assets/icons/activity/ic_CrossFit.png";
  static const activityImagesDownhillSkiing = "assets/icons/activity/ic_Downhill_Skiing.png";
  static const activityImagesFootball = "assets/icons/activity/ic_football.png";
  static const activityImagesFrisbee = "assets/icons/activity/ic_Frisbee.png";
  static const activityImagesGardening = "assets/icons/activity/ic_Gardening.png";
  static const activityImagesGolf = "assets/icons/activity/ic_Golf.png";
  static const activityImagesGymnastics = "assets/icons/activity/ic_Gymnastics.png";
  static const activityImagesHandball = "assets/icons/activity/ic_Handball.png";
  static const activityImagesHockey = "assets/icons/activity/ic_Hockey.png";
  static const activityImagesHorseRiding = "assets/icons/activity/ic_Horse_Riding.png";
  static const activityImagesIceSkating = "assets/icons/activity/ic_Ice_Skating.png";
  static const activityImagesIndoorSkating = "assets/icons/activity/ic_Indoor_Skating.png";
  static const activityImagesIndoorVolleyball = "assets/icons/activity/ic_Indoor_Volleyball.png";
  static const activityImagesInlineSkating = "assets/icons/activity/ic_Inline_Skating.png";
  static const activityImagesIntervalTraining = "assets/icons/activity/ic_Interval_Training.png";
  static const activityImagesJogging = "assets/icons/activity/ic_Jogging.png";
  static const activityImagesKayaking = "assets/icons/activity/ic_Kayaking.png";
  static const activityImagesKettlebell = "assets/icons/activity/ic_kettlebell.png";
  static const activityImagesKickBoxing = "assets/icons/activity/ic_Kick_Boxing.png";
  static const activityImagesKickScooter = "assets/icons/activity/ic_Kick_Scooter.png";
  static const activityImagesKiteSkiing = "assets/icons/activity/ic_Kite_Skiing.png";
  static const activityImagesKiteSurfing = "assets/icons/activity/ic_Kite_Surfing.png";
  static const activityImagesMartialArts = "assets/icons/activity/ic_Martial_Arts.png";
  static const activityImagesMeditating = "assets/icons/activity/ic_Meditating.png";
  static const activityImagesMixedMartialArts = "assets/icons/activity/ic_Mixed_Martial_Arts.png";
  // static const activityImagesMountainBiking = "assets/icons/activity/ic_Mountain_Biking.png";
  static const activityImagesNordicWalking = "assets/icons/activity/ic_Nordic_Walking.png";
  static const activityImagesOpenWaterSwimming = "assets/icons/activity/ic_Open_Water_Swimming.png";
  static const activityImagesOther = "assets/icons/activity/ic_Other.png";
  static const activityImagesP90x = "assets/icons/activity/ic_P90x.png";
  static const activityImagesPacedWalking = "assets/icons/activity/ic_PacedWalking.png";
  static const activityImagesParagliding = "assets/icons/activity/ic_paragliding.png";
  static const activityImagesPilates = "assets/icons/activity/ic_Pilates.png";
  static const activityImagesPolo = "assets/icons/activity/ic_Polo.png";
  static const activityImagesPoolSwimming = "assets/icons/activity/ic_Pool_Swimming.png";
  static const activityImagesPushchairWalking = "assets/icons/activity/ic_Push_chair_Walking.png";
  static const activityImagesRacquetball = "assets/icons/activity/ic_Racquet_ball.png";
  // static const activityImagesRoadBiking = "assets/icons/activity/ic_Road_Biking.png";
  static const activityImagesRockClimbing = "assets/icons/activity/ic_Rock_Climbing.png";
  static const activityImagesRowing = "assets/icons/activity/ic_Rowing.png";
  static const activityImagesRowingMachine = "assets/icons/activity/ic_Rowing_Machine.png";
  static const activityImagesRugby = "assets/icons/activity/ic_Rugby.png";
  static const activityImagesRuning = "assets/icons/activity/ic_runing.png";
  static const activityImagesSailing = "assets/icons/activity/ic_Sailing.png";
  static const activityImagesSandRunning = "assets/icons/activity/ic_Sand_Running.png";
  static const activityImagesSkating = "assets/icons/activity/ic_Skating.png";
  static const activityImagesSkippingRope = "assets/icons/activity/ic_SkippingRope.png";
  static const activityImagesSledding = "assets/icons/activity/ic_Sledding.png";
  static const activityImagesSnowboarding = "assets/icons/activity/ic_Snowboarding.png";
  static const activityImagesSnowshoeing = "assets/icons/activity/ic_Snowshoeing.png";
  static const activityImagesSoftball = "assets/icons/activity/ic_Softball.png";
  static const activityImagesSpinning = "assets/icons/activity/ic_spinning.png";
  static const activityImagesSquash = "assets/icons/activity/ic_squash.png";
  static const activityImagesStairClimbing = "assets/icons/activity/ic_Stair_Climbing.png";
  static const activityImagesStairClimbingMachine = "assets/icons/activity/ic_Stair_Climbing_Machine.png";
  static const activityImagesStandUpPaddleBoarding = "assets/icons/activity/ic_Stand_Up_Paddle_boarding.png";
  // static const activityImagesStationaryBiking = "assets/icons/activity/ic_Stationary_Biking.png";
  static const activityImagesStrengthTraining = "assets/icons/activity/ic_Strength_Training.png";
  static const activityImagesSurfing = "assets/icons/activity/ic_Surfing.png";
  static const activityImagesSwimming = "assets/icons/activity/ic_Swimming.png";
  static const activityImagesTableTennis = "assets/icons/activity/ic_Table_Tennis.png";
  static const activityImagesTennis = "assets/icons/activity/ic_Tennis.png";
  static const activityImagesTreadmillRunning = "assets/icons/activity/ic_Treadmill_Running.png";
  static const activityImagesTreadmillWalking = "assets/icons/activity/ic_Treadmill_Walking.png";
  // static const activityImagesUtilityBiking = "assets/icons/activity/ic_Utility_Biking.png";
  static const activityImagesWakeboarding = "assets/icons/activity/ic_Wakeboarding.png";
  static const activityImagesWaterPolo = "assets/icons/activity/ic_Water_Polo.png";
  static const activityImagesWeightlifting = "assets/icons/activity/ic_Weight_lifting.png";
  static const activityImagesWheelchair = "assets/icons/activity/ic_Wheelchair.png";
  static const activityImagesWindSurfing = "assets/icons/activity/ic_Wind_Surfing.png";
  static const activityImagesZumba = "assets/icons/activity/ic_zumba.png";
  static const activityImagesArchery = "assets/icons/activity/ic_Archery.png";
  static const activityImagesBarre = "assets/icons/activity/ic_Barre.png";
  static const activityImagesBowling = "assets/icons/activity/ic_Bowling.png";
  static const activityImagesClimbing = "assets/icons/activity/ic_climbing.png";
  static const activityImagesCoolDown = "assets/icons/activity/ic_cool_down.png";
  static const activityImagesCoreTraining = "assets/icons/activity/ic_Core_Training.png";
  static const activityImagesCrossTraining = "assets/icons/activity/ic_CrossTraining.png";
  static const activityImagesDiskSports = "assets/icons/activity/ic_disk_sports.png";
  static const activityImagesEquestrianSport = "assets/icons/activity/ic_EquestrianSport.png";
  static const activityImagesFishing = "assets/icons/activity/ic_fishing.png";
  static const activityImagesFitnessGaming = "assets/icons/activity/ic_fitness_gaming.png";
  static const activityImagesFlexibility = "assets/icons/activity/ic_flexibility.png";
  static const activityImagesHiking = "assets/icons/activity/ic_hiking.png";
  static const activityImagesHunting = "assets/icons/activity/ic_hunting.png";
  static const activityImagesLacrosse = "assets/icons/activity/ic_lacrosse.png";
  static const activityImagesPaddleSports = "assets/icons/activity/ic_PaddleSports.png";
  static const activityImagesPickleball = "assets/icons/activity/ic_Pickleball.png";
  static const activityImagesPlay = "assets/icons/activity/ic_play.png";
  static const activityImagesTaichi = "assets/icons/activity/ic_taichi.png";
  static const activityImagesWrestling = "assets/icons/activity/ic_wrestling.png";


  ///Android Activity Name Workout
  // static const activityAerobicsAndroid = "Aerobics";
  static const activityAmericanFootballAndroid = "American football";
  static const activityAustralianFootballAndroid = "Australian football";
  // static const activityBackCountrySkiingAndroid = "BackCountry Skiing";
  static const activityBadmintonAndroid = "Badminton";
  static const activityBaseballAndroid = "Baseball";
  static const activityBasketballAndroid = "Basketball";
  // static const activityBeachVolleyballAndroid = "Beach Volleyball";
  // static const activityBiathlonAndroid = "Biathlon";
  static const activityBoxingAndroid = "Boxing";
  static const activityCalisthenicsAndroid = "Calisthenics";
  // static const activityCircuitTrainingAndroid = "Circuit Training";
  static const activityCricketAndroid = "Cricket";
  // static const activityCrossSkatingAndroid = "Cross Skating";
  // static const activityCyclingAndroid = "Cycling";
  // static const activityCrossFitAndroid = "CrossFit";
  // static const activityCrossCountrySkiingAndroid = "Cross Country Skiing";
  // static const activityCurlingAndroid = "Curling";
  static const activityDancingAndroid = "Dancing";
  // static const activityDownhillSkiingAndroid = "Downhill Skiing";
  static const activityEllipticalAndroid = "Elliptical";
  // static const activityErgoMeterAndroid = "Ergo meter";
  static const activityFencingAndroid = "Fencing";
  // static const activityFitnessWalkingAndroid = "Fitness Walking";
  // static const activityFlossingAndroid = "Flossing";
  // static const activityFootballAndroid = "Football";
  static const activityFrisbeeAndroid = "Frisbee";
  // static const activityGardeningAndroid = "Gardening";
  static const activityGolfAndroid = "Golf";
  static const activityGymnasticsAndroid = "Gymnastics";
  static const activityHandballAndroid = "Handball";
  // static const activityHockeyAndroid = "Hockey";
  // static const activityHorseRidingAndroid = "Horse Riding";
  // static const activityIceSkatingAndroid = "Ice Skating";
  // static const activityInDoorSkatingAndroid = "Indoor Skating";
  // static const activityInDoorVolleyballAndroid = "Indoor Volleyball";
  // static const activityInLineSkatingAndroid = "Inline Skating";
  // static const activityIntervalTrainingAndroid = "Interval Training";
  // static const activityJoggingAndroid = "Jogging";
  // static const activityKayakingAndroid = "Kayaking";
  // static const activityKettlebellAndroid = "Kettlebell";
  // static const activityKickScooterAndroid = "Kick Scooter";
  // static const activityKickBoxingAndroid = "Kick Boxing";
  // static const activityKiteSkiingAndroid = "Kite Skiing";
  // static const activityKiteSurfingAndroid = "Kite Surfing";
  static const activityMartialArtsAndroid = "Martial arts";
  // static const activityMeditatingAndroid = "Meditating";
  // static const activityMixedMartialArtsAndroid = "Mixed Martial Arts";
  // static const activityMountainBikingAndroid = "Mountain Biking";
  // static const activityNordicWalkingAndroid = "Nordic Walking";
  static const activityOpenWaterSwimmingAndroid = "Open water swimming";
  static const activityOtherAndroid = "Other";
  // static const activityP90xAndroid = "P90x";
  // static const activityPacedWalkingAndroid = "PacedWalking";
  static const activityParaglidingAndroid = "Paragliding";
  static const activityPilatesAndroid = "Pilates";
  // static const activityPoloAndroid = "Polo";
  static const activityPoolSwimmingAndroid = "Pool swimming";
  // static const activityPushchairWalkingAndroid = "Push chair Walking";
  static const activityRacquetballAndroid = "Racquet ball";
  // static const activityRoadBikingAndroid = "Road Biking";
  static const activityRockClimbingAndroid = "Rock climbing";
  static const activityRollerSkiingAndroid = "Roller skiing";
  static const activityRowingAndroid = "Rowing";
  // static const activityRowingMachineAndroid = "Rowing Machine";
  static const activityRugbyAndroid = "Rugby";
  static const activityRunningAndroid = "Running";
  static const activitySailingAndroid = "Sailing";
  // static const activitySandRunningAndroid = "Sand Running";
  static const activityScubaDivingAndroid = "Scuba diving";
  // static const activitySkateboardingAndroid = "Skateboarding";
  static const activitySkatingAndroid = "Skating";
  // static const activitySkiingAndroid = "Skiing";
  // static const activitySkippingRopeAndroid = "SkippingRope";
  // static const activitySleddingAndroid = "Sledding";
  static const activitySnowboardingAndroid = "Snowboarding";
  // static const activitySnowshoeingAndroid = "Snowshoeing";
  static const activitySoftballAndroid = "Softball";
  // static const activitySpinningAndroid = "Spinning";
  static const activitySquashAndroid = "Squash";
  static const activityStairClimbingAndroid = "Stair climbing";
  static const activityStairClimbingMachineAndroid = "Stair climbing machine";
  // static const activityStandUpPaddleAndroid = "Stand Up Paddle boarding";
  // static const activityStationaryBikingAndroid = "Stationary Biking";
  static const activityStrengthTrainingAndroid = "Strength training";
  // static const activitySurfingAndroid = "Surfing";
  // static const activitySwimmingAndroid = "Swimming";
  static const activityTableTennisAndroid = "Table tennis";
  static const activityTennisAndroid = "Tennis";
  static const activityTreadmillRunningAndroid = "Treadmill running";
  // static const activityTreadmillWalkingAndroid = "Treadmill Walking";
  // static const activityUtilityBikingAndroid = "Utility Biking";
  static const activityVolleyballAndroid = "Volleyball";
  // static const activityWakeboardingAndroid = "Wakeboarding";
  static const activityWalkingAndroid = "Walking";
  static const activityWaterPoloAndroid = "Water polo";
  static const activityWeightliftingAndroid = "Weight lifting";
  static const activityWheelChairAndroid = "Wheelchair";
  // static const activityWindSurfingAndroid = "Wind Surfing";
  static const activityYogaAndroid = "Yoga";
  // static const activityZumbaAndroid = "Zumba";



  ///Ios Activity Name WorkOut
  static const activityAmericanFootballIos = "American football";
  static const activityArcheryIos = "Archery";//////
  static const activityAustralianFootballIos = "Australian football";
  static const activityBadmintonIos = "Badminton";
  static const activityBarreIos = "Barre";//////
  static const activityBaseballIos = "Baseball";
  static const activityBasketballIos = "Basketball";
  static const activityBowlingIos = "Bowling";
  static const activityBoxingIos = "Boxing";
  // static const activityBikingIos = "Biking";
  static const activityCalisthenicsIos = "Calisthenics";
  static const activityClimbingIos = "Climbing";
  static const activityCoolDownIos = "Cooldown";
  static const activityCoreTrainingIos = "Coretraining";
  static const activityCricketIos = "Cricket";
  static const activityCrossTrainingIos = "Cross training";
  static const activityCyclingIos = "Cycling";
  static const activityCrossCountrySkiingIos = "Cross country skiing";
  static const activityCurlingIos = "Curling";
  static const activityDancingIos = "Dance";
  static const activityDiskSportsIos = "Disksports";
  static const activityDownhillSkiingIos = "Downhill skiing";
  static const activityEllipticalIos = "Elliptical";
  static const activityEquestrianSportsIos = "Equestrian sports";
  static const activityFencingIos = "Fencing";
  static const activityFishingIos = "Fishing";
  static const activityFitnessWalkingIos = "Fitness walking";
  static const activityFitnessGamingIos = "Fitness gaming";
  static const activityFlexibilityIos = "Flexibility";
  static const activityFunctionalStrengthTrainingIos = "Functional strength training";
  static const activityFootballIos = "Football";
  static const activityGolfIos = "Golf";
  static const activityGymnasticsIos = "Gymnastics";
  static const activityHandCycleIos = "Hand cycling";
  static const activityHandballIos = "Handball";
  static const activityHikingIos = "Hiking";
  static const activityHockeyIos = "Hockey";
  static const activityHuntingIos = "Hunting";
  static const activityKickBoxingIos = "Kick boxing";
  static const activityLacrosseIos = "Lacrosse";
  static const activityMixedCardioIos = "Mixed cardio";
  static const activityMartialArtsIos = "Martial arts";
  static const activityPaddleSportsIos = "Paddle sports";
  static const activityPickleballIos = "Pickleball";
  static const activityPlayIos = "Play";
  static const activityPilatesIos = "Pilates";
  static const activityPreparationAndRecoveryIos = "Preparation and recovery";
  static const activityRowingIos = "Rock climbing";
  static const activityRockClimbingIos = "Rowing";
  static const activityRugbyIos = "Rugby";
  static const activityRunningIos = "Running";
  // static const activityRunningTreadmillIos = "Running treadmill";
  // static const activityRunningJoggingIos = "Running jogging";
  // static const activityRunningSandIos = "Running sand";
  static const activitySailingIos = "Sailing";
  static const activitySkatingSportIos = "Skating";
  static const activitySnowSportIos = "Snow sports";
  static const activitySocialDanceIos = "Social dance";
  static const activitySnowboardingIos = "Snowboarding";
  static const activitySoftballIos = "Softball";
  static const activityStairIos = "Stair";
  static const activityStepTrainingIos = "Step training";
  static const activitySurfingSportsIos = "Surfing sports";
  static const activitySwimmingIos = "Swimming";
  static const activityTableTennisIos = "Table tennis";
  static const activityTennisIos = "Tennis";
  static const activityTaiChiIos = "Tai chi";
  static const activityTraditionalStrengthTrainingIos = "Traditional strength training";
  // static const activityTreadmillRunningIos = "Treadmill running";
  static const activityVolleyballIos = "Volleyball";
  static const activityWalkingIos = "Walking";
  static const activityWaterFitnessIos = "Water fitness";
  static const activityWaterPoloIos = "Water polo";
  static const activityWheelChairRunPaceIos = "Wheelchair run pace";
  static const activityWheelChairWalkPaceIos = "Wheelchair walk pace";
  static const activityWrestlingIos = "Wrestling";
  static const activityYogaIos = "Yoga";
  static const activityOtherIos = "Other";

  static String generalJson = "generalJson";
  static String activityJson = "activityJson";

  static const activityByDefaultList = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemWeights,
    itemMixed
  ];

  static const selectPrimaryServerAppBar = "Select Primary Connection";

  static const callMessage = "startCall";

  static String parentType = "Parent type";
  static String hasMemberTypeActivity = "Activity type";
  static String hasMemberTypeModMin = "Mod min";
  static String hasMemberTypeVigMin = "Vig min";
  static String hasMemberTypeTotalMin = "Total min";
  static String hasMemberTypeCalories = "Calories";
  static String hasMemberTypePeakHeartRate = "Peak Heart Rate";
  static String hasMemberTypeSteps = "Steps";
  static String hasMemberTypeEx = "Experience";


  static String codeChildActivityCalories = "55424-6";
  static String codeChildActivityPeakHeartRate = "55426-1";
  static String codeChildActivityVigorousMin = "77593-2";
  static String codeChildActivityModerateMin = "77592-4";
  static String codeChildActivityTotalMin = "55411-3";
  static String codeChildActivitySteps = "55423-8";
  static String codeChildActivityEx = "67675-9";
  static String codeChildActivityType = "PAPanel";

  static String hasMemberMapIdKey = "hasMemberMapIdKey";
  static String hasMemberMapDateKey = "hasMemberMapDateKey";

  static int defaultSmileyType = 0;

  static int delayTimeLength = 20;
  static bool isCalledAppleGoogleSync = false;
  static bool isSingleServer = false;

  static String metaDataServerName = "metaDataServerName";
  static String metaDataServerSecure = "metaDataServerSecure";
  static String metaDataServerNameDefault = "Server";
  static const failedConnected = "Connection Failed";

  static const scannerLoader = "assets/json/scanner.json";

  static const txtError = "Error";
  static const txtUserCanceled = "The user has canceled the login.";
  static String wizard = "Setup Wizard";
  static const screenTypeHistory = "History screen";
  static const screenTypeBottom = "Bottom screen";
  static const screenTypeHome = "Home screen";
  static const screenTypeMixed = "Mixed screen";

  static const txtErrorConditionNotCreated = "Condition is not a Created, Please try again later.";
  static const txtErrorGoalNotCreated = "Goal is not a Created, Please try again later.";
  static const txtErrorCarePlanNotCreated = "Care Plan is not a Created, Please try again later.";
  static const txtErrorRxNotCreated = "RX is not a Created, Please try again later.";
  static const txtErrorReferralsNotCreated = "Referral is not a Created, Please try again later.";
  static const txtErrorTodoNotCreated = "Task is not created, Please try again later.";



  static const txtExpireTitle = "Session Expired";
  static const txtExpireDesc = "Your session has expired. Please log in again.";
  static const settingFeedBack  = "Feedback";
  static const settingFeedBackUs  = "Send Us Feedback";
  static const rxCode = "229065009";
  static const totalSecondOfTimeOut = 5;
  static const connectionTimeOut = "Connection timeout...";

  static String graphDataNotFind = "No graph are currently recorded";

  static const settingClearData  = "Clear Tracking Chart Data";

  static const newActivityTotal  ="Tracks the total duration of your selected activity session.";
  static const newActivityModMin  ="Measures the time spent engaging in moderate-intensity effort.";
  static const newActivityVIgMin  ="Measures the time spent engaging in vigorous-intensity effort.";
  static const newActivityStrengthDays  ="Tracks for the selected day if you perform strength training.";
  static const newActivityCalories  = "Calculates the total calories burned during your activity session.";
  static const newActivitySteps  = "Counts the total number of steps taken during your activity session.";
  static const newActivityPeakHeartRate  ="Records your highest heart rate during your activity session, indicating the intensity of your workout.";
  static const newActivityExperience  ="Allows you to log and reflect on your overall experience and satisfaction for your activity session.";
  static const newActivityNotes  ="Allows you to add personal notes about your activity session";



  static const dailyValuesTotal ="Tracks the total duration of all physical activities for the day.";
  static const dailyValuesModMin ="Measures the time spent engaging in moderate-intensity activities during the day.";
  static const dailyValuesVigMin ="Measures the time spent engaging in vigorous-intensity activities during the day";
  static const dailyValuesStrengthDay ="Tracks if you perform strength training exercises during the day";
  static const dailyValuesCalories ="Calculates the total calories burned from all physical activities during the day.";
  static const dailyValuesSteps ="Counts the total number of steps taken throughout the day.";
  static const dailyValuesRestingHeartRate ="Monitors your resting heart rate for the day to provide insights into your cardiovascular health";
  static const dailyValuesPeakHeartRate ="Records your highest heart rate reached during any physical activity throughout the day.";
  static const dailyValuesExperience ="Allows you to log and reflect on your overall experience and satisfaction with your activities for the day.";
  static const dailyValuesNotes  ="Allows you to add personal notes about your activities throughout the day.";
  static const qrScannerTitle  ="Connect to Physical Activity Server";

  static List<ListOfMeaSure> listOfMeaSure = [];
  static int selectedRadioValue = -1;

  static const connectionNameToolTip = "The connection name is automatically derived from metadata, but you can change it if you prefer. It helps you identify and manage your connections.";
  static const connectionURLToolTip = "Enter the URL of the FHIR server. This is the web address where your health data will be accessed and managed.";
  static const clientIdToolTip = "Client ID that’s used to authenticate your connection to the FHIR server.";
  static const useMyOwn = "Use my own";
  static const useOther = "Use other";

  static const dataSyncingCondition = "Condition data syncing..";
  static const dataSyncingRX = "RX data syncing..";
  static const dataSyncingGoal = "Goal data syncing..";
  static const dataSyncingCarePlan = "Physical activity plan data syncing..";
  static const dataSyncingReferral = "Referral data syncing..";
  static const dataSyncingPatientTask = "Task data syncing..";

  static bool isCalledAPI = false;

  static List<ActivityTable> trackingChartData = [];

  static String htmlDisclaimerTopText  = '''<p style="margin: 10px 0; padding-left: 20px;">
  This disclaimer ("Disclaimer") is provided to outline the terms and conditions governing the testing of the It’s Time to Move Mobile App, It’s Time to Move Provider Mobile App, and associated web interfaces ("App") developed by the American Heart Association Inc. and their associates. By participating in the testing of the App, you agree to adhere to the following:
  </p>''';
  static String htmlDisclaimerBottomText1  = '''<p style="margin: 10px 0; padding-left: 20px;">By participating in the testing of either of the It’s Time To Move Mobile Apps, you acknowledge that you have read, understood, and agree to be bound by the terms and conditions of this Disclaimer. If you do not agree with any of these terms, please do not participate in the testing process and remove the app(s) from your device.</p>''';
  static String htmlDisclaimerBottomText2  = '''<p style="margin: 10px 0; padding-left: 20px;">Thank you for your valuable contribution to the development of the It’s Time To Move Mobile App. Your feedback is greatly appreciated.</p>''';
  static String htmlDisclaimer = '''<!DOCTYPE html>
      <html lang="en">
  <head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
  body {
  font-family: Arial, sans-serif;
  line-height: 1.6;
  margin: 20px;
}
h3 {
color: #333;
}
p {
margin: 10px 0;
text-indent: 200px
}
ul {
margin: 10px 0;
padding-left: 20px;
}
li {
margin-bottom: 10px;
}
</style>
</head>
<body>

<ul>
<li>
<strong>Voluntary Participation:</strong> Your participation in testing the App is entirely voluntary and you are under no obligation to provide feedback or continue testing at any time.
</li>
</br>
<li>
<strong>Feedback and Reporting:</strong> Any feedback, comments, suggestions, or issues you encounter while testing the App should be promptly reported to the American Heart Association Inc. through the designated communication channels provided for testing purposes.
</li>
</br>
<li>
<strong>Medical Disclaimer:</strong> Use of the App is not intended to result in or to be construed as medical advice, diagnosis, and treatment by physicians and/or patients or other individuals and is not a substitute for consultations with qualified health professionals who are familiar with your medical needs.
</li>
</br>
<li>
<strong>No Warranty:</strong> The App is provided for testing purposes only and is not a final production-ready version. The Company makes no warranties or representations regarding the accuracy, reliability, or functionality of the App during the testing phase. By accessing or using the App, you agree to comply with all applicable federal, state, and local laws and/or regulations which may relate to the App.
</li>
</br>
<li>
<strong>Data Loss:</strong> You acknowledge that data loss or corruption may occur during the testing process and that the American Heart Association Inc., Dogwood Health Consulting, or the Physical Activity Alliance are not liable for any loss of data, including but not limited to personal information or other data stored on your device.
</li>
</br>
<li>
<strong>Indemnification:</strong> You agree to indemnify and hold the American Heart Association Inc., Dogwood Health Consulting, the Physical Activity Alliance, and the affiliates, officers, directors, employees, contractors, volunteers, sponsors, and agents of the aforementioned organizations harmless from any claims, damages, losses, liabilities, costs, or expenses arising out of your participation in testing the App. In no event will the American Heart Association Inc., Dogwood Health Consulting, the Physical Activity Alliance, or the affiliates, officers, directors, employees, contractors, volunteers, sponsors, agents of these organizations be liable to you, anyone claiming by, through, or under you, or anyone else for (i) any decision or action taken or not taken in reliance upon the information contained or provided through the App, (ii) claims arising out of or related to the App, (iii) your use of the App, or (iv) for any incidental, indirect, special, consequential, or punitive damages, including but not limited to possible health side effects, loss of revenues, damages, claims, demands, or actions. The foregoing release, indemnity, and limitation of liability shall be as broad and inclusive as is permitted by the jurisdiction in which you live.
</li>
</br>
<li>
<strong>Termination of Testing:</strong> The American Heart Association Inc. reserves the right to terminate your participation in testing the App at any time and for any reason without prior notice.
</li>
</br>
<li>
<strong>No Compensation:</strong> You understand and agree that you will not receive any compensation, monetary or otherwise, for your participation in testing the App.
</li>
</br>
<li>
<strong>Ownership:</strong> The App and all related intellectual property rights are owned by the American Heart Association Inc. Your participation in testing the App does not grant you any rights, licenses, or ownership in the App or its components.
</li>
</br>
<li>
<strong>Acceptance of Changes:</strong> The American Heart Association Inc. may update or modify this Disclaimer at any time. Your continued participation in testing the App constitutes your acceptance of any changes to this Disclaimer.
</li>
</ul>
</body>
</html>
''';
  static const txtAgreeDesc = "Agree & Accept Disclaimer";
  static const txtPleaseAccept = "Please accept disclaimer";

  static const notesReferralDesc = "Add any additional comments or details about the referral. This can include motivations, obstacles, or specific observations related to progress";

}
