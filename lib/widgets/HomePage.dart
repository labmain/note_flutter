import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:note_flutter/Manager/UserTools.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'package:note_flutter/Net/net_model.dart';
import 'package:note_flutter/Net/net_utils.dart';
import 'package:note_flutter/Routers/Routers.dart';
import 'package:note_flutter/widgets/ChangePasswordPage.dart';
import 'package:note_flutter/widgets/NoteEditPage.dart';
import 'package:note_flutter/widgets/NoteListPage.dart';
import 'package:note_flutter/widgets/notebook_list_widget.dart';

import 'note_list_widget.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NotebookModel> notebookList = [];
  List<NoteModel> notes = [];

  /// 当前选中的笔记本
  var notebookCurrentSelectIndex = 0;

  set notebook_current_select_index(int index) {
    setState(() {
      notebookCurrentSelectIndex = index;
    });
    // 获取笔记列表
    _getNoteList();
  }

  int noteCurrentSelectIndex = 0;

  /// 当前选中的笔记
  set note_current_select_index(int index) {
    setState(() {
      noteCurrentSelectIndex = index;
    });

    if (index + 1 <= notes.length) {
      var note = notes[index];
      _noteEditController.text = note.content ?? "";
      // markdownDataStreamController.sink.add(note.content ?? "");
    } else {
      // markdownDataStreamController.sink.add("");
      _noteEditController.text = "";
    }
  }

  final TextEditingController _controller = new TextEditingController();

  /// 笔记编辑
  final TextEditingController _noteEditController = new TextEditingController();
  var isShowPreview = false;

  /// 输入框，动态更改提示文案
  ValueNotifier<String> _valueListenable = ValueNotifier<String>("");

  /// 笔记内容
  var markdownDataStreamController = StreamController<String>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("笔记"),
        actions: _actions(),
      ),
      drawer: _drawer(),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround, // 平分
        crossAxisAlignment: CrossAxisAlignment.start,
        children: MediaQuery.of(context).size.width > 800
            ? [
                Expanded(
                    child: NotebookList(
                        notebookList: notebookList,
                        selectIndex: notebookCurrentSelectIndex,
                        selectAction: (index) {
                          notebook_current_select_index = index;
                        }),
                    flex: 1),
                Expanded(
                    child: NoteList(
                        notes: notes,
                        selectIndex: noteCurrentSelectIndex,
                        selectAction: (index) {
                          note_current_select_index = index;
                        }),
                    flex: 1),
                Expanded(
                  flex: 3,
                  child: isShowPreview
                      ? Markdown(
                          // controller: controller,
                          selectable: true,
                          data: _noteEditController.text,
                          imageDirectory: 'https://raw.githubusercontent.com',
                        )
                      : NoteEditWidget(controller: _noteEditController),
                ),
              ]
            : [
                NotebookList(
                  notebookList: notebookList,
                )
              ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteAction,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _incrementCounter() {
    // Navigator.of(context).pushNamed(Routers.editNote);
    // getNotebookList();
  }

  void _listOnTap() {}

  void _getData() async {
    notebookList = await SystemNetUtils.requestNodeBookList();
    if (notebookList.length > 0) {
      var currentNotebook = notebookList[notebookCurrentSelectIndex];
      notes = await SystemNetUtils.getAllNoteList(currentNotebook.id);
    }
    // 刷新ui
    setState(() {});
  }

  void _getNoteList() async {
    if (notebookList.length > 0) {
      var currentNotebook = notebookList[notebookCurrentSelectIndex];
      notes = await SystemNetUtils.getAllNoteList(currentNotebook.id);
      if (notes.length > 0) {
        note_current_select_index = 0;
      }
      // 刷新ui
      setState(() {});
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
      _getData();
      // 清空
      _controller.text = "";
      Navigator.of(context).pop(true);
    } else {
      _valueListenable.value = "创建失败，请稍收再试！";
    }
  }

  void checkUserState() async {
    // var user = await UserTools.instance.getUser();
    // if (user.token == null) {
    //   SchedulerBinding.instance.addPostFrameCallback((_) {
    //     Navigator.of(context).pushNamed(Routers.login);
    //   });
    // } else {
    _getData();
    // }
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
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(Routers.login);
    });
  }

  /// 修改
  void _changePassword() {
    UserTools.instance.clearUser();
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(Routers.changePassword);
    });
  }

  _notelistWidget() {
    return;
  }

  _drawer() {
    return Drawer(
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
            leading: Icon(Icons.people),
            title: Text("修改密码"),
            onTap: _changePassword,
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('退出登录'),
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  /// 添加新的笔记
  _addNoteAction() {
    if (notebookList.length > 0) {
      var currentNotebook = notebookList[notebookCurrentSelectIndex];
      var note = NoteModel.createNote(currentNotebook.id);
      notes.add(note);
      note_current_select_index = notes.length - 1;
      setState(() {});
    }
  }

  _saveNote() async {
    var note = notes[noteCurrentSelectIndex];
    note.content = _noteEditController.text;
    if (_noteEditController.text.length <= 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("没有内容！")));
      return;
    }
    var isOK = await SystemNetUtils.saveNote(note);
    if (isOK) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("保存成功！")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("保存失败！")));
    }
    setState(() {});
  }

  /// 添加新的笔记本
  _addNotebookAction() {
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
                  builder: (BuildContext context, String value, Widget? child) {
                    return Text(
                      value,
                      style: TextStyle(color: Colors.red, fontSize: 13),
                    );
                  },
                )
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
  }

  _actions() {
    var isBig = MediaQuery.of(context).size.width > 800;
    if (isBig) {
      return [
        IconButton(
          icon: Icon(Icons.refresh),
          onPressed: () {
            checkUserState();
          },
        ),
        IconButton(
          icon: Icon(Icons.preview),
          onPressed: () {
            isShowPreview = !isShowPreview;
            setState(() {});
          },
        ),
        IconButton(
          icon: Icon(Icons.delete),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("警告"),
                    content: Text("确认删除改笔记吗？"),
                    actions: <Widget>[
                      TextButton(
                        child: Text("确定"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("取消"),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                    ],
                  );
                });
          },
        ),
        IconButton(
          icon: Icon(Icons.save),
          onPressed: _saveNote,
        )
      ];
    } else {
      return [
        IconButton(icon: Icon(Icons.add_box), onPressed: _addNotebookAction)
      ];
    }
  }
}
