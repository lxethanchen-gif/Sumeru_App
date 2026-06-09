import 'package:flutter/material.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:suneru1/pages/detail/teaching_detail_page.dart';
import 'package:suneru1/translation/translation_provider.dart';
import 'package:suneru1/translation/translation_service.dart';
import 'package:suneru1/pages/widgets/teaching_card.dart';

class ShiZhaiPage extends StatelessWidget {
  const ShiZhaiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final list = teachingsList.where((t) => t.tag == '詩摘').toList();
    return list.isEmpty
        ? const Center(child: Text('詩摘'))
        : ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, i) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: TeachingCard(item: list[i]),
            ),
          );
  }
}