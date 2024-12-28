import 'package:flutter/services.dart';

mixin OrientationMixin {
  void lockPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

    void locklandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }



  void unlockOrientation() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }
}