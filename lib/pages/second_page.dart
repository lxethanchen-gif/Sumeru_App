import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  final List<Map<String, String>> _allPoems = [
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

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _cardKeys = [];
  final List<ExpansionTileController> _tileControllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < _allPoems.length; i++) {
      _cardKeys.add(GlobalKey());
      _tileControllers.add(ExpansionTileController());
    }
  }

  void _scrollToIndex(int index) {
    final keyContext = _cardKeys[index].currentContext;
    if (keyContext != null) {
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
      if (!_tileControllers[index].isExpanded) {
        _tileControllers[index].expand();
      }
    }
  }

  void _showMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12, bottom: 12),
                child: Text(
                  '詩摘要目錄',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
              ),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _allPoems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: const Icon(Icons.book_rounded, color: Color(0xFFE5A900)),
                      title: Text(
                        _allPoems[index]['title']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _scrollToIndex(index);
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton(
        onPressed: _showMenuBottomSheet,
        backgroundColor: const Color(0xFFE5A900),
        shape: const CircleBorder(),
        child: const Icon(Icons.menu_book, color: Colors.white),
      ),
      body: SafeArea(
        child: ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16.0),
          itemCount: _allPoems.length,
          itemBuilder: (context, index) {
            return Padding(
              key: _cardKeys[index],
              padding: const EdgeInsets.only(bottom: 16.0),
              child: PoemCard(
                title: _allPoems[index]['title']!,
                subtitle: _allPoems[index]['subtitle']!,
                content: _allPoems[index]['content']!,
                tileController: _tileControllers[index],
              ),
            );
          },
        ),
      ),
    );
  }
}

class PoemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String content;
  final ExpansionTileController? tileController;

  const PoemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.content,
    this.tileController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: tileController,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 13, color: Colors.grey[500]),
          ),
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24, bottom: 40, top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SelectableText(
                      content,
                      style: const TextStyle(
                        fontSize: 17,
                        height: 1.8,
                        letterSpacing: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 8,
                  right: 12,
                  child: IconButton(
                    icon: const Icon(Icons.copy_rounded, size: 20, color: Color(0xFFE5A900)),
                    tooltip: '複製開示內文',
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: content));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('已複製「$title」內文至剪貼簿'),
                            duration: const Duration(seconds: 2),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: const Color(0xFFE5A900),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}