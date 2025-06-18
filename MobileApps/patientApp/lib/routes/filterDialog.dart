import 'package:flutter/material.dart';

import '../ui/history/controllers/history_controller.dart';
import '../utils/color.dart';
import '../utils/font_style.dart';
import '../utils/sizer_utils.dart';

class FilterDialog extends StatefulWidget {
  final HistoryController logic;

  FilterDialog({required this.logic});

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  @override
  Widget build(BuildContext context) {
    Orientation orientation = MediaQuery.of(context).orientation;

    return AlertDialog(
      contentPadding: const EdgeInsets.all(0),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      content: Container(
        width: orientation == Orientation.landscape
            ? MediaQuery.of(context).size.width * 0.4
            : MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: CColor.white,
        ),
        child: Wrap(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: EdgeInsets.only(left: Sizes.width_2_5),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.logic.trackingPrefList.length,
                    itemBuilder: (context, index) {
                      return Row(
                        children: [
                          Text(widget.logic.trackingPrefList[index].titleName.toString()),
                          Checkbox(
                            value: widget.logic.trackingPrefList[index].isSelected,
                            onChanged: (value) {
                              setState(() {
                                widget.logic.onChangeTitle(!widget.logic.trackingPrefList[index].isSelected, index);
                              });
                            },
                          ),
                        ],
                      );
                    },
                    physics: const AlwaysScrollableScrollPhysics(),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: AppFontStyle.styleW600(CColor.black, FontSize.size_12),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.logic.onChangeTitleTapOnOk();
                      },
                      child: Text(
                        "Ok",
                        style: AppFontStyle.styleW600(CColor.black, FontSize.size_12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
