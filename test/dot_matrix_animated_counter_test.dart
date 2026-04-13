import 'package:dot_matrix_animated_counter/dot_matrix_animated_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders counter with controller and theme extension', (tester) async {
    final controller = DotMatrixCounterController(initialValue: 42);

    await tester.pumpWidget(
      MaterialApp(
        theme: DotMatrixCounterTheme.apply(
          ThemeData.dark(),
          const DotMatrixCounterThemeData(
            animationStyle: DotMatrixAnimationStyle.slide,
          ),
        ),
        home: Scaffold(
          body: DotMatrixAnimatedCounter(
            controller: controller,
            digitCount: 3,
          ),
        ),
      ),
    );

    expect(find.byType(DotMatrixAnimatedCounter), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsNWidgets(3));
  });

  testWidgets('renders grouping and negative values', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: DotMatrixAnimatedCounter(
            value: -1234,
            digitCount: 4,
            useGrouping: true,
          ),
        ),
      ),
    );

    expect(find.byType(DotMatrixAnimatedCounter), findsOneWidget);
    expect(find.byType(AnimatedSwitcher), findsNWidgets(6));
  });

  testWidgets('scales down inside narrow constraints without overflow', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            child: DotMatrixAnimatedCounter(
              value: 123456789,
              digitCount: 9,
              useGrouping: true,
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
