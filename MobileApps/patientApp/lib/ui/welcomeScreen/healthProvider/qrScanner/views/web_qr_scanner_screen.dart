import 'package:banny_table/ui/welcomeScreen/healthProvider/healthProvider/controllers/health_provider_controller.dart';
import 'package:banny_table/ui/welcomeScreen/healthProvider/qrScanner/controllers/qr_scanner_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/font_style.dart';
import 'package:banny_table/utils/utils.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../../utils/sizer_utils.dart';

class WebQrScannerScreen extends StatelessWidget {
  HealthProviderController? healthProviderController;
  WebQrScannerScreen({this.healthProviderController ,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) {
        return  Scaffold(
          backgroundColor: CColor.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (BuildContext context,BoxConstraints constraints) {
                return GetBuilder<QrScannerController>(builder: (logic) {
                  return Column(
                    children: [
                      Expanded(child: _widgetQrManageDetails(context, logic,constraints),),
                      _widgetButtonDetails(context,constraints,logic),
                    ],
                  );
                });
              }
            ),
          ),
        );
      },
    );
  }


  _widgetQrManageDetails(BuildContext context, QrScannerController logic,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(
          left: AppFontStyle.sizesWidthManageWeb(1.7, constraints),
          right: AppFontStyle.sizesWidthManageWeb(1.7, constraints)
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // _widgetQrDetails(logic,context),
            _widgetMoreDetails(context,constraints),
            _widgetServerDropDown(context,logic,constraints),
            // Expanded(child: Container()),
            // Expanded(child: Container()),
          ],
        ),
      ),
    );
  }

/*
  _widgetQrDetails(QrScannerController logic,BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(
          top: 12.h
      ),
      // height: 70.h,
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(
                  right: 8.h,
                  left: 8.h),
              color: CColor.transparent,
              child: TextFormField(
                maxLines: 1,
                controller: logic.qrCodeDetailsController,
                textAlign: TextAlign.start,
                focusNode: logic.qrdDetails,
                keyboardType: TextInputType.text,
                style: AppFontStyle.styleW500(CColor.black,
                    Utils.sizesFontManage(context ,2.9)),
                cursorColor: CColor.black,
                decoration: InputDecoration(
                  hintText: "Enter a url".tr,
                  hintStyle: AppFontStyle.styleW500(CColor.black,
                      Utils.sizesFontManage(context ,2.9)),
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
*/

  _widgetMoreDetails(BuildContext context,BoxConstraints constraints) {
    return Container(
      margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(1.2, constraints)),
      alignment: Alignment.centerLeft,
      child: Text(
        Constant.qrScannerDetail,
        textAlign: TextAlign.start,
        style: AppFontStyle.styleW500(CColor.black,AppFontStyle.sizesFontManageWeb(1.4,constraints),),
      ),
    );
  }

  _widgetQrCodeMoBileUse(BuildContext context, QrScannerController logic) {
    return Container(
      margin: EdgeInsets.only(
        top: 110.h,
      ),
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(7).r,
        child: SizedBox(
          width: 200.w,
          height: 200.w,
          child: MobileScanner(
            controller: logic.cameraController,
            onDetect: (barcode) {
              if (barcode.barcodes[0].rawValue == null) {
                Debug.printLog('Failed to scan Barcode');
              } else {
                logic.onQRViewCreated(barcode.barcodes[0].displayValue);
              }
            },
          ),
        ),
      ),
    );
  }

  _widgetButtonDetails(BuildContext context,BoxConstraints constraints,QrScannerController logic) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            margin: EdgeInsets.only(
              left:AppFontStyle.sizesWidthManageWeb(1.7, constraints),
              right:AppFontStyle.sizesWidthManageWeb(1.7, constraints),
              // top: 110
            ),
            padding: EdgeInsets.only(
                top: AppFontStyle.sizesHeightManageWeb(1.5, constraints),
                bottom: AppFontStyle.sizesHeightManageWeb(1.5, constraints)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      logic.gotoNextPage();
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
                            fontSize:AppFontStyle.sizesFontManageWeb(1.5,constraints)),
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

  _widgetServerDropDown(BuildContext context, QrScannerController logic,BoxConstraints constraints) {
      return Container(
        height: Get.height*0.2,
        margin: EdgeInsets.only(
            top: AppFontStyle.sizesHeightManageWeb(1.8,constraints)),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
              horizontal: AppFontStyle.sizesWidthManageWeb(1.8,constraints), vertical: AppFontStyle.sizesHeightManageWeb( 1.8 ,constraints)),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: CColor.greyF8,
            border: Border.all(color: CColor.primaryColor, width: 0.7),
          ),
          child: InkWell(
            onTap: (){
              if(Utils.getServerList.isEmpty){
                showDialogForAddNewServerUrl(
                    context, logic, logic.update,false,constraints);
                logic.onChangeTextFiled(-1,false);
              }else{
                showDialogForChooseUrl(logic, context,constraints);
              }
            },
            child: (logic.getServerList().isEmpty) ? Container(
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Please select connection",
                      style: AppFontStyle.styleW500(
                        CColor.black,
                        AppFontStyle.sizesFontManageWeb(1.4,constraints),
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
                  return Text(
                    logic.getServerList()[index].title,
                    style: AppFontStyle.styleW500(
                      CColor.black,
                      AppFontStyle.sizesFontManageWeb(1.4,constraints),
                    ),
                  );
                }),
          ),
        ),
      );
  }

  void showDialogForChooseUrl(QrScannerController logic, BuildContext context,BoxConstraints constraints) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, setStateDialogForChooseCode) {
            return Dialog(
              backgroundColor: CColor.white,
              insetPadding: const EdgeInsets.all(0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.0),
                ),
              ),
              child: SingleChildScrollView(
                    child: Container(
                      width: Get.width * 0.3,
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
                                  Utils.getServerList[index].title, logic,setStateDialogForChooseCode,constraints);
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
                                  context, logic, setStateDialogForChooseCode,false,constraints);
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
                                  AppFontStyle.sizesFontManageWeb(1.3, constraints),
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
                                      padding:  EdgeInsets.symmetric(vertical: 9,horizontal: 10),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black, AppFontStyle.sizesFontManageWeb(1.3, constraints)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: AppFontStyle.sizesWidthManageWeb(0.8, constraints)),
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
                                      padding:  EdgeInsets.symmetric(vertical: 9,horizontal: 10),
                                      child: Text(
                                        "Add",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white, AppFontStyle.sizesFontManageWeb(1.3, constraints)),
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
    );
  }


  _itemUrlData(int index, BuildContext context, String codeList,
      QrScannerController logic,setStateDialogForChooseCode,BoxConstraints constraints) {
    return InkWell(
      onTap: () {
        showDialogForAddNewServerUrl(
            context, logic, setStateDialogForChooseCode,true,constraints,index: index);
        logic.onChangeTextFiled(index,true);
      },
      child: Dismissible(
        key: Key(Utils.getServerList[index].url) ,
        onDismissed: (direction) {
          Debug.printLog("onDismissed...");
          logic.removeFromUrlList(index);
          setStateDialogForChooseCode((){});
        },
        child: Container(
          margin: EdgeInsets.only(bottom: (kIsWeb) ?AppFontStyle.sizesHeightManageWeb(1.0, constraints) :  Sizes.height_3, left: Sizes.width_1),
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
                  maxLines: 1,
                  style: AppFontStyle.styleW500(
                    CColor.black,
                    AppFontStyle.sizesFontManageWeb(1.3, constraints),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  logic.changeIsAuth(Utils.getServerList[index].isSecure);
                  showDialogForAddNewServerUrl(
                      context, logic, setStateDialogForChooseCode,true,constraints,index: index);
                  logic.onChangeTextFiled(index,true);
                },
                child: Container(
                  margin: EdgeInsets.only(right: AppFontStyle.sizesWidthManageWeb(0.8, constraints)),
                  child: Icon(
                    Icons.edit,
                    size: AppFontStyle.sizesFontManageWeb(1.1, constraints),
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
                  margin: EdgeInsets.only(right: AppFontStyle.sizesWidthManageWeb(0.8, constraints)),
                  child: Icon(
                    Icons.delete,
                    size: AppFontStyle.sizesFontManageWeb(1.1, constraints),
                    color: CColor.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  showDialogForAddNewServerUrl(BuildContext context, QrScannerController logic,
      setStateDialogForChooseCode,bool isEdit,BoxConstraints constraints,{int index = -1}) {
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
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10)
                      ),
                      padding: EdgeInsets.all(AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                      // width: Get.width * 0.3,
                      child: Column(
                        children: [
                          if(logic.addServerTitleName.text.isNotEmpty)
                            Container(
                              // margin: EdgeInsets.only(bottom: AppFontStyle.sizesHeightManageWeb(1.0, constraints)),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: AppFontStyle.sizesWidthManageWeb(1.0, constraints), left: AppFontStyle.sizesWidthManageWeb(1.0, constraints),bottom:  AppFontStyle.sizesHeightManageWeb(0.6, constraints)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Connection Name",
                                          style: AppFontStyle.styleW700(CColor.black,AppFontStyle.sizesFontManageWeb(1.2, constraints) ),
                                        ),
                                        PopupMenuButton(
                                          elevation: 0,
                                          constraints: BoxConstraints(
                                      minWidth: Get.width * 0.1, maxWidth: Get.width * 0.3),
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
                                              color: CColor.black, size: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // height: Get.height * 0.1,
                                    margin: EdgeInsets.only(bottom:  AppFontStyle.sizesHeightManageWeb(0.6, constraints)),
                                    color: CColor.transparent,
                                    child: TextFormField(
                                      controller: logic.addServerTitleName,
                                      focusNode: logic.addServerTitleNameFocus,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.text,
                                      style: AppFontStyle.styleW500(
                                          CColor.black, AppFontStyle.sizesFontManageWeb(0.8, constraints)),
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
                                right: AppFontStyle.sizesWidthManageWeb(1.0, constraints), left: AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Connection URL",
                                  style: AppFontStyle.styleW700(CColor.black,
                                      (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10),
                                ),
                                PopupMenuButton(
                                  elevation: 0,
                                  constraints: BoxConstraints(
                                      minWidth: Get.width * 0.1, maxWidth: Get.width * 0.3),
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
                                      color: CColor.black, size: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(0.6, constraints) ),
                            color: CColor.transparent,
                            // height: Get.height * 0.1,
                            child: TextFormField(
                              controller: logic.addOtherUrlController,
                              focusNode: logic.addOtherUrlFocus,
                              textAlign: TextAlign.start,
                              keyboardType: TextInputType.text,
                              style: AppFontStyle.styleW500(
                                  CColor.black, AppFontStyle.sizesFontManageWeb(0.8, constraints)),
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
                              margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(0.8, constraints)),
                              child: Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(
                                        right: AppFontStyle.sizesWidthManageWeb(1.0, constraints), left: AppFontStyle.sizesWidthManageWeb(1.0, constraints)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Client Id",
                                          style: AppFontStyle.styleW700(CColor.black,
                                              (kIsWeb) ? AppFontStyle.sizesFontManageWeb(1.2, constraints) : FontSize.size_10),
                                        ),
                                        PopupMenuButton(
                                          elevation: 0,
                                          constraints: BoxConstraints(
                                      minWidth: Get.width * 0.1, maxWidth: Get.width * 0.3),
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
                                              color: CColor.black, size: AppFontStyle.sizesFontManageWeb(1.5, constraints)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(0.6, constraints)),
                                    // height: Get.height * 0.1,
                                    color: CColor.transparent,
                                    child: TextFormField(
                                      controller: logic.addOtherUrlClientIdController,
                                      focusNode: logic.addOtherUrlClientIdFocus,
                                      textAlign: TextAlign.start,
                                      keyboardType: TextInputType.text,
                                      style: AppFontStyle.styleW500(
                                          CColor.black, AppFontStyle.sizesFontManageWeb(0.8, constraints)),
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
                            margin: EdgeInsets.only(top: AppFontStyle.sizesHeightManageWeb(1.3, constraints)),
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
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        "Cancel",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.black, AppFontStyle.sizesFontManageWeb(1.2, constraints)),
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
                                        setStateDialogForChooseCode(() {});
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
                                      padding: const EdgeInsets.all(10),
                                      child: Text(
                                        /*(logic.isAuth)?"Connect"
                                            "":(!logic.isEdit)?"Add":"Update",*/
                                        "Connect",
                                        textAlign: TextAlign.center,
                                        style: AppFontStyle.styleW400(
                                            CColor.white, AppFontStyle.sizesFontManageWeb(1.2, constraints)),
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

}
