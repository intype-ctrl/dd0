// home_tab.dart 파일 (수정 완료된 전체 코드)

import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:line_icons/line_icons.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/screens/notifications/notifications.dart';

import '../../../components/app_logo.dart';
import '../../../components/drawer_menu.dart';
import 'tab_medium.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({
    super.key,
    required this.settings,
  });

  final AppSettingsModel settings;

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> with TickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 1, vsync: this);

  static const double _minHeight = 85.0;
  static const double _maxScale = 1.3;
  double get _maxHeight => _minHeight * _maxScale;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Scaffold를 제거하고 NestedScrollView를 바로 반환합니다.
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverPersistentHeader(
          pinned: true,
          floating: true,
          delegate: _HeaderDelegate(
            minExtentHeight: _minHeight,
            maxExtentHeight: _maxHeight,
            maxScale: _maxScale,
            // ✅ 이제 버튼을 누르면 부모 Scaffold의 endDrawer가 열립니다.
            onOpenEndDrawer: () => Scaffold.of(context).openEndDrawer(),
            onOpenNotifications: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const Notifications()),
            ),
          ),
        ),
      ],
      body: Builder(
        builder: (context) {
          final sc = PrimaryScrollController.of(context);
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: TabMedium(
              sc: sc,
              tc: _tabController,
              homeCategories: const [],
              settings: widget.settings,
            ),
          );
        },
      ),
    );
  }
}

/// SliverPersistentHeader 전용 델리게이트 (변경 없음)
class _HeaderDelegate extends SliverPersistentHeaderDelegate {
  _HeaderDelegate({
    required this.minExtentHeight,
    required this.maxExtentHeight,
    required this.maxScale,
    required this.onOpenEndDrawer,
    required this.onOpenNotifications,
  });

  final double minExtentHeight;
  final double maxExtentHeight;
  final double maxScale;
  final VoidCallback onOpenEndDrawer;
  final VoidCallback onOpenNotifications;

  @override
  double get minExtent => minExtentHeight;

  @override
  double get maxExtent => maxExtentHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    final scale = maxScale - (0.3 * progress);

    return Material(
      elevation: overlapsContent ? 1 : 0,
      color: Theme.of(context).appBarTheme.backgroundColor ??
          Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 8, top: 8),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Transform.scale(
                  scale: scale,
                  alignment: Alignment.topLeft,
                  child: const AppLogo(),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      padding: const EdgeInsets.only(right: 8),
                      constraints: const BoxConstraints(),
                      icon: const Icon(LineIcons.bell),
                      onPressed: onOpenNotifications,
                    ),
                    IconButton(
                      icon: const Icon(EvaIcons.menu_2, size: 28),
                      onPressed: onOpenEndDrawer,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderDelegate oldDelegate) {
    return minExtentHeight != oldDelegate.minExtentHeight ||
        maxExtentHeight != oldDelegate.maxExtentHeight ||
        maxScale != oldDelegate.maxScale;
  }
}