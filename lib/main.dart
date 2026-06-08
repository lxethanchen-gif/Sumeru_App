import 'package:flutter/material.dart';
import 'package:suneru1/pages/first_page.dart';
import 'package:suneru1/pages/second_page.dart';
import 'package:suneru1/pages/third_page.dart';
import 'package:suneru1/pages/fourth_page.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/pages/detail/teaching_detail_page.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/language_fab.dart';

void main() => runApp(const MyApp());

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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF6B503)),
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
  final _searchController = TextEditingController();
  String _searchQuery = '';

  static const _allPoems = [
    {'title': '候車', 'subtitle': '諦深 · 2026.6.1', 'content': '一眾列侯長站台，\n七七八八箱包排；\n繁花美景均無視，\n只盯是否火車來！'},
    {'title': '庶人', 'subtitle': '諦深 · 2026.6.1', 'content': '腳前碧海腳後山，\n左首鏡湖印藍天；\n是處若非仙人居，\n定立豪傑此地間！'},
    {'title': '錯搭窩', 'subtitle': '諦深 · 2026.6.1', 'content': '峽谷河灘熱如灸，\n老衲掩蓬坐中休；\n窸窸窣窣禪衣動，\n尋處搭窩小鳥抽！'},
  ];

  static const _allVideos = [
    {'id': 'LJyHPuiF8UQ', 'title': '諦深大師 開示 2020年3月7日',  'subtitle': '密宗已经不是佛法了，解梦，遗传病，神通，不淫戒等等', 'image': 'https://img.youtube.com/vi/LJyHPuiF8UQ/0.jpg'},
    {'id': '_bkfCBKp258', 'title': '諦深大師 開示 2020年3月14日', 'subtitle': '时间就是空间，微尘国，算命，佛的三身',               'image': 'https://img.youtube.com/vi/_bkfCBKp258/0.jpg'},
    {'id': 'CK_iPAYYfgM', 'title': '諦深大師 開示 2020年3月21日', 'subtitle': '道教，念佛，打坐，参禅，不淫戒，恒顺众生，诽谤的果报', 'image': 'https://img.youtube.com/vi/CK_iPAYYfgM/0.jpg'},
    {'id': 'OsV884KPIew', 'title': '諦深大師 開示 2020年3月28日', 'subtitle': '密宗已经不是佛法了，解梦',                          'image': 'https://img.youtube.com/vi/OsV884KPIew/0.jpg'},
    {'id': 'iqXuRXKhMz4', 'title': '諦深大師 開示 2020年4月4日',  'subtitle': '密宗已经不是佛法了，解梦',                          'image': 'https://img.youtube.com/vi/iqXuRXKhMz4/0.jpg'},
  ];

  static const pages = [FirstPage(), SecondPage(), ThirdPage(), FourthPage()];

  @override
  void dispose() { _searchController.dispose(); super.dispose(); }

  bool get _isSearching => _searchQuery.isNotEmpty;

  List<Teaching> get _filteredTeachings {
    final q = _searchQuery.toLowerCase();
    return teachingsList.where((t) =>
      t.title.toLowerCase().contains(q) || t.subtitle.toLowerCase().contains(q) ||
      t.tag.toLowerCase().contains(q)   || t.content.toLowerCase().contains(q),
    ).toList();
  }

  List<Map<String, String>> get _filteredPoems {
    final q = _searchQuery.toLowerCase();
    return _allPoems.where((p) =>
      p['title']!.toLowerCase().contains(q) || p['content']!.toLowerCase().contains(q),
    ).toList();
  }

  List<Map<String, String>> get _filteredVideos {
    final q = _searchQuery.toLowerCase();
    return _allVideos.where((v) =>
      v['title']!.toLowerCase().contains(q) || v['subtitle']!.toLowerCase().contains(q),
    ).toList();
  }

  static const _gold = Color(0xFFF6B503);
  static const _bgColor = Color(0xFFF5F5F5); // ← 與 FirstPage 一致

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        title: const Text('須彌山佛國網', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5)),
        centerTitle: true,
        backgroundColor: _gold,
        foregroundColor: Colors.white,
        elevation: 2,
        shadowColor: Colors.black26,
      ),
      body: Column(
        children: [
          if (currentPage != 3)
            ColoredBox(
              color: _bgColor,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 8, spreadRadius: 1, offset: const Offset(0, 2))],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: '搜尋文字開示、詩摘、影片...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFE5A900)),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(icon: const Icon(Icons.clear, color: Colors.grey), onPressed: () => setState(() { _searchController.clear(); _searchQuery = ''; }))
                          : null,
                      filled: true, fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: Colors.transparent)),
                    ),
                  ),
                ),
              ),
            ),
          Expanded(child: _isSearching ? _buildSearchResults(context) : pages[currentPage]),
        ],
      ),
      floatingActionButton: const LanguageFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, spreadRadius: 1, offset: const Offset(0, -2))],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          currentIndex: currentPage,
          onTap: (v) => setState(() { currentPage = v; _searchController.clear(); _searchQuery = ''; }),
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          elevation: 0,
          selectedItemColor: _gold,
          unselectedItemColor: Colors.grey.shade400,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, letterSpacing: 0.5),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          showUnselectedLabels: true,
          iconSize: 24,
          items: _navItems,
        ),
      ),
    );
  }

  static const _navItems = [
    BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4, top: 6), child: Icon(Icons.menu_book_rounded)),    activeIcon: Icon(Icons.menu_book_rounded),    label: '文字開示'),
    BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4, top: 6), child: Icon(Icons.edit_note_rounded)),    activeIcon: Icon(Icons.edit_note_rounded),    label: '詩摘'),
    BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4, top: 6), child: Icon(Icons.headphones_rounded)),   activeIcon: Icon(Icons.headphones_rounded),   label: '語音開示'),
    BottomNavigationBarItem(icon: Padding(padding: EdgeInsets.only(bottom: 4, top: 6), child: Icon(Icons.live_tv_rounded)),      activeIcon: Icon(Icons.live_tv_rounded),      label: '直播'),
  ];

  Widget _buildSearchResults(BuildContext context) {
    final teachings = _filteredTeachings;
    final poems     = _filteredPoems;
    final videos    = _filteredVideos;
    if (teachings.isEmpty && poems.isEmpty && videos.isEmpty) {
      return const Center(child: Text('查無相關內容', style: TextStyle(color: Colors.grey, fontSize: 16)));
    }
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      children: [
        if (teachings.isNotEmpty) ...[
          _SectionHeader('文字開示', Icons.menu_book_rounded, teachings.length),
          ...teachings.map((t) => _TeachingResultCard(teaching: t)),
          const SizedBox(height: 8),
        ],
        if (poems.isNotEmpty) ...[
          _SectionHeader('詩摘', Icons.edit_note_rounded, poems.length),
          ...poems.map((p) => _PoemResultCard(poem: p)),
          const SizedBox(height: 8),
        ],
        if (videos.isNotEmpty) ...[
          _SectionHeader('語音開示', Icons.headphones_rounded, videos.length),
          ...videos.map((v) => _VideoResultCard(video: v)),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

// ── 共用白色卡片陰影裝飾 ──────────────────────────────────
BoxDecoration _cardDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10),
  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, spreadRadius: 1, offset: const Offset(0, 3))],
);

// ── 分組標題 ─────────────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String label;
  final IconData icon;
  final int count;
  const _SectionHeader(this.label, this.icon, this.count);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 4),
      child: Row(children: [
        Icon(icon, size: 18, color: const Color(0xFFE5A900)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFFE5A900))),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
          decoration: BoxDecoration(color: const Color(0xFFFEF7EB), borderRadius: BorderRadius.circular(12)),
          child: Text('$count', style: const TextStyle(fontSize: 12, color: Color(0xFFE5A900))),
        ),
      ]),
    );
  }
}

// ── 文字開示結果卡片 ──────────────────────────────────────
class _TeachingResultCard extends StatelessWidget {
  final Teaching teaching;
  const _TeachingResultCard({required this.teaching});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _cardDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TeachingDetailPage(teaching: teaching))),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(teaching.subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(teaching.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Row(children: [
              _Chip(teaching.tag), const SizedBox(width: 6), _Chip(teaching.subTag),
              const Spacer(),
              Text(teaching.date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]),
          ]),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _cardDecoration,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(poem['title']!, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(poem['subtitle']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(poem['content']!, style: const TextStyle(fontSize: 14, height: 1.8, letterSpacing: 1.2)),
        ]),
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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: _cardDecoration,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => VideoPlayPage(videoId: video['id']!, videoTitle: video['title']!),
        )),
        child: Row(children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(10)),
            child: Image.network(video['image']!, width: 110, height: 70, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(video['title']!,    maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(video['subtitle']!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ]),
            ),
          ),
        ]),
      ),
    );
  }
}

// ── 標籤元件 ─────────────────────────────────────────────
class _Chip extends StatelessWidget {
  final String label;
  const _Chip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: const Color(0xFFF6B503), borderRadius: BorderRadius.circular(20)),
      child: Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFFB48200), fontWeight: FontWeight.w500)),
    );
  }
}