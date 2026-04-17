
import 'package:flutter/material.dart';

// ThemeData {
//        return ThemeData() {
//         colorScheme: ColorScheme.light(
//           surface: Colors.grey.shade100,
//           onSurface: Colors.black,
//           primary: Color(0xFF00B2E7),
//           secondary: Color(0xFFE064F7),
//           tertiary: Color(0xFFFF8D6C),
//           outline: Colors.grey.shade400,
//         )
// }

const ColorScheme lightScheme = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF8BAF9A),
  onPrimary: Color(0xFFFFFFFF),
  primaryContainer: Color(0xFFDCE7DE),
  onPrimaryContainer: Color(0xFF30443B),

  secondary: Color(0xFFAFC8B7),
  onSecondary: Color(0xFF25352E),
  secondaryContainer: Color(0xFFE8F0E9),
  onSecondaryContainer: Color(0xFF33483F),

  tertiary: Color(0xFFC9D9CD),
  onTertiary: Color(0xFF25322D),
  tertiaryContainer: Color(0xFFEAF1EA),
  onTertiaryContainer: Color(0xFF385047),

  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  errorContainer: Color(0xFFF9DEDC),
  onErrorContainer: Color(0xFF410E0B),

  surface: Color(0xFFF3F6F2),
  onSurface: Color(0xFF33423B),
  surfaceContainerHighest: Color(0xFFE2E9E4),
  onSurfaceVariant: Color(0xFF61746A),

  outline: Color(0xFFB5C2BB),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFF2A3531),
  onInverseSurface: Color(0xFFEEF4F0),
  inversePrimary: Color(0xFFBFD5C7),
);

const ColorScheme darkScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7FA08D),
  onPrimary: Color(0xFF122019),
  primaryContainer: Color(0xFF24362F),
  onPrimaryContainer: Color(0xFFD8E8DF),
  
  secondary: Color(0xFF6F8C7E),
  onSecondary: Color(0xFF14201A),
  secondaryContainer: Color(0xFF20312A),
  onSecondaryContainer: Color(0xFFD5E6DD),

  tertiary: Color(0xFF93AC9E),
  onTertiary: Color(0xFF17231E),
  tertiaryContainer: Color(0xFF26352F),
  onTertiaryContainer: Color(0xFFE1ECE5),

  error: Color(0xFFF2B8B5),
  onError: Color(0xFF601410),
  errorContainer: Color(0xFF8C1D18),
  onErrorContainer: Color(0xFFF9DEDC),

  surface: Color(0xFF0F1714),
  onSurface: Color(0xFFE7F0EA),
  surfaceContainerHighest: Color(0xFF1D2925),
  onSurfaceVariant: Color(0xFFAAB9B0),

  outline: Color(0xFF74877D),
  shadow: Color(0xFF000000),
  inverseSurface: Color(0xFFE7F0EA),
  onInverseSurface: Color(0xFF1B2420),
  inversePrimary: Color(0xFF4E6B5D),
);