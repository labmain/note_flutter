import 'package:flutter/material.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/Model/notebook_model.dart';
import 'package:note_flutter/Net/net_model.dart';
import 'package:note_flutter/Routers/Routers.dart';
import 'package:note_flutter/widgets/NoteEditPage.dart';

class NoteListPage extends StatefulWidget {
 NotebookModel notebook;
  NoteListPage({Key? key, required this.notebook})
      : super(key: key);

  @override
  _NoteListPageState createState() => _NoteListPageState();
}

class _NoteListPageState extends State<NoteListPage> {
  List<NoteModel> notes = [];
  void _incrementCounter() {
    // Navigator.of(context).pushNamed(Routers.editNote);
    // getNotebookList();
  }

  void _createNewNote(NotebookModel notebook) {}
  void _getNotebookList() async {
    try {
      // 获取笔记本列表
      notes =
          await SystemNetUtils.getAllNoteList(widget.notebook.id);
      // 刷新ui
      setState(() {});
    } catch (e) {
      print(e);
    }
  }

  Widget showUpdateTime(double time) {
    var date = new DateTime.fromMillisecondsSinceEpoch((time * 1000).toInt());

    return Text(date.toString());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotebookList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return ListView(
      restorationId: 'list_demo_list_view',
      padding: const EdgeInsets.symmetric(vertical: 8),
      children: [
        for (int index = 0; index < notes.length; index++)
          ListTile(
            leading: ExcludeSemantics(
              child: Icon(Icons.notes),
            ),
            title: Text(notes[index].title),
            subtitle: showUpdateTime(notes[index].updateTime ?? 0.0),
            onTap: () {
              Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
                return NoteEditPage(widget.notebook, notes[index]);
              })).then((isRefresh) {
                var r = isRefresh as bool;
                if (r) {
                  _getNotebookList();
                }
              });
            },
          ),
      ],
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text("笔记列表"),
  //       leading: IconButton(
  //         icon: Icon(Icons.arrow_back),
  //         onPressed: () {
  //           Navigator.of(context).pop();
  //         },
  //       ),
  //     ),
  //     body: Scrollbar(
  //       child: ListView(
  //         restorationId: 'list_demo_list_view',
  //         padding: const EdgeInsets.symmetric(vertical: 8),
  //         children: [
  //           for (int index = 0; index < notes.length; index++)
  //             ListTile(
  //               leading: ExcludeSemantics(
  //                 child: Icon(Icons.notes),
  //               ),
  //               title: Text(notes[index].title),
  //               subtitle: showUpdateTime(notes[index].updateTime),
  //               onTap: () {
  //                 Navigator.of(context)
  //                     .push(new MaterialPageRoute(builder: (_) {
  //                   return NoteEditPage(widget.notebook, notes[index]);
  //                 })).then<bool>((isRefresh) {
  //                   var r = isRefresh as bool;
  //                   if (r) {
  //                     _getNotebookList();
  //                   }
  //                 });
  //               },
  //             ),
  //         ],
  //       ),
  //     ),
  //     floatingActionButton: FloatingActionButton(
  //       onPressed: () {
  //         Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
  //           return NoteEditPage(
  //               widget.notebook, NoteModel.createNote(widget.notebook.id));
  //         })).then<bool>((isRefresh) {
  //           var r = isRefresh as bool;
  //           if (r) {
  //             _getNotebookList();
  //           }
  //         });
  //       },
  //       tooltip: 'Increment',
  //       child: Icon(Icons.add),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }
}
