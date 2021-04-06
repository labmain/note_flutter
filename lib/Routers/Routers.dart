import 'package:note_flutter/widgets/HomePage.dart';
import 'package:note_flutter/widgets/NoteEditPage.dart';

class Routers {
  static String root = "/"; //跟页面必须定义为这个样式
  static String editNote = "/editNote";
  static final routers = {
    // 首页
    root: (context) => HomePage(
          title: "标题",
        ),
    // 编辑
    editNote: (context) => NoteEditPage(),
  };
}
