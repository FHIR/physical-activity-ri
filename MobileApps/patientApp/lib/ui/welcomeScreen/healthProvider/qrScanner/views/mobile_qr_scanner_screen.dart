import 'package:banny_table/dataModel/patientDataModel.dart';
import 'package:banny_table/routes/app_routes.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/controllers/qr_scanner_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../../../utils/sizer_utils.dart';
import '../../../../../utils/debug.dart';
import '../../../../../utils/utils.dart';


class MobileQrScannerScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;
  MobileQrScannerScreen({this.healthProviderController,Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    return  Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: GetBuilder<QrScannerController>(builder: (logic) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(child: _widgetQrManageDetails(context,logic,orientation)),
                  _widgetButtonDetails(logic,orientation),

                ],
              );
            }),
          ),
        );

  }


  _widgetQrManageDetails(BuildContext context, QrScannerController logic,Orientation orientation
      ) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(
            left:(orientation == Orientation.portrait)? 5.w : 3.w,
            right: (orientation == Orientation.portrait)? 5.w : 3.w
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _widgetMoreDetails(orientation),
            _widgetQrCodeMoBileUse(context, logic,orientation),
            _widgetServerDropDown(context, logic,orientation),
          ],
        ),
      ),
    );
  }

  _widgetQrDetails(QrScannerController logic) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
        top: 12.h
      ),
      height: 48.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: 8.w,
                  left: 8.w),
              color: CColor.transparent,
              child: TextFormField(
                  maxLines: 1,
                  controller: logic.qrCodeDetailsController,
                  textAlign: TextAlign.start,
                  focusNode: logic.qrdDetails,
                  keyboardType: TextInputType.text,
                  style: AppFontStyle.styleW500(CColor.black,
                      12.sp),
                  cursorColor: CColor.black,
                  decoration: InputDecoration(
                    hintText: "Enter a url".tr,
                    filled: true,
                    // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                    border: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: CColor.primaryColor, width: 0.7),
                      borderRadius: BorderRadius.circular(13.0).r,
                    ),
                  ),
                ),

            ),
          ),
        ],
      ),
    );
  }

  _widgetServerDropDown(BuildContext context, QrScannerController logic,Orientation orientation
      ) {
    return Container(
      height: (orientation == Orientation.portrait)? Get.height*0.14 :Get.height*0.12,
        margin: EdgeInsets.only(
            left:(orientation == Orientation.portrait) ? Sizes.width_3:Sizes.width_4,
            right:(orientation == Orientation.portrait)? Sizes.width_3 :Sizes.width_4, top: Sizes.height_4),
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
                horizontal: Sizes.width_3, vertical: Sizes.height_1_5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: CColor.greyF8,
              border: Border.all(color: CColor.primaryColor, width: 0.7),
            ),
            child: InkWell(
              onTap: (){
                if(Utils.getServerList.isEmpty){
                  showDialogForAddNewServerUrl(
                      context, logic, logic.update,false);
                  logic.onChangeTextFiled(-1,false);
                }else{
                  showDialogForChooseUrl(logic, context,orientation);
                }
              },
              child: (logic.getServerList().isEmpty) ? Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        Constant.titleManualSetup,
                        style: AppFontStyle.styleW500(
                          CColor.black,
                          (orientation == Orientation.portrait) ?FontSize.size_10:FontSize.size_9,
                        ),
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                ),
              ): ListView.builder(
                shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: logic.getServerList().length,
                  itemBuilder: (context,index){
                return Row(
                  children: [
                    Expanded(
                      child: Text(
                        logic.getServerList()[index].title,
                        style: AppFontStyle.styleW500(
                          CColor.black,
                          (orientation == Orientation.portrait) ? FontSize.size_10:FontSize.size_7,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    // const Icon(Icons.arrow_drop_down_rounded)
                  ],
                );
              }),
            ),
        ),
      );

  }

  _widgetMoreDetails(Orientation orientation) {
    return Container(
      margin: EdgeInsets.only(top:(orientation == Orientation.portrait) ? 15.h : 6.h,left: 15.h,
          right: 15.h),
      alignment: Alignment.centerLeft,
      child: Text(
        Constant.qrScannerDetail,
        textAlign: TextAlign.start,
        style: AppFontStyle.styleW500(CColor.black, (orientation == Orientation.portrait) ? 14.sp:7.sp),
      ),
    );
  }

  _widgetQrCodeMoBileUse(BuildContext context, QrScannerController logic,Orientation orientation) {
    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(top:(orientation == Orientation.portrait) ? 25.h : 0.h),
          child: ClipRRect(
            child: GestureDetector(
              onTap: (){
                // Get.toNamed(AppRoutes.cameraScreen);
                logic.checkCameraPermissionAndOpenCamera();
              },
              child: SizedBox(
                width: (orientation == Orientation.portrait) ? 200.w : 50.w,
                height: (orientation == Orientation.portrait) ? 150.w :50.w,
                child: Image.asset("assets/icons/ic_qr_scan_main.png"),
              ),
            ),
          ),
        ),
        Text("Tap to scan",
          style: AppFontStyle.styleW700(CColor.black, (orientation == Orientation.portrait) ? 14.sp:7.sp),)
      ],
    );
  }

  _widgetButtonDetails(QrScannerController logic,Orientation orientation
      ) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              left:(orientation == Orientation.portrait) ?8.w:12.w,
              right:(orientation == Orientation.portrait) ?8.w:12.w,
              // top: 110
            ),
            padding: EdgeInsets.only(
                top: 4.h, bottom:(orientation == Orientation.portrait) ? 12.h:8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      logic.gotoNextPage();
                      // logic.callServiceProvider();
                    },
                    child: Container(
                      padding:  (orientation == Orientation.portrait) ?EdgeInsets.all(10).w :EdgeInsets.symmetric(vertical: 4.5.w),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: CColor.primaryColor,
                          borderRadius: BorderRadius.circular( (orientation == Orientation.portrait) ? 13 :5).w,
                          border: Border.all(
                              color: CColor.white
                          )
                      ),
                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: CColor.white,
                            fontSize:(orientation == Orientation.portrait) ? 15.sp:7.sp),
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

  void showDialogForChooseUrl(QrScannerController logic, BuildContext context,Orientation orientation) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialogForChooseCode) {
            return AlertDialog(
              backgroundColor: CColor.white,
              contentPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              content: SingleChildScrollView(
                child: Container(
                  width: (orientation == Orientation.portrait) ?  Get.width * 0.8 :Get.width * 0.6,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        15,
                      ),
                      color: CColor.white),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ListView.builder(
                        itemBuilder: (context, index) {
                          return _itemUrlData(index, context,
                              Utils.getServerList[index].title, logic,
                              setStateDialogForChooseCode,orientation);
                        },
                        itemCount: Utils.getServerList.length,
                        padding: const EdgeInsets.all(0),
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                      ),
                      InkWell(
                        onTap: () {
                          Get.back();
                          showDialogForAddNewServerUrl(
                              context, logic, setStateDialogForChooseCode,false);
                          logic.onChangeTextFiled(-1,false);
                        },
                        child: Container(
                          margin: EdgeInsets.only(
                            left: Sizes.width_2,
                          ),
                          child: Text(
                            "+ Add New Connection",
                            style: AppFontStyle.styleW500(
                              CColor.primaryColor,
                              FontSize.size_12,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: Sizes.height_2),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  Get.back();
                                  // logic.addUrlForMultiServer();
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.transparent),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Cancel",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.black, FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: Sizes.width_2),
                            Expanded(
                              child: TextButton(
                                onPressed: () {
                                  setStateDialogForChooseCode(() {
                                    logic.addUrlForMultiServer();
                                  });
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      CColor.primaryColor),
                                  elevation: MaterialStateProperty.all(1),
                                  shadowColor:
                                  MaterialStateProperty.all(CColor.gray),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      side: const BorderSide(
                                          color: CColor.primaryColor,
                                          width: 0.7),
                                    ),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    "Add",
                                    textAlign: TextAlign.center,
                                    style: AppFontStyle.styleW400(
                                        CColor.white, FontSize.size_12),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).then((value) => {

    });
  }

  _itemUrlData(int index, BuildContext context, String codeList,
      QrScannerController logic,setStateDialogForChooseCode,Orientation orientation) {
    return InkWell(
      onTap: () {
        setStateDialogForChooseCode(() {
          logic.onChangeUrl(index);
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: Sizes.width_2),
        child: Row(
          children: [
            Checkbox(
              value: Utils.getServerList[index].isSelected,
              onChanged: (value) {
                setStateDialogForChooseCode(() {
                  logic.onChangeUrl(index);
                });
              },
            ),
            Expanded(
              child: Text(
                codeList,
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
                style: AppFontStyle.styleW500(
                  CColor.black,
                  FontSize.size_10,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                logic.changeIsAuth(Utils.getServerList[index].isSecure);
                Get.back();
                showDialogForAddNewServerUrl(
                    context, logic, setStateDialogForChooseCode,true,index: index);
                logic.onChangeTextFiled(index,true);
              },
              child: Container(
                margin: EdgeInsets.only(right: Sizes.width_2),
                child: Icon(
                  Icons.edit,
                  size: Sizes.width_5,
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                showDeleteAlertDialog(context, (value) {
                  logic.removeFromUrlList(index,isRemovedFromLocal: false);
                  Get.back();
                  setStateDialogForChooseCode(() {});
                }, codeList, (value) {
                  Get.back();
                });
              },
              child: Container(
                margin: EdgeInsets.only(right: Sizes.width_2),
                child: Icon(
                  Icons.delete,
                  size: Sizes.width_5,
                  color: CColor.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  showDeleteAlertDialog(BuildContext context,Function okCallBack,String serverName,Function cancelCallBack) {

    // set up the button
    Widget okButton = TextButton(
      child: const Text("Delete"),
      onPressed: () {
        okCallBack.call("");
      },
    );

    Widget cancelButton = TextButton(
      child: const Text("Cancel"),
      onPressed: () {
        cancelCallBack.call("");
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(serverName),
      content: const Text("This connection will be deleted from your app."),
      actions: [
        okButton,
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDialogForAddNewServerUrl(BuildContext context, QrScannerController logic,
      setStateDialogForChooseCode,bool isEdit,{int index = -1}) {
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
                          if(logic.addServerTitleName.text.isNotEmpty)
                            Container(
                              margin: EdgeInsets.only(bottom: Sizes.height_2),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: Sizes.width_2, left: Sizes.width_2,bottom: Sizes.height_1),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Connection Name",
                                          style: AppFontStyle.styleW700(CColor.black,
                                              (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                                        ),
                                        PopupMenuButton(
                                          elevation: 0,
                                          constraints: BoxConstraints(
                                              minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                                          color: Colors.transparent,
                                          padding: const EdgeInsets.all(0),
                                          position: PopupMenuPosition.under,
                                          itemBuilder: (context) {
                                            return [
                                              PopupMenuItem(
                                                child: Container(
                                                    padding: const EdgeInsets.all(6),
                                                    decoration: BoxDecoration(
                                                        color: CColor.white,
                                                        border: Border.all(width: 1),
                                                        borderRadius: BorderRadius.circular(10)),
                                                    child: const Text(
                                                        Constant.connectionNameToolTip)),
                                              ),
                                            ];
                                          },
                                          child: Icon(Icons.info_outline,
                                              color: CColor.black, size: Sizes.height_2_5),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                  // margin: EdgeInsets.only(top: Sizes.height_1),
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addServerTitleName,
                                    focusNode: logic.addServerTitleNameFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: AppFontStyle.styleW500(
                                        CColor.black, FontSize.size_10),
                                    maxLines: 1,
                                    cursorColor: CColor.black,
                                    decoration: InputDecoration(
                                      filled: true,
                                      // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                          ),
                                ],
                              ),
                            ),
                          Container(
                            margin: EdgeInsets.only(
                                 right: Sizes.width_2, left: Sizes.width_2),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Connection URL",
                                  style: AppFontStyle.styleW700(CColor.black,
                                      (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                                ),
                                PopupMenuButton(
                                  elevation: 0,
                                  constraints: BoxConstraints(
                                      minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                                  color: Colors.transparent,
                                  padding: const EdgeInsets.all(0),
                                  position: PopupMenuPosition.under,
                                  itemBuilder: (context) {
                                    return [
                                      PopupMenuItem(
                                        child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                                color: CColor.white,
                                                border: Border.all(width: 1),
                                                borderRadius: BorderRadius.circular(10)),
                                            child: const Text(
                                                Constant.connectionURLToolTip)),
                                      ),
                                    ];
                                  },
                                  child: Icon(Icons.info_outline,
                                      color: CColor.black, size: Sizes.height_2_5),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_1),
                            color: CColor.transparent,
                            child: TextFormField(
                              controller: logic.addOtherUrlController,
                              focusNode: logic.addOtherUrlFocus,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              style: AppFontStyle.styleW500(
                                  CColor.black, FontSize.size_10),
                              maxLines: 1,
                              cursorColor: CColor.black,
                              decoration: InputDecoration(
                                // hintText: "Connection url".tr,
                                filled: true,
                                // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                disabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: CColor.primaryColor, width: 0.7),
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                              ),
                            ),
                          ),
                          if(logic.isAuth)
                            Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Column(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(
                                      right: Sizes.width_2, left: Sizes.width_2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Client Id",
                                        style: AppFontStyle.styleW700(CColor.black,
                                            (kIsWeb) ? FontSize.size_3 : FontSize.size_10),
                                      ),
                                      PopupMenuButton(
                                        elevation: 0,
                                        constraints: BoxConstraints(
                                            minWidth: Get.width * 0.1, maxWidth: Get.width * 0.8),
                                        color: Colors.transparent,
                                        padding: const EdgeInsets.all(0),
                                        position: PopupMenuPosition.under,
                                        itemBuilder: (context) {
                                          return [
                                            PopupMenuItem(
                                              child: Container(
                                                  padding: const EdgeInsets.all(6),
                                                  decoration: BoxDecoration(
                                                      color: CColor.white,
                                                      border: Border.all(width: 1),
                                                      borderRadius: BorderRadius.circular(10)),
                                                  child: const Text(
                                                      Constant.clientIdToolTip)),
                                            ),
                                          ];
                                        },
                                        child: Icon(Icons.info_outline,
                                            color: CColor.black, size: Sizes.height_2_5),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: Sizes.height_1),
                                  color: CColor.transparent,
                                  child: TextFormField(
                                    controller: logic.addOtherUrlClientIdController,
                                    focusNode: logic.addOtherUrlClientIdFocus,
                                    textAlign: TextAlign.start,
                                    keyboardType: TextInputType.text,
                                    style: AppFontStyle.styleW500(
                                        CColor.black, FontSize.size_10),
                                    maxLines: 1,
                                    cursorColor: CColor.black,
                                    decoration: InputDecoration(
                                      filled: true,
                                      // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: Sizes.width_5),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      disabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: CColor.primaryColor, width: 0.7),
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: Sizes.height_2),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      Get.back();
                                      logic.onChangeEditAdd(true);
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          CColor.transparent),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black, FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: Sizes.width_2),
                                Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      var serverInputtedUrl = logic.addOtherUrlController.text.toString();
                                      var serverClientId = logic.addOtherUrlClientIdController.text.toString();
                                      if(serverInputtedUrl.isNotEmpty && serverClientId.isEmpty && logic.isValidURL(serverInputtedUrl)) {
                                        Utils.checkWhetherSecureOrNot(
                                            serverInputtedUrl,context).then((value) async {
                                          Debug.printLog("Map data from metadata....$value");
                                          if(value.isNotEmpty){
                                            if(value[Constant.msg] == Constant.failedConnected){
                                              Get.back();
                                              Get.back();
                                              Utils.showErrorDialog(context, Constant.txtError, value[Constant.msg]);
                                              return;
                                            }
                                            if(value[Constant.metaDataServerName] != null){
                                              logic.changeServerName(value[Constant.metaDataServerName],false);
                                            }

                                            if(value[Constant.metaDataServerSecure]){
                                              Get.back();
                                              logic.changeIsAuth(true);
                                            }else{
                                              ///This is for when It will come without Secure server from the
                                              ///Meta data API then we will close this Dialog and Show Connection success
                                              ///Dialog
                                              // Get.back();
                                              logic.addNewServerUrlDataIntoList(
                                                  true,
                                                  index: index,setStateDialogForChooseCode,isEditServer:
                                              logic.isEdit,isNotClose: false).then((value) => {
                                                Debug.printLog("Close Dialog"),
                                              });
                                              logic.onChangeEditAdd(logic.isEdit);
                                              try{

                                              }catch(e){
                                                setStateDialogForChooseCode(() {});
                                              }
                                            }

                                           if(!value[Constant.metaDataServerSecure]) {
                                             if (context.mounted) {
                                               try {
                                                 await logic.getPatientList(
                                                     false);
                                               } catch (e) {
                                                 Debug.printLog(
                                                     'Error fetching patient list: $e');
                                               }
                                             }
                                           }
                                          }else{
                                            Utils.showToast(Get.context!, value[Constant.msg].toString());
                                          }
                                          setState((){});
                                        });
                                      }
                                      else if(serverInputtedUrl.isNotEmpty && serverClientId.isNotEmpty){
                                        if(logic.isAuth && serverClientId.isEmpty){
                                          Utils.showToast(Get.context!, "Please enter valid client id");
                                          return;
                                        }
                                        if(logic.isEdit) {
                                          logic.addNewServerUrlDataIntoList(
                                              Utils.getServerList[index].isSelected,
                                              index: index,setStateDialogForChooseCode,isEditServer: true);
                                        }else{
                                          logic.addNewServerUrlDataIntoList(
                                              true,
                                              index: index,setStateDialogForChooseCode).then((value) => {
                                            Debug.printLog("Close Dialog"),
                                          });
                                        }
                                        logic.onChangeEditAdd(logic.isEdit);
                                        // setStateDialogForChooseCode(() {});
                                      }
                                      else{
                                        Utils.showToast(Get.context!, "Please enter valid connection URL");
                                      }
                                    },
                                    style: ButtonStyle(
                                      backgroundColor: MaterialStateProperty.all(
                                          CColor.primaryColor),
                                      elevation: MaterialStateProperty.all(1),
                                      shadowColor:
                                      MaterialStateProperty.all(CColor.gray),
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15.0),
                                          side: const BorderSide(
                                              color: CColor.primaryColor,
                                              width: 0.7),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        /*(logic.isAuth)?"Connect"
                                            "":(!logic.isEdit)?"Add":"Update",*/
                                        "Connect",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white, FontSize.size_12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
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
      logic.onChangeEditAdd(false);
    });
  }


}
