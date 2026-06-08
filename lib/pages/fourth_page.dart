import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class FourthPage extends StatefulWidget {
  const FourthPage({super.key});

  @override
  State<FourthPage> createState() => _FourthPageState();
}

class _FourthPageState extends State<FourthPage> {
  late YoutubePlayerController _controller;
  bool _isPlaying = true;
  double _volume = 100.0; 

  @override
  void initState() {
    super.initState();
    const String liveVideoId = 'SrVV_lrHSHI';

    _controller = YoutubePlayerController.fromVideoId(
      videoId: liveVideoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: false,       
        showFullscreenButton: true,
        mute: false,
      ),
    );
  }

  @override
  void deactivate() {
    _controller.pauseVideo();
    if (_isPlaying) {
      setState(() {
        _isPlaying = false;
      });
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _controller.pauseVideo();
    } else {
      await _controller.playVideo();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _rewind10Seconds() async {
    final double currentPosition = await _controller.currentTime;
    double targetPosition = currentPosition - 10;
    if (targetPosition < 0) targetPosition = 0;
    _controller.seekTo(seconds: targetPosition);
  }

  void _fastForward10Seconds() async {
    final double currentPosition = await _controller.currentTime;
    _controller.seekTo(seconds: currentPosition + 10);
  }

  @override
  Widget build(BuildContext context) {
    // 尊榮橘金色
    const Color primaryGold = Color.fromARGB(255, 246, 181, 3);
    final Color panelBackground = const Color(0xff1e1e1e).withValues(alpha: 0.75);

    return Scaffold(
      backgroundColor: const Color(0xff0d0d0d), 
      extendBodyBehindAppBar: true, 
      appBar: AppBar(
        backgroundColor: Colors.transparent, 
        foregroundColor: primaryGold,
        elevation: 0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // 🎬 YouTube 直播播放器區塊
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: YoutubePlayer(
                controller: _controller,
                aspectRatio: 16 / 9,
              ),
            ),
          
          // 📏 控制播放欄位距離影片位置約 5 公分
          const SizedBox(height: 10), 

          // 🎛️ 扁平化極簡懸浮控制面板
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), 
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    color: panelBackground,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: primaryGold.withValues(alpha: 0.12), 
                      width: 1,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 1️⃣ 上層：三鍵大小與顏色完全一致的控制列
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ⏪ 倒轉按鈕（外觀與播放鍵完全一致）
                            GestureDetector(
                              onTap: _rewind10Seconds,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryGold,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.replay_10_rounded,
                                  size: 22,
                                  color: Color(0xff0d0d0d),
                                ),
                              ),
                            ),
                            
                            const SizedBox(width: 24), // 緊湊對稱間距

                            // ⏸️/▶️ 中央播放/暫停按鈕
                            GestureDetector(
                              onTap: _togglePlayPause,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryGold,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: Icon(
                                  _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                                  size: 24,
                                  color: const Color(0xff0d0d0d),
                                ),
                              ),
                            ),

                            const SizedBox(width: 20), // 緊湊對稱間距

                            // ⏩ 快轉按鈕（外觀與播放鍵完全一致）
                            GestureDetector(
                              onTap: _fastForward10Seconds,
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: primaryGold,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: primaryGold.withValues(alpha: 0.2),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: const Icon(
                                  Icons.forward_10_rounded,
                                  size: 22,
                                  color: Color(0xff0d0d0d),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12), 

                      // 2️⃣ 下層：純粹的音量滑桿（頭尾精準切齊倒轉與快轉鍵）
                      Padding(
                        padding: EdgeInsets.zero,
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: primaryGold,
                            inactiveTrackColor: Colors.white.withValues(alpha: 0.1),
                            thumbColor: Colors.white, 
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 5.0, 
                            ),
                            overlayColor: primaryGold.withValues(alpha: 0.15),
                            overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
                            trackHeight: 2.5, 
                            trackShape: const RectangularSliderTrackShape(), 
                          ),
                          child: Slider(
                            value: _volume,
                            min: 0.0,
                            max: 100.0,
                            onChanged: (newValue) {
                              setState(() {
                                _volume = newValue;
                              });
                              _controller.setVolume(newValue.round());
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}