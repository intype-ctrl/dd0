import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:news_app/models/app_settings_model.dart';
import 'package:news_app/screens/bookmarks.dart';
import 'package:news_app/utils/next_screen.dart';
import 'package:url_launcher/url_launcher.dart'; // ← 링크 열기
import '../providers/package_provider.dart';
import '../services/app_service.dart';
import 'app_logo.dart';

// --- 아이콘 경로/링크 상수 ---
const _alarmIconPath = 'assets/images/a1.png';
const _companyImagePath = 'assets/images/company.png';

const _snsIconPaths = [
  'assets/images/s1.png',
  'assets/images/s2.png',
  'assets/images/s3.png',
  'assets/images/s4.png',
  'assets/images/s5.png',
  'assets/images/s6.png',
];

const _snsLinks = [
  'https://www.goodpeople.or.kr/',
  'https://www.instagram.com/goodpeoplei',
  'https://www.youtube.com/@goodpeoplei',
  'https://www.facebook.com/GPInternational/',
  'https://blog.naver.com/goodpeoplei',
  'https://pf.kakao.com/_aDzjd',
];

// --- UI 튜닝 상수 ---
const double snsIconSize = 50;                 // SNS 아이콘 표시 크기
const kAlarmPillBg = Color(0xFFF2F3F5);        // 알림설정 pill 배경
const kSubmenuBg   = Color(0xFFF5F6F8);        // 2차 메뉴 그룹 박스 배경

// 드롭다운 전체 영역 좌우 패딩
const double kDropdownHpad = 16.0;

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    this.settings,
  });

  final AppSettingsModel? settings;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

// 좌우 30px 길이의 얇은 커스텀 Divider
Widget _customDivider(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16), // 좌우 16px
    child: Container(
      height: 1,
      color: Theme.of(context).dividerColor.withOpacity(0.15),
    ),
  );
}

class _CustomDrawerState extends State<CustomDrawer> {
  /// 현재 열린 2차 메뉴 키 (null / 'news' / 'about')
  String? _openKey;

  Color get _divider => Theme.of(context).dividerColor.withOpacity(0.15);
  TextStyle? get _menuText => Theme.of(context).textTheme.titleMedium;

  @override
  void initState() {
    super.initState();
    // 아이콘 미리 로딩해서 첫 표시 빠르게
    WidgetsBinding.instance.addPostFrameCallback((_) {
      for (final p in _snsIconPaths) {
        precacheImage(AssetImage(p), context);
      }
      precacheImage(const AssetImage(_alarmIconPath), context);
      precacheImage(const AssetImage(_companyImagePath), context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.7,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      elevation: 16,
      child: SafeArea(
        child: Column(
          children: [
            // 상단 X 버튼
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            // ====== 본문: 전부 하나의 ListView로 (하단 고정 없음) ======
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    // ----- 메뉴 섹션 -----
                    _twoDepth(
                      keyName: 'news',
                      title: '굿피플 소식',
                      isOpen: _openKey == 'news',
                      onToggle: () {
                        setState(() {
                          _openKey = (_openKey == 'news') ? null : 'news';
                        });
                      },
                      child: const _SubGroup(
                        children: [
                          _SubItem('국내 소식' /* , route: '/news/domestic' */),
                          _SubDivider(),
                          _SubItem('해외 소식' /* , route: '/news/global' */),
                        ],
                      ),
                    ),
                    _customDivider(context),

                    _rootRow('굿피플 영상'),
                    _customDivider(context),

                    _rootRow('월간 좋은사람'),
                    _customDivider(context),

                    _rootRow('공지사항'),
                    _customDivider(context),

                    _twoDepth(
                      keyName: 'about',
                      title: '굿피플 소개',
                      isOpen: _openKey == 'about',
                      onToggle: () {
                        setState(() {
                          _openKey = (_openKey == 'about') ? null : 'about';
                        });
                      },
                      child: const _SubGroup(
                        children: [
                          _SubItem('걸어온 길' /* , route: '/about/history' */),
                          _SubDivider(),
                          _SubItem('재정보고' /* , route: '/about/report' */),
                        ],
                      ),
                    ),
                    _customDivider(context),

                    _rootRow('자주하는 질문'),

                    const SizedBox(height: 16),

                    // ----- 알림설정 pill -----
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(40),
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        overlayColor: MaterialStateProperty.all(Colors.transparent),
                        onTap: () {
                          // TODO: 알림설정 페이지 연결
                        },
                        child: Container(
                          height: 44,
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          decoration: BoxDecoration(
                            color: kAlarmPillBg,
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                _alarmIconPath,
                                width: 18,
                                height: 18,
                                filterQuality: FilterQuality.low,
                              ),
                              const SizedBox(width: 8),
                              Text('알림설정', style: _menuText),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ----- SNS 3x2 그리드 -----
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _snsIconPaths.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 1.0,
                        ),
                        itemBuilder: (_, i) {
                          return Center(
                            child: InkWell(
                              onTap: () => _openExternal(_snsLinks[i]),
                              borderRadius: BorderRadius.circular(12),
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              overlayColor: MaterialStateProperty.all(Colors.transparent),
                              child: Image.asset(
                                _snsIconPaths[i],
                                width: snsIconSize,
                                height: snsIconSize,
                                fit: BoxFit.contain,
                                filterQuality: FilterQuality.high,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 12),

                    // ----- 회사소개 이미지 (원본 비율) -----
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18),
                      child: FooterCompany(),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- 레이아웃 유틸 ----------

  Widget _rootRow(String title) {
    // 탭 동작/하이라이트 없음
    return ListTile(
      visualDensity: const VisualDensity(vertical: -1),
      contentPadding: const EdgeInsets.symmetric(horizontal: kDropdownHpad),
      title: Text(
        title,
        style: _menuText?.copyWith(
          fontWeight: FontWeight.bold,   // Bold
        ),
      ),
      onTap: null,
    );
  }

  Widget _twoDepth({
    required String keyName,
    required String title,
    required bool isOpen,
    required VoidCallback onToggle,
    required Widget child,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 드롭다운 타이틀 (좌우 16px, Bold, 스플래시 제거)
        InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          focusColor: Colors.transparent,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 14,
              horizontal: kDropdownHpad,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: _menuText?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(isOpen ? Icons.expand_less : Icons.expand_more, size: 20),
              ],
            ),
          ),
        ),
        // 펼친 영역 (좌우 16px)
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Padding(
            padding: const EdgeInsets.only(
              left: kDropdownHpad,
              right: kDropdownHpad,
              bottom: 6,
            ),
            child: child,
          ),
          crossFadeState:
              isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }

  Future<void> _openExternal(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('링크를 열 수 없습니다.')),
      );
    }
  }
}

// ====== 2차 메뉴: 그룹/아이템/디바이더 ======

class _SubGroup extends StatelessWidget {
  final List<Widget> children;
  const _SubGroup({required this.children, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 6, bottom: 6),
      decoration: BoxDecoration(
        color: kSubmenuBg,
        borderRadius: BorderRadius.circular(1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: children,
        ),
      ),
    );
  }
}

class _SubItem extends StatelessWidget {
  final String label;
  final String? route; // 라우팅은 나중에 연결
  const _SubItem(this.label, {this.route, super.key});

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.bold, // 2차 메뉴 항목 Bold
        );

    return InkWell(
      onTap: route == null
          ? null
          : () {
              Navigator.pop(context);
              Navigator.pushNamed(context, route!);
            },
      splashColor: Colors.black12.withOpacity(.06),
      highlightColor: Colors.black12.withOpacity(.04),
      child: SizedBox(
        height: 44,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(label, style: style),
          ),
        ),
      ),
    );
  }
}

class _SubDivider extends StatelessWidget {
  const _SubDivider({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: const Color.fromARGB(255, 112, 112, 112).withOpacity(0.06),
    );
  }
}

// ====== 회사소개 이미지 ======

/// 원본 비율 그대로(라운드/그림자/비율 강제 없음)
class FooterCompany extends StatelessWidget {
  const FooterCompany({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      _companyImagePath,   // assets/images/company.png
      fit: BoxFit.contain, // 잘림 없이 비율 유지
      filterQuality: FilterQuality.high,
    );
  }
}

// ====== (옵션) 이전 스켈레톤 유지용 ======

class _SubRowPlaceholder extends StatelessWidget {
  const _SubRowPlaceholder();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Row(
        children: const [
          SizedBox(width: 12),
          _Bar(width: 80),
        ],
      ),
    );
  }
}

class _FooterSkeleton extends StatelessWidget {
  const _FooterSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        _Bar(width: 210),
        SizedBox(height: 6),
        _Bar(width: 240),
        SizedBox(height: 4),
        _Bar(width: 260),
        SizedBox(height: 4),
        _Bar(width: 220),
        SizedBox(height: 6),
        _Bar(width: 200),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({required this.width});
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 12,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(.25),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
