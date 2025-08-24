import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/components/drawer_menu.dart';
import 'package:news_app/models/app_settings_model.dart';
import '../../../components/app_logo.dart';
import '../../notifications/notifications.dart';
import 'tab0/tab0.dart';

class HomeTabWithoutTabs extends ConsumerWidget {
  const HomeTabWithoutTabs({super.key, required this.settings});

  final AppSettingsModel settings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      backgroundColor: Theme.of(context).canvasColor,

      // 👉 우측에서 열리는 드로워
      endDrawer: Visibility(
        visible: settings.drawerMenu ?? true,
        child: CustomDrawer(settings: settings),
      ),

      key: scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              titleSpacing: 0,        // 좌측 여백 제거
              leadingWidth: 0,        // 기본 leading 공간 제거
              title: const AppLogo(), // 로고 완전 좌측

              elevation: 1,
              actions: <Widget>[
                // 알림
                IconButton(
                  padding: const EdgeInsets.only(right: 8),
                  constraints: const BoxConstraints(),
                  icon: const Icon(LineIcons.bell),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const Notifications()),
                  ),
                ),
                // 햄버거 → 우측 드로워 열기
                IconButton(
                  icon: const Icon(EvaIcons.menu_2, size: 28),
                  onPressed: () => scaffoldKey.currentState!.openEndDrawer(),
                ),
              ],

              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            final ScrollController innerScrollController =
                PrimaryScrollController.of(context);
            return Tab0(sc: innerScrollController, settings: settings);
          },
        ),
      ),
    );
  }
}
