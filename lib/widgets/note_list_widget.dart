import 'package:flutter/material.dart';
import 'package:note_flutter/Model/note_model.dart';
import 'package:note_flutter/widgets/NoteListPage.dart';
typedef SelectTapCallback = void Function();
class NoteList extends StatefulWidget {
  List<NoteModel> notes = [];
  int? selectIndex;
  SelectTapCallback? selectAction;
  NoteList({required this.notes, this.selectIndex, this.selectAction});

  @override
  _NoteListState createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {

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
              onTap: widget.selectAction ?? null,
              selected: widget.selectIndex != null ? widget.selectIndex == index :
              false,
            ),
        ],
      ),
    );
  }
}