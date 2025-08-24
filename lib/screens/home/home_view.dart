import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/screens/tabs/categories_tab/categories_tab.dart';
import 'package:news_app/screens/tabs/home_tab/home_tab.dart';
import 'package:news_app/screens/tabs/podcast_tab.dart/podcast_tab.dart';
import 'package:news_app/screens/tabs/profile_tab/profile_tab.dart';
import 'package:news_app/screens/tabs/videos_tab/videos_tab.dart';
import 'package:news_app/components/drawer_menu.dart';
import 'home_bottom_bar.dart';

final homeTabControllerProvider =
    StateProvider<PageController>((ref) => PageController(initialPage: 0));

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key, required this.settings});
  final AppSettingsModel settings;

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  bool _drawerOpen = false;

  @override
  Widget build(BuildContext context) {
    final tabController = ref.watch(homeTabControllerProvider);

    return Scaffold(
      // 왼쪽에서 나오는 드로워
      drawer: CustomDrawer(settings: widget.settings),
      
      // ✅ 오른쪽에서 나오는 드로워 (HomeTab에서 이동해 옴)
      endDrawer: CustomDrawer(settings: widget.settings),

      drawerScrimColor: Colors.black.withOpacity(0.45),
      onDrawerChanged: (open) => setState(() => _drawerOpen = open),
      body: PageView(
        allowImplicitScrolling: true,
        controller: tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: _children(),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: IgnorePointer(
          ignoring: _drawerOpen,
          child: AnimatedOpacity(
            opacity: _drawerOpen ? 0.55 : 1.0,
            duration: const Duration(milliseconds: 160),
            child: ClipRect(
              child: BackdropFilter(
                filter: _drawerOpen
                    ? ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0)
                    : ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: BottomBar(settings: widget.settings),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _children() {
    final homeTab = HomeTab(settings: widget.settings);
    List<Widget> tabs = [homeTab, const CategoriesTab(), const ProfileTab()];
    final bool audioTabEnabled = widget.settings.audioTab ?? false;
    final bool videoTabEnabled = widget.settings.videoTab ?? false;

    if (!audioTabEnabled && !videoTabEnabled) {
      return tabs;
    } else if (!videoTabEnabled) {
      tabs.insert(1, const PodcastTab());
    } else if (!audioTabEnabled) {
      tabs.insert(1, const VideosTab());
    } else {
      tabs.insert(1, const VideosTab());
      tabs.insert(2, const PodcastTab());
    }
    return tabs;
  }
}