import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:note_flutter/Manager/UserTools.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'package:note_flutter/Net/net_model.dart';
import 'package:note_flutter/Routers/Routers.dart';
import 'package:note_flutter/widgets/ChangePasswordPage.dart';
import 'package:note_flutter/widgets/NoteEditPage.dart';
import 'package:note_flutter/widgets/NoteListPage.dart';

const String _markdownData = """
# Markdown Example
Markdown allows you to easily include formatted text, images, and even formatted
Dart code in your app.
## Titles
Setext-style
```
This is an H1
=============
This is an H2
-------------
```
Atx-style
```
# This is an H1
## This is an H2
###### This is an H6
```
Select the valid headers:
- [x] `# hello`
- [ ] `#hello`
## Links
[Google's Homepage][Google]
```
[inline-style](https://www.google.com)
[reference-style][Google]
```
## Images
![Flutter logo](/dart-lang/site-shared/master/src/_assets/image/flutter/icon/64.png)
## Tables
|Syntax                                 |Result                               |
|---------------------------------------|-------------------------------------|
|`*italic 1*`                           |*italic 1*                           |
|`_italic 2_`                           | _italic 2_                          |
|`**bold 1**`                           |**bold 1**                           |
|`__bold 2__`                           |__bold 2__                           |
|`This is a ~~strikethrough~~`          |This is a ~~strikethrough~~          |
|`***italic bold 1***`                  |***italic bold 1***                  |
|`___italic bold 2___`                  |___italic bold 2___                  |
|`***~~italic bold strikethrough 1~~***`|***~~italic bold strikethrough 1~~***|
|`~~***italic bold strikethrough 2***~~`|~~***italic bold strikethrough 2***~~|
## Styling
Style text as _italic_, __bold__, ~~strikethrough~~, or `inline code`.
- Use bulleted lists
- To better clarify
- Your points
## Code blocks
Formatted Dart code looks really pretty too:
```
void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Markdown(data: markdownData),
    ),
  ));
}
```
## Center Title
###### ※ ※ ※
_* How to implement it see main.dart#L129 in example._
## Custom Syntax
NaOH + Al_2O_3 = NaAlO_2 + H_2O
C_4H_10 = C_2H_6 + C_2H_4
## Markdown widget
This is an example of how to create your own Markdown widget:
    Markdown(data: 'Hello _world_!');
Enjoy!
[Google]: https://www.google.com/
## Line Breaks
This is an example of how to create line breaks (tab or two whitespaces):
line 1
  
   
line 2
  
  
  
line 3
""";

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<NotebookModel> notebookList = [];
  List<NoteModel> notes = [];

  /// 当前选中的笔记本
  var notebookCurrentSelectIndex = 0;
  /// 当前选中功能的笔记
  var noteCurrentSelectIndex = 0;
  final TextEditingController _controller = new TextEditingController();
  var isShowPreview = false;

  /// 输入框，动态更改提示文案
  ValueNotifier<String> _valueListenable = ValueNotifier<String>("");

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
                Expanded(child: _listWidget(), flex: 1),
                Expanded(
                    child: NoteList(notes: notes,),
                    flex: 1),
                Expanded(
                  flex: 3,
                  child: _editWidget(),
                ),
              ]
            : [_listWidget()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNotebookAction,
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

  void _getNoteList() async {
    var currentNotebook = notebookList[notebookCurrentSelectIndex];
    if (currentNotebook.id.isEmpty) {
      return;
    }
    try {
      // 获取笔记列表
      notes =
      await SystemNetUtils.getAllNoteList(currentNotebook.id);
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
      _getNoteList();
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
    _getNotebookList();
    _getNoteList();
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

  _listWidget() {
    return ListView(
      restorationId: 'list_demo_list_view',
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (int index = 0; index < notebookList.length; index++)
          ListTile(
            leading: ExcludeSemantics(
              child: Icon(Icons.menu_book_sharp),
            ),
            title: Text(notebookList[index].name),
            subtitle: Text("subtitle"),
            onTap: () {
              setState(() {
                notebookCurrentSelectIndex = index;
              });
            },
            selected: notebookCurrentSelectIndex == index,
          ),
      ],
    );
  }

  _notelistWidget() {
    return ;
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

  Widget _editWidget() {
    if (isShowPreview) {
      return Markdown(
        // controller: controller,
        selectable: true,
        data: _markdownData,
        imageDirectory: 'https://raw.githubusercontent.com',
      );
    } else {
      return NoteEditWidget(content: _markdownData);
    }
  }

  /// 添加新的笔记
  _addNoteAction() {
    // String? bookID = notebookList[notebookCurrentSelectIndex].id;
  }

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
                    valueListenable: _valueListenable, builder: (BuildContext context, String value, Widget? child) {
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
        ), IconButton(
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
          onPressed: () {},
        )
      ];
    } else {
      return [
        IconButton(icon: Icon(Icons.add_box), onPressed: _addNotebookAction)
      ];
    }
  }
}

class NoteList extends StatefulWidget {
  List<NoteModel> notes = [];
  NoteList({required this.notes});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  int noteCurrentSelectIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: ListView(
        restorationId: 'list_note_list_view',
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int index = 0; index < widget.notes.length; index++)
            ListTile(
              leading: ExcludeSemantics(
                child: Icon(Icons.menu_book_sharp),
              ),
              title: Text(widget.notes[index].title),
              subtitle: Text("subtitle"),
              onTap: () {
                setState(() {
                  noteCurrentSelectIndex = index;
                });
              },
              selected: noteCurrentSelectIndex == index,
            ),
        ],
      ),
    );
  }
}

