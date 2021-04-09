import 'dart:ui';

import 'package:flutter/cupertino.dart';

class Utils {
  static double screenWidth = 0.0;
  static double screenHeight = 0.0;
  static double statusHeight = 0.0;
  static double bottomHeight = 0.0;
  static double showWidth = 0.0;


  //初始化应用参数
  void initAppUI(BuildContext context) {
    // TALUserCenterManager.talUserCenterInit();
    Utils.screenWidth = MediaQuery.of(context).size.width;
    Utils.screenHeight = MediaQuery.of(context).size.height;
    Utils.statusHeight = MediaQueryData.fromWindow(window).padding.top;
    Utils.showWidth = 1180;
  }

}
