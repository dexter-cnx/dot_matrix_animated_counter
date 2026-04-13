import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'dot_matrix_counter_controller.dart';
import 'dot_matrix_counter_theme.dart';

class DotMatrixAnimatedCounter extends StatefulWidget {
  final int? value;
  final DotMatrixCounterController? controller;

  /// Minimum amount of numeric digits before grouping/sign are applied.
  final int digitCount;

  /// Pads numeric digits with zeros before rendering.
  final bool padWithZeros;

  /// Adds a grouping separator, e.g. `12,345`.
  final bool useGrouping;

  /// Grouping separator character.
  final String groupingSeparator;

  final AlignmentGeometry alignment;
  final DotMatrixCounterThemeData? theme;

  const DotMatrixAnimatedCounter({
    super.key,
    this.value,
    this.controller,
    this.digitCount = 3,
    this.padWithZeros = false,
    this.useGrouping = false,
    this.groupingSeparator = ',',
    this.alignment = Alignment.center,
    this.theme,
  })  : assert(value != null || controller != null, 'Provide either value or controller.'),
        assert(digitCount >= 0, 'digitCount must be >= 0'),
        assert(groupingSeparator.length == 1, 'groupingSeparator must be a single character');

  @override
  State<DotMatrixAnimatedCounter> createState() => _DotMatrixAnimatedCounterState();
}

class _DotMatrixAnimatedCounterState extends State<DotMatrixAnimatedCounter> {
  late int _currentValue;

  static const Map<String, List<List<int>>> _font = {
    '0': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ],
    '1': [
      [0, 0, 1, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 1, 1, 0],
    ],
    '2': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
    ],
    '3': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [0, 0, 1, 1, 0],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ],
    '4': [
      [1, 0, 0, 1, 0],
      [1, 0, 0, 1, 0],
      [1, 0, 0, 1, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 1, 0],
      [0, 0, 0, 1, 0],
      [0, 0, 0, 1, 0],
    ],
    '5': [
      [1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 0],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ],
    '6': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 0],
      [1, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ],
    '7': [
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [0, 0, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 1, 0, 0, 0],
      [1, 0, 0, 0, 0],
      [1, 0, 0, 0, 0],
    ],
    '8': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ],
    '9': [
      [0, 1, 1, 1, 0],
      [1, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 1],
      [0, 0, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 1, 1, 1, 0],
    ],
    '-': [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [1, 1, 1, 1, 1],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
    ',': [
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
      [0, 0, 0],
      [0, 1, 0],
      [0, 1, 0],
      [1, 0, 0],
    ],
    ' ': [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
    ],
  };

  @override
  void initState() {
    super.initState();
    _currentValue = widget.controller?.value ?? widget.value ?? 0;
    widget.controller?.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant DotMatrixAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.controller != widget.controller) {
      oldWidget.controller?.removeListener(_handleControllerChanged);
      widget.controller?.addListener(_handleControllerChanged);
      _currentValue = widget.controller?.value ?? widget.value ?? _currentValue;
    } else if (widget.controller == null && oldWidget.value != widget.value && widget.value != null) {
      _currentValue = widget.value!;
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleControllerChanged);
    super.dispose();
  }

  void _handleControllerChanged() {
    if (!mounted || widget.controller == null) {
      return;
    }

    setState(() {
      _currentValue = widget.controller!.value;
    });
  }

  List<String> _formatCharacters(int number) {
    final isNegative = number < 0;
    final rawDigits = number.abs().toString();
    final paddedDigits = widget.padWithZeros
        ? rawDigits.padLeft(math.max(widget.digitCount, rawDigits.length), '0')
        : rawDigits;

    final groupedDigits = widget.useGrouping
        ? _applyGrouping(paddedDigits, widget.groupingSeparator)
        : paddedDigits;

    final leadingSpaces = widget.padWithZeros
        ? ''
        : ' ' * math.max(widget.digitCount - rawDigits.length, 0);

    final sign = isNegative ? '-' : '';
    return '$leadingSpaces$sign$groupedDigits'.split('');
  }

  String _applyGrouping(String digits, String separator) {
    if (digits.length <= 3) {
      return digits;
    }

    final buffer = StringBuffer();

    for (var index = 0; index < digits.length; index++) {
      final charIndexFromEnd = digits.length - index;
      buffer.write(digits[index]);
      if (charIndexFromEnd > 1 && charIndexFromEnd % 3 == 1) {
        buffer.write(separator);
      }
    }

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme ?? DotMatrixCounterTheme.of(context);
    final characters = _formatCharacters(_currentValue);

    return Padding(
      padding: theme.padding,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final content = Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var index = 0; index < characters.length; index++) ...[
                _AnimatedCharacter(
                  character: characters[index],
                  theme: theme,
                  font: _font,
                ),
                if (index < characters.length - 1) SizedBox(width: theme.digitSpacing),
              ],
            ],
          );

          if (constraints.hasBoundedWidth) {
            return SizedBox(
              width: constraints.maxWidth,
              child: Align(
                alignment: widget.alignment,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: widget.alignment,
                  child: content,
                ),
              ),
            );
          }

          return Align(
            alignment: widget.alignment,
            child: content,
          );
        },
      ),
    );
  }
}

class _AnimatedCharacter extends StatelessWidget {
  final String character;
  final DotMatrixCounterThemeData theme;
  final Map<String, List<List<int>>> font;

  const _AnimatedCharacter({
    required this.character,
    required this.theme,
    required this.font,
  });

  @override
  Widget build(BuildContext context) {
    final matrix = font[character] ?? font[' ']!;

    return AnimatedSwitcher(
      duration: theme.animationDuration,
      switchInCurve: theme.animationCurve,
      switchOutCurve: theme.animationCurve,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: Alignment.center,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) => _buildTransition(child, animation),
      child: Column(
        key: ValueKey<String>(character),
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final row in matrix)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (final status in row)
                  _AnimatedDot(
                    isOn: status == 1,
                    theme: theme,
                  ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    switch (theme.animationStyle) {
      case DotMatrixAnimationStyle.slide:
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.35),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      case DotMatrixAnimationStyle.flip:
        return AnimatedBuilder(
          animation: animation,
          child: child,
          builder: (context, child) {
            final curvedValue = CurvedAnimation(
              parent: animation,
              curve: theme.animationCurve,
            ).value;
            final rotation = (1 - curvedValue) * (math.pi / 2);
            return Opacity(
              opacity: curvedValue,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..setEntry(3, 2, 0.0015)
                  ..rotateX(rotation),
                child: child,
              ),
            );
          },
        );
      case DotMatrixAnimationStyle.fadeScale:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
            child: child,
          ),
        );
    }
  }
}

class _AnimatedDot extends StatelessWidget {
  final bool isOn;
  final DotMatrixCounterThemeData theme;

  const _AnimatedDot({
    required this.isOn,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: theme.animationDuration,
      curve: theme.animationCurve,
      width: theme.dotSize,
      height: theme.dotSize,
      margin: EdgeInsets.all(theme.dotSpacing / 2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isOn ? theme.onColor : theme.offColor,
        boxShadow: isOn
            ? [
                BoxShadow(
                  color: theme.glowColor.withOpacity(0.8),
                  blurRadius: theme.glowBlurRadius,
                  spreadRadius: theme.glowSpreadRadius,
                ),
              ]
            : null,
      ),
    );
  }
}
