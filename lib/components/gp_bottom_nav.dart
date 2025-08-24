import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../providers/nav_provider.dart';
import '../utils/launch_external.dart';

class GpBottomNav extends ConsumerWidget {
  const GpBottomNav({super.key});

  static const _inactive = Color(0xFF9FA4AA);
  static const _active = Color(0xFFFF6A00);

  BottomNavigationBarItem _item({
    required bool active,
    required String inactiveIcon,
    required String activeIcon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(active ? activeIcon : inactiveIcon, width: 26, height: 26),
      label: label,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(navIndexProvider);

    return SafeArea(
      top: false,
      child: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        selectedItemColor: _active,
        unselectedItemColor: _inactive,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        backgroundColor: Colors.white,
        elevation: 12,
        onTap: (i) async {
          if (i == 2) {
            // 후원하기: 외부 링크 열기
            await launchExternal('https://online.mrm.or.kr/9uBblWm');
            return; // 탭 전환하지 않음
          }
          ref.read(navIndexProvider.notifier).state = i;
        },
        items: [
          _item(
            active: index == 0,
            inactiveIcon: 'assets/icons/home.svg',
            activeIcon: 'assets/icons/home-active.svg',
            label: '홈',
          ),
          _item(
            active: index == 1,
            inactiveIcon: 'assets/icons/search.svg',
            activeIcon: 'assets/icons/search-active.svg',
            label: '검색',
          ),
          _item(
            active: false, // 외부 링크이므로 항상 비활성 스타일 유지
            inactiveIcon: 'assets/icons/donate.svg',
            activeIcon: 'assets/icons/donate-active.svg',
            label: '후원하기',
          ),
        ],
      ),
    );
  }
}
