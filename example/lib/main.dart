import 'dart:async';
import 'dart:math';

import 'package:dot_matrix_animated_counter/dot_matrix_animated_counter.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ExampleApp());
}

enum ExampleThemePreset {
  arcade,
  sunset,
  mint,
}

extension on ExampleThemePreset {
  String get label {
    switch (this) {
      case ExampleThemePreset.arcade:
        return 'Arcade Cyan';
      case ExampleThemePreset.sunset:
        return 'Sunset Amber';
      case ExampleThemePreset.mint:
        return 'Mint Terminal';
    }
  }

  DotMatrixCounterThemeData get counterTheme {
    switch (this) {
      case ExampleThemePreset.arcade:
        return const DotMatrixCounterThemeData(
          dotSize: 10,
          dotSpacing: 3,
          digitSpacing: 10,
          onColor: Colors.white,
          offColor: Color(0xFF1C1F26),
          glowColor: Colors.cyanAccent,
          animationDuration: Duration(milliseconds: 420),
          animationCurve: Curves.easeOutCubic,
          padding: EdgeInsets.all(8),
        );
      case ExampleThemePreset.sunset:
        return const DotMatrixCounterThemeData(
          dotSize: 10,
          dotSpacing: 3,
          digitSpacing: 10,
          onColor: Color(0xFFFFF3DD),
          offColor: Color(0xFF2A1C17),
          glowColor: Colors.orangeAccent,
          animationDuration: Duration(milliseconds: 420),
          animationCurve: Curves.easeOutCubic,
          padding: EdgeInsets.all(8),
        );
      case ExampleThemePreset.mint:
        return const DotMatrixCounterThemeData(
          dotSize: 10,
          dotSpacing: 3,
          digitSpacing: 10,
          onColor: Color(0xFFDFFFF5),
          offColor: Color(0xFF13211D),
          glowColor: Color(0xFF6CFFB7),
          animationDuration: Duration(milliseconds: 420),
          animationCurve: Curves.easeOutCubic,
          padding: EdgeInsets.all(8),
        );
    }
  }

  ThemeData applyToTheme(ThemeData base) {
    final scheme = switch (this) {
      ExampleThemePreset.arcade => const ColorScheme.dark(primary: Colors.cyanAccent),
      ExampleThemePreset.sunset => const ColorScheme.dark(primary: Colors.orangeAccent),
      ExampleThemePreset.mint => const ColorScheme.dark(primary: Color(0xFF6CFFB7)),
    };

    return DotMatrixCounterTheme.apply(
      base.copyWith(colorScheme: scheme),
      counterTheme,
    );
  }
}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  ExampleThemePreset _preset = ExampleThemePreset.arcade;

  @override
  Widget build(BuildContext context) {
    final baseTheme = ThemeData.dark().copyWith(
      scaffoldBackgroundColor: const Color(0xFF0B0D10),
      cardColor: const Color(0xFF11151B),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF0B0D10)),
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _preset.applyToTheme(baseTheme),
      home: DemoPage(
        preset: _preset,
        onPresetChanged: (preset) => setState(() => _preset = preset),
      ),
    );
  }
}

class DemoPage extends StatefulWidget {
  final ExampleThemePreset preset;
  final ValueChanged<ExampleThemePreset> onPresetChanged;

  const DemoPage({
    super.key,
    required this.preset,
    required this.onPresetChanged,
  });

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  final _controller = DotMatrixCounterController(initialValue: 1234);
  final _random = Random();
  Timer? _timer;
  bool _autoPlay = false;

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _toggleAutoPlay() {
    setState(() => _autoPlay = !_autoPlay);
    _timer?.cancel();

    if (_autoPlay) {
      _timer = Timer.periodic(const Duration(milliseconds: 1100), (_) {
        _controller.setValue(_nextInterestingValue());
      });
    }
  }

  int _nextInterestingValue() {
    const values = <int>[
      12,
      99,
      321,
      1234,
      98765,
      120034,
      -45,
      -1234,
      -987654,
      1000000,
    ];
    return values[_random.nextInt(values.length)];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final extensionTheme = DotMatrixCounterTheme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dot Matrix Animated Counter Example'),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1040),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 16,
                      runSpacing: 16,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Theme preset', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            DropdownButton<ExampleThemePreset>(
                              value: widget.preset,
                              items: ExampleThemePreset.values
                                  .map(
                                    (preset) => DropdownMenuItem<ExampleThemePreset>(
                                      value: preset,
                                      child: Text(preset.label),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (preset) {
                                if (preset != null) {
                                  widget.onPresetChanged(preset);
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Current theme', style: theme.textTheme.titleMedium),
                            const SizedBox(height: 8),
                            Text(
                              'dotSize: ${extensionTheme.dotSize.toStringAsFixed(0)}  •  '
                              'spacing: ${extensionTheme.dotSpacing.toStringAsFixed(0)}  •  '
                              'glow: ${extensionTheme.glowBlurRadius.toStringAsFixed(0)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Controller demo', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        const Text(
                          'Uses controller updates, comma formatting, and negative values.',
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: DotMatrixAnimatedCounter(
                            controller: _controller,
                            digitCount: 7,
                            padWithZeros: true,
                            useGrouping: true,
                            theme: extensionTheme.copyWith(
                              dotSize: 12,
                              dotSpacing: 3,
                              digitSpacing: 8,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            FilledButton(
                              onPressed: () => _controller.decrement(),
                              child: const Text('-1'),
                            ),
                            FilledButton(
                              onPressed: () => _controller.increment(),
                              child: const Text('+1'),
                            ),
                            FilledButton(
                              onPressed: () => _controller.setValue(120034),
                              child: const Text('Set 120,034'),
                            ),
                            FilledButton(
                              onPressed: () => _controller.setValue(-987654),
                              child: const Text('Set -987,654'),
                            ),
                            FilledButton(
                              onPressed: () => _controller.setValue(_nextInterestingValue()),
                              child: const Text('Random'),
                            ),
                            OutlinedButton(
                              onPressed: _toggleAutoPlay,
                              child: Text(_autoPlay ? 'Stop Auto' : 'Auto Animate'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Animation styles', style: theme.textTheme.titleLarge),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    for (final style in DotMatrixAnimationStyle.values)
                      SizedBox(
                        width: 320,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_styleLabel(style), style: theme.textTheme.titleMedium),
                                const SizedBox(height: 16),
                                Center(
                                  child: DotMatrixAnimatedCounter(
                                    controller: _controller,
                                    digitCount: 6,
                                    padWithZeros: true,
                                    useGrouping: true,
                                    theme: extensionTheme.copyWith(
                                      animationStyle: style,
                                      dotSize: 9,
                                      digitSpacing: 7,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _styleLabel(DotMatrixAnimationStyle style) {
    switch (style) {
      case DotMatrixAnimationStyle.fadeScale:
        return 'Fade + Scale';
      case DotMatrixAnimationStyle.slide:
        return 'Slide';
      case DotMatrixAnimationStyle.flip:
        return 'Flip';
    }
  }
}
