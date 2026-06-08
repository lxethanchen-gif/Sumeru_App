import 'package:flutter/material.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/pages/detail/teaching_detail_page.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/translation_service.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  final List<Teaching> _data = teachingsList;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF5F5F5),
      child: _data.isEmpty
          ? const Center(child: Text('目前無內容'))
          : ListView.builder(
              itemCount: _data.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: _TeachingCard(item: _data[index]),
                );
              },
            ),
    );
  }
}

// ── 卡片元件（含翻譯）────────────────────────────────────
class _TeachingCard extends StatefulWidget {
  final Teaching item;
  const _TeachingCard({required this.item});

  @override
  State<_TeachingCard> createState() => _TeachingCardState();
}

class _TeachingCardState extends State<_TeachingCard> {
  String? _cachedLang;
  String _title = '';
  String _subtitle = '';
  String _tag = '';
  String _subTag = '';
  bool _isTranslating = false;

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
        _title = widget.item.title;
        _subtitle = widget.item.subtitle;
        _tag = widget.item.tag;
        _subTag = widget.item.subTag;
      });
      return;
    }

    setState(() => _isTranslating = true);

    final results = await Future.wait([
      TranslationService.translate(text: widget.item.title, to: langCode),
      TranslationService.translate(text: widget.item.subtitle, to: langCode),
      TranslationService.translate(text: widget.item.tag, to: langCode),
      TranslationService.translate(text: widget.item.subTag, to: langCode),
    ]);

    if (mounted) {
      setState(() {
        _cachedLang = langCode;
        _title = results[0];
        _subtitle = results[1];
        _tag = results[2];
        _subTag = results[3];
        _isTranslating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TranslationProvider.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeachingDetailPage(teaching: widget.item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: _isTranslating
              ? _buildSkeleton()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _subtitle,
                      style: const TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _TagChip(label: _tag),
                        const SizedBox(width: 6),
                        _TagChip(label: _subTag),
                        const Spacer(),
                        Text(
                          widget.item.date,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SkeletonBox(width: 120, height: 12),
        const SizedBox(height: 8),
        _SkeletonBox(width: double.infinity, height: 18),
        const SizedBox(height: 10),
        Row(
          children: [
            _SkeletonBox(width: 60, height: 22),
            const SizedBox(width: 6),
            _SkeletonBox(width: 60, height: 22),
          ],
        ),
      ],
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

// ── 標籤元件 ─────────────────────────────────────────────
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
