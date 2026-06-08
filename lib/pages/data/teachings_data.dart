class Teaching {
  final String title;
  final String subtitle;
  final String tag;
  final String subTag;
  final String date;
  final String content;
  final String audioFileName; // 必須要有的欄位

  const Teaching({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.subTag,
    required this.date,
    required this.content,
    required this.audioFileName, // 這裡必須補上
  });
}

const List<Teaching> teachingsList = [
  Teaching(
    title: '修行不是條條大路通羅馬',
    subtitle: '諦深大師開示',
    tag: '應世卷',
    subTag: '破障',
    date: '2018/10/24',
    // 使用 ''' 包含長文本，可以保留換行與排版
    content: '''第一段開示內容...    
    這裡是第二段內容，您可以輸入長篇的文字。
    修行並非一蹴可幾，需要長期不斷的精進。''',
    audioFileName: 'lesson1.mp3',
  ),
  Teaching(
    title: '修行的真正意義',
    subtitle: '諦深大師開示',
    tag: '應世卷',
    subTag: '破障',
    date: '2018/11/15',
    content: '''修行的真正意義在於內心的轉化和覺悟。    
    透過修行，我們能夠超越自我，達到真正的自由與平靜。''',
    audioFileName: 'lesson2.mp3',
  ),
  Teaching(
    title: '修行不是條條大路通羅馬',
    subtitle: '諦深大師開示',
    tag: '應世卷',
    subTag: '破障',
    date: '2018/10/24',
    // 使用 ''' 包含長文本，可以保留換行與排版
    content: '''第一段開示內容...    
    這裡是第二段內容，您可以輸入長篇的文字。
    修行並非一蹴可幾，需要長期不斷的精進。''',
    audioFileName: 'lesson1.mp3',
  ),
  Teaching(
    title: '修行的真正意義',
    subtitle: '諦深大師開示',
    tag: '應世卷',
    subTag: '破障',
    date: '2018/11/15',
    content: '''修行的真正意義在於內心的轉化和覺悟。    
    透過修行，我們能夠超越自我，達到真正的自由與平靜。''',
    audioFileName: 'lesson2.mp3',
  ),
  Teaching(
    title: '修行不是條條大路通羅馬',
    subtitle: '諦深大師開示',
    tag: '應世卷',
    subTag: '破障',
    date: '2018/10/24',
    // 使用 ''' 包含長文本，可以保留換行與排版
    content: '''第一段開示內容...    
    這裡是第二段內容，您可以輸入長篇的文字。
    修行並非一蹴可幾，需要長期不斷的精進。''',
    audioFileName: 'lesson1.mp3',
  ),
  Teaching(
    title: '修行的真正意義',
    subtitle: '諦深大師開示',
    tag: '應世卷',
    subTag: '破障',
    date: '2018/11/15',
    content: '''修行的真正意義在於內心的轉化和覺悟。    
    透過修行，我們能夠超越自我，達到真正的自由與平靜。''',
    audioFileName: 'lesson2.mp3',
  ),
];
