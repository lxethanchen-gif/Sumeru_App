import 'package:flutter/material.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/pages/detail/teaching_detail_page.dart';

class FirstPage extends StatefulWidget {
  // ← 改成 StatefulWidget，搜尋需要 setState
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Teaching> _filteredList = teachingsList; // 預設顯示全部

  // 搜尋邏輯：比對標題、副標題、標籤、內文
  void _onSearchChanged(String keyword) {
    final query = keyword.trim();
    setState(() {
      if (query.isEmpty) {
        _filteredList = teachingsList;
      } else {
        _filteredList = teachingsList.where((item) {
          return item.title.contains(query) ||
              item.subtitle.contains(query) ||
              item.tag.contains(query) ||
              item.subTag.contains(query) ||
              item.content.contains(query);
        }).toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 搜尋欄 ──────────────────────────────────
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
          child: TextField(
            controller: _searchController,
            onChanged: _onSearchChanged,
            keyboardType: TextInputType.text, // ← 確保是文字鍵盤
            textInputAction: TextInputAction.search,
            enableSuggestions: true, // ← 開啟輸入建議
            autocorrect: false,
            decoration: InputDecoration(
              hintText: '搜尋開示關鍵字...',
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 246, 181, 3),
              ),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        _searchController.clear();
                        _onSearchChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: const Color.fromARGB(255, 253, 248, 235),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 246, 181, 3),
                  width: 1.5,
                ),
              ),
            ),
          ),
        ),

        // ── 搜尋結果數量提示 ────────────────────────
        if (_searchController.text.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                Text(
                  '共找到 ${_filteredList.length} 則開示',
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
          ),

        // ── 列表 ────────────────────────────────────
        Expanded(
          child: _filteredList.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        '找不到相關開示',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  itemCount: _filteredList.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = _filteredList[index];
                    return _TeachingCard(item: item);
                  },
                ),
        ),
      ],
    );
  }
}

// ── 開示卡片元件 ──────────────────────────────────────────
class _TeachingCard extends StatelessWidget {
  final Teaching item;
  const _TeachingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeachingDetailPage(teaching: item),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 副標題
              Text(
                item.subtitle,
                style: const TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 4),

              // 主標題
              Text(
                item.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),

              // 標籤 + 日期
              Row(
                children: [
                  _TagChip(label: item.tag),
                  const SizedBox(width: 6),
                  _TagChip(label: item.subTag),
                  const Spacer(),
                  Text(
                    item.date,
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
        border: Border.all(color: const Color.fromARGB(255, 246, 181, 3)),
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
