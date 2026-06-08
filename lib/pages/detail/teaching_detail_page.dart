import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/translation_service.dart';
import 'package:suneru1/translation/language_fab.dart';

class TeachingDetailPage extends StatefulWidget {
  final Teaching teaching;
  const TeachingDetailPage({super.key, required this.teaching});

  @override
  State<TeachingDetailPage> createState() => _TeachingDetailPageState();
}

class _TeachingDetailPageState extends State<TeachingDetailPage> {
  String? _cachedLang;
  late String _title;
  late String _subtitle;
  late String _tag;
  late String _subTag;
  late String _content;
  bool _isTranslating = false;

  static const Color _gold = Color(0xFFD4A017);
  static const Color _goldLight = Color(0xFFFFF8E7);
  static const Color _bg = Color(0xFFFAFAFA);

  @override
  void initState() {
    super.initState();
    _resetToOriginal();
  }

  void _resetToOriginal() {
    _title = widget.teaching.title;
    _subtitle = widget.teaching.subtitle;
    _tag = widget.teaching.tag;
    _subTag = widget.teaching.subTag;
    _content = widget.teaching.content;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeTranslate();
  }

  Future<void> _maybeTranslate() async {
    final langCode = TranslationProvider.of(context).langCode;
    if (_cachedLang == langCode) return;

    if (langCode == 'zh-TW') {
      setState(() {
        _cachedLang = langCode;
        _resetToOriginal();
      });
      return;
    }

    setState(() => _isTranslating = true);

    final results = await Future.wait([
      TranslationService.translate(text: widget.teaching.title, to: langCode),
      TranslationService.translate(
        text: widget.teaching.subtitle,
        to: langCode,
      ),
      TranslationService.translate(text: widget.teaching.tag, to: langCode),
      TranslationService.translate(text: widget.teaching.subTag, to: langCode),
      TranslationService.translate(text: widget.teaching.content, to: langCode),
    ]);

    if (mounted) {
      setState(() {
        _cachedLang = langCode;
        _title = results[0];
        _subtitle = results[1];
        _tag = results[2];
        _subTag = results[3];
        _content = results[4];
        _isTranslating = false;
      });
    }
  }

  void _copyAll() {
    final text = [
      _subtitle,
      _title,
      '$_tag・$_subTag',
      widget.teaching.date,
      '',
      _content,
    ].join('\n');

    Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            SizedBox(width: 8),
            Text('已複製開示全文', style: TextStyle(fontSize: 14)),
          ],
        ),
        backgroundColor: _gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslationProvider.of(context);

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          _isTranslating ? '翻譯中...' : _title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFEEEEEE)),
        ),
        actions: [
          if (_isTranslating)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: _gold,
                  ),
                ),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.copy_rounded, size: 20, color: _gold),
              tooltip: '複製全文',
              onPressed: _copyAll,
            ),
        ],
      ),
      floatingActionButton: const LanguageFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      // ── 新增底部導覽列 ──
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
            currentIndex: 0, // 文字開示固定高亮
            onTap: (value) {
              // 關閉詳細頁回到主頁面，再切換 tab
              Navigator.pop(context);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedItemColor: const Color(0xFFF6B503),
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
      body: _isTranslating
          ? _buildLoadingBody()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── 副標題 ──
                  Text(
                    _subtitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 103, 92, 59),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // ── 主標題 ──
                  Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── 標籤列 ──
                  Row(
                    children: [
                      _TagChip(label: _tag),
                      const SizedBox(width: 6),
                      _TagChip(label: _subTag),
                      const Spacer(),
                      Text(
                        widget.teaching.date,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 131, 91, 56),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // ── 金色細分隔線 ──
                  Container(
                    height: 1.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          _gold.withValues(alpha: 0.8),
                          _gold.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── 內文 ──
                  Text(
                    _content,
                    style: const TextStyle(
                      fontSize: 17,
                      height: 2.1,
                      color: Color(0xFF2C2C2C),
                      letterSpacing: 0.4,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // ── 底部複製按鈕 ──
                  Center(
                    child: TextButton.icon(
                      onPressed: _copyAll,
                      icon: const Icon(
                        Icons.copy_rounded,
                        size: 16,
                        color: _gold,
                      ),
                      label: const Text(
                        '複製全文',
                        style: TextStyle(
                          fontSize: 14,
                          color: _gold,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: _goldLight,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 120, height: 13),
          const SizedBox(height: 12),
          _SkeletonBox(width: double.infinity, height: 28),
          const SizedBox(height: 8),
          _SkeletonBox(width: 200, height: 28),
          const SizedBox(height: 18),
          Row(
            children: [
              _SkeletonBox(width: 70, height: 26),
              const SizedBox(width: 8),
              _SkeletonBox(width: 70, height: 26),
            ],
          ),
          const SizedBox(height: 28),
          Container(height: 1.5, color: Colors.grey[200]),
          const SizedBox(height: 28),
          for (int i = 0; i < 10; i++) ...[
            _SkeletonBox(
              width: i % 3 == 0 ? double.infinity : (i % 3 == 1 ? 280 : 220),
              height: 14,
            ),
            const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  const _SkeletonBox({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFD4A017).withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12,
          color: Color(0xFFB8860B),
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
