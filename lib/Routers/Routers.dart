import 'package:note_flutter/widgets/ChangePasswordPage.dart';
import 'package:note_flutter/widgets/HomePage.dart';
import 'package:note_flutter/widgets/NoteEditPage.dart';
import 'package:note_flutter/widgets/NotePreviewPage.dart';
import 'package:note_flutter/widgets/loginPage.dart';
import 'package:note_flutter/widgets/signupPage.dart';

class Routers {
  static String root = "/"; //跟页面必须定义为这个样式
  static String editNote = "/editNote";
  static String previewNode = "/previewNode";
  static String login = "/login";
  static String signup = "/signup";
  static String changePassword = "/changePassword";
  static final routers = {
    //登录页面
    login: (context) => LoginPage(),
    signup: (context) => SignUpPage(),
    changePassword: (context) => ChangePasswordPage(),
    // 首页
    root: (context) => HomePage(
        ),
    // 编辑
    // editNote: (context) => NoteEditPage(),
    previewNode: (context) => NotePreviewPage(
          markdownData: '',
        ),
  };
}
