import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomScrollBehavior extends MaterialScrollBehavior {
  ///understand there
  @override
  Set<PointerDeviceKind> get dragDevice =>
      {PointerDeviceKind.touch, PointerDeviceKind.mouse};
}
