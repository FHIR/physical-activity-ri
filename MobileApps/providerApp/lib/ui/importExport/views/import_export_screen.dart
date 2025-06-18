import 'package:banny_table/healthData/getSetHealthData.dart';
import 'package:banny_table/ui/importExport/controllers/import_export_controller.dart';
import 'package:banny_table/utils/color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constant.dart';
import '../../../utils/font_style.dart';
import '../../../utils/sizer_utils.dart';

class ImportExportScreen extends StatelessWidget {
  const ImportExportScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(
          useMaterial3: false
      ),
      child: Scaffold(
        backgroundColor: CColor.white,
        appBar: AppBar(
          backgroundColor: CColor.primaryColor,
          title:  const Text(
            Constant.settingImportExportHealthData,
          ),
        ),
        body: GetBuilder<ImportExportController>(builder: (logic) {
          return Column(
            children: [
              _widgetAuth(logic,context),
              _widgetImportData(logic,context),
              _widgetExportData(logic,context),
            ],
          );
        }),
      ),
    );
  }

  _widgetAuth(ImportExportController logic, BuildContext context) {
    return InkWell(
      onTap: () async {
        // logic.authentication();
        // await GetSetHealthData.authentication(true,(value){});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),

        margin: EdgeInsets.symmetric(
            horizontal: Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.width_3,
            vertical: Sizes.height_1),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.backgroundColor,
              ),
              child: Image.asset(Constant.settingImportIcons,
                width:  Sizes.width_6,
                height:  Sizes.width_6,),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingAuthentication,
                  style: AppFontStyle.styleW600(CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetImportData(ImportExportController logic, BuildContext context) {
    return InkWell(
      onTap: () {
        // logic.importDataFromHealth();
        // GetSetHealthData.importDataFromHealth((value){

        // },true);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),

        margin: EdgeInsets.symmetric(
            horizontal: Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.width_3,
            vertical: Sizes.height_1),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.backgroundColor,
              ),
              child: Image.asset(Constant.settingImportIcons,
                width:  Sizes.width_6,
                height:  Sizes.width_6,),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingImportHealthData,
                  style: AppFontStyle.styleW600(CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

  _widgetExportData(ImportExportController logic, BuildContext context) {
    return InkWell(
      onTap: () {
        // logic.exportDataFromHealth();
        // GetSetHealthData.exportDataFromHealth((value){

        // });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: CColor.greyF8,
          boxShadow: const [
            BoxShadow(
              color: CColor.txtGray50,
              // blurRadius: 1,
              spreadRadius: 0.5,
            )
          ],
        ),

        margin: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        padding: EdgeInsets.symmetric(
            horizontal: (kIsWeb) ? Sizes.width_1 : Sizes.width_3,
            vertical: Sizes.height_1),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: CColor.backgroundColor,
              ),
              child: Image.asset(Constant.settingExportIcons,
                width: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,
                height: (kIsWeb) ? Sizes.width_1_5 : Sizes.width_6,),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: Sizes.width_3),
                child: Text(
                  Constant.settingExportHealthData,
                  style: AppFontStyle.styleW600(CColor.black,
                      (kIsWeb) ? FontSize.size_3 : FontSize.size_12),
                ),
              ),
            ),
            const Icon(Icons.navigate_next_rounded)
          ],
        ),
      ),
    );
  }

}
