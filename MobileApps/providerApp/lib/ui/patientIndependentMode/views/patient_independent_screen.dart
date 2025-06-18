import 'package:banny_table/ui/patientIndependentMode/controllers/patient_independent_controller.dart';
import 'package:banny_table/ui/patientIndependentMode/datamodel/ToDoListDatamodel.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../db_helper/box/to_do_form_data.dart';
import '../../../routes/app_routes.dart';
import '../../../utils/constant.dart';
import '../../../utils/debug.dart';
import '../../../utils/font_style.dart';
import '../../../utils/sizer_utils.dart';
import '../../../utils/utils.dart';

class PatientIndependentScreen extends StatelessWidget {
  const PatientIndependentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: ScreenUtilInit(
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return  LayoutBuilder(
            builder: (BuildContext context,BoxConstraints constraints) {
              return GetBuilder<PatientIndependentController>(builder: (logic) {
                return DefaultTabController(
                  length: Utils.getPrimaryServerData() == null ? 2: (Utils.getPrimaryServerData()!.isAdmin) ? 3:2,
                  // length: 3,
                  initialIndex: 0,
                  child: Scaffold(
                    backgroundColor: CColor.white,
                    appBar: AppBar(
                      toolbarHeight: 50,
                      // primary:(orientation == Orientation.portrait)?true :false,
                      backgroundColor: CColor.primaryColor,
                      title: const Text("Physical Activity Provider"),
                      actions: [
                        (logic.selectedTabBarValue == 0) ?
                        InkWell(
                          onTap: () {
                            showFilterDialog(logic, context,Constant.homePatientTask,orientation,constraints);
                          },
                          child: Container(
                            margin: EdgeInsets.only(
                              right: Sizes.width_3
                            ),
                            alignment: Alignment.center,
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.filter_list_rounded,
                              color: CColor.white,
                              size:(kIsWeb) ?  AppFontStyle.sizesWidthManageWeb(1.4, constraints):Sizes.width_5,
                            ),
                          ),
                        ) : Container()
                      ],
                      bottom:  TabBar(
                        labelColor: CColor.white,
                        indicatorColor: CColor.white,
                        onTap: (value){
                          logic.changeMode(value);
                        },
                        /*tabs: const [
                          Tab(text: "Patient"),
                          Tab(text: 'ToDo'),
                        ],*/
                        tabs: [

                          Tab(child: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                child: const Text("Todo"),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: (kIsWeb) ? Sizes.width_5:Sizes.width_14
                                ),
                                alignment: Alignment.topCenter,
                                child: Container(
                                  width: (kIsWeb) ? Sizes.height_3: Sizes.height_2_5,
                                  height: (kIsWeb) ?Sizes.height_3 :Sizes.height_2_5,
                                  decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle
                                  ),
                                  alignment: Alignment.center,
                                  // padding: EdgeInsets.all(3),
                                  child: Text(logic.toDoCreatedDataList.where((element) => element.tag != Constant.statusTaskReviewed).length.toString(),style: AppFontStyle.styleW500(
                                      CColor.white, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : FontSize.size_9),),
                                ),
                              )
                            ],
                          )),
                          const Tab(text: "Patient"),
                          if(Utils.getPrimaryServerData() != null && Utils.getPrimaryServerData()!.isAdmin)const Tab(text: "Provider"),
                        ],
                      ),
                    ),
                    floatingActionButton: logic.selectedTabBarValue == 1 ? FloatingActionButton(
                      backgroundColor: CColor.primaryColor,
                      onPressed: () {
                         Get.toNamed(AppRoutes.createPatientScreen,arguments:[null]);
                      },
                      child: const Icon(Icons.add),
                    ) :
                    (logic.selectedTabBarValue == 2 && Utils.getPrimaryServerData()!.isAdmin)  ?
                    FloatingActionButton(
                      backgroundColor: CColor.primaryColor,
                      onPressed: () {

                        Debug.printLog("Tab On Provider");
                        Get.toNamed(AppRoutes.createPractitionerScreen,arguments: [null]);
                      },
                      child: const Icon(Icons.add),
                    )  : Container(),
                    body:  SafeArea(
                        child: TabBarView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                            Utils.pullToRefreshApi(
                                _listViewToDoTask(logic),
                                logic.refreshController,
                                logic.onRefresh,
                                logic.onLoading),


                            Utils.pullToRefreshApi(
                                _widgetPatientMode(context, logic, orientation,constraints),
                                logic.refreshPatient,
                                logic.onRefreshPatient,
                                logic.onLoadingPatient),


                            if (Utils.getPrimaryServerData() != null &&
                                Utils.getPrimaryServerData()!.isAdmin)
                              Utils.pullToRefreshApi(
                                  _widgetPractitionerModePractitioner(
                                      context, logic, orientation,constraints),
                                  logic.refreshProvider,
                                  logic.onRefreshProvider,
                                  logic.onLoadingProvider),
                      ],
                            ),

                    ),
                  ),
                );
              });
            }
          );
        },
      ),
    );
  }

  _widgetPatientMode(BuildContext context, PatientIndependentController logic,Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top:  (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints): Sizes.height_1,
          left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Expanded(child: _widgetSearchIDText(logic,orientation)),
              Expanded(child: _widgetSearchNameText(logic,orientation,constraints),),
            ],
          ),
          _widgetPatientIds(logic,orientation,constraints),
          // _widgetButtonDetails(context)
        ],
      ),
    );
  }

  /*Widget _widgetSearchIDText(PatientIndependentController logic,Orientation orientation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top:(orientation == Orientation.portrait)? Sizes.height_2 :Sizes.height_0_2, right: Sizes.width_1_5, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.searchIdControllers,
            // keyboardType: TextInputType.text,
            keyboardType: Utils.getInputTypeKeyboard(),
            textAlign: TextAlign.start,
            focusNode: logic.searchIdFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Id",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getPatientList();
            },
          ),
        ),
      ],
    );
  }*/

  Widget _widgetSearchNameText(PatientIndependentController logic,Orientation orientation,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints)
                  : (orientation == Orientation.portrait)
                      ? Sizes.height_2
                      : Sizes.height_0_2,
              right: (kIsWeb)
                  ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
              left: (kIsWeb)
                  ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) : Sizes.width_1_5),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.searchNameControllers,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.searchNameFocus,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Name",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getPatientList();
            },
          ),
        ),
      ],
    );
  }

  _widgetPatientIds(PatientIndependentController logic,Orientation orientation,BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(
            left:  (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.5, constraints) : Sizes.width_1_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.5, constraints) : Sizes.width_1_2,
            top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) : (orientation == Orientation.portrait)? Sizes.height_2 :Sizes.height_0_5
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal:  (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.3, constraints):Sizes.width_0_5, vertical: 7),
            decoration: const BoxDecoration(
                color: CColor.white
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (logic.patientProfileList.isNotEmpty)?
                Container(
              /*    margin: const EdgeInsets.only(
                    // bottom:(orientation == Orientation.portrait)? Sizes.height_6:Sizes.height_1
                  ),*/
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      return _itemUser(logic, index, context ,orientation,constraints);
                    },
                    itemCount: logic.patientProfileList.length,
                    padding:  EdgeInsets.only(bottom: Sizes.height_7),
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                  ),
                ): (!logic.isShowProgress) ?
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "No user found",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CColor.black,
                        fontSize: (orientation == Orientation.portrait)? 15.sp :7.sp),
                  ),
                ):Container(),
                Container(
                  alignment: Alignment.center,
                  child: (logic.isShowProgress) ?
                  const CircularProgressIndicator(
                    // backgroundColor: CColor.primaryColor,
                    valueColor: AlwaysStoppedAnimation(CColor.primaryColor),
                    // strokeWidth: 10,
                  ) : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemUser(PatientIndependentController logic, int index, BuildContext context, Orientation orientation,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        logic.saveDetail(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          border: Border.all(
              color: (logic.patientProfileList[index].patientId ==
                  Utils.getPatientId() ||
                  logic.patientProfileList[index].patientId ==
                      Utils.getProviderId()) /*||
                      logic.patientProfileList[index].patientId ==
                          Utils.getServiceProviderId())*/
                  ? CColor.primaryColor
                  : CColor.transparent),
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.3, constraints): Sizes.width_0_5,
            vertical:  (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : (orientation == Orientation.portrait)? Sizes.height_1 :Sizes.height_0_5),
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.height_1_2,
          vertical: Sizes.height_1,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints):10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: const Icon(Icons.person, color: CColor.primaryColor,),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left: (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : (orientation == Orientation.portrait)? Sizes.width_3 :Sizes.width_5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      logic.patientProfileList[index].fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : (orientation == Orientation.portrait)? 13.sp : 10.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: "${logic.patientProfileList[index].fName} ",
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.3, constraints) : (orientation == Orientation.portrait)? 13.sp : 7.sp
                              ),
                            ),
                            TextSpan(
                              text: logic.patientProfileList[index].lName
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.2, constraints) : (orientation == Orientation.portrait)? 13.sp : 7.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      logic.patientProfileList[index].dob.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints) : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Utils.checkDate(logic.patientProfileList[index].dob.toString()),
                              // text:DateFormat(Constant.commonDateFormatMmmDdYyyy).format(DateTime.parse(logic.patientProfileList[index].dob.toString())),
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ?  AppFontStyle.sizesFontManageWeb(1.2, constraints) :(orientation == Orientation.portrait)? 12.sp :6.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                )),
            InkWell(
              onTap: () {
                /*Get.toNamed(AppRoutes.createPatientScreen,
                        arguments: [logic.patientProfileList[index]])!
                    .then((value) => (value) {
                          Debug.printLog("Call....");
                        });*/
                Navigator.of(context).pushNamed(AppRoutes.createPatientScreen,
                    arguments: [logic.patientProfileList[index]])
                    .then((value) {
                  Debug.printLog("Call....");
                  // logic.getPatientList();
                });
              },
              child: Container(
                padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints):10),
                child: const Icon(Icons.edit, color: CColor.primaryColor,),
              ),
            ),

          ],
        ),
      ),
    );
  }

/*  _widgetButtonDetails(BuildContext context) {
    return GetBuilder<PatientIndependentController>(builder: (logic) {
      if ((kIsWeb)) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left:8.h,
                right:8.h,
                // top: 110
              ),
              padding: EdgeInsets.only(
                  top: 4.h, bottom: 10.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        logic.moveToScreen();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CColor.primaryColor,
                            borderRadius: BorderRadius.circular(13),
                            border: Border.all(
                                color: CColor.white
                            )
                        ),
                        child: Text(
                          "Next",
                          style: TextStyle(
                              color: CColor.white,
                              fontSize:Utils.sizesFontManage(context ,3.5)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              margin: EdgeInsets.only(
                left: 8.w,
                right: 8.w,
              ),
              padding: EdgeInsets.only(top: 4.h, bottom: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        logic.moveToScreen();
                      },
                      child: Container(
                        padding:  const EdgeInsets.all((kIsWeb)?5:10).w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: CColor.primaryColor,
                            borderRadius: BorderRadius.circular(13).w,
                            border: Border.all(color: CColor.white)),
                        child: Text(
                          "Next",
                          style: TextStyle(color: CColor.white,
                              fontSize: Utils.sizesFontManage(context ,7)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }
    });
  }*/


  /// ToDo Tasks
  _listViewToDoTask(PatientIndependentController logic) {
    return (logic.toDoCreatedDataList.isEmpty)
        ? _emptyCreatedWidget()
        : Container(
      color: CColor.white,
      margin: EdgeInsets.only(
          // top: Sizes.height_2_1,
          left: Sizes.width_1,
          right: Sizes.width_1),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _itemCreatedToDoList(logic.toDoCreatedDataList[index]
              ,logic,index,context);
        },
        itemCount: logic.toDoCreatedDataList.length,
        padding: EdgeInsets.only(bottom: Sizes.height_10),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }

  _itemCreatedToDoList(ToDoDataListModel conditionData, PatientIndependentController logic,int index,BuildContext context) {
    return (logic.toDoCreatedDataList.isEmpty) ? _emptyWidget("You don’t have any open tasks") :
    GestureDetector(
      onTap: () async {

        if(conditionData.ownerReference.split("/")[0] != null) {
          if(conditionData.ownerReference.split("/")[0].toLowerCase() == "Patient".toLowerCase()){
                         await Get.toNamed(AppRoutes.toDoFormScreen, arguments: [
                conditionData,
                (conditionData.isCreated!)
                    ? Constant.todoFromCreated
                    : Constant.todoFromAssigned,
                true
              ])!
                  .then((value) async =>
                      {logic.updateMethod(), await logic.getTodoApiData()});

          }else{
            await Get.toNamed(AppRoutes.taskReferralScreen,arguments: [conditionData])!.then((value) async =>
            {logic.updateMethod(), await logic.getTodoApiData()});

          }
        }else{
          await Get.toNamed(AppRoutes.taskReferralScreen,arguments: [conditionData])!.then((value) async =>
          {logic.updateMethod(), await logic.getTodoApiData()});
        }
/*             await Get.toNamed(AppRoutes.toDoFormScreen, arguments: [
                conditionData,
                (conditionData.isCreated!)
                    ? Constant.todoFromCreated
                    : Constant.todoFromAssigned,
                true
              ])!
                  .then((value) async =>
                      {logic.updateMethod(), await logic.getTodoApiData()});*/
            },
      child: Container(
        decoration: BoxDecoration(
          color: (conditionData.tag != Constant.statusTaskReviewed) ? CColor.blueColorRe: CColor.white ,
        ),

        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_2),
        width: double.infinity,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              (conditionData.priority == Constant.priorityUrgent) ? Container(
                margin: EdgeInsets.only(
                    right: Sizes.width_1
                ),
                child: Image.asset(
                    Constant.icInformation, color: CColor.red,width: Sizes.height_2,height: Sizes.height_2,),
              ) :Container(),
              Expanded  (
                  child: Container(
                    margin: EdgeInsets.only(left: Sizes.width_1,right: Sizes.width_4),
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        RichText(
                      text: TextSpan(
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: [
                          TextSpan(
                            ///Patient Name
                            text: "${Utils.uiStatusFromAPIStatus(conditionData.status ?? "")} ",
                            style:  TextStyle(
                              fontWeight:  (conditionData.tag != Constant.statusTaskReviewed) ? FontWeight.bold:  FontWeight.w500 ,
                              color: Utils.uiStatusColorFromAPIStatus(conditionData.status ?? "")
                            ),
                          ),
                          if(conditionData.forDisplay != "" && conditionData.forDisplay != "null" && conditionData.forDisplay != "Null")TextSpan(
                            ///Patient Name
                            text: conditionData.forDisplay,
                            style:  TextStyle(
                              fontWeight:  (conditionData.tag != Constant.statusTaskReviewed) ? FontWeight.bold:  FontWeight.w500 ,
                            ),
                          ),
                          TextSpan(
                            text: (conditionData.display != null)
                                ? ': ${conditionData.display} '
                                : (conditionData.code != null) ? ": ${conditionData.code}" :
                            (conditionData.text != "") ? conditionData.text : "",
                            style: TextStyle(
                              fontWeight: (conditionData.tag != Constant.statusTaskReviewed) ?  FontWeight.bold:FontWeight.w500 ,
                            ),
                          ),
                        ],
                      ),
                          maxLines: 3,
                    )
                  ],
                ),
                  )),
              Column(
                children: [
                  conditionData.isCreated! ?
                  Container(
                    margin: EdgeInsets.only(
                        top: Sizes.height_0_4
                    ),
                    child: Image.asset(
                      Constant.icCreated,
                      height: Sizes.height_3,
                      width: Sizes.height_3,
                    ),
                  ) :
                  Container(
                    margin: EdgeInsets.only(
                        top: Sizes.height_0_4
                    ),
                    child: Image.asset(
                      Constant.icAssign,
                      height: Sizes.height_3,
                      width: Sizes.height_3,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _emptyWidget(String title) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5,vertical: Sizes.height_3),
        child: Text(
          title,
          style: AppFontStyle.styleW500(
              CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  _emptyCreatedWidget() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: Sizes.width_5),
        child: Text(
          "You don’t have any open tasks",
          style: AppFontStyle.styleW500(CColor.black, (kIsWeb)?FontSize.size_3:FontSize.size_12),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void showFilterDialog(PatientIndependentController logic, BuildContext context,String fromType,Orientation orientation,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              // backgroundColor: Colors.transparent,
              // insetPadding: const EdgeInsets.all(10),
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: Container(
                // margin: const EdgeInsets.all(40),
                width: Get.width * 0.15,
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                    color: CColor.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      // height: (orientation == Orientation.portrait) ? Sizes.height_35 :Sizes.height_25,
                      child: Container(
                        margin: EdgeInsets.only(left: Sizes.width_2_5),
                        child: ListView.builder(
                          itemBuilder: (context, index) {
                            return Row(
                              children: [
                                Text(logic.shortingNameTODO(
                                  logic.getFilterListStatusWise(fromType)[index].status
                                      .toString()),
                                ),
                                Checkbox(
                                  value: logic.getFilterListStatusWise(fromType)[index].isSelected,
                                  onChanged: (value) {
                                    logic.onChangeFilterDara(
                                        !logic.getFilterListStatusWise(fromType)[index].isSelected,
                                        index,fromType);
                                    setState(() {});
                                  },
                                )
                              ],
                            );
                          },
                          shrinkWrap: true,
                          itemCount: logic.getFilterListStatusWise(fromType).length,
                          physics: const AlwaysScrollableScrollPhysics(),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.back();
                          },
                          child: Text(
                            "Cancel",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints):FontSize.size_12,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            logic.onChangeFilterDataTapOnOk(fromType);
                          },
                          child: Text(
                            "Ok",
                            style: AppFontStyle.styleW600(
                              CColor.black,
                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.5, constraints):FontSize.size_12,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

///Practitioner
  _widgetPractitionerModePractitioner(BuildContext context, PatientIndependentController logic,Orientation orientation,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          top:  (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(0.8, constraints): Sizes.height_1,
          left: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
          right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(1.0, constraints) : Sizes.width_3
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Expanded(child: _widgetSearchIDTextPractitioner(logic,orientation)),
              Expanded(child: _widgetSearchNameTextPractitioner(logic,orientation,constraints),),
            ],
          ),
          _widgetPatientIdsPractitioner(logic, orientation,constraints),
          // _widgetButtonDetails(context)
        ],
      ),
    );
  }

  Widget _widgetSearchIDTextPractitioner(PatientIndependentController logic,orientation) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          // height: Sizes.height_6,
          margin: EdgeInsets.only(
              top:(orientation == Orientation.portrait)? Sizes.height_2 :Sizes.height_0_2, right: Sizes.width_1_5, left: Sizes.width_3),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.searchIdControllersPractitioner,
            // keyboardType: TextInputType.text,
            keyboardType: Utils.getInputTypeKeyboard(),
            textAlign: TextAlign.start,
            focusNode: logic.searchIdFocusPractitioner,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Id",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getListPractitioner();
            },
          ),
        ),
      ],
    );
  }

  Widget _widgetSearchNameTextPractitioner(PatientIndependentController logic,orientation,BoxConstraints constraints) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(
              top: (kIsWeb)
                  ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) :(orientation == Orientation.portrait)
                  ? Sizes.height_2
                  : Sizes.height_0_2,
              right: (kIsWeb)
                  ? AppFontStyle.sizesWidthManageWeb(1.0, constraints): Sizes.width_3,
              left:(kIsWeb)
                  ? AppFontStyle.sizesWidthManageWeb(0.9, constraints) :  Sizes.width_1_5),
          decoration: BoxDecoration(
            color: CColor.transparent,

            border: Border.all(
              color: CColor.primaryColor, width: 0.7,
            ),
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: TextFormField(
            controller: logic.searchNameControllersPractitioner,
            keyboardType: TextInputType.text,
            textAlign: TextAlign.start,
            focusNode: logic.searchNameFocusPractitioner,
            textInputAction: TextInputAction.done,
            style: AppFontStyle.styleW500(
                CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints)  : FontSize.size_10),
            cursorColor: CColor.black,
            decoration: const InputDecoration(
              hintText: "Search Name",
              filled: true,
              border: InputBorder.none,
            ),
            onChanged: (value) {
              logic.getListPractitioner();
            },
          ),
        ),
      ],
    );
  }

  _widgetPatientIdsPractitioner(PatientIndependentController logic,Orientation orientation,BoxConstraints constraints) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(

            left:  (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.5, constraints) : Sizes.width_1_3,
            right: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.5, constraints) : Sizes.width_1_2,
            top: (kIsWeb) ? AppFontStyle.sizesHeightManageWeb(1.0, constraints) :(orientation == Orientation.portrait)? Sizes.height_2 :Sizes.height_0_5
        ),
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(
                horizontal:(kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.3, constraints): Sizes.width_0_5, vertical: 7),
            decoration: const BoxDecoration(
                color: CColor.white
            ),
            child: Stack(
              alignment: Alignment.topCenter,
              // crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                (logic.practitionerProfileList.isNotEmpty)?
                ListView.builder(
                  itemBuilder: (context, index) {
                    return _itemUserPractitioner(logic, index, context,orientation,constraints);
                  },
                  itemCount: logic.practitionerProfileList.length,
                  padding:  EdgeInsets.only(bottom: Sizes.height_7),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                ): (!logic.isShowProgress) ?
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "No user found",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: CColor.black,
                        fontSize: (orientation == Orientation.portrait)? 15.sp :7.sp),
                  ),
                ):Container(),
                Container(
                  alignment: Alignment.center,
                  child: (logic.isShowProgress) ?
                  const CircularProgressIndicator(
                    // backgroundColor: CColor.primaryColor,
                    valueColor: AlwaysStoppedAnimation(CColor.primaryColor),
                    // strokeWidth: 10,
                  ) : Container(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemUserPractitioner(PatientIndependentController logic, int index, BuildContext context,Orientation orientation,BoxConstraints constraints) {
    return GestureDetector(
      onTap: () {
        // logic.saveDetailPractitioner(index);
      },
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.white,
          border: Border.all(
              color: (logic.practitionerProfileList[index].patientId ==
                  Utils.getPatientId() ||
                  logic.practitionerProfileList[index].patientId ==
                      Utils.getProviderId()) /*||
                      logic.practitionerProfileList[index].patientId ==
                          Utils.getServiceProviderId())*/
                  ? CColor.primaryColor
                  : CColor.transparent),
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),
        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.3, constraints):  Sizes.width_0_5,
            vertical: (kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.8, constraints) : (orientation == Orientation.portrait)? Sizes.height_1 :Sizes.height_0_5),
        padding: EdgeInsets.symmetric(
          horizontal : Sizes.height_1_2,
          vertical:  Sizes.height_1,),
        width: double.infinity,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints):10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.primaryColor30,
              ),
              child: const Icon(Icons.person, color: CColor.primaryColor,),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(
                      left:  (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.0, constraints) : (orientation == Orientation.portrait)? Sizes.width_3 :Sizes.width_5),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      logic.practitionerProfileList[index].fName.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? 5.sp : (orientation == Orientation.portrait)? 13.sp : 10.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: "${logic.practitionerProfileList[index].fName} ",
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints)  : (orientation == Orientation.portrait)? 13.sp : 7.sp
                              ),
                            ),
                            TextSpan(
                              text: logic.practitionerProfileList[index].lName
                                  .toString(),
                              style: AppFontStyle.styleW600(
                                  CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints)  : (orientation == Orientation.portrait)? 13.sp : 7.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                      logic.practitionerProfileList[index].dob.isNotEmpty ?
                      RichText(
                        text: TextSpan(
                          text: "",
                          style: AppFontStyle.styleW700(
                              CColor.black, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.3, constraints)  : 13.sp),
                          children: [

                            ///This Is use For Goal Type is mandatory
                            TextSpan(
                              text: Utils.checkDate(logic.practitionerProfileList[index].dob.toString()),
                              style: AppFontStyle.styleW600(
                                  CColor.gray, (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints)  : (orientation == Orientation.portrait)? 13.sp : 6.sp
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    ],
                  ),
                )),
            InkWell(
              onTap: () {
                /*Get.toNamed(AppRoutes.createPractitionerScreen,arguments: [logic.practitionerProfileList[index]])!
                .then((value) => (value) {
                  logic.getListPractitioner();
                });*/

                Navigator.of(context).pushNamed(AppRoutes.createPractitionerScreen,
                    arguments:[ logic.practitionerProfileList[index]])
                    .then((value) {
                  // logic.getListPractitioner();
                });

              },
              child: Container(
                padding:  EdgeInsets.all((kIsWeb) ? AppFontStyle.sizesWidthManageWeb(0.7, constraints):10),
                child: const Icon(Icons.edit, color: CColor.primaryColor,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
