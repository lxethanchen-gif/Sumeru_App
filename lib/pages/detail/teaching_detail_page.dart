import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/translation_service.dart';

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
      TranslationService.translate(text: widget.teaching.subtitle, to: langCode),
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
            Icon(Icons.check_circle_outline, color: Colors.white, size: 30),
            SizedBox(width: 10),
            Text('已複製開示全文'),
          ],
        ),
        backgroundColor: const Color(0xFFD4A017),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    TranslationProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isTranslating ? '翻譯中...' : _title),
        backgroundColor: const Color(0xFFD4A017),
        foregroundColor: Colors.white,
        actions: [
          if (_isTranslating)
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isTranslating
          ? _buildLoadingBody()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _subtitle,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _TagChip(label: _tag),
                      const SizedBox(width: 6),
                      _TagChip(label: _subTag),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: _copyAll,
                        child: const Icon(
                          Icons.copy_rounded,
                          size: 20,
                          color: Color(0xFFD4A017),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        widget.teaching.date,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 16),
                  Text(
                    _content,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.8,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoadingBody() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBox(width: 140, height: 14),
          const SizedBox(height: 10),
          _SkeletonBox(width: double.infinity, height: 26),
          const SizedBox(height: 14),
          Row(children: [
            _SkeletonBox(width: 70, height: 24),
            const SizedBox(width: 8),
            _SkeletonBox(width: 70, height: 24),
          ]),
          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),
          for (int i = 0; i < 8; i++) ...[
            _SkeletonBox(
              width: i % 3 == 0 ? double.infinity : (i % 3 == 1 ? 260 : 200),
              height: 14,
            ),
            const SizedBox(height: 10),
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
        borderRadius: BorderRadius.circular(4),
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
