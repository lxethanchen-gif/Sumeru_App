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
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF5F5F5),
      child: teachingsList.isEmpty
          ? const Center(child: Text('目前無內容'))
          : ListView.builder(
              itemCount: teachingsList.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: _TeachingCard(item: teachingsList[i]),
              ),
            ),
    );
  }
}

// ── 卡片元件 ─────────────────────────────────────────────
class _TeachingCard extends StatefulWidget {
  final Teaching item;
  const _TeachingCard({required this.item});
  @override
  State<_TeachingCard> createState() => _TeachingCardState();
}

class _TeachingCardState extends State<_TeachingCard> {
  String? _cachedLang;
  late String _title, _subtitle, _tag, _subTag;
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
    final r = await Future.wait([
      TranslationService.translate(text: widget.item.title, to: langCode),
      TranslationService.translate(text: widget.item.subtitle, to: langCode),
      TranslationService.translate(text: widget.item.tag, to: langCode),
      TranslationService.translate(text: widget.item.subTag, to: langCode),
    ]);
    if (!mounted) return;
    setState(() {
      _cachedLang = langCode;
      _title = r[0]; _subtitle = r[1]; _tag = r[2]; _subTag = r[3];
      _isTranslating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TranslationProvider.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => TeachingDetailPage(teaching: widget.item),
        )),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: _isTranslating ? _buildSkeleton() : _buildContent(),
        ),
      ),
    );
  }

  Widget _buildContent() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(_subtitle, style: const TextStyle(fontSize: 16, color: Color(0xFF5C4225))),
      const SizedBox(height: 4),
      Text(_title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
      const SizedBox(height: 10),
      Row(children: [
        _TagChip(_tag),
        const SizedBox(width: 6),
        _TagChip(_subTag),
        const Spacer(),
        Text(widget.item.date, style: const TextStyle(fontSize: 16, color: Color(0xFF5E4B32))),
      ]),
    ],
  );

  Widget _buildSkeleton() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _Skeleton(w: 120, h: 12),
      const SizedBox(height: 8),
      _Skeleton(w: double.infinity, h: 18),
      const SizedBox(height: 10),
      Row(children: [_Skeleton(w: 60, h: 22), const SizedBox(width: 6), _Skeleton(w: 60, h: 22)]),
    ],
  );
}

// ── 工具元件 ─────────────────────────────────────────────
class _Skeleton extends StatelessWidget {
  final double w, h;
  const _Skeleton({required this.w, required this.h});
  @override
  Widget build(BuildContext context) => Container(
    width: w, height: h,
    decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(4)),
  );
}

class _TagChip extends StatelessWidget {
  final String label;
  const _TagChip(this.label);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(color: const Color(0xFFF6B503), borderRadius: BorderRadius.circular(20)),
    child: Text(label, style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500)),
  );
}