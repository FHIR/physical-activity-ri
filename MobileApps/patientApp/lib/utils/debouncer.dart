import 'dart:async';
import 'dart:ui';

class DebouncerCustom {
  int? milliseconds = 1000;
  VoidCallback? action;
  Timer? timer;

  DebouncerCustom({this.milliseconds});

  run(VoidCallback action) {
    timer?.cancel();
    timer = Timer(Duration(milliseconds: milliseconds ?? 1000), action);
  }
}