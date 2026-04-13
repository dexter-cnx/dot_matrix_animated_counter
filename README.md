# dot_matrix_animated_counter

[![Deploy example to GitHub Pages](https://github.com/dexter-cnx/dot_matrix_animated_counter/actions/workflows/github-pages.yml/badge.svg)](https://github.com/dexter-cnx/dot_matrix_animated_counter/actions/workflows/github-pages.yml)
[Live demo](https://dexter-cnx.github.io/dot_matrix_animated_counter/)

Animated dot-matrix counters for Flutter with:

- controller-driven updates
- `ThemeExtension`-based styling
- `fadeScale`, `slide`, and `flip` transitions
- negative number support
- comma/grouping formatting

![Example preview](example.gif)

## Installation

```yaml
dependencies:
  dot_matrix_animated_counter: ^0.2.0
```

## Quick start

```dart
final controller = DotMatrixCounterController(initialValue: 1234);

MaterialApp(
  theme: DotMatrixCounterTheme.apply(
    ThemeData.dark(),
    const DotMatrixCounterThemeData(
      glowColor: Colors.cyanAccent,
      animationStyle: DotMatrixAnimationStyle.slide,
    ),
  ),
  home: Scaffold(
    body: Center(
      child: DotMatrixAnimatedCounter(
        controller: controller,
        digitCount: 7,
        padWithZeros: true,
        useGrouping: true,
      ),
    ),
  ),
)
```

## Theming with ThemeExtension

```dart
final appTheme = DotMatrixCounterTheme.apply(
  ThemeData.dark(),
  const DotMatrixCounterThemeData(
    dotSize: 10,
    dotSpacing: 3,
    digitSpacing: 10,
    glowColor: Colors.orangeAccent,
    onColor: Colors.white,
    offColor: Color(0xFF221B18),
    animationStyle: DotMatrixAnimationStyle.flip,
  ),
);
```

You can also apply a local override:

```dart
DotMatrixCounterTheme(
  data: const DotMatrixCounterThemeData(
    glowColor: Colors.greenAccent,
  ),
  child: const DotMatrixAnimatedCounter(value: 42),
)
```

## Main API

```dart
DotMatrixAnimatedCounter(
  controller: controller,
  digitCount: 7,
  padWithZeros: true,
  useGrouping: true,
  theme: const DotMatrixCounterThemeData(
    animationStyle: DotMatrixAnimationStyle.fadeScale,
  ),
)
```

### Parameters

- `value` or `controller`: source of the integer value
- `digitCount`: minimum numeric digits before sign/grouping are added
- `padWithZeros`: left-pad digits with `0`
- `useGrouping`: add comma separators
- `groupingSeparator`: override the grouping character
- `theme`: optional local theme override

## Controller

```dart
controller.increment();
controller.decrement();
controller.setValue(-123456);
controller.reset();
```

## Example app

The bundled example demonstrates:

- theme preset selection
- controller-based updates
- negative and comma-formatted values
- each animation style side-by-side

## GitHub Pages

This repository includes a GitHub Actions workflow at [`.github/workflows/github-pages.yml`](/Users/dxtr_m4/develop/mobile_projects/dot_matrix_animated_counter/.github/workflows/github-pages.yml) that builds the `example` app and deploys it to GitHub Pages.

To enable it:

1. Open the repository settings in GitHub.
2. Go to `Pages`.
3. Set the source to `GitHub Actions`.
4. Push to `main` or run the workflow manually.

The published site will be the Flutter example app. For a project site, GitHub Pages will usually be available at `https://<owner>.github.io/<repo>/`. For a user or organization site named `<owner>.github.io`, the base path is `/`.
