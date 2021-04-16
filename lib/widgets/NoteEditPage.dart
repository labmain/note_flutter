import 'package:flutter/material.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'package:note_flutter/Net/net_model.dart';
import 'NotePreviewPage.dart';

/// Opens an [AlertDialog] showing what the user typed.
class NoteEditPage extends StatefulWidget {
  NotebookModel notebookModel;
  NoteModel noteModel;
  NoteEditPage(this.notebookModel, this.noteModel, {Key? key}) : super(key:
  key);

  @override
  _NoteEditPageState createState() => new _NoteEditPageState();
}

/// State for [NoteEditPage] widgets.
class _NoteEditPageState extends State<NoteEditPage> {
  final TextEditingController _controller = new TextEditingController();

  /// 是否有保存，删除的操作
  bool isChange = false;
  // 保存
  void _saveContent() async {
    if (_controller.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("请在输入一些内容！")));
      return;
    }
    if (widget.noteModel.content == _controller.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("没有更改内容！")));
      return;
    }
    widget.noteModel.content = _controller.text;
    var isOK = await SystemNetUtils.saveNote(widget.noteModel);
    if (isOK) {
      isChange = true;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("保存成功！")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("保存失败！")));
    }
  }

  void _deleteNote() {
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
                  isChange = true;
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  /// 退出逻辑
  void _backAction() {
    if (widget.noteModel.content != _controller.text) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("提示"),
              content: Text("发现有未保存的内容!"),
              actions: <Widget>[
                TextButton(
                  child: Text("离开"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text("再想想"),
                  onPressed: () {
                    isChange = true;
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          });
    } else {
      Navigator.of(context).pop(isChange);
    }
  }

  _deleteAction() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("提示"),
            content: Text("您确定要删除当前文件吗?"),
            actions: <Widget>[
              TextButton(
                child: Text("取消"),
                onPressed: () => {Navigator.of(context).pop('cancel')},
              ),
              TextButton(
                child: Text("删除"),
                onPressed: () {
                  isChange = true;
                  Navigator.of(context).pop(true);
                  // 执行删除操作
                  SystemNetUtils.deleteNote(widget.noteModel.id).then((isOK) {
                    Navigator.of(context).pop(true);
                    if (isOK) {
                      print("删除成功");
                    } else {
                      print("删除失败！");
                    }
                  });
                },
              ),
            ],
          );
        });
  }

  List<Widget> _barTools() {
    return [
      IconButton(
        icon: Icon(Icons.preview),
        onPressed: () {
          Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
            return new NotePreviewPage(markdownData: _controller.text);
          }));
        },
      ),
      IconButton(
        icon: Icon(Icons.delete),
        onPressed: _deleteAction,
      ),
      IconButton(
        icon: Icon(Icons.save),
        onPressed: _saveContent,
      )
    ];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller.addListener(() {
      // 监听内容修改
    });
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.noteModel.content ?? "";
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑页面"),
        leading:
            IconButton(icon: Icon(Icons.arrow_back), onPressed: _backAction),
        actions: _barTools(),
      ),
      body: NoteEditWidget(content: '',),
    );
  }
}

class NoteEditWidget extends StatefulWidget {
  final TextEditingController controller = new TextEditingController();
  var content = "";
  NoteEditWidget({required this.content, Key? key}) : super(key: key);
  @override
  _NoteEditWidgetState createState() => new _NoteEditWidgetState();
}

class _NoteEditWidgetState extends State<NoteEditWidget> {
  @override
  Widget build(BuildContext context) {
    widget.controller.text = widget.content;
    return Container(
      color: Colors.white,
      height: double.infinity,
      // margin: EdgeInsets.all(32),
      child: TextField(
        controller: widget.controller,
        autofocus: true,
        scrollPadding: EdgeInsets.all(8),
        maxLines: null,
        decoration: InputDecoration(
          hintText: "请输入内容",
          border: InputBorder.none,
          filled: true,
          // fillColor: Colors.red,
        ),
      ),
    );
  }
}
