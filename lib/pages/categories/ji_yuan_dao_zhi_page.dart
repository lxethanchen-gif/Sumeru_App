import 'package:flutter/material.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/pages/detail/teaching_detail_page.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/translation_service.dart';
import 'package:suneru1/pages/widgets/teaching_card.dart';

class JiYuanDaoZhiPage extends StatelessWidget {
  const JiYuanDaoZhiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = teachingsList.where((t) => t.tag == '機緣道旨').toList();
    return list.isEmpty
        ? const Center(child: Text('機緣道旨'))
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TeachingCard(item: list[i]),
            ),
          );
  }
}