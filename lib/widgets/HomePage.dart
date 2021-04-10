import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:note_flutter/Manager/UserTools.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'package:note_flutter/Net/net_model.dart';
import 'package:note_flutter/Routers/Routers.dart';
import 'package:note_flutter/widgets/NoteListPage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NotebookModel> notebookList = [];
  final TextEditingController _controller = new TextEditingController();

  /// 输入框，动态更改提示文案
  ValueNotifier<String> _valueListenable = ValueNotifier<String>("");
  void _incrementCounter() {
    // Navigator.of(context).pushNamed(Routers.editNote);
    // getNotebookList();
  }

  void _listOnTap() {}
  void _getNotebookList() async {
    try {
      // 获取笔记本列表
      notebookList = await SystemNetUtils.requestNodeBookList();
      // 刷新ui
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  void _addNewNotebook(String notebookName) async {
    if (_controller.text.isEmpty) {
      _valueListenable.value = "请输入内容";
      return;
    }
    var isHas = await SystemNetUtils.checkNotebookName(notebookName);
    if (isHas) {
      _valueListenable.value = "已经有相同的名字，请重新输入";
      return;
    }
    var notebook = NotebookModel.createNote(notebookName);
    var isOK = await SystemNetUtils.createNotebook(notebook);
    if (isOK) {
      _getNotebookList();
      // 清空
      _controller.text = "";
      Navigator.of(context).pop(true);
    } else {
      _valueListenable.value = "创建失败，请稍收再试！";
    }
  }

  void checkUserState() async {
    var user = await UserTools.instance.getUser();
    if (user.token == null) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushNamed(Routers.login);
      });
    } else {
      _getNotebookList();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUserState();
    _controller.addListener(() {
      _valueListenable.value = "";
    });
  }

  /// 退出登录
  void _logout() {
    UserTools.instance.clearUser();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(Routers.login);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("笔记本列表"),
        actions: [
          IconButton(
              icon: Icon(Icons.add_box),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("添加新的笔记本"),
                        content: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: _controller,
                            ),
                            Padding(padding: EdgeInsets.only(top: 8)),
                            ValueListenableBuilder(
                                valueListenable: _valueListenable,
                                builder: (BuildContext context, String value,
                                    Widget child) {
                                  return Text(
                                    value,
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 13),
                                  );
                                })
                          ],
                        ),
                        actions: <Widget>[
                          TextButton(
                            child: Text("取消"),
                            onPressed: () {
                              _controller.text = "";
                              _valueListenable.value = "";
                              Navigator.of(context).pop(true);
                            },
                          ),
                          TextButton(
                            child: Text("保存"),
                            onPressed: () {
                              _addNewNotebook(_controller.text);
                              _valueListenable.value = "";
                            },
                          ),
                        ],
                      );
                    });
              })
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                '用户信息',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.restore_from_trash_rounded),
              title: Text('回收站'),
            ),
            ListTile(
              leading: Icon(Icons.people),
              title: Text(UserTools.instance.currentUser.name),
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('退出登录'),
              onTap: _logout,
            ),
          ],
        ),
      ),
      body: ListView(
        restorationId: 'list_demo_list_view',
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int index = 0; index < notebookList.length; index++)
            ListTile(
              leading: ExcludeSemantics(
                child: CircleAvatar(child: Text("$index")),
              ),
              title: Text(notebookList[index].name),
              subtitle: Text("subtitle"),
              onTap: () {
                var id = notebookList[index].id;
                Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                  return NoteListPage(
                    notebook: notebookList[index],
                    title: "笔记列表",
                  );
                }));
              },
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNotebookList,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
