import 'teachings_list.dart';

export 'teachings_list.dart' show teachingsList;

class Teaching {
  final String title;
  final String subtitle;
  final String tag;
  final String subTag;
  final String date;
  final String content;

  const Teaching({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.subTag,
    required this.date,
    required this.content,
  });
}