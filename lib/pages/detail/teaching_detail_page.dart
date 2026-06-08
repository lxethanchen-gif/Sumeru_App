import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:suneru1/pages/data/teachings_data.dart';
import 'package:flutter/services.dart';

class TeachingDetailPage extends StatefulWidget {
  final Teaching teaching;
  const TeachingDetailPage({super.key, required this.teaching});

  @override
  State<TeachingDetailPage> createState() => _TeachingDetailPageState();
}

class _TeachingDetailPageState extends State<TeachingDetailPage> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      await _player.play(AssetSource('audio/${widget.teaching.audioFileName}'));
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  void _copyToClipboard() {
    final String contentToCopy =
        '''
    【${widget.teaching.subtitle}】
    標題：${widget.teaching.title}
    類別：${widget.teaching.tag} / ${widget.teaching.subTag}
    日期：${widget.teaching.date}

    內容：
    ${widget.teaching.content}
      ''';

    Clipboard.setData(ClipboardData(text: contentToCopy)).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已複製開示內容至剪貼簿'),
          duration: Duration(seconds: 2),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F2), // 溫潤紙質底色
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        title: const Text(
          "開示內容",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- 1. 標題與播放器 ---
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.teaching.subtitle,
                          style: const TextStyle(
                            color: Color(0xFF8D6E63),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.teaching.title,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF263238),
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                      size: 50,
                    ),
                    color: const Color(0xFFD4A017),
                    onPressed: _togglePlay,
                  ),
                  IconButton(
                    icon: const Icon(Icons.copy, size: 30),
                    color: const Color(0xFFD4A017),
                    onPressed: _copyToClipboard,
                    tooltip: '複製全文',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // --- 2. 標籤與日期列 ---
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _buildTagChip(widget.teaching.tag, const Color(0xFFD4A017)),
                  _buildTagChip(
                    widget.teaching.subTag,
                    const Color(0xFF8D6E63),
                  ),
                  _buildDateChip(widget.teaching.date),
                ],
              ),

              const SizedBox(height: 32),

              // --- 3. 裝飾線 (放在內容上方) ---
              Container(
                width: 360, // 線條長度
                height: 2,
                color: const Color(0xFFD4A017),
              ),
              const SizedBox(height: 20),

              // --- 4. 主要內容區域 ---
              Text(
                widget.teaching.content,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 2.0,
                  letterSpacing: 1.0,
                  color: Color(0xFF37474F),
                ),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // 輔助 Widget：標籤美化
  Widget _buildTagChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1), // 淡底色
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // 輔助 Widget：日期美化
  Widget _buildDateChip(String date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        date,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
        ),
      ),
    );
  }
}
