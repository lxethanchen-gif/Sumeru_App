import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

// ==========================================
// 1. 主畫面：美化搜尋功能與影片卡片清單 (ThirdPage)
// ==========================================
class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final List<Map<String, String>> _allVideos = const [
    {
      'id': 'LJyHPuiF8UQ',
      'title': '諦深大師 開示 2020年3月7日',
      'subtitle': '密宗已经不是佛法了，解梦，遗传病，神通，不淫戒等等',
      'image': 'https://img.youtube.com/vi/LJyHPuiF8UQ/0.jpg'
    },
    {
      'id': 'LJyHPuiF8UQ',
      'title': '諦深大師 開示 2020年3月7日',
      'subtitle': '密宗已经不是佛法了，解梦',
      'image': 'https://img.youtube.com/vi/LJyHPuiF8UQ/0.jpg'
    },
    {
      'id': 'LJyHPuiF8UQ',
      'title': '諦深大師 開示 2020年3月7日',
      'subtitle': '密宗已经不是佛法了，解梦',
      'image': 'https://img.youtube.com/vi/LJyHPuiF8UQ/0.jpg'
    },
  ];

  List<Map<String, String>> _filteredVideos = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredVideos = _allVideos;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterVideos(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _filteredVideos = _allVideos;
      } else {
        _filteredVideos = _allVideos.where((video) {
          final titleMatch = video['title']!.toLowerCase().contains(keyword.toLowerCase());
          final subtitleMatch = video['subtitle']!.toLowerCase().contains(keyword.toLowerCase());
          return titleMatch || subtitleMatch;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // 定義與 App 一致的莊嚴金色
    const Color primaryGold = Color.fromARGB(255, 246, 181, 3);
    // ✨ 根據截圖精準調配的極淡暖米色/奶油色背景
    const Color searchBgColor = Color.fromARGB(255, 254, 247, 235);
    // 搭配暖色背景的深褐色字體，讓整體視覺更和諧精緻
    const Color textBrown = Color.fromARGB(255, 90, 70, 40);

    return Scaffold(
      body: Column(
        children: [
          // ✨ 完美還原截圖：精緻暖米色平面搜尋欄
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Container(
              // 拿掉了原本的 BoxShadow，使畫面呈現跟圖片一樣的平面純粹感
              decoration: const BoxDecoration(),
              child: TextField(
                controller: _searchController,
                onChanged: (value) => _filterVideos(value),
                style: const TextStyle(fontSize: 15, color: textBrown),
                cursorColor: primaryGold, // 輸入時的閃爍游標維持金色
                decoration: InputDecoration(
                  hintText: '搜尋開示關鍵字...',
                  hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
                  
                  // 圓潤典雅的金色放大鏡圖示
                  prefixIcon: const Icon(Icons.search_rounded, color: primaryGold, size: 22),
                  
                  // 清除按鈕
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.cancel_rounded, color: Colors.black26, size: 20),
                          onPressed: () {
                            _searchController.clear();
                            _filterVideos('');
                          },
                        )
                      : null,
                  
                  contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                  filled: true,
                  fillColor: searchBgColor, // 👈 換上與圖片相符的精緻暖米底色
                  
                  // 預設未點擊時的邊框（無邊線，完全靠背景色襯托膠囊感）
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  
                  // 點擊輸入時的邊框（同樣保持平滑無邊線，避免突兀的黑白框打碎暖色調）
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          // 🎬 影片列表區塊
          Expanded(
            child: _filteredVideos.isEmpty
                ? const Center(
                    child: Text(
                      '沒有找到符合關鍵字的開示影片',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    itemCount: _filteredVideos.length,
                    itemBuilder: (context, index) {
                      final video = _filteredVideos[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoPlayPage(
                                  videoId: video['id']!,
                                  videoTitle: video['title']!,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Image.network(
                                  video['image']!,
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              ListTile(
                                title: Text(video['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text(video['subtitle']!),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// 2. 終極相容播放畫面 (VideoPlayPage)
// ==========================================
class VideoPlayPage extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const VideoPlayPage({
    super.key,
    required this.videoId,
    required this.videoTitle,
  });

  @override
  State<VideoPlayPage> createState() => _VideoPlayPageState();
}

class _VideoPlayPageState extends State<VideoPlayPage> {
  late YoutubePlayerController _controller;
  double _currentVolume = 100;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: widget.videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: false,       
        showFullscreenButton: false, 
        mute: false,               
      ),
    );
  }

  @override
  void dispose() {
    _controller.close(); 
    super.dispose();
  }

  void _seekRelative(int seconds) async {
    try {
      final double currentSeconds = await _controller.currentTime;
      double targetSeconds = currentSeconds + seconds;
      if (targetSeconds < 0) targetSeconds = 0.0;
      
      _controller.seekTo(seconds: targetSeconds, allowSeekAhead: true);
    } catch (e) {
      final double currentSec = _controller.value.metaData.duration.inSeconds * 0.0;
      _controller.seekTo(seconds: (currentSec + seconds).clamp(0.0, 9999.0));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.videoTitle),
      ),
      body: Column(
        children: [
          YoutubePlayer(
            controller: _controller,
            aspectRatio: 16 / 9,
          ),
          const SizedBox(height: 30),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.replay_10, size: 36),
                onPressed: () => _seekRelative(-10), 
              ),
              const SizedBox(width: 20),
              ElevatedButton.icon(
                onPressed: () async => await _controller.pauseVideo(),
                icon: const Icon(Icons.pause),
                label: const Text('暫停'),
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () async => await _controller.playVideo(),
                icon: const Icon(Icons.play_arrow),
                label: const Text('播放'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.forward_10, size: 36),
                onPressed: () => _seekRelative(10), 
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(),
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                const Icon(Icons.volume_up),
                const SizedBox(width: 10),
                const Text('音量'),
                Expanded(
                  child: Slider(
                    value: _currentVolume,
                    min: 0,
                    max: 100,
                    divisions: 10,
                    label: '${_currentVolume.round()}%',
                    onChanged: (newValue) {
                      setState(() {
                        _currentVolume = newValue;
                      });
                      _controller.setVolume(_currentVolume.round());
                    },
                  ),
                ),
                Text('${_currentVolume.round()}%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}