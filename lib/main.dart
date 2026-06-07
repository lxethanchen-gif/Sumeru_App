import 'package:flutter/material.dart';
import 'package:suneru1/pages/first_page.dart';
import 'package:suneru1/pages/second_page.dart';
import 'package:suneru1/pages/third_page.dart';
import 'package:suneru1/pages/fourth_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '須彌山佛國網',
      debugShowCheckedModeBanner: false, // 順便幫你關閉右上角的 Debug 標籤，讓畫面更乾淨
      theme: ThemeData(
        useMaterial3: true, // 啟用新版 Material 3 設計語彙
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 246, 181, 3),
        ),
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  final List<Widget> pages = [
    const FirstPage(),
    const SecondPage(),
    const ThirdPage(),
    const FourthPage(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color primaryGold = Color.fromARGB(255, 246, 181, 3);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '須彌山佛國網',
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.5),
        ),
        centerTitle: true,
        backgroundColor: primaryGold,
        foregroundColor: Colors.white,
        elevation: 2, // 給 AppBar 一點淡淡的陰影層次
        shadowColor: Colors.black26,
      ),
      body: pages[currentPage],
      
      // ✨ 精緻化底欄：加上 Container 與陰影裝飾
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),  // 頂部左圓角
            topRight: Radius.circular(20), // 頂部右圓角
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08), // 超輕薄的陰影
              blurRadius: 15,
              spreadRadius: 1,
              offset: const Offset(0, -2), // 讓陰影往上飄起，增加浮空卡片感
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: BottomNavigationBar(
            currentIndex: currentPage,
            onTap: (value) {
              setState(() {
                currentPage = value;
              });
            },
            // 💡 視覺核心優化設定
            type: BottomNavigationBarType.fixed, // 固定樣式，平分寬度
            backgroundColor: Colors.white,      // 純白底色襯托金色
            elevation: 0,                       // 關閉內建陰影（改用上方外層 Container 的精緻陰影）
            
            // 🏷️ 標籤文字樣式優化
            selectedItemColor: primaryGold,
            unselectedItemColor: Colors.grey.shade400, // 👈 改為高質感的輕灰色，讓目前的選中項目更突出
            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 11,
            ),
            
            // 🎭 縮放與動畫細節
            showUnselectedLabels: true, // 依然保留未選中文字，但尺寸較小，形成精緻的對比
            iconSize: 24,              // 標準適中圖示大小
            
            items: const [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.menu_book_rounded), // 換成更圓潤的現代圖示
                ),
                activeIcon: Icon(Icons.menu_book_rounded),
                label: '文字開示',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.article_rounded),
                ),
                activeIcon: Icon(Icons.article_rounded),
                label: '詩摘',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.video_library_rounded),
                ),
                activeIcon: Icon(Icons.video_library_rounded),
                label: '語音開示',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Icon(Icons.videocam_rounded), // 修正為錄影機圖示，更符合直播
                ),
                activeIcon: Icon(Icons.videocam_rounded),
                label: '直播',
              ),
            ],
          ),
        ),
      ),
    );
  }
}