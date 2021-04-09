/// 图片资源
class ImageName {
  /// 获取本地图片
  /// name：图片名
  String png(String name) {
    return module + name + ".png";
  }

  String jpeg(String name) {
    return module + name + ".jpeg";
  }

  String gif(String name) {
    return module + name + ".gif";
  }

  /// 根路径下
  static String get _homePath => "resources/";

  /// 通用
  static ImageName get common => ImageName(_homePath + "common/");

  /// 主要的
  static ImageName get main => ImageName(_homePath + "main/");

  /// 登录
  static ImageName get login => ImageName(_homePath + "login/");

  /// 背景
  static ImageName get background => ImageName(_homePath + "background/");

  ///gif
  static ImageName get gifResourse => ImageName(_homePath + "gif/");


  final String module;
  ImageName(this.module);
}
