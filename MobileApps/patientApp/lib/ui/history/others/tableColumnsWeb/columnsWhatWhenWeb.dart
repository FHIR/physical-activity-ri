import 'package:banny_table/utils/font_style.dart';
import 'package:flutter/material.dart';

import '../../../../utils/color.dart';
import '../../../../utils/constant.dart';
import '../../../../utils/sizer_utils.dart';

DataColumn cWhatWhenWeb(){
  return DataColumn(
    label: Expanded(
      child: Container(
        decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(
                  color: CColor.black
              ),
            )
        ),
        child: Row(
          children: [
            SizedBox(
              width: Sizes.width_20,
              child: const Text(
                'What\n/When\n',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget cWhatWhenWebNormal(BoxConstraints constraints){
  return Container(
    alignment: Alignment.center,
    height: AppFontStyle.commonHeightForTrackingChartWeb(constraints),
    decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.black
          ),
        )
    ),
    child:Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Text(
            'What\n/When\n',
            textAlign: TextAlign.center,
            style: AppFontStyle.headerStyleWeb(constraints),
          ),
        ),
      ],
    ),
  );
}