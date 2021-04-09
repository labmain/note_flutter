import 'package:uuid/uuid.dart';

class NotebookModel {
  String id;
  String name;
  List<String> noteList;
  double updateTime;
  String userID;

  NotebookModel(
      {this.id, this.name, this.noteList, this.updateTime, this.userID});

  NotebookModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    updateTime = json['updateTime'];
    userID = json['userID'];
    if (json['noteList'] != null) {
      noteList = <String>[];
      json['noteList'].forEach((v) {
        noteList.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['updateTime'] = this.updateTime;
    data['userID'] = this.userID;
    if (this.noteList != null) {
      data['noteList'] = this.noteList;
    }
    return data;
  }

  // 创建一个笔记模型
  static NotebookModel createNote(String name) {
    var notebook = NotebookModel();
    notebook.name = name;
    notebook.id = Uuid().v1();
    return notebook;
  }
}
