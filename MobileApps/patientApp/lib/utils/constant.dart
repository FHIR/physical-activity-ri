import 'dart:io';

import 'package:banny_table/utils/sizer_utils.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../ui/configuration/datamodel/configuration_datamodel.dart';
import 'package:banny_table/dataModel/patientDataModel.dart';
import '../ui/graph/datamodel/graphDatamodel.dart';


class Constant {

  static const failureCode = false;
  static const successCode = true;
  // static bool isCalledAppleGoogleSync = false;
  static const responseFailureCode = 400;
  static const responseSuccessCode = 200;
  static const responseNoDataCode = 202;
  static const responseCreatedCode = 201;
  static const responseUnauthorizedCode = 401;
  static const responsePaymentRequired = 402;
  static const responseRequired = 422;
  static const responseInCorrectString = "404";
  static const responseNotFound = 404;


  static bool isEditMode = true;
  // static bool isAutoCalMode = false;

  static const txtAgreeDesc = "Agree & Accept Disclaimer";
  static const returnType = "return";
  static const type = "type";
  static const baseUrl = "";
  static const fhirParameters = "fhirParameters";
  static const isSuccess = "isSuccess";
  static const msg = "msg";
  static const failed = "Failed";
  static const successFullyConnected = "Successfully connected";
  static const failedConnected = "Connection Failed";
  static const fontFamilyPoppins = "Poppins";
  static const accoutnNotApproved = "Account does not have patient linked yet. Please contact admin of the application";
  static const patientAcNotFound = "Patient account not found";

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
  static const tableLog = "tableLog";


  /*shared_preferences Keys*/
  static const  keySyncingTime = "syncingTime";
  static const  keySyncing = "keySyncing";
  static const  keyWelcomeDetails = "keyWelcomeDetails";



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



  static const logTableAppBar = "Diagnostics";
  static const selectPrimaryServerAppBar = "Select Primary Connection";


  static const itemBicycling = "Bicycling";
  static const itemJogging = "Jogging";
  static const itemRunning = "Running";
  static const itemSwimming = "Swimming";
  static const itemWalking = "Walking";
  static const itemWeights = "Weights";
  // static const itemMixed = "Mixed";

  static const welcomeIcon =  "assets/images/welcome3.png";
  static const welcomeIconSvg =  "assets/images/welcome.svg";
  static const screen2IconSvg =  "assets/images/2.svg";

  ///Api Log Types
  static const referral = "Referral";
  static const getReferralCreated = "getReferralCreated";
  static const getReferralAssigned = "getReferralAssigned";
  static const getExercisePrescription = "getExercisePrescription";
  static const getPatient = "getPatient";
  static const getCareManager = "getCareManager";
  static const getPatientList = "getPatientList";
  static const getPatientListTestUse = "getPatientListTestUse";
  static const getMonthActivityList = "getMonthActivityList";
  static const getCarePlanActivityList = "getCarePlanActivityList";
  static const getConditionActivityList = "getConditionActivityList";
  static const getTaskDataList = "getTaskDataList";
  static const getGoalDataList = "getGoalDataList";
  static const processExercisePrescription = "processExercisePrescription";
  static const processReferral = "processReferral";
  static const processTask = "processTask";
  static const processCarePlan = "processCarePlan";
  static const processCondition = "processCondition";
  static const processGoal = "processGoal";
  static const getPerformerList = "getPerformerList";
  static const getPerformerSearchList = "getPerformerSearchList";
  static const processResource = "processResource";


  ///Type
  static const serviceRequest = "ServiceRequest";
  static const task = "Task";
  static const carePlan = "CarePlan";
  static const condition = "Condition";
  static const goal = "Goal";
  static const observation = "Observation";
  static const monthly = "Monthly";
  static const trackingChart = "TrackingChart";



  /*Icons*/
  static const iconBicycling =  "assets/icons/ic_bicycle.png";
  static const iconJogging = "assets/icons/ic_jogging.png";
  static const iconRunning = "assets/icons/ic_running.png";
  static const iconSwimming = "assets/icons/ic_swimming.png";
  static const iconWalking = "assets/icons/ic_walking.png";
  static const iconWeights = "assets/icons/ic_strength.png";
  static const iconMixed = "assets/icons/ic_mixed.png";

  static const codeBicycling =  "LA11837-4";
  static const codeJogging = "LA11835-8";
  static const codeRunning = "	LA11836-6";
  static const codeSwimming = "LA11838-2";
  static const codeWalking = "LA11834-1";
  static const codeWeights = "LA11839-0";
  static const codeMixed = "LA11840-8";


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

  static const activityByDefaultList = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemWeights,
    // itemMixed
  ];
  // static const daysStrengthShowWithItem = [itemWeights, itemMixed];

/*  static const caloriesShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemMixed
  ];*/
  static const stepsShowWithItem = [
    itemJogging,
    itemRunning,
    itemWalking,
    // itemMixed
  ];
  static const heartPeckShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemWeights,
    // itemMixed
  ];
  static const experienceShowWithItem = [
    itemBicycling,
    itemJogging,
    itemRunning,
    itemSwimming,
    itemWalking,
    itemWeights,
    // itemMixed
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
  static var webTextFiledTextSize = (kIsWeb) ? Utils.sizesFontManage(Get.context!, 2.2) :FontSize.size_3;
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
  static const commonDateForChart = "yyyy\nMM-dd";
  static const commonDateFormatMmmDdYyyy = "MMM dd, yyyy";
  static const commonDateFormatDdMmmYyyy = "dd MMM, yyyy";
  static const commonDateFormatDd = "dd";
  static const commonDateFormatDdMMM = "dd\nMMM";
  static const commonDateFormatMMM = "MMM";
  static const commonDateFormatFullDate = "yyyy-MM-dd hh:mm a";
  static const commonDateFormatHhMmA = " hh:mm a";
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
  static const homeDailyValuesIconsPath = "assets/icons/ic_daily_values.png";
  static const homeMonthlySummary = "assets/icons/ic_calender.png";
  static const homeTrackingChart = "assets/icons/ic_tracking.png";
  static const homeToDO = "assets/icons/ic_to_do_list_home.png";

  static const homeRecord = "New Activity";
  static const homeMonthly = "Monthly Summary";
  static const homeTracking = "Tracking Chart ";
  static const homeToDoList = "To Do List ";
  static const homeDailyValues = "Daily Values";


  /*use on Setting Screen*/
  static const settingEditMode  = "Edit mode";
  static String settingQRScan  = "QR connect provider";
  static const settingSwitchProfile  = "Switch profile";
  static const settingAutoCalculation  = "Auto calculation";
  static const settingConfiguration  = "Activity Configuration";
  static const settingProfileConfiguration  = "Profile Configuration";
  static const settingFeedBack  = "Feedback";
  static const settingFeedBackUs  = "Send Us Feedback";
  static const settingReferral  = "Referral";
  static const settingCondition  = "Condition";
  // static const settingCarePlan  = "CarePlan";
  static const settingCarePlan  = "Physical activity plan";
  static const settingRx  = "Rx";
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
  static const icInformation = "assets/icons/ic_information.png";





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


  static const dailyValueLabelHeaderCalories = "Daily calories";
  static const dailyValueLabelHeaderSteps = "Daily steps";
  static const dailyValueLabelHeaderRest = "Average resting heart rate";
  static const dailyValueLabelHeaderPeck = "Peak heart rate";
  static const dailyValueLabelHeaderTotal = "Total minutes";
  static const dailyValueLabelHeaderModerate = "Moderate minutes";
  static const dailyValueLabelHeaderVigorous = "Vigorous minutes";
  static const dailyValueLabelHeaderDays = "Strength days";

  static const configurationHeaderToolTipTotal = "Tracks the total duration of all physical activities combined. This can be viewed at the day, week, or individual activity level.";
  static const configurationHeaderToolTipModMin = "Measures the time spent engaging in moderate-intensity activities like brisk walking. You can track this for each activity, day, or week.";
  static const configurationHeaderToolTipVigMin = "Measures the time spent engaging in vigorous-intensity activities, tracked per activity, day, or week";
  static const configurationHeaderToolTipNotes = "Allows you to add personal notes about your workouts and activities. Notes can be added for each activity or summarised for the day or week.";
  static const configurationHeaderToolTipStrengthDays = "Tracks the number of days you perform strength training exercises. This can be viewed at the day or week level";
  static const configurationHeaderToolTipCalories = "Calculates the total calories burned from all physical activities. You can see this information for each activity, day, or week.";
  static const configurationHeaderToolTipSteps = "Counts the total number of steps taken. This can be monitored for each activity, daily, or weekly.";
  static const configurationHeaderToolTipRestingHeart = "Monitors your resting heart rate, providing insights into your overall cardiovascular health. This can be tracked daily or weekly";
  static const configurationHeaderToolTipPeckHeart = "Records your highest heart rate during physical activities, indicating the intensity of your workouts. You can review this data per activity, day, or week.";
  static const configurationHeaderToolTipExperience = "Allows you to log and reflect on your overall workout experience and satisfaction, available at the activity and daily level.";


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


  static const headerDayPerWeek = "Days/\nweek";
  static const headerAverageMin = "Mins\n";
  static const headerAverageMinPerWeek = "Mins/\nweek";
  static const headerStrength = "Strength days/week";

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
  // static const headerGraphLogScreen = "Patient Assessment";
  static const headerGraphLogScreen = "Graphs";
  static const headerSettingScreen = "Setting";
  static const headerMixedScreen = "Plans and Goals";
  static const headerConfigurationScreen = "Configuration";
  static const headerPatientProfileScreen  = "Patient Profile";
  static const headerPatientUserScreen  = "Patient";


  static const labelStatus  = "Status";
  static const statusAll  = "All";
  static const statusDraft  = "Draft";
  static const statusActive  = "Active";
  static const statusOnHold  = "On-hold";
  static const statusRevoked  = "Revoked";
  static const statusCompleted  = "Completed";
  static const statusEnteredInError  = "Entered-in-error";
  static const statusUnknown  = "Unknown";
  static const statusAwaitingReview  = "Action Requested";
  static const statusInProgress  = "In-Progress";


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


  static const icInProgress = "assets/icons/ic_in_ptogress.png";
  static const icCompleted = "assets/icons/ic_completd_task.png";
  static const icCancel = "assets/icons/ic_cancelled.png";


  /*Activity Name*/
  static const activityAerobics = "Aerobics";
  static const activityAmericanFootball = "American football";
  static const activityBadminton = "Badminton";
  static const activityBaseball = "Baseball";
  static const activityBasketball = "Basketball";
  static const activityBiathlon = "Biathlon";
  static const activityBoxingGlove = "Boxingglove";
  static const activityCircuitTraining = "Circuittraining";
  static const activityCricket = "Cricket";
  static const activityCurlingStone = "Curlingstone";
  static const activityCycling = "Cycling";
  static const activityDancing = "Dancing";
  static const activityDumbbell = "Dumbbell";
  static const activityElliptical = "Elliptical";
  static const activityErgoMeter = "Ergo meter";
  static const activityFencing = "Fencing";
  static const activityRollerSkating = "Roller-Skating";
  static const activityScubaDiving = "Scubadiving";
  static const activitySkiing = "Skiing";
  static const activitySoccerBall = "SoccerBall";
  static const activityVolleyball = "Volleyball";
  static const activityWalking = "Walking";
  static const activityWaterSkiing = "Water skiing";
  static const activityYoga = "Yoga";



  ///Android Activity Name Workout
  static const activityAmericanFootballAndroid = "American football";
  static const activityAmericanFootballAndroidCode = "americanFootball";
  static const activityAustralianFootballAndroid = "Australian football";
  static const activityAustralianFootballAndroidCode = "australianFootball";
  static const activityBadmintonAndroid = "Badminton";
  static const activityBadmintonAndroidCode = "badminton";
  static const activityBaseballAndroid = "Baseball";
  static const activityBaseballAndroidCode = "baseball";
  static const activityBasketballAndroid = "Basketball";
  static const activityBasketballAndroidCode = "basketball";
  static const activityBoxingAndroid = "Boxing";
  static const activityBoxingAndroidCode = "boxing";
  static const activityCalisthenicsAndroid = "Calisthenics";
  static const activityCalisthenicsAndroidCode = "";
  static const activityCricketAndroid = "Cricket";
  static const activityCricketAndroidCode = "cricket";
  static const activityDancingAndroid = "Dancing";
  static const activityDancingAndroidCode = "dancing";
  static const activityEllipticalAndroid = "Elliptical";
  static const activityEllipticalAndroidCode = "elliptical";
  static const activityFencingAndroid = "Fencing";
  static const activityFencingAndroidCode = "fencing";
  static const activityFrisbeeAndroid = "Frisbee";
  static const activityFrisbeeAndroidCode = "";
  static const activityGolfAndroid = "Golf";
  static const activityGolfAndroidCode = "golf";
  static const activityGymnasticsAndroid = "Gymnastics";
  static const activityGymnasticsAndroidCode = "gymnastics";
  static const activityHandballAndroid = "Handball";
  static const activityHandballAndroidCode = "handball";
  static const activityMartialArtsAndroid = "Martial arts";
  static const activityMartialArtsAndroidCode = "martialArts";
  static const activityOpenWaterSwimmingAndroid = "Open water swimming";
  static const activityOpenWaterSwimmingAndroidCode = "";
  static const activityOtherAndroid = "Other";
  static const activityOtherAndroidCode = "other";
  static const activityParaglidingAndroid = "Paragliding";
  static const activityParaglidingAndroidCode = "";
  static const activityPilatesAndroid = "Pilates";
  static const activityPilatesAndroidCode = "pilates";
  static const activityPoolSwimmingAndroid = "Pool swimming";
  static const activityPoolSwimmingAndroidCode = "";
  static const activityRacquetballAndroid = "Racquet ball";
  static const activityRacquetballAndroidCode = "";
  static const activityRockClimbingAndroid = "Rock climbing";
  static const activityRockClimbingAndroidCode = "";
  static const activityRollerSkiingAndroid = "Roller skiing";
  static const activityRollerSkiingAndroidCode = "";
  static const activityRowingAndroid = "Rowing";
  static const activityRowingAndroidCode = "";
  static const activityRugbyAndroid = "Rugby";
  static const activityRugbyAndroidCode = "rugby";
  static const activityRunningAndroid = "Running";
  static const activityRunningAndroidCode = "running";
  static const activitySailingAndroid = "Sailing";
  static const activitySailingAndroidCode = "sailing";
  static const activityScubaDivingAndroid = "Scuba diving";
  static const activityScubaDivingAndroidCode = "";
  static const activitySkatingAndroid = "Skating";
  static const activitySkatingAndroidCode = "skatingSports";
  static const activitySnowboardingAndroid = "Snowboarding";
  static const activitySnowboardingAndroidCode = "snowboarding";
  static const activitySoftballAndroid = "Softball";
  static const activitySoftballAndroidCode = "softball";
  static const activitySquashAndroid = "Squash";
  static const activitySquashAndroidCode = "";
  static const activityStairClimbingAndroid = "Stair climbing";
  static const activityStairClimbingAndroidCode = "";
  static const activityStairClimbingMachineAndroid = "Stair climbing machine";
  static const activityStairClimbingMachineAndroidCode = "";
  static const activityStrengthTrainingAndroid = "Strength training";
  static const activityStrengthTrainingAndroidCode = "";
  static const activityTableTennisAndroid = "Table tennis";
  static const activityTableTennisAndroidCode = "tableTennis";
  static const activityTennisAndroid = "Tennis";
  static const activityTennisAndroidCode = "tennis";
  static const activityTreadmillRunningAndroid = "Treadmill running";
  static const activityTreadmillRunningAndroidCode = "";
  static const activityVolleyballAndroid = "Volleyball";
  static const activityVolleyballAndroidCode = "volleyball";
  static const activityWalkingAndroid = "Walking";
  static const activityWalkingAndroidCode = "walking";
  static const activityWaterPoloAndroid = "Water polo";
  static const activityWaterPoloAndroidCode = "waterPolo";
  static const activityWeightliftingAndroid = "Weight lifting";
  static const activityWeightliftingAndroidCode = "";
  static const activityWheelChairAndroid = "Wheelchair";
  static const activityWheelChairAndroidCode = "Wheelchair";
  static const activityYogaAndroid = "Yoga";
  static const activityYogaAndroidCode = "yoga";



  ///Ios Activity Name WorkOut
  static const activityAmericanFootballIos = "American football";
  static const activityAmericanFootballIosCode = "americanFootball";
  static const activityArcheryIos = "Archery";
  static const activityArcheryIosCode = "archery";
  static const activityAustralianFootballIos = "Australian football";
  static const activityAustralianFootballIosCode = "australianFootball";
  static const activityBadmintonIos = "Badminton";
  static const activityBadmintonIosCode = "badminton";
  static const activityBarreIos = "Barre";
  static const activityBarreIosCode = "barre";
  static const activityBaseballIos = "Baseball";
  static const activityBaseballIosCode = "baseball";
  static const activityBasketballIos = "Basketball";
  static const activityBasketballIosCode = "basketball";
  static const activityBowlingIos = "Bowling";
  static const activityBowlingIosCode = "bowling";
  static const activityBoxingIos = "Boxing";
  static const activityBoxingIosCode = "boxing";
  static const activityCalisthenicsIos = "Calisthenics";
  static const activityCalisthenicsIosCode = "";
  static const activityClimbingIos = "Climbing";
  static const activityClimbingIosCode = "climbing";
  static const activityCoolDownIos = "Cooldown";
  static const activityCoolDownIosCode = "cooldown";
  static const activityCoreTrainingIos = "Coretraining";
  static const activityCoreTrainingIosCode = "coreTraining";
  static const activityCricketIos = "Cricket";
  static const activityCricketIosCode = "cricket";
  static const activityCrossTrainingIos = "Cross training";
  static const activityCrossTrainingIosCode = "crossTraining";
  static const activityCyclingIos = "Cycling";
  static const activityCyclingIosCode = "cycling";
  static const activityCrossCountrySkiingIos = "Cross country skiing";
  static const activityCrossCountrySkiingIosCode = "crossCountrySkiing";
  static const activityCurlingIos = "Curling";
  static const activityCurlingIosCode = "curling";
  static const activityDancingIos = "Dance";
  static const activityDancingIosCode = "dance";
  static const activityDiskSportsIos = "Disksports";
  static const activityDiskSportsIosCode = "discSports";
  static const activityDownhillSkiingIos = "Downhill skiing";
  static const activityDownhillSkiingIosCode = "downhillSkiing";
  static const activityEllipticalIos = "Elliptical";
  static const activityEllipticalIosCode = "elliptical";
  static const activityEquestrianSportsIos = "Equestrian sports";
  static const activityEquestrianSportsIosCode = "equestrianSports";
  static const activityFencingIos = "Fencing";
  static const activityFencingIosCode = "fencing";
  static const activityFishingIos = "Fishing";
  static const activityFishingIosCode = "fishing";
  static const activityFitnessWalkingIos = "Fitness walking";
  static const activityFitnessWalkingIosCode = "";
  static const activityFitnessGamingIos = "Fitness gaming";
  static const activityFitnessGamingIosCode = "fitnessGaming";
  static const activityFlexibilityIos = "Flexibility";
  static const activityFlexibilityIosCode = "flexibility";
  static const activityFunctionalStrengthTrainingIos = "Functional strength training";
  static const activityFunctionalStrengthTrainingIosCode = "functionalStrengthTraining";
  static const activityFootballIos = "Football";
  static const activityFootballIosCode = "";
  static const activityGolfIos = "Golf";
  static const activityGolfIosCode = "golf";
  static const activityGymnasticsIos = "Gymnastics";
  static const activityGymnasticsIosCode = "gymnastics";
  static const activityHandCycleIos = "Hand cycling";
  static const activityHandCycleIosCode = "handCycling";
  static const activityHandballIos = "Handball";
  static const activityHandballIosCode = "handball";
  static const activityHikingIos = "Hiking";
  static const activityHikingIosCode = "hiking";
  static const activityHockeyIos = "Hockey";
  static const activityHockeyIosCode = "hockey";
  static const activityHuntingIos = "Hunting";
  static const activityHuntingIosCode = "hunting";
  static const activityKickBoxingIos = "Kick boxing";
  static const activityKickBoxingIosCode = "kickboxing";
  static const activityLacrosseIos = "Lacrosse";
  static const activityLacrosseIosCode = "lacrosse";
  static const activityMixedCardioIos = "Mixed cardio";
  static const activityMixedCardioIosCode = "mixedCardio";
  static const activityMartialArtsIos = "Martial arts";
  static const activityMartialArtsIosCode = "martialArts";
  static const activityPaddleSportsIos = "Paddle sports";
  static const activityPaddleSportsIosCode = "paddleSports";
  static const activityPickleballIos = "Pickleball";
  static const activityPickleballIosCode = "pickleball";
  static const activityPlayIos = "Play";
  static const activityPlayIosCode = "play";
  static const activityPilatesIos = "Pilates";
  static const activityPilatesIosCode = "pilates";
  static const activityPreparationAndRecoveryIos = "Preparation and recovery";
  static const activityPreparationAndRecoveryIosCode = "preparationAndRecovery";
  static const activityRowingIos = "Rock climbing";
  static const activityRowingIosCode = "";
  static const activityRockClimbingIos = "Rowing";
  static const activityRockClimbingIosCode = "rowing";
  static const activityRugbyIos = "Rugby";
  static const activityRugbyIosCode = "rugby";
  static const activityRunningIos = "Running";
  static const activityRunningIosCode = "running";
  static const activitySailingIos = "Sailing";
  static const activitySailingIosCode = "sailing";
  static const activitySkatingSportIos = "Skating";
  static const activitySkatingSportIosCode = "skatingSports";
  static const activitySnowSportIos = "Snow sports";
  static const activitySnowSportIosCode = "snowSports";
  static const activitySocialDanceIos = "Social dance";
  static const activitySocialDanceIosCode = "socialDance";
  static const activitySnowboardingIos = "Snowboarding";
  static const activitySnowboardingIosCode = "snowboarding";
  static const activitySoftballIos = "Softball";
  static const activitySoftballIosCode = "softball";
  static const activityStairIos = "Stair";
  static const activityStairIosCode = "stairs";
  static const activityStepTrainingIos = "Step training";
  static const activityStepTrainingIosCode = "stepTraining";
  static const activitySurfingSportsIos = "Surfing sports";
  static const activitySurfingSportsIosCode = "surfingSports";
  static const activitySwimmingIos = "Swimming";
  static const activitySwimmingIosCode = "swimming";
  static const activityTableTennisIos = "Table tennis";
  static const activityTableTennisIosCode = "tableTennis";
  static const activityTennisIos = "Tennis";
  static const activityTennisIosCode = "tennis";
  static const activityTaiChiIos = "Tai chi";
  static const activityTaiChiIosCode = "taiChi";
  static const activityTraditionalStrengthTrainingIos = "Traditional strength training";
  static const activityTraditionalStrengthTrainingIosCode = "traditionalStrengthTraining";
  static const activityVolleyballIos = "Volleyball";
  static const activityVolleyballIosCode = "volleyball";
  static const activityWalkingIos = "Walking";
  static const activityWalkingIosCode = "walking";
  static const activityWaterFitnessIos = "Water fitness";
  static const activityWaterFitnessIosCode = "waterFitness";
  static const activityWaterPoloIos = "Water polo";
  static const activityWaterPoloIosCode = "waterPolo";
  static const activityWheelChairRunPaceIos = "Wheelchair run pace";
  static const activityWheelChairRunPaceIosCode = "wheelchairRunPace";
  static const activityWheelChairWalkPaceIos = "Wheelchair walk pace";
  static const activityWheelChairWalkPaceIosCode = "wheelchairWalkPace";
  static const activityWrestlingIos = "Wrestling";
  static const activityWrestlingIosCode = "wrestling";
  static const activityYogaIos = "Yoga";
  static const activityYogaIosCode = "yoga";
  static const activityOtherIos = "Other";
  static const activityOtherIosCode = "other";



  static const lifeCycleStatusAccepted = "assets/icons/ic_play.png";
  static const lifeCycleStatusOnHold = "assets/icons/ic_pause.png";
  static const lifeCycleStatusCancelled = "assets/icons/ic_stop.png";
  static const lifeCycleStatusCompleted = "assets/icons/ic_checkMark_gray.png";


  /*static const goalTypeMinWeek  = "Min/Week";
  static const goalTypeMinDay  = "Min/Day";
  static const goalTypeMinMonth  = "Min/Month";
  static const goalTypeHourWeek  = "Hr/Week";
  static const goalTypeHourDay  = "Hr/Day";
  static const goalTypeHourMonth  = "Hr/Month";*/
  /*static const goalTypesStep  = "Average Daily Step Count";
  static const goalTypesBPM  = "Target Resting Heart Rate";
  static const goalTypesBPMRest  = "Minimum Daily Peak Heart Rate";
  static const goalTypesBPMCalories  = "Average Daily Calories Burned";
  static const goalTypesDaysPerWeek  = "Average Days per Week of Physical Activity";
  static const goalTypesAverageMinutes  = "Average Minutes per Day of Physical Activity";
  static const goalTypesMinutesPerWeek  = "Average Minutes per Week of Physical Activity";
  static const goalTypesDaysPerWeekTraining  = "Average Days per Week of Strength training";*/

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
  static const toDoStatusDraft = "Draft";

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

  static const healthProviderIntro = "This app lets you share information with your doctor, gym, personal trainer, or others who have systems set up to share information. You can choose to share information about your activity levels, and you can receive goals, exercise prescriptions, recommended reading/videos, and other information.";
  static const healthProviderIntroShort = "Would you like to set up any connections now?";
  /*static const syncDescIos = "This app allows you to Connect with Apple Health if you grant permission. You can control what information (if any) is shared.";
  static const syncDescAndroid = "This app allows you to Connect with Apple Health if you grant permission. You can control what information (if any) is shared.";*/
  static const syncDescIos = "This app allows you to share information between this app and Apple health. You can control what information (If any) is shared.";
  static const syncDescAndroid = "This app allows you to share information between this app and Health Connect. You can control what information (If any) is shared.";
  /*static String syncPermissionReadDetail = "Read: Allow this app to access steps, calories, minutes, or other ${(Platform.isAndroid)?"Health Connect’s":"Apple Health’s"} activity data (e.g.from your phone, watch, fitness tracker, etc.).";
  static String syncPermissionWriteDetail = "Write: Share information you log in this application with other apps you've granted ${(Platform.isAndroid)?"Health Connect":"Apple Health"} permission to.";*/
  static String syncPermissionReadDetail = "Allow this app to access steps, calories, minutes, or other ${(Platform.isAndroid)?"Health Connect’s":"Apple Health’s"} activity data (e.g.from your phone, watch, fitness tracker, etc.).";
  static String syncPermissionWriteDetail = "Share information you log in this application with other apps you've granted ${(Platform.isAndroid)?"Health Connect":"Apple Health"} permission to.";
  static String syncConfirmAndroidIos = "Do you want to enable sharing with ${(Platform.isAndroid)?"Health Connect":"Apple Health"} ?";
  static String syncEditReadWriteIos = "To edit read/write permissions, go to the Settings app > Health > Data Access & Devices > Patient";
  static String syncEditReadWriteAndroid = "To edit read/write permissions, go to the Health connect > App permission > Patient";
  static const healthProviderPatient = "Your provider has given you access to multiple patient records (likely family members or others you have a care relationship with). Please indicate which patient record is ‘yours’ and will be associated with steps or other activity tracked on this device.";
  static const qrScannerDetail = "Your health provider should have given you a QR code or URL to establish a connection with their system. Please point your device's camera at the QR code or type in the URL. If you don't have either, hit cancel and come back using 'settings' once you've got one of these from your provider.";
  static const likeToAddConnection = "Do you want to connect to another health provider?";


  static const configurationIntro = "In this App, you can record information about your physical activity, including general information such as daily steps, as well as information about specific exercise events.";
  static const configurationIntroShort = "Choose Your Activities: Select the activities you love.";
  static const configurationIntroShortSecond = "Track What Matters: Decide what to measure – Steps, Heart Rate, Calories, and more.";
  static const configurationIntroInfo = "Would you like to customize your activities and tracking preferences now? ";
  static String trackingPrefDesc = "Select the data you want the app to track.";
  static String activitySelectionDesc = "Which types of activities would you like to track? This app will only show activities you choose. (You can add or remove activities later too.)";
  static String selectPrimaryI = "You are connected to multiple provider systems that allow storing your goals and other information. This app will share your activity records with all of these providers. However, you must choose one system as your ‘primary’ system, which is where your goals will be and this app will treat as the ‘official’ storage area for other information.";

  static String settingSetupWizard = "Click to initiate a guided setup if you skipped the initial configuration or wish to update your settings.";
  static String settingConnectedServer = "Use this to update or establish a new connection with your health provider.";
  static String settingHealthData = "Toggle to enable or disable syncing with Apple Health for comprehensive health data integration.";
  static String settingActivityConfig = "Configure which activities are tracked and how they are recorded in the app. Customize settings to fit your personal health goals and preferences.";
  static String settingTrackingEditMode = "When turned off, tracking chart data entries are disabled. Toggle on to edit or input new data.";
  static String settingTrackingAutoCalculation = "If enabled, the app automatically calculates values based on input data. When disabled, you can choose to manually add numbers or use auto-calculation for each entry.";
  static String settingSyncingTimeDesc = "Select how frequently your data should be synced: real-time, daily, or weekly";
  static String settingLogDesc = "This is mainly for testing and diagnostics and it’s not intended for patients. Useful for technical support and troubleshooting app functionality.";
  static String activityLogDesc = "This is only relevant if you have received a code from your provider.";

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
  static const careManager = "CareManager";
  static const serviceProvider = "serviceProvider";



  // static bool boolActivityMinTotal = true;
  // static bool boolActivityMinMod = true;
  // static bool boolActivityMinVig = true;
  // static bool boolNotes = true;
  // static bool boolDaysStr = true;
  // static bool boolCalories = true;
  // static bool boolSteps = true;
  // static bool boolRestHeartRate = true;
  // static bool boolPeakHeartRate = true;
  // static bool boolExperience = true;
  // static bool boolHeartRate = false;

  static bool boolCalories = false;
  static bool boolSteps = false;
  static bool boolHeartRate = false;
  static bool boolExperience = false;
  static bool boolActivityMinMod = false;
  static bool boolActivityMinVig = false;

  static const txtPleaseWait = "Please wait";
  static const txtActivityDataProgress = "Tracking chart data sync is in progress";
  static const txtMonthlyDataProgress = "Monthly data is in progress";
  static const txtMonthlySync = "Monthly syncing";
  static const txtMonthlySyncDesc = "Getting your monthly data will take some time.";
  static const txtToDoDataProgress = "ToDo task data is in progress";
  static const txtGoalDataProgress = "Goal data is in progress";
  static const txtReferralDataProgress = "Referral data is in progress";
  static const txtConditionDataProgress = "Condition data is in progress";
  static const txtCarePlanDataProgress = "Careplan data is in progress";
  static const txtDataMiningProgress = "Data importing with new connection...";
  static const txtConnectingUrlProgress = "Connection is in progress...";
  static const txtPleaseAccept = "Please accept disclaimer";

  static const txtHealthConnect = "Health connect";
  static const txtAppleHealth = "Apple health";
  static const txtDisclaimer = "Disclaimer";

  static const server1Hapi = "https://hapi.fhir.org/baseR4";
  static const server2Fire = "https://server.fire.ly/r4";
  static const server8Fire = "https://server.fire.ly/r5";
  static const server3Meld = "https://gw.interop.community/PAA/data";
  static const server4Meld = "https://gw.interop.community/ServerA/open";
  static const server5Meld = "https://gw.interop.community/Physical/open";
  static const server6Meld = "https://gw.interop.community/Physical2/open";
  static const server7Meld = "https://demo.kodjin.com/fhir";


  static const local1 = "http://192.168.1.12:8081/fhir";
  static const local2 = "http://192.168.1.12:8082/fhir";
  static const local3 = "http://192.168.1.12:8080/fhir";
  static const local4 = "http://192.168.1.12:8090/fhir";

  static const local = "http://143.198.107.157:8080/fhir";
  static const secure2 = "http://51.8.89.151:8080/fhir";
  ///physical_activity
  ///
  ///msd@gmail.com
  ///12345
  ///kano@gmail.com
  ///1234

  static const secureServerPaa = "https://gw.interop.community/PAA/data";
  static const secureServerPaa2 = "https://gw.interop.community/PAA/data";
  static const secureServerPaa3 = "https://gw.interop.community/PAA/data";

  static const clientIdLocal = "physical_activity";
  static const clientIdMeld1 = "37862658-025c-42b3-ba86-8c16452c2e22";
  static const clientIdMeld2 = "3e8049c9-2712-4a79-9779-2797240e8b73";
  static const clientIdMeld3 = "f7163369-f9b9-49ec-bc52-460c1f2d022f";

  ///Monthly Summary
  static const dayPerWeek = "For an average week in the last 30 days, how many days per week did you engage in moderate to vigorous exercise (like walking fast, running, jogging, dancing, swimming, biking, or other activities that cause a light or heavy sweat)?";
  static const avgMin = " On those days that you engage in moderate to vigorous exercise, how many minutes, on average, do you exercise?";
  static const avgMinPerWeek = "The product of the two Exercise Vital Sign (EVS) measures, giving an average amount of moderate to vigorous physical activity in minutes/week (and captured using LOINC code 82290-8)";
  static const strengthDays = "An indication of the frequency of strength-based exercises a patient has performed, expressed as days/week (and captured using LOINC code 82291-6)";

  static const callMessage = "startCall";

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

  /// use for graph screen
  static String selectedTimeFrame = Utils.timeFrameList[0];
  static String selectedTime = Utils.timeList[0];

  static const progressLoader = "assets/json/loading.json";

  static String graphDataNotFind = "No graph are currently recorded";
  static String selectServer = "Select your Connection";
  static String connectToYourProvider = "Connect to Your Health Provider";
  // static String connectToYourProvider = "Physical Activity FHIR server ";
  static String wizard = "Setup Wizard";
  static int defaultSmileyType = 0;
  static int defaultExQuestionMarkSmiley = 4;
  static String typeOther = "Other";

  static var configurationJson = [
    {
      "title": "Bicycling",
      "iconImage": "assets/icons/ic_bicycle.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11837-4"
    },
    {
      "title": "Jogging",
      "iconImage": "assets/icons/ic_jogging.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11835-8"
    },
    {
      "title": "Running",
      "iconImage": "assets/icons/ic_running.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11836-6"
    },
    {
      "title": "Swimming",
      "iconImage": "assets/icons/ic_swimming.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11838-2"
    },
    {
      "title": "Walking",
      "iconImage": "assets/icons/ic_walking.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11834-1"
    },
    {
      "title": "Weights",
      "iconImage": "assets/icons/ic_strength.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11839-0"
    },
    {
      "title": "Mixed",
      "iconImage": "assets/icons/ic_mixed.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": "LA11840-8"
    },
    {
      "title": "Squash",
      "iconImage": "assets/icons/activity/ic_squash.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": ""
    },
    {
      "title": "American Football",
      "iconImage": "assets/icons/activity/ic_american_football.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": false,
      "isCalories": false,
      "isSteps": false,
      "isRest": false,
      "isPeck": false,
      "isNotes": true,
      "isExperience": false,
      "activityCode": ""
    },
    {
      "title": "Pilates",
      "iconImage": "assets/icons/activity/ic_Pilates.png",
      "isEnabled": true,
      "isModerate": true,
      "isVigorous": true,
      "isTotal": true,
      "isDaysStr": true,
      "isCalories": true,
      "isSteps": true,
      "isRest": true,
      "isPeck": true,
      "isNotes": true,
      "isExperience": true,
      "activityCode": ""
    }
  ];


  static String generalJson = "generalJson";
  static String activityJson = "activityJson";

  static int delayTimeLength = 20;

  static String codeChildActivityCalories = "55424-6";
  static String codeChildActivityPeakHeartRate = "55426-1";
  static String codeChildActivityVigorousMin = "77593-2";
  static String codeChildActivityModerateMin = "77592-4";
  static String codeChildActivityTotalMin = "55411-3";
  static String codeChildActivityType = "PAPanel";
  static String codeChildActivitySteps = "55423-8";
  static String codeChildActivityEx = "67675-9";

  static String hasMemberMapIdKey = "hasMemberMapIdKey";
  static String hasMemberMapDateKey = "hasMemberMapDateKey";

  static String hasMemberTypeActivity = "Activity type";
  static String hasMemberTypeModMin = "Mod min";
  static String hasMemberTypeVigMin = "Vig min";
  static String hasMemberTypeTotalMin = "Total min";
  static String hasMemberTypeCalories = "Calories";
  static String hasMemberTypeSteps = "Steps";
  static String hasMemberTypeEx = "Experience";
  static String hasMemberTypePeakHeartRate = "Peak Heart Rate";
  static String parentType = "Parent type";
  static String metaDataServerName = "metaDataServerName";
  static String metaDataServerSecure = "metaDataServerSecure";
  static String metaDataServerNameDefault = "Server";

  static const scannerLoader = "assets/json/scanner.json";

  static var cameraURL = "";
  static const pleaseSelect = "Please select";

  static const txtErrorConditionNotCreated = "Condition is not a Created, Please try again later.";
  static const txtErrorGoalNotCreated = "Goal is not a Created, Please try again later.";
  static const txtErrorCarePlanNotCreated = "Care Plan is not a Created, Please try again later.";
  static const txtErrorRxNotCreated = "RX is not a Created, Please try again later.";
  static const txtErrorReferralsNotCreated = "Referral is not a Created, Please try again later.";
  static const txtErrorTodoNotCreated = "Task is not created, Please try again later.";


  static const txtError = "Error";
  static const txtUserCanceled = "The user has canceled the login.";
  static const txtConnectionSuccess = "Connection Successful!";

  static const txtExpireTitle = "Session Expired";
  static const txtExpireDesc = "Your session has expired. Please log in again.";

  static const screenTypeHistory = "History screen";
  static const screenTypeBottom = "Bottom screen";
  static const screenTypeHome = "Home screen";
  static const screenTypeMixed = "Mixed screen";
  static const txtConnectingPatient = "Connecting to patient....";
  static bool isDialogOpenFromBottomScreen = false;
  static const rxCode = "229065009";
  static const totalSecondOfTimeOut = 5;
  static const connectionTimeOut = "Connection timeout...";
  static const appleHealthId = "com.apple.Health";
  static const appleLink = "https://apple.com";


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


  static List<ListOfMeaSure> listOfMeaSure = [];
  static int selectedRadioValue = -1;

  static const connectionNameToolTip = "The connection name is automatically derived from metadata, but you can change it if you prefer. It helps you identify and manage your connections.";
  static const connectionURLToolTip = "Enter the URL of the FHIR server. This is the web address where your health data will be accessed and managed.";
  static const clientIdToolTip = "Client ID that’s used to authenticate your connection to the FHIR server.";
  static const titleManualSetup = "Manually enter connection information";

  static const dataSyncingGoal = "Goal data syncing..";

  static const dataMixScreen = "goingToMix";
  static const dataGoalList = "dataGoalList";

  static bool isCalledAPI = false;
  static const txtPhysicalActivityPanel = "Physical Activity Panel";
  static const totalCountOfAPIData  = "10000";
  static const activityAlready  = "The activity is already in existence.";
  static const pleaseEnterActivity  = "Please enter the name of the activity";

  static String isProgress = "InProgress";
  static String isCancel = "InCancel";
  static String isCompleted = "InCompleted";
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

  static const strengthActivity = "strength";


  static const override = "0";
  static const notOverride = "1";

}
