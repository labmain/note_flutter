import 'package:flutter/material.dart';
import 'package:note_flutter/Model/notebook_model.dart';
typedef SelectTapCallback = void Function(int index);
class NotebookList extends StatefulWidget {
  List<NotebookModel> notebookList = [];
  int? selectIndex;
  SelectTapCallback? selectAction;
  NotebookList({required this.notebookList, this.selectIndex, this.selectAction});

  @override
  _NotebookListState createState() => _NotebookListState();
}

class _NotebookListState extends State<NotebookList> {

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[100],
      child: ListView(
        restorationId: 'list_demo_list_view',
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          for (int index = 0; index < widget.notebookList.length; index++)
            ListTile(
              leading: ExcludeSemantics(
                child: Icon(Icons.menu_book_sharp),
              ),
              title: Text(widget.notebookList[index].name),
              subtitle: Text("subtitle"),
              onTap: () {
                widget.selectAction?.call(index);
              },
              selected: widget.selectIndex != null ? widget.selectIndex == index :
              false,
            ),
        ],
      ),
    );
  }
}