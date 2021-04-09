import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_flutter/resources/image_resource.dart';
import 'package:note_flutter/utils/ui_utils.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  static final GlobalKey<ScaffoldState> _scaffoldKey =
      GlobalKey<ScaffoldState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _correctPhone = true;
  bool _correctPassword = true;

  bool showProgress = false;

  void _checkInput() {
    if (_phoneController.text.isNotEmpty) {
      _correctPhone = true;
    } else {
      _correctPhone = false;
    }
    if (_passwordController.text.isNotEmpty) {
      _correctPassword = true;
    } else {
      _correctPassword = false;
    }
    setState(() {});
  }

  //跳转登录
  _onTabGoToLogin() {
    _checkInput();
    if (!_correctPassword || !_correctPhone) {
      return;
    }
  }

  // 注册
  _onTabGoToRegister() {
    print("注册拉！");
  }

  //跳转试用入口
  _onTabGoToTrial() {
    debugPrint("跳转试用入口");
  }

  //跳转试用入口
  _onTabGoToIntroduce() {
    debugPrint("跳转购买咨询");
  }

  @override
  Widget build(BuildContext context) {
    Utils().initAppUI(context);
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.deepPurple[100],
        body: Stack(children: <Widget>[
          ///顶部插图
          Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                ImageName.login.png("login_colour_top_l"),
                width: 224 * 0.5,
                height: 314 * 0.5,
              )),

          ///顶部插图
          Align(
            alignment: Alignment.topRight,
            child: Image.asset(
              ImageName.login.png("login_colour_top_r"),
              width: 179 * 0.5,
              height: 101 * 0.5,
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.only(left: 80),
              child: Image.asset(
                ImageName.login.png("login_colour_bottom_l"),
                width: 286 * 0.5,
                height: 157 * 0.5,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Image.asset(
              ImageName.login.png("login_colour_bottom_r"),
              width: 710 * 0.5,
              height: 395 * 0.5,
            ),
          ),
          GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
          ),
          ListView(
            children: [
              SafeArea(
                  child:

                      ///顶部插图
                      _buildLogInWidgets(context))
            ],
          ),
        ]));
  }

  _buildLogInWidgets(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, //垂直方向对其方式
      crossAxisAlignment: CrossAxisAlignment.start, //水平方向对其方式
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Text(
              "云笔记",
              style: TextStyle(fontSize: 48),
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
        Center(
          child: Container(
            width: Utils.screenWidth * 0.8,
            height:
                Utils.screenHeight < 800 ? 800 * 0.7 : Utils.screenHeight * 0.7,
            // padding: const EdgeInsets.all(50),
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 2.0,
                  ),
                ]),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround, // 平分
              crossAxisAlignment: CrossAxisAlignment.start,
              children: MediaQuery.of(context).size.width > 800
                  ? [
                      getLoginInputWidget(),
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: Colors.blue,
                          padding: EdgeInsets.all(5.0),
                          child: Center(child: Icon(Icons.message)),
                        ),
                      ),
                    ]
                  : [getLoginInputWidget()],
            ),
          ),
        ),
        Padding(padding: EdgeInsets.only(top: 20)),
      ],
    );
  }

  /// 登录输入框
  Widget getLoginInputWidget() {
    // Color mainColor = ColorResource.COLOR_FFEEEEEE;
    // Color hitColor = ColorResource.COLOR_FFCCCCCC;

    var bloskSize = MediaQuery.of(context).size.width / 100;
    bool _checkboxSelected = true;
    return Expanded(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(
                    left: 32,
                    bottom: Utils.screenHeight < 800
                        ? 800 * 0.02
                        : Utils.screenHeight * 0.02),
                child: Text(
                  'Welcom!',
                  style: TextStyle(color: Color(0xff222222), fontSize: 26),
                ),
              ),
            ),
            Container(
              // 用户名
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                // cursorColor: mainColor,
                controller: _phoneController,
                keyboardType: TextInputType.text,
                // scrollPadding: EdgeInsets.all(20.0),
                decoration: InputDecoration(
                  hintText: '请输入账户',
                  hintStyle: TextStyle(color: Color(0xffcccccc)),
                  // contentPadding: EdgeInsets.only(left: 50.0),
                  errorText: _correctPhone ? null : '用户名不可为空！',
                  errorStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12.0),
                    child: Icon(Icons.supervised_user_circle),
                  ),
                  // focusedBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: mainColor)),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: mainColor)),
                  // errorBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: mainColor)),
                ),
                onSubmitted: (value) {
                  _checkInput();
                },
              ),
            ),
            Container(
              // 密码输入框
              padding: const EdgeInsets.all(32.0),
              child: TextField(
                style: TextStyle(color: Colors.black),
                // cursorColor: mainColor,
                controller: _passwordController,
                obscureText: true,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  // contentPadding: EdgeInsets.only(bottom: 20),
                  suffixIcon: IconButton(
                    icon:
                        Image.asset(ImageName.login.png("login_icon_psd_show")),
                  ),
                  hintText: '请输入密码',
                  // hintStyle: TextStyle(color: hitColor),
                  errorText: _correctPassword ? null : '密码不可为空！',
                  errorStyle: TextStyle(color: Colors.teal),
                  prefixIcon: Padding(
                    padding: const EdgeInsetsDirectional.only(end: 12.0),
                    child: Icon(Icons.lock),
                  ),
                  // focusedBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: mainColor)),
                  // enabledBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: mainColor)),
                  // errorBorder: UnderlineInputBorder(
                  //     borderSide: BorderSide(color: mainColor)),
                ),
                onSubmitted: (value) {
                  _checkInput();
                },
              ),
            ),
            Row(
              children: [
                Padding(padding: EdgeInsets.only(top: 20, left: 32)),
                Checkbox(
                  value: _checkboxSelected,
                  activeColor: Colors.red, //选中时的颜色
                  onChanged: (value) {
                    setState(() {
                      _checkboxSelected = value;
                    });
                  },
                ),
                Text("记住密码"),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                // 登录按钮
                padding: const EdgeInsets.all(32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, //垂直方向对其方式
                  crossAxisAlignment: CrossAxisAlignment.center, //水平方向对其方式
                  children: [
                    Expanded(
                        flex: 1,
                        child: Material(
                          child: TextButton(
                            child: Container(
                                margin: const EdgeInsets.all(12.0),
                                child: Text(
                                  "登录",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                            onPressed: _onTabGoToLogin,
                          ),
                          color: Color(0xFF3A63FB),
                          borderRadius: BorderRadius.circular(20.0),
                          elevation: 5.0,
                        )),
                    Padding(padding: EdgeInsets.only(left: 32)),
                    Expanded(
                        flex: 1,
                        child: Material(
                          child: TextButton(
                            child: Container(
                                margin: const EdgeInsets.all(12.0),
                                child: Text(
                                  "注册",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                            onPressed: _onTabGoToRegister,
                          ),
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20.0),
                          elevation: 5.0,
                        ))
                  ],
                ),
              ),
            ),
          ]),
      flex: 1,
    );
  }

  ///Build: 图片插图控件
  Widget getLoginImageWidget(String imgName, double size) {
    return Container(
      width: size,
      height: size,
      child: Image.asset(ImageName.login.png(imgName)),
    );
  }
}
