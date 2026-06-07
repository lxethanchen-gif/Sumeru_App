import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 導入系統服務以調用剪貼簿

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  // 詩詞資料
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

  List<Map<String, String>> _foundPoems = [];
  final TextEditingController _searchController = TextEditingController();
  
  // 用於控制列表捲動
  final ScrollController _scrollController = ScrollController();
  // 用來記錄每張卡片的 Key，方便目錄跳轉定位
  final List<GlobalKey> _cardKeys = [];
  // 【新增】用來控制每張卡片展開/折疊的控制器清單
  final List<ExpansionTileController> _tileControllers = [];

  @override
  void initState() {
    super.initState();
    _foundPoems = _allPoems;
    // 根據詩詞數量初始化 GlobalKey 與 ExpansionTileController
    for (var i = 0; i < _allPoems.length; i++) {
      _cardKeys.add(GlobalKey());
      _tileControllers.add(ExpansionTileController()); // 建立對應的控制器
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Map<String, String>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPoems;
    } else {
      results = _allPoems
          .where((poem) =>
              poem['title']!.contains(enteredKeyword) ||
              poem['content']!.contains(enteredKeyword))
          .toList();
    }

    setState(() {
      _foundPoems = results;
    });
  }

  // 捲動到指定索引卡片並自動展開的函數
  void _scrollToIndex(int index) {
    final keyContext = _cardKeys[index].currentContext;
    if (keyContext != null) {
      // 1. 動畫捲動到卡片位置
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500), 
        curve: Curves.easeInOut,
      );
      
      // 2. 自動將該張卡片展開
      if (!_tileControllers[index].isExpanded) {
        _tileControllers[index].expand();
      }
    }
  }

  // 彈出底部目錄面版
  void _showMenuBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          // 限制目錄最大高度為螢幕的一半，避免卡片極多時擋住整個畫面
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
              
              // 目錄列表清單
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
                        Navigator.pop(context); // 關閉目錄底層面板
                        
                        // 如果目前有搜尋過濾，先清空搜尋讓所有卡片顯示，才能順利跳轉定位
                        if (_searchController.text.isNotEmpty) {
                          setState(() {
                            _searchController.clear();
                            _foundPoems = _allPoems;
                          });
                          // 稍微延遲等待 UI 重新整理渲染完成後再執行捲動與展開
                          Future.delayed(const Duration(milliseconds: 150), () {
                            _scrollToIndex(index);
                          });
                        } else {
                          _scrollToIndex(index);
                        }
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
      backgroundColor: const Color(0xFFFDFBF7), 
      floatingActionButton: FloatingActionButton(
        onPressed: _showMenuBottomSheet,
        backgroundColor: const Color(0xFFE5A900), 
        shape: const CircleBorder(), 
        child: const Icon(Icons.menu_book, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 頂部純白搜尋欄位區塊
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => _runFilter(value),
                  decoration: InputDecoration(
                    hintText: '搜尋開示關鍵字...',
                    hintStyle: TextStyle(color: Colors.grey[400], fontSize: 15),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFFE5A900)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _runFilter('');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            
            // 下方詩詞卡片清單
            Expanded(
              child: _foundPoems.isNotEmpty
                  ? ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      itemCount: _foundPoems.length,
                      itemBuilder: (context, index) {
                        // 找出該卡片在原始資料 _allPoems 的索引值，用來綁定正確的 Key 與 Controller
                        final originalIndex = _allPoems.indexWhere(
                            (p) => p['title'] == _foundPoems[index]['title']);
                        
                        return Padding(
                          key: originalIndex != -1 ? _cardKeys[originalIndex] : null,
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: PoemCard(
                            title: _foundPoems[index]['title']!,
                            subtitle: _foundPoems[index]['subtitle']!,
                            content: _foundPoems[index]['content']!,
                            // 將對應的控制器傳入卡片
                            tileController: originalIndex != -1 ? _tileControllers[originalIndex] : null,
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('找不到相關的詩摘要', style: TextStyle(color: Colors.grey, fontSize: 16)),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// 詩詞卡片元件（右下角帶有一鍵複製按鈕，並支援外部控制器操控開合）
class PoemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String content;
  final ExpansionTileController? tileController; // 【新增】接收控制器的參數

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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: tileController, // 【新增】綁定控制器
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
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          children: [
            Stack(
              children: [
                // 詩詞開示內容
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
                
                // 右下角的複製按鈕定位
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