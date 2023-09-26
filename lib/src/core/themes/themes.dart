import 'package:flutter/material.dart';
part 'color_schemes.g.dart';

final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: _lightColorScheme,
  appBarTheme: AppBarTheme(
    centerTitle: false,
    backgroundColor: _lightColorScheme.surface,
    elevation: 0,
    foregroundColor: _lightColorScheme.onSurface,
    iconTheme: IconThemeData(
      size: 24,
      color: _lightColorScheme.onSurfaceVariant,
    ),
  ),
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: _lightColorScheme.surface,
    indicatorColor: _lightColorScheme.secondaryContainer,
    labelTextStyle: MaterialStateProperty.all(
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
    ),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: _lightColorScheme.primary,
    foregroundColor: _lightColorScheme.onPrimary,
  ),
  toggleButtonsTheme: ToggleButtonsThemeData(
    borderWidth: 2,
    borderColor: _lightColorScheme.secondary,
    borderRadius: BorderRadius.circular(50),
    fillColor: _lightColorScheme.primaryContainer,
    selectedBorderColor: _lightColorScheme.secondary,
  ),
  elevatedButtonTheme: const ElevatedButtonThemeData(
    style: ButtonStyle(
      elevation: MaterialStatePropertyAll(3),
    ),
  ),
  dividerTheme: DividerThemeData(color: _lightColorScheme.onBackground),
  //dropdownMenuTheme: DropdownMenuThemeData(inputDecorationTheme: InputDecorationTheme()),
);

final darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: _darkColorScheme,
    appBarTheme: AppBarTheme(
      centerTitle: false,
      backgroundColor: _darkColorScheme.surface,
      elevation: 0,
      foregroundColor: _darkColorScheme.onSurface,
      iconTheme: IconThemeData(
        size: 24,
        color: _darkColorScheme.onSurfaceVariant,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: _darkColorScheme.surface,
      indicatorColor: _darkColorScheme.secondaryContainer,
      labelTextStyle: MaterialStateProperty.all(
        const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: _darkColorScheme.primary,
      foregroundColor: _darkColorScheme.onPrimary,
    ),
    toggleButtonsTheme: ToggleButtonsThemeData(
      borderWidth: 2,
      borderColor: _darkColorScheme.secondary,
      borderRadius: BorderRadius.circular(50),
      fillColor: _darkColorScheme.primaryContainer,
      selectedBorderColor: _darkColorScheme.secondary,
    ),
    dividerTheme: DividerThemeData(color: _darkColorScheme.onBackground));
