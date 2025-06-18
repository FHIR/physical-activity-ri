import 'dart:math' as math;
import 'package:banny_table/utils/color.dart';
import 'package:flutter/material.dart';

import 'debug.dart';
 
@immutable
class ExpandableFabClass extends StatefulWidget {
  const ExpandableFabClass({
    Key? key,
    this.isInitiallyOpen,
    required this.distanceBetween,
    required this.subChildren,
    required this.callback,
    required this.animationController,
    required this.open,
  }) : super(key: key);

  final bool? isInitiallyOpen;
  final double distanceBetween;
  final List<Widget> subChildren;
  final Function? callback;
  final AnimationController animationController;
  final bool? open;



  @override
  _ExpandableFabClassState createState() => _ExpandableFabClassState(callback: callback,animationController:
  animationController,open: open);
}

class _ExpandableFabClassState extends State<ExpandableFabClass>
    with SingleTickerProviderStateMixin {
  // late final AnimationController _animationController;
  late final Animation<double> _expandAnimationFab;
  bool? open;
  Function? callback;
  late final AnimationController animationController;


  _ExpandableFabClassState({required this.callback,required this.animationController,required this.open});

  @override
  void initState() {
    super.initState();
    open = widget.isInitiallyOpen ?? false;
    /*animationController = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );*/
    _expandAnimationFab = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: animationController,
    );
    callback = (){
      Debug.printLog("Call Back for plus.....");
    };
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      open = !open!;
      if (open!) {
        animationController.forward();
      } else {
        animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: CColor.primaryColor,
                size: 30,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    /*final children = <Widget>[];
    final count = widget.subChildren.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
    i < count;
    i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distanceBetween,
          progress: _expandAnimationFab,
          child: widget.subChildren[i],
        ),
      );
    }*/
    final children = <Widget>[];
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 100,
        // maxDistance: widget.distanceBetween,
        maxDistance: 60,
        progress: _expandAnimationFab,
        child: widget.subChildren[0],
      ),
    );
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 100,

        // maxDistance: widget.distanceBetween,
        maxDistance: 115,
        progress: _expandAnimationFab,
        child: widget.subChildren[1],
      ),
    );
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 100,
        // maxDistance: widget.distanceBetween,
        maxDistance: 170,
        progress: _expandAnimationFab,
        child: widget.subChildren[2],
      ),
    );
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 100,
        // maxDistance: widget.distanceBetween,
        maxDistance: 225,
        progress: _expandAnimationFab,
        child: widget.subChildren[3],
      ),
    );
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 100,
        // maxDistance: widget.distanceBetween,
        maxDistance: 280,
        progress: _expandAnimationFab,
        child: widget.subChildren[4],
      ),
    );
    children.add(
      _ExpandingActionButton(
        directionInDegrees: 100,
        // maxDistance: widget.distanceBetween,
        maxDistance: 335,
        progress: _expandAnimationFab,
        child: widget.subChildren[5],
      ),
    );
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: open!,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          open! ? 0.7 : 1.0,
          open! ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: open! ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: CColor.primaryColor,
            onPressed: _toggle,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          // right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}