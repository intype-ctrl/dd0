import 'dart:io';
import 'package:flutter/material.dart';
import '../configs/app_config.dart';
import 'text_themes.dart';

// 1) 라이트용 ColorScheme 정의 (여기서 surfaceVariant를 지정)
final ColorScheme _lightScheme = ColorScheme.fromSeed(
  seedColor: const Color(0xFFDF4C07),       // 브랜드 컬러(원하는 색)
  brightness: Brightness.light,
).copyWith(
  surfaceVariant: Colors.grey.shade100,     // ★ 2차메뉴/알림설정에 쓰이는 공통 배경색
  onSurfaceVariant: Colors.black87,         // (필요시) 그 위의 텍스트/아이콘 색상
  // 다른 항목도 필요하면 여기서 함께 지정 가능: primary, secondary 등
);

final ThemeData lightTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,
  visualDensity: VisualDensity.adaptivePlatformDensity,

  // 2) 여기서 colorScheme 주입
  colorScheme: _lightScheme,

  // 아래 기존 설정들은 유지(필요시 _lightScheme 값과 정합성 맞춰도 OK)
  primaryColor: const Color.fromARGB(255, 223, 76, 7),
  textTheme: Platform.isIOS ? textThemeiOS : textThemeDefault,
  cardColor: Colors.white, //tile color
  canvasColor: Colors.grey.shade100, // body color of home and some particular screen
  secondaryHeaderColor: Colors.grey.shade300, //secondary tile color
  scaffoldBackgroundColor: Colors.white,

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
  ),
  dividerTheme: DividerThemeData(
    color: const Color.fromARGB(255, 185, 185, 185),
    thickness: 0.7,
  ),
);
