import 'package:flutter/foundation.dart';

/// Controller used to update one or more [DotMatrixAnimatedCounter] widgets.
class DotMatrixCounterController extends ValueNotifier<int> {
  DotMatrixCounterController({int initialValue = 0}) : super(initialValue);

  int get currentValue => value;

  void setValue(int newValue) => value = newValue;

  void increment([int step = 1]) => value += step;

  void decrement([int step = 1]) => value -= step;

  void reset([int newValue = 0]) => value = newValue;
}
