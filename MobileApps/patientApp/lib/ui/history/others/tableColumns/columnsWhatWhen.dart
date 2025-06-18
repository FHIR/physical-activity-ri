import 'package:banny_table/ui/history/controllers/history_controller.dart';
import 'package:banny_table/utils/constant.dart';
import 'package:flutter/material.dart';

import '../../../../utils/color.dart';
import '../../../../utils/sizer_utils.dart';

DataColumn cWhatWhen(Orientation orientation){
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
              width: (orientation ==
                  Orientation.portrait)
                  ? Sizes.width_40
                  : Sizes.width_50,
              child: const Text(
                'What\n/When\n',
                textAlign: TextAlign
                    .center,
              ),
            ),

          ],
        ),
      ),
    ),
  );
}

Widget cWhatWhenWidgetNormal(Orientation orientation, BuildContext context, HistoryController logic){
  return Container(
    width:MediaQuery.of(context).size.width * ((logic.isPortrait)?0.35:0.2),
    height: Constant.commonHeightForTableBoxMobileHeader,
    alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
              color: CColor.black
          ),
        ),
      color: CColor.white
    ),
    child: Container(
      alignment: Alignment.center,
      child: const SizedBox(
        child: Text(
          'What\n/When\n',
          textAlign: TextAlign
              .center,
        ),
      ),
    ),
  );
}