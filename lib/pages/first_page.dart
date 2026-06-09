import 'package:flutter/material.dart';
import 'package:suneru1/pages/categories/ying_shi_juan_page.dart';
import 'package:suneru1/pages/categories/mie_zui_juan_page.dart';
import 'package:suneru1/pages/categories/ji_yuan_dao_zhi_page.dart';
import 'package:suneru1/pages/categories/shi_zhai_page.dart';

enum TeachingCategory {
  yingShiJuan('應世卷'),
  mieZuiJuan('滅罪卷'),
  jiYuanDaoZhi('機緣道旨'),
  shiZhai('詩摘');

  const TeachingCategory(this.label);
  final String label;
}

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});
  @override
  State<FirstPage> createState() => FirstPageState();
}

class FirstPageState extends State<FirstPage> {
  TeachingCategory _selected = TeachingCategory.yingShiJuan;

  // 對應每個分類的頁面
  Widget get _currentPage => switch (_selected) {
    TeachingCategory.yingShiJuan  => const YingShiJuanPage(),
    TeachingCategory.mieZuiJuan   => const MieZuiJuanPage(),
    TeachingCategory.jiYuanDaoZhi => const JiYuanDaoZhiPage(),
    TeachingCategory.shiZhai      => const ShiZhaiPage(),
  };

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: const Color(0xFFF5F5F5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 橫向膠囊分類列 ──
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              children: TeachingCategory.values.map((cat) {
                final isActive = cat == _selected;
                return GestureDetector(
                  onTap: () => setState(() => _selected = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 7),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFFF6B503)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: isActive
                            ? const Color(0xFFF6B503)
                            : const Color(0xFFE0D5C8),
                        width: isActive ? 2 : 1.5,
                      ),
                    ),
                    child: Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isActive
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF5C4225),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 4),
          // ── 對應分類的頁面 ──
          Expanded(child: _currentPage),
        ],
      ),
    );
  }
}