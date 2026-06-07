import 'package:flutter/material.dart';
import 'package:suneru1/pages/data/teachings_data.dart';

class TeachingDetailPage extends StatelessWidget {
  final Teaching teaching;   // ← 整個物件傳進來

  const TeachingDetailPage({super.key, required this.teaching});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(teaching.subtitle),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 246, 181, 3),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 主標題
            Text(
              teaching.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),

            // 標籤列
            Row(
              children: [
                _DetailTagChip(label: teaching.tag),
                const SizedBox(width: 6),
                _DetailTagChip(label: teaching.subTag),
                const Spacer(),
                Text(
                  teaching.date,
                  style: const TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),

            // 內文
            Text(
              teaching.content,
              style: const TextStyle(
                fontSize: 18,
                height: 2.2,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailTagChip extends StatelessWidget {
  final String label;
  const _DetailTagChip({required this.label});

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