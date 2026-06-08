import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});
  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  static const _allVideos = [
    {'id': 'LJyHPuiF8UQ', 'title': '諦深大師 開示 2020年3月7日',  'subtitle': '密宗已经不是佛法了，解梦，遗传病，神通，不淫戒等等', 'image': 'https://img.youtube.com/vi/LJyHPuiF8UQ/0.jpg'},
    {'id': '_bkfCBKp258', 'title': '諦深大師 開示 2020年3月14日', 'subtitle': '时间就是空间，微尘国，算命，佛的三身',               'image': 'https://img.youtube.com/vi/_bkfCBKp258/0.jpg'},
    {'id': 'CK_iPAYYfgM', 'title': '諦深大師 開示 2020年3月21日', 'subtitle': '道教，念佛，打坐，参禅，不淫戒，恒顺众生，诽谤的果报', 'image': 'https://img.youtube.com/vi/CK_iPAYYfgM/0.jpg'},
    {'id': 'OsV884KPIew', 'title': '諦深大師 開示 2020年3月28日', 'subtitle': '密宗已经不是佛法了，解梦',                          'image': 'https://img.youtube.com/vi/OsV884KPIew/0.jpg'},
    {'id': 'iqXuRXKhMz4', 'title': '諦深大師 開示 2020年4月4日',  'subtitle': '密宗已经不是佛法了，解梦',                          'image': 'https://img.youtube.com/vi/iqXuRXKhMz4/0.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        itemCount: _allVideos.length,
        itemBuilder: (_, i) {
          final v = _allVideos[i];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.07), blurRadius: 10, spreadRadius: 1, offset: const Offset(0, 3))],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => VideoPlayPage(videoId: v['id']!, videoTitle: v['title']!),
              )),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(v['image']!, height: 180, width: double.infinity, fit: BoxFit.cover),
                    ListTile(
                      title: Text(v['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(v['subtitle']!),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── VideoPlayPage ─────────────────────────────────────────
class VideoPlayPage extends StatefulWidget {
  final String videoId, videoTitle;
  const VideoPlayPage({super.key, required this.videoId, required this.videoTitle});
  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  late final YoutubePlayerController _controller;
  double _volume = 100;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(showControls: false, showFullscreenButton: false, mute: false),
    );
  }

  @override
  void dispose() { _controller.close(); super.dispose(); }

  Future<void> _seekRelative(int seconds) async {
    try {
      final current = await _controller.currentTime;
      _controller.seekTo(seconds: (current + seconds).clamp(0.0, 9999.0), allowSeekAhead: true);
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.videoTitle)),
      body: Column(children: [
        YoutubePlayer(controller: _controller, aspectRatio: 16 / 9),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(icon: const Icon(Icons.replay_10, size: 36), onPressed: () => _seekRelative(-10)),
            const SizedBox(width: 20),
            ElevatedButton.icon(
              onPressed: () async => await _controller.pauseVideo(),
              icon: const Icon(Icons.pause), label: const Text('暫停'),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              onPressed: () async => await _controller.playVideo(),
              icon: const Icon(Icons.play_arrow), label: const Text('播放'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
            ),
            const SizedBox(width: 20),
            IconButton(icon: const Icon(Icons.forward_10, size: 36), onPressed: () => _seekRelative(10)),
          ],
        ),
        const SizedBox(height: 40),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(children: [
            const Icon(Icons.volume_up),
            const SizedBox(width: 10),
            const Text('音量'),
            Expanded(
              child: Slider(
                value: _volume, min: 0, max: 100, divisions: 10,
                label: '${_volume.round()}%',
                onChanged: (v) { setState(() => _volume = v); _controller.setVolume(v.round()); },
              ),
            ),
            Text('${_volume.round()}%'),
          ]),
        ),
      ]),
    );
  }
}