import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:news_app/firebase_options.dart';
import 'core/app.dart';
import 'configs/language_config.dart';
import 'services/app_service.dart';
import 'services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1) 로컬라이제이션 초기화
  await EasyLocalization.ensureInitialized();

  // 2) Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // 3) Hive 초기화 (동기 함수라 await 제거)
  HiveService.initHive();

  // 4) SVG/이미지 프리캐시
  AppService.svgPrecacheImage();

  // 5) 최상위에 EasyLocalization → 내부에 ProviderScope → MyApp
  runApp(
    EasyLocalization(
      supportedLocales: LanguageConfig.supportedLocales,
      path: 'assets/translations',
      fallbackLocale: LanguageConfig.fallbackLocale,
      startLocale: LanguageConfig.startLocale,
      child: const ProviderScope(
        child: MyApp(),
      ),
    ),
  );
}
