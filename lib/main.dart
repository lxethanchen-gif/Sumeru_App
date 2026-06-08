import 'package:flutter/material.dart';
import 'package:suneru1/pages/first_page.dart';
import 'package:suneru1/pages/second_page.dart';
import 'package:suneru1/pages/third_page.dart';
import 'package:suneru1/pages/fourth_page.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/pages/detail/teaching_detail_page.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/language_fab.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TranslationProvider(
      notifier: TranslationNotifier(),
      child: MaterialApp(
        title: '須彌山佛國網',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 246, 181, 3),
          ),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, String>> _allPoems = const [
    {
      'title': '候車',
      'subtitle': '諦深 · 2026.6.1',
      'content': '一眾列侯長站台，\n七七八八箱包排；\n繁花美景均無視，\n只盯是否火車來！',
    },
    {
      'title': '庶人',
      'subtitle': '諦深 · 2026.6.1',
      'content': '腳前碧海腳後山，\n左首鏡湖印藍天；\n是處若非仙人居，\n定立豪傑此地間！',
    },
    {
      'title': '錯搭窩',
      'subtitle': '諦深 · 2026.6.1',
      'content': '峽谷河灘熱如灸，\n老衲掩蓬坐中休；\n窸窸窣窣禪衣動，\n尋處搭窩小鳥抽！',
    },
  ];

  final List<Map<String, String>> _allVideos = const [
    {
      'id': 'LJyHPuiF8UQ',
      'title': '諦深大師 開示 2020年3月7日',
      'subtitle': '密宗已经不是佛法了，解梦，遗传病，神通，不淫戒等等',
      'image': 'https://img.youtube.com/vi/LJyHPuiF8UQ/0.jpg',
    },
    {
      'id': '_bkfCBKp258',
      'title': '諦深大師 開示 2020年3月14日',
      'subtitle': '时间就是空间，微尘国，算命，佛的三身',
      'image': 'https://img.youtube.com/vi/_bkfCBKp258/0.jpg',
    },
    {
      'id': 'CK_iPAYYfgM',
      'title': '諦深大師 開示 2020年3月21日',
      'subtitle': '道教，念佛，打坐，参禅，不淫戒，恒顺众生，诽谤的果报',
      'image': 'https://img.youtube.com/vi/CK_iPAYYfgM/0.jpg',
    },
    {
      'id': 'OsV884KPIew',
      'title': '諦深大師 開示 2020年3月28日',
      'subtitle': '密宗已经不是佛法了，解梦',
      'image': 'https://img.youtube.com/vi/OsV884KPIew/0.jpg',
    },
    {
      'id': 'iqXuRXKhMz4',
      'title': '諦深大師 開示 2020年4月4日',
      'subtitle': '密宗已经不是佛法了，解梦',
      'image': 'https://img.youtube.com/vi/iqXuRXKhMz4/0.jpg',
    },
  ];

  final List<Widget> pages = const [
    FirstPage(),
    SecondPage(),
    ThirdPage(),
    FourthPage(),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Teaching> get _filteredTeachings {
    final q = _searchQuery.toLowerCase();
    return teachingsList
        .where(
          (t) =>
              t.title.toLowerCase().contains(q) ||
              t.subtitle.toLowerCase().contains(q) ||
              t.tag.toLowerCase().contains(q) ||
              t.content.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Map<String, String>> get _filteredPoems {
    final q = _searchQuery.toLowerCase();
    return _allPoems
        .where(
          (p) =>
              p['title']!.toLowerCase().contains(q) ||
              p['content']!.toLowerCase().contains(q),
        )
        .toList();
  }

  List<Map<String, String>> get _filteredVideos {
    final q = _searchQuery.toLowerCase();
    return _allVideos
        .where(
          (v) =>
              v['title']!.toLowerCase().contains(q) ||
              v['subtitle']!.toLowerCase().contains(q),
        )
        .toList();
  }

  bool get _isSearching => _searchQuery.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    const Color primaryGold = Color.fromARGB(255, 246, 181, 3);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '須彌山佛國網',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: primaryGold,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
      ),

      body: Column(
        children: [
          // ── 固定搜尋欄，卡片從下方滑過 ──
          Material(
            elevation: 0,
            color: const Color(0xFFF5F5F5), // ← 與 FirstPage 底色一致
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15), // ← 暗灰色陰影
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: '搜尋文字開示、詩摘、影片...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Color(0xFFE5A900),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () => setState(() {
                              _searchController.clear();
                              _searchQuery = '';
                            }),
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none, // ← 用陰影取代邊框
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: const BorderSide(
                        color: Colors.transparent,
                        width: 0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── 主體：搜尋結果 or 一般頁面 ──
          Expanded(
            child: _isSearching
                ? _buildSearchResults(context)
                : pages[currentPage],
          ),
        ],
      ),

      floatingActionButton: const LanguageFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: currentPage,
            onTap: (value) => setState(() {
              currentPage = value;
              _searchController.clear();
              _searchQuery = '';
            }),
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: primaryGold,
            unselectedItemColor: Colors.grey.shade400,
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
            showUnselectedLabels: true,
            iconSize: 24,
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.menu_book_rounded),
                ),
                activeIcon: Icon(Icons.menu_book_rounded),
                label: '文字開示',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.article_rounded),
                ),
                activeIcon: Icon(Icons.article_rounded),
                label: '詩摘',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.video_library_rounded),
                ),
                activeIcon: Icon(Icons.video_library_rounded),
                label: '語音開示',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.videocam_rounded),
                ),
                activeIcon: Icon(Icons.videocam_rounded),
                label: '直播',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final teachings = _filteredTeachings;
    final poems = _filteredPoems;
    final videos = _filteredVideos;
    final totalCount = teachings.length + poems.length + videos.length;

    if (totalCount == 0) {
      return const Center(
        child: Text(
          '查無相關內容',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        if (teachings.isNotEmpty) ...[
          _SectionHeader(
            label: '文字開示',
            icon: Icons.menu_book_rounded,
            count: teachings.length,
          ),
          ...teachings.map((t) => _TeachingResultCard(teaching: t)),
          const SizedBox(height: 8),
        ],
        if (poems.isNotEmpty) ...[
          _SectionHeader(
            label: '詩摘',
            icon: Icons.article_rounded,
            count: poems.length,
          ),
          ...poems.map((p) => _PoemResultCard(poem: p)),
          const SizedBox(height: 8),
        ],
        if (videos.isNotEmpty) ...[
          _SectionHeader(
            label: '語音開示',
            icon: Icons.video_library_rounded,
            count: videos.length,
          ),
          ...videos.map((v) => _VideoResultCard(video: v)),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

// ── 分組標題 ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  const _SectionHeader({
    required this.label,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: const Color(0xFFE5A900)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFFE5A900),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF7EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count',
              style: const TextStyle(fontSize: 12, color: Color(0xFFE5A900)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── 文字開示結果卡片 ──────────────────────────────────────
class _TeachingResultCard extends StatelessWidget {
  final Teaching teaching;
  const _TeachingResultCard({required this.teaching});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TeachingDetailPage(teaching: teaching),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teaching.subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                teaching.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _Chip(label: teaching.tag),
                  const SizedBox(width: 6),
                  _Chip(label: teaching.subTag),
                  const Spacer(),
                  Text(
                    teaching.date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── 詩摘結果卡片 ─────────────────────────────────────────
class _PoemResultCard extends StatelessWidget {
  final Map<String, String> poem;
  const _PoemResultCard({required this.poem});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              poem['title']!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              poem['subtitle']!,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              poem['content']!,
              style: const TextStyle(
                fontSize: 14,
                height: 1.8,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 影片結果卡片 ─────────────────────────────────────────
class _VideoResultCard extends StatelessWidget {
  final Map<String, String> video;
  const _VideoResultCard({required this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VideoPlayPage(
              videoId: video['id']!,
              videoTitle: video['title']!,
            ),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(10),
              ),
              child: Image.network(
                video['image']!,
                width: 110,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 4,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      video['title']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      video['subtitle']!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(
                Icons.play_circle_outline,
                color: Color(0xFFE5A900),
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── 標籤元件 ─────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 246, 181, 3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color.fromARGB(255, 180, 130, 0),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
