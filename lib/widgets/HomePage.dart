import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotebookList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurple,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Messages'),
            ),
            ListTile(
              leading: Icon(Icons.account_circle),
              title: Text('Profile'),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
            ),
          ],
        ),
      ),
      body: Scrollbar(
        child: ListView(
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
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (_) {
                    return NoteListPage(
                      notebookID: id,
                      title: "笔记列表",
                    );
                  }));
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNotebookList,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
