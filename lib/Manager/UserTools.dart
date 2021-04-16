import 'package:note_flutter/Model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTools {
  User currentUser = User();

  /// 是否已经登录
  bool isLogin() {
    return currentUser.token == null || currentUser.token!.isEmpty;
  }

  /// 登录成功之后，
  Future<bool> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final setTokenResult = await prefs.setString('user_token', user.token ?? "");
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_id', user.id);
    if (setTokenResult) {
      print('保存登录token成功');
      // Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => route == null,);
      return true;
    } else {
      print('error, 保存登录token失败');
      return false;
    }
  }

  clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_token");
    prefs.remove("user_name");
    prefs.remove("user_name");
    UserTools.instance.currentUser = User();
  }

  /// 获取
  Future<User> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    var user = User();
    user.token = prefs.getString("user_token");
    user.name = prefs.getString("user_name") ?? "临时用户";
    user.id = prefs.getString("user_id") ?? "0";
    return user;
  }

  bool checkUserIsLogin() {
    var userToken = "";
    if (userToken.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  // 单例
  static final UserTools instance = UserTools._internal();

  factory UserTools() {
    return instance;
  }

  UserTools._internal();
}
