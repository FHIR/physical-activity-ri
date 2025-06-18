import 'package:banny_table/utils/color.dart';
import 'package:banny_table/utils/sizer_utils.dart';
import 'package:flutter/material.dart';

// https://stackoverflow.com/questions/46480221/flutter-floating-action-button-with-speed-dail
class FabWithIcons extends StatefulWidget {
  FabWithIcons({super.key, this.text, this.onIconTapped});

  // final List<IconData>? icons;
  final List<Widget>? text;
  ValueChanged<int>? onIconTapped;

  @override
  State createState() => FabWithIconsState();
}

class FabWithIconsState extends State<FabWithIcons>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  bool isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      // mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text!.length, (int index) {
        return _buildChild(index);
      }).toList()
        ..add(
          _buildFab(),
        ),
    );
  }

  Widget _buildChild(int index) {
    return Container(
      alignment: Alignment.bottomRight,
      // color: CColor.backgroundColor,
      child: ScaleTransition(
        scale: CurvedAnimation(
          parent: _controller,
          curve: Interval(0.0, 1.0 - index / widget.text!.length / 2.0,
              curve: Curves.easeOut),
        ),
        child: InkWell(
          onTap: () {
            _onTapped(index);
          },
          child: Container(
            padding: EdgeInsets.only(bottom: Sizes.height_2,
            right: Sizes.height_1),
            child: widget.text![index],
          ),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Container(
      alignment: Alignment.bottomRight,
      margin: EdgeInsets.symmetric(
          horizontal: Sizes.width_4,),
      child: FloatingActionButton(
        onPressed: () {
          if (_controller.isDismissed) {
            _controller.forward();
          } else {
            _controller.reverse();
          }
          onChangeOpenButton();
        },
        tooltip: 'Add log',
        backgroundColor: CColor.primaryColor,
        elevation: 2.0,
        child: Icon((!isOpen)?Icons.add:Icons.close),
      ),
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped!(index);
    onChangeOpenButton();
  }

  onChangeOpenButton(){
    setState(() {
      isOpen = !isOpen;
    });
  }
}
