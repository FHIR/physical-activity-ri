import 'package:banny_table/ui/cameraScreen/controllers/camera_controllers.dart';
import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:banny_table/utils/debug.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<CameraControllers>(builder: (logic) {
        return Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: Get.height*1,
                  // width: Get.width*0.8,
                  // margin: EdgeInsets.only(
                  //   left: Get.width*0.1,
                  //   right: Get.width*0.1
                  // ),

                  child: MobileScanner(
                    controller: logic.cameraController,
                    onDetect: (barcode) {
                      if (barcode.barcodes[0].rawValue == null) {
                        Debug.printLog('Failed to scan Barcode');
                      } else {
                        // logic.getQrlDetalis()
                        logic.getUrlDetalis(barcode.barcodes[0].displayValue);
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(child: Container()),

                Expanded(
                  child: Container(
                    // alignment: Alignment.center,
                    // height: Sizes.width_30,
                    // width:Sizes.width_30,
                    child: Lottie.asset(
                      Constant.scannerLoader, width: Sizes.width_75,fit: BoxFit.fill,delegates: LottieDelegates(
                      values: [
                        ValueDelegate.color(
                          const ['**', 'Stroke 1', '**'],
                          value: CColor.primaryColor,
                        ),
                      ],
                    ),),
                  ),
                ),
                Expanded(child: Container()),
              ],
            )

            /*Column(
              children: [
                Expanded(child: Container(
                  color: CColor.qrBGColor,
                )),
                Container(
                  color: CColor.qrBGColor,
                  child: Row(
                    children: [
                      Expanded(
                          child:Container(
                        color: CColor.qrBGColor,
                      )),
                      Container(
                        child: Image.asset("assets/icons/ic_scanning.png",width: Sizes.height_30, height: Sizes.height_30, ),
                      ),
                      Expanded(child:Container(
                        color: CColor.qrBGColor,
                      )),
                    ],
                  ),
                ),
                Expanded(child: Container(
                  width: double.infinity,
                  color: CColor.qrBGColor,
                  child: Row(
                    children: [
                      const Spacer(),
                      *//*Container(
                          decoration: BoxDecoration(
                            color:CColor.primaryColor,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.width_3,vertical: Sizes.height_2_5
                          ),
                          child: Text("Please Tap",style: TextStyle(
                            fontSize: FontSize.size_15
                          ),)),*//*
                      const Spacer(),
                    ],
                  ),
                )),
              ],
            ),*/

          ],
        );
      }),
    );
  }

}