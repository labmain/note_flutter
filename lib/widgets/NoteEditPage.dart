import 'package:flutter/material.dart';

/// Opens an [AlertDialog] showing what the user typed.
class NoteEditPage extends StatefulWidget {
  NoteEditPage({Key key}) : super(key: key);

  @override
  _NoteEditPageState createState() => new _NoteEditPageState();
}

/// State for [NoteEditPage] widgets.
class _NoteEditPageState extends State<NoteEditPage> {
  // final TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.grey,
        height: double.infinity,
        margin: EdgeInsets.all(32),
        child: TextField(
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
      ),
    );
  }
}
