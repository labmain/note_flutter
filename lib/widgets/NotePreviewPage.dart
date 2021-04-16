import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NotePreviewPage extends StatefulWidget {
  // 声明一个成员变量来保存
  final String markdownData;

  // 构造函数需要
  NotePreviewPage({Key? key, required this.markdownData})
      : super(key: key);

  @override
  _NotePreviewPageState createState() => _NotePreviewPageState();
}

class _NotePreviewPageState extends State<NotePreviewPage> {
  final controller = ScrollController();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("展示"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SafeArea(
        child: Markdown(
          controller: controller,
          selectable: true,
          data: widget.markdownData,
          imageDirectory: 'https://raw.githubusercontent.com',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.arrow_upward),
        onPressed: () => controller.animateTo(0,
            duration: Duration(seconds: 1), curve: Curves.easeOut),
      ),
    );
  }
}
